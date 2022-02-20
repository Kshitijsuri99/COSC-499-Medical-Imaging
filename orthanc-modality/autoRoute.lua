function OnStoredInstance(instanceId, tags, metadata)
    SendToModality(instanceId, 'pacs')
  end