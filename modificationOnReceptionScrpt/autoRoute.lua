function OnStoredInstance(instanceId, tags, metadata)
    SendToModality(instanceId, 'orthanc-pacs')
  end