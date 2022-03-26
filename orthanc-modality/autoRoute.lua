-- autorouting file. Sends DICOM images 
function OnStoredInstance(instanceId, tags, metadata)
    SendToModality(instanceId, 'pacs')
  end