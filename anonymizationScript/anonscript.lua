-- This sample shows how to use Orthanc to modify incoming instances.

-- This file is not USED!!!

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
       --Other Patient Ids	(0010,1000)
       modifyRequest["Replace"]["0010,1000"] = "1"
       --Other Patient Names	(0010,1001)
       modifyRequest["Replace"]["0010,1001"] = "1"
       --Patient's Age	(0010,1010)
       modifyRequest["Replace"]["0010,1010"] = "1"
       --Patient's Size	(0010,1020)
       modifyRequest["Replace"]["0010,1020"] = "1"
       --Patient's Weight	(0010,1030)
       modifyRequest["Replace"]["0008,001030"] = "1"
       --Medical Record Locator	(0010,1090)
       modifyRequest["Replace"]["0010,1090"] = "1"
       --Ethnic Group	(0010,2160)
       modifyRequest["Replace"]["0010,2160"] = "1"
       --Occupation	(0010,2180)
       modifyRequest["Replace"]["0010,2180"] = "1"
       --Additional Patient's History	(0010,21B0)
       modifyRequest["Replace"]["0010,21B0"] = "1"
       --Patient Comments	(0010,4000)
       modifyRequest["Replace"]["0010,4000"] = "1"
       --Series Description	(0008,103E)	
       modifyRequest["Replace"]["0008,103E"] = "1"
       --Device Serial Number	(0018,1000)
       modifyRequest["Replace"]["0018,1000"] = "1"
       --Institutional Department name	(0008,1040)	
       modifyRequest["Replace"]["0008,1040"] = "1"
       --Protocol Name	(0018,1030)
       modifyRequest["Replace"]["0018,1030"] = "1"
       --Physician(s) of Record	(0008,1048)	
       modifyRequest["Replace"]["0008,1048"] = "1"
       --Study Instance UID	(0020,000D)
       modifyRequest["Replace"]["0020,000D"] = "1"
       --Performing Physicians' Name	(0008,1050)	
       modifyRequest["Replace"]["0008,1050"] = "1"
       --Series Instance UID	(0020,000E)
       modifyRequest["Replace"]["0020,000E"] = "1"
       --Name of Physician(s) Reading study	(0008,1060)	
       modifyRequest["Replace"]["0008,1060"] = "1"
       --Study ID	(0020,0010)
       modifyRequest["Replace"]["0020,0010"] = "1"
       --Operator's Name	(0008,1070)	
       modifyRequest["Replace"]["0008,001070"] = "1"
       --Frame of Reference UID	(0020,0052)
       modifyRequest["Replace"]["0020,000052"] = "1"
       --Admitting Diagnoses Description	(0008,1080)	
       modifyRequest["Replace"]["0008,001080"] = "1"
       --Synchronization Frame of Reference UID	(0020,0200)
       modifyRequest["Replace"]["0020,0200"] = "1"
       --Referenced SOP Instance UID	(0008,1155)	
       modifyRequest["Replace"]["0008,1155"] = "1"
       --Image Comments	(0020,4000)
       modifyRequest["Replace"]["0020,4000"] = "1"
       --Derivation Description	(0008,2111)	
       modifyRequest["Replace"]["0008,2111"] = "1"
       --Request Attributes Sequence	(0040,0275)
       modifyRequest["Replace"]["0040,0275"] = "1"
       --Patient's Name	(0010,0010)	
       modifyRequest["Replace"]["0010,0010"] = "1"
       --UID	(0040,A124)
       modifyRequest["Replace"]["0040,A124"] = "1"
       --Patient ID	(0010,0020)	
       modifyRequest["Replace"]["0010,0020"] = "1"
       --Content Sequence	(0040,A730)
       modifyRequest["Replace"]["0040,A730"] = "1"
       --Patient's Birth Date 	(0010,0030)	
       modifyRequest["Replace"]["0010,0030"] = "1"
       --Storage Media File-set UID	(0088,0140)
       modifyRequest["Replace"]["0088,0140"] = "1"
       --Patient's Birth Time	(0010,0032)	
       modifyRequest["Replace"]["0010,0032"] = "1"
       --Referenced Frame of Reference UID	(3006,0024)
       modifyRequest["Replace"]["3006,0024"] = "1"
       --Patient's Sex	(0010,0040)	
       modifyRequest["Replace"]["0010,0040"] = "1"
       --Related Frame of Reference UID	(3006,00C2)
       modifyRequest["Replace"]["3006,00C2"] = "1"
 
 
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

 function createPointerReference(){
      -- todo
      -- make sure to refer to anonymized data through the unanonymized data so its one way
 }

 -- tags to anonymize:
 -- keep these for refernce 
 -- instance creator UID
