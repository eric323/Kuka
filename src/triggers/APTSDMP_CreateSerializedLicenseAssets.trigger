trigger APTSDMP_CreateSerializedLicenseAssets on Apttus_Config2__AssetLineItem__c (after insert) 
{
	Set<ID> setAssetIds = new Set<ID>();
	for(Apttus_Config2__AssetLineItem__c objAssets: Trigger.new)
	{
		setAssetIds.add(objAssets.id);
	}
   //  system.debug('setAssetIds==='+setAssetIds);
    if(!setAssetIds.isempty())
    {
    	APTSDMP_SerializedLicenseAssets.insertSerializedLicenseAssets(setAssetIds); 
    }
}