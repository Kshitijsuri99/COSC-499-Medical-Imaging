-- This sample shows how to use Orthanc to modify incoming instances.

function OnStoredInstance(instanceId, tags, metadata, origin)
   -- Do not process twice the same file
   if origin['RequestOrigin'] ~= 'Lua' then

      local modifyRequest = {}
      local crossTable = {}

      modifyRequest["Remove"] = {}
      table.insert(modifyRequest["Remove"], "OperatorsName")

      modifyRequest["Replace"] = {}
      modifyRequest["Replace"]["InstitutionName"] = "noName"
      modifyRequest["Replace"]["SOPInstanceUID"] = tags["SOPInstanceUID"]
      modifyRequest["Replace"]["StudyDescription"] = "noName"

      -- Institution address 
      modifyRequest["Replace"]["InstitutionAddress"] = "daniils house"
      -- Referring Physician's Name
      modifyRequest["Replace"]["ReferringPhysicianName"] = "noName"
      -- Station Name
      modifyRequest["Replace"]["StationName"] = "noName"

      -- modifyRequest["Replace"]["PatientID"] = "000000000000"
      -- modifyRequest["Replace"]["StudyDate"] = "0"
      -- modifyRequest["Replace"]["SeriesDate"] = "0"

      -- modifyRequest["Replace"]["AcquisitionDate"] = "0"
      -- modifyRequest["Replace"]["ContentDate"] = "0"
      -- modifyRequest["Replace"]["StudyTime"] = "0"
      -- modifyRequest["Replace"]["SeriesTime"] = "0"

      modifyRequest["Force"] = true  -- because we want to keep the same SOPInstanceUID

      -- download a modified version of the instance
      local modifiedDicom = RestApiPost('/instances/' .. instanceId .. '/modify', DumpJson(modifyRequest))

      -- upload the modified instance.  When performing modification at the instance level, all IDs from the original instance
      -- are preserved (SOPInstanceUID, SeriesInstanceUID, StudyInstanceUID)
      -- so when you'll upload it to Orthanc, it will overwrite the old instance only
      -- if you've set the "OverwriteInstances" option to true in your configuration file
      local uploadResponse = ParseJson(RestApiPost('/instances', modifiedDicom))

      local crossTableDicom = addPointerReference(crossTable, instanceId, uploadResponse["ID"])
      local uploadCrossTable = ParseJson(RestApiPost('/instances', crossTableDicom))


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

function addPointerReference(crossTable, unanonymizedId, anonymizedId)
   crossTable["Add"]["OriginalId"] = unanonymizedId
   crossTable["Add"]["AnonymizedId"] = anonymizedId
   return RestApiPost('/instances/' .. instanceId .. '/modify', DumpJson(crossTable))
end