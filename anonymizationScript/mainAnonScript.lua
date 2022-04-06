-- BELOW IS WHAT WE NEEEEEDED

function OnStoredInstance(instanceId, tags, metadata, origin)
   -- Ignore the instances that result from the present Lua script to
   -- avoid infinite loops
   if origin['RequestOrigin'] ~= 'Lua' then

      -- ANONYMIZATION SECTION -- START --
      local force = true
      local replace = {}
      local keep = { 'PatientAge', 'PatientSex', 'PatientID' }
      replace['PatientName'] = 'anonymous'
      -- ANONYMIZATION SECTION -- END --

      -- PROXY IDENTIFIER SECTION -- START --
      replace['ModifyingDeviceID'] = '--replaceWithProxyID--'
      replace['ModifiedImageDate'] = os.date('%Y%m%d')
      replace['ModifiedImageTime'] = os.date('%H%M%S')
      replace['ModifyingDeviceManufacturer'] = 'Collective Minds Radiology'
      ---- PROXY IDENTIFIER SECTION -- END --

      -- Anonymize according to  the instance
      local command = {}
      command['Replace'] = replace
      command['Keep'] = keep
      command['Force'] = force
      local modifiedFile = RestApiPost('/instances/' .. instanceId .. '/anonymize', DumpJson(command, true))

      -- Upload the modified instance to the Orthanc database so that
      -- it can be sent by Orthanc to other modalities
      local modifiedId = ParseJson(RestApiPost('/instances/', modifiedFile)) ['ID']

      -- Send the modified instance to another modality
      RestApiPost('/peers/CMRADCORE/store', modifiedId)

      -- Delete the original and the modified instances
      RestApiDelete('/instances/' .. instanceId)
      RestApiDelete('/instances/' .. modifiedId)
   end
   local resources = {'patients','studies','series','instances'}
   local R = w.listPACSresource(resources)

   local patient = w.listSingleResource(resources[1], R.patients[1])

  -- list Nth (1st) resource from Studies for given Patient
  local studies = w.listSingleResource(resources[2],patient.Studies[1])

  -- list Nth (1st) resource from Series for given Study
  local series = w.listSingleResource(resources[3],studies.Series[1])

  -- list Nth (1st) resource from Instances for given Series
  local instance =  w.listSingleResource(resources[4],series.Instances[1])

      -- modify DICOM file Tags using Iguana's DLL
      file2modifyLocally = dicomedit.edit(iguana.workingDir()..file2modifyLocally)
      
   -- retrieve the hierarchy of all the DICOM tags for Instance identified by ID
  local tags = w.listSingleResource(resources[4],instance.ID,'simplified-tags')

  -- retrieve hexadecimal indexes of DICOM tags for Instance identified by ID
  local hextags = w.listSingleResource(resources[4], instance.ID, 'tags')

  -- access the raw value of DICOM tag '0010-0010', AKA 'PatientName' 
  local PatientName = w.acquireSingleResource(resources[4], instance.ID, 'content', '0010-0010')

  -- retrieve list of DICOM hexadecimal tags, available with given Instance
  local ListOfHexTags = w.listSingleResource(resources[4],instance.ID,'content')

  -- recursively drill down through sequences of tags to find 'ImageType' 'Value'
  local ImgTypeValue = w.acquireSingleResource(resources[4], instance.ID,'content',ListOfHexTags[2])
   -- push modified file back to Orthanc
   local RData,RCode,RHeaders=w.pushResource2Orthanc('instances',file2modifyLocally)

end