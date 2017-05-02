global class APTSDMP_SerializedLicenseAssets 
{
	global APTSDMP_SerializedLicenseAssets(){}
	//To get SLAs
	@RemoteAction
	global static APTSDMP_WrapperUtils.SerializedLicenseAssetsWrapper getSerializedAssets(Id AcctId) 
    {
        APTSDMP_WrapperUtils.SerializedLicenseAssetsWrapper returnwrapper = new APTSDMP_WrapperUtils.SerializedLicenseAssetsWrapper();
        
        List<APTSDMP_WrapperUtils.SerializedWrapper> lstAssetsWrapper = new List<APTSDMP_WrapperUtils.SerializedWrapper>();
        if(AcctId != null)
		{
			for(APTSDMP_Serialized_License_Asset__c obj: [SELECT Id,APTSDMP_Billing_Account__c,APTSDMP_Billing_Account__r.Name,APTSDMP_Controller_Asset__c,APTSDMP_Expiration_Date__c,APTSDMP_Integration_Message__c,APTSDMP_Integration_Status__c,APTSDMP_License_Product__c,APTSDMP_License_Product__r.Name,APTSDMP_Robot_Asset__c,APTSDMP_Status__c,APTSDMP_Activation_Date__c,APTSDMP_Product_Name__c,APTSDMP_Account_Name__c FROM APTSDMP_Serialized_License_Asset__c WHERE APTSDMP_Billing_Account__c =: AcctId AND APTSDMP_Status__c=:'Active'])
			{
				APTSDMP_WrapperUtils.SerializedWrapper assetsWrap = new APTSDMP_WrapperUtils.SerializedWrapper();
                assetsWrap.Id = obj.Id;
				assetsWrap.ProductName = obj.APTSDMP_License_Product__r.Name;
				assetsWrap.CustomerName = obj.APTSDMP_Billing_Account__r.Name;
				assetsWrap.Status = obj.APTSDMP_Status__c;
				assetsWrap.IntegrationStatus = obj.APTSDMP_Integration_Status__c;
				assetsWrap.IntegrationMessage = obj.APTSDMP_Integration_Message__c;
				assetsWrap.RoboAsset = obj.APTSDMP_Robot_Asset__c;
				assetsWrap.ControllerAsset = obj.APTSDMP_Controller_Asset__c;
				assetsWrap.ActivationDate = obj.APTSDMP_Activation_Date__c;
				assetsWrap.ExpirationDate = obj.APTSDMP_Expiration_Date__c;
				lstAssetsWrapper.add(assetsWrap);
			}
			if(lstAssetsWrapper.size()>0)
			{
			    returnwrapper.LicenseAssets = lstAssetsWrapper;
                return returnwrapper;
			}
			else
			{
				return null;
			}
		}
        else
        {
        	return null;
        }
           
    }
   //To update SLAs
   @RemoteAction
   global static void updateSerailizedAssets(String jsonData)
   {
   		if(jsonData != '' & jsonData !=null)
   		{
		   	Map<String, Object> mapJsonObjects = (Map<String, Object>)JSON.deserializeUntyped(jsondata);
			List<Object> lst = (List<Object>)mapJsonObjects.get('LicenseAssets');
			List<APTSDMP_Serialized_License_Asset__c> lstUpdateAssets = new List<APTSDMP_Serialized_License_Asset__c>();
			//system.debug('lst==='+lst.size());
			for (Object obj : lst) 
			{
		    	APTSDMP_Serialized_License_Asset__c objAssets = new APTSDMP_Serialized_License_Asset__c();
			     // now get attributes for this LicenseAssets.
			     Map<String, Object> mapAttribute = (Map<String, Object>)obj;
			     //system.debug('mapAttribute=='+mapAttribute);
			     // now loop through  LicenseAssets attributes.
			     for (String attributeName : mapAttribute.keyset()) 
			     {
			         // handle response
			         if(attributeName =='Id')
			        {
			            objAssets.Id = String.valueOf(mapAttribute.get(attributeName));
			        }
			        else if(attributeName =='APTSDMP_Activation_Date__c')
			        {
			            objAssets.APTSDMP_Activation_Date__c = mapAttribute.get(attributeName) != '' ? Date.valueOf(mapAttribute.get(attributeName)) : null;
			        }
			        else if(attributeName =='APTSDMP_Billing_Account__c')
			        {
		            	objAssets.APTSDMP_Billing_Account__c = mapAttribute.get(attributeName) != '' ? String.valueOf(mapAttribute.get(attributeName)) : null;
			        }
			         else if(attributeName =='APTSDMP_Controller_Asset__c')
			        {
			             objAssets.APTSDMP_Controller_Asset__c =mapAttribute.get(attributeName) != '' ? String.valueOf(mapAttribute.get(attributeName)) : null;
			        }
			        else if(attributeName =='APTSDMP_Expiration_Date__c')
			        {
			            objAssets.APTSDMP_Expiration_Date__c =  mapAttribute.get(attributeName) != '' ? Date.valueOf(mapAttribute.get(attributeName)) : null;
			        } 
			        else if(attributeName =='APTSDMP_External_Unique_ID__c')
			        {
			          objAssets.APTSDMP_External_Unique_ID__c = mapAttribute.get(attributeName) != '' ? String.valueOf(mapAttribute.get(attributeName)) : null;
			        }
			        else if(attributeName =='APTSDMP_Integration_Message__c')
			        {
			          objAssets.APTSDMP_Integration_Message__c = mapAttribute.get(attributeName) != '' ? String.valueOf(mapAttribute.get(attributeName)) : '';
			        } 
			        else if(attributeName =='APTSDMP_Integration_Status__c')
			        {
			          objAssets.APTSDMP_Integration_Status__c =mapAttribute.get(attributeName) != '' ? String.valueOf(mapAttribute.get(attributeName)) : '';
			        }
			        else if(attributeName =='APTSDMP_License_Product__c')
			        {
			             objAssets.APTSDMP_License_Product__c = mapAttribute.get(attributeName) != '' ? String.valueOf(mapAttribute.get(attributeName)) : null;
			        } 
			        else if(attributeName =='APTSDMP_Original_Asset__c')
			        {
			            objAssets.APTSDMP_Original_Asset__c =mapAttribute.get(attributeName) != '' ? String.valueOf(mapAttribute.get(attributeName)) : null;
			        }
			        else if(attributeName =='APTSDMP_Robot_Asset__c')
			        {
			            objAssets.APTSDMP_Robot_Asset__c = mapAttribute.get(attributeName) != '' ? String.valueOf(mapAttribute.get(attributeName)) : null;
			        } 
			        else if(attributeName =='APTSDMP_Status__c')
			        {
			            objAssets.APTSDMP_Status__c =mapAttribute.get(attributeName) != '' ? String.valueOf(mapAttribute.get(attributeName)) : '';
			        }
			         //System.debug('========> ' + attributeName + ' = ' + mapAttribute.get(attributeName));
			     }
		    	lstUpdateAssets.add(objAssets);
	 		}
	 		//system.debug('lstUpdateAssets===='+lstUpdateAssets.size());
	 		if(lstUpdateAssets.size()>0)
	 			update lstUpdateAssets;
   		}
 		
	}
	//To insert SLA through trigger
    public static void insertSerializedLicenseAssets(Set<Id> setAssetIds)
    {
    	List<APTSDMP_Serialized_License_Asset__c> lstSerializedAssets = new List<APTSDMP_Serialized_License_Asset__c>();
    	for(Apttus_Config2__AssetLineItem__c objAssets: [SELECT Id,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.Family,Apttus_Config2__AccountId__c,Apttus_Config2__Quantity__c FROM Apttus_Config2__AssetLineItem__c Where Id IN: setAssetIds])
    	{
    		if(objAssets.Apttus_Config2__ProductId__r.Family=='Serialized License' && (objAssets.Apttus_Config2__Quantity__c >= 1 && objAssets.Apttus_Config2__Quantity__c <= 5000))
    		{
    			for(Integer iQuantity = 1;iQuantity <= objAssets.Apttus_Config2__Quantity__c; iQuantity++)
    			{
    				APTSDMP_Serialized_License_Asset__c obj = new APTSDMP_Serialized_License_Asset__c();
    				obj.APTSDMP_Original_Asset__c = objAssets.Id;
    				obj.APTSDMP_Billing_Account__c = objAssets.Apttus_Config2__AccountId__c;
    				obj.APTSDMP_Integration_Message__c = '';
                    obj.APTSDMP_Status__c = 'Active';   
                    Date datum = system.today();                    
                    obj.APTSDMP_Expiration_Date__c = datum.addYears(1);
    				obj.APTSDMP_License_Product__c = objAssets.Apttus_Config2__ProductId__c;
    				lstSerializedAssets.add(obj);
    			}
    		}
    	}
    	//system.debug('list size===='+lstSerializedAssets.size());
    	if(lstSerializedAssets.size()>0)
    		insert lstSerializedAssets;
    }
}