--  modifyRequest["Replace"]["0008,0014"] = "1"
--  -- Accession Number
--  modifyRequest["Replace"]["0008,0050"] = "1"
--  -- Institution Name
--  modifyRequest["Replace"]["0008,0080"] = "1"
--  -- Institution address 
--  modifyRequest["Replace"]["0008,0081"] = "1"
--  -- Referring Physician's Name
--  modifyRequest["Replace"]["0008,0090"] = "1"
--  -- Referring Physician's Address
--  modifyRequest["Replace"]["0008,0092"] = "1"
--  -- Referring Physician's Telephone numbers
--  modifyRequest["Replace"]["0008,0094"] = "1"
--  -- Station Name
--  modifyRequest["Replace"]["0008,001010"] = "1"
--  -- Study Description
--  modifyRequest["Replace"]["0008,001030"] = "1"
--  --Other Patient Ids	(0010,1000)
--  modifyRequest["Replace"]["0010,1000"] = "1"
--  --Other Patient Names	(0010,1001)
--  modifyRequest["Replace"]["0010,1001"] = "1"
--  --Patient's Age	(0010,1010)
--  modifyRequest["Replace"]["0010,1010"] = "1"
--  --Patient's Size	(0010,1020)
--  modifyRequest["Replace"]["0010,1020"] = "1"
--  --Patient's Weight	(0010,1030)
--  modifyRequest["Replace"]["0008,001030"] = "1"
--  --Medical Record Locator	(0010,1090)
--  modifyRequest["Replace"]["0010,1090"] = "1"
--  --Ethnic Group	(0010,2160)
--  modifyRequest["Replace"]["0010,2160"] = "1"
--  --Occupation	(0010,2180)
--  modifyRequest["Replace"]["0010,2180"] = "1"
--  --Additional Patient's History	(0010,21B0)
--  modifyRequest["Replace"]["0010,21B0"] = "1"
--  --Patient Comments	(0010,4000)
--  modifyRequest["Replace"]["0010,4000"] = "1"
--  --Series Description	(0008,103E)	
--  modifyRequest["Replace"]["0008,103E"] = "1"
--  --Device Serial Number	(0018,1000)
--  modifyRequest["Replace"]["0018,1000"] = "1"
--  --Institutional Department name	(0008,1040)	
--  modifyRequest["Replace"]["0008,1040"] = "1"
--  --Protocol Name	(0018,1030)
--  modifyRequest["Replace"]["0018,1030"] = "1"
--  --Physician(s) of Record	(0008,1048)	
--  modifyRequest["Replace"]["0008,1048"] = "1"
--  --Study Instance UID	(0020,000D)
--  modifyRequest["Replace"]["0020,000D"] = "1"
--  --Performing Physicians' Name	(0008,1050)	
--  modifyRequest["Replace"]["0008,1050"] = "1"
--  --Series Instance UID	(0020,000E)
--  modifyRequest["Replace"]["0020,000E"] = "1"
--  --Name of Physician(s) Reading study	(0008,1060)	
--  modifyRequest["Replace"]["0008,1060"] = "1"
--  --Study ID	(0020,0010)
--  modifyRequest["Replace"]["0020,0010"] = "1"
--  --Operator's Name	(0008,1070)	
--  modifyRequest["Replace"]["0008,001070"] = "1"
--  --Frame of Reference UID	(0020,0052)
--  modifyRequest["Replace"]["0020,000052"] = "1"
--  --Admitting Diagnoses Description	(0008,1080)	
--  modifyRequest["Replace"]["0008,001080"] = "1"
--  --Synchronization Frame of Reference UID	(0020,0200)
--  modifyRequest["Replace"]["0020,0200"] = "1"
--  --Referenced SOP Instance UID	(0008,1155)	
--  modifyRequest["Replace"]["0008,1155"] = "1"
--  --Image Comments	(0020,4000)
--  modifyRequest["Replace"]["0020,4000"] = "1"
--  --Derivation Description	(0008,2111)	
--  modifyRequest["Replace"]["0008,2111"] = "1"
--  --Request Attributes Sequence	(0040,0275)
--  modifyRequest["Replace"]["0040,0275"] = "1"
--  --Patient's Name	(0010,0010)	
--  modifyRequest["Replace"]["0010,0010"] = "1"
--  --UID	(0040,A124)
--  modifyRequest["Replace"]["0040,A124"] = "1"
--  --Patient ID	(0010,0020)	
--  modifyRequest["Replace"]["0010,0020"] = "1"
--  --Content Sequence	(0040,A730)
--  modifyRequest["Replace"]["0040,A730"] = "1"
--  --Patient's Birth Date 	(0010,0030)	
--  modifyRequest["Replace"]["0010,0030"] = "1"
--  --Storage Media File-set UID	(0088,0140)
--  modifyRequest["Replace"]["0088,0140"] = "1"
--  --Patient's Birth Time	(0010,0032)	
--  modifyRequest["Replace"]["0010,0032"] = "1"
--  --Referenced Frame of Reference UID	(3006,0024)
--  modifyRequest["Replace"]["3006,0024"] = "1"
--  --Patient's Sex	(0010,0040)	
--  modifyRequest["Replace"]["0010,0040"] = "1"
--  --Related Frame of Reference UID	(3006,00C2)
--  modifyRequest["Replace"]["3006,00C2"] = "1"
 