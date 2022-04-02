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
 end