-- This sample shows how to use Orthanc to modify incoming instances.

function OnStoredInstance(instanceId, tags, metadata, origin)
   -- Do not process twice the same file
   if origin['RequestOrigin'] ~= 'Lua' then

      local modifyRequest = {}
      
      modifyRequest["Remove"] = {}
      table.insert(modifyRequest["Remove"], "OperatorsName")
      
      modifyRequest["Replace"] = {}
      modifyRequest["Replace"]["InstitutionName"] = "Orthanc Demo Hospital"
      modifyRequest["Replace"]["StudyDescription"] = "Orthanc Demo Hospital"
      modifyRequest["Replace"]["StationName"] = "Orthanc Demo Hospital"
      -- instance creator UID
      modifyRequest["Replace"]["0008,0014"] = "1"
      -- Accession Number
      modifyRequest["Replace"]["0008,0050"] = "1"
      -- Institution Name
      modifyRequest["Replace"]["0008,0080"] = "1"
      -- Institution address 
      modifyRequest["Replace"]["0008,0081"] = "1"
      -- Referring Physician's Name
      modifyRequest["Replace"]["0008,0090"] = "1"
      -- Referring Physician's Address
      modifyRequest["Replace"]["0008,0092"] = "1"
      -- Referring Physician's Telephone numbers
      modifyRequest["Replace"]["0008,0094"] = "1"
      -- Station Name
      modifyRequest["Replace"]["0008,001010"] = "1"
      -- Study Description
      modifyRequest["Replace"]["0008,001030"] = "1"

      --Series Description	(0008,103E)	
      --Device Serial Number	(0018,1000)
      --Institutional Department name	(0008,1040)	
      --Protocol Name	(0018,1030)
      --Physician(s) of Record	(0008,1048)	
      --Study Instance UID	(0020,000D)
      --Performing Physicians' Name	(0008,1050)	
      --Series Instance UID	(0020,000E)
      --Name of Physician(s) Reading study	(0008,1060)	
      --Study ID	(0020,0010)
      --Operator's Name	(0008,1070)	
      --Frame of Reference UID	(0020,0052)
      --Admitting Diagnoses Description	(0008,1080)	
      --Synchronization Frame of Reference UID	(0020,0200)
      --Referenced SOP Instance UID	(0008,1155)	
      --Image Comments	(0020,4000)
      --Derivation Description	(0008,2111)	
      --Request Attributes Sequence	(0040,0275)
      --Patient's Name	(0010,0010)	
      --UID	(0040,A124)
      --Patient ID	(0010,0020)	
      --Content Sequence	(0040,A730)
      --Patient's Birth Date 	(0010,0030)	
      --Storage Media File-set UID	(0088,0140)
      --Patient's Birth Time	(0010,0032)	
      --Referenced Frame of Reference UID	(3006,0024)

      modifyRequest["Replace"]["SOPInstanceUID"] = tags["SOPInstanceUID"]
      modifyRequest["Force"] = true  -- because we want to keep the same SOPInstanceUID

      -- download a modified version of the instance
      local modifiedDicom = RestApiPost('/instances/' .. instanceId .. '/modify', DumpJson(modifyRequest))

      -- upload the modified instance.  When performing modification at the instance level, all IDs from the original instance
      -- are preserved (SOPInstanceUID, SeriesInstanceUID, StudyInstanceUID)
      -- so when you'll upload it to Orthanc, it will overwrite the old instance only
      -- if you've set the "OverwriteInstances" option to true in your configuration file
      local uploadResponse = ParseJson(RestApiPost('/instances', modifiedDicom))

      -- PrintRecursive(uploadResponse)
      
      if (uploadResponse["Status"] == 'AlreadyStored') then
         print("Are you sure you've enabled 'OverwriteInstances' option ?")
      end

      if (uploadResponse["ID"] ~= instanceId) then
         print("modified instance and original instance don't have the same Orthanc IDs !")
      end 

      print('replaced InstitutionName in instance ' .. instanceId)

   end
end

function OnStableStudy(studyId, tags, metadata)
   -- since we have modified tags that are stored in the Index DB at Study/Series level: InstitutionName and OperatorsName,
   -- we need to reconstruct the Index DB data for this study

   RestApiPost('/studies/' .. studyId .. '/reconstruct', "")

   print('reconstructed Index DB data for study ' .. studyId)

end
