function OnStoredInstance(instanceId, tags, metadata)
    SendToModality(instanceId, 'PACS')
  end