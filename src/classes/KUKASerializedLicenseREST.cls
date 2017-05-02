/*
 * @Description : 
 * -----------------------------------------------------------------------------
 *  Developer           Date        Comments
 * -----------------------------------------------------------------------------
 *  Arokia Joseph     2017-04-12   Initial Version
 *
 */
 @RestResource (urlMapping='/KUKASerializedLicenses/*')
global  class KUKASerializedLicenseREST {
    
 
    
    
    @HttpGet 
    global static KUKA_WrapperUtils.SerializedXpertLicenseWrapper  GET()
    {
        KUKA_WrapperUtils.SerializedXpertLicenseWrapper returnWrapper = new KUKA_WrapperUtils.SerializedXpertLicenseWrapper();
        KUKA_WrapperUtils.License license = new KUKA_WrapperUtils.License();
        KUKA_WrapperUtils.User user= new KUKA_WrapperUtils.User();
        KUKA_WrapperUtils.Domain domain= new KUKA_WrapperUtils.Domain();
        KUKA_WrapperUtils.LicenseOwner licenseOwner= new KUKA_WrapperUtils.LicenseOwner();
         
         
        List<KUKA_WrapperUtils.License> Licenses = new List<KUKA_WrapperUtils.License>();      
        List<KUKA_WrapperUtils.domain> domains = new List<KUKA_WrapperUtils.domain>();
        List<KUKA_WrapperUtils.LicenseOwner> licenseOwners= new List<KUKA_WrapperUtils.LicenseOwner> ();
         //Read the Request from the URL
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
 		String userName = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);  
 		List<User> userList;
 		if(userName != null && !String.isEmpty(userName)) {
 			
 			
 		userList = 	[Select u.Users_Organisation__c, u.Username, u.UserType, u.UserRoleId, u.UserID18__c, u.ProfileId, u.Name, u.LastName, u.Kuka_ExternalUserID__c, u.IsActive, u.Id, u.FirstName, u.FederationIdentifier, 
 		                 u.EmployeeNumber, u.Email, u.Contact.Id, u.ContactId, u.CompanyName From User u  where u.Username = :userName and isActive = true];
 		
 	  	    
 	    
 	    if(userList != null && !userList.isEmpty()){
 	    	// Populate User Domain Information
 	    	   if(userList[0].Users_Organisation__c != null && userList[0].Users_Organisation__c.equalsIgnoreCase('External Community')){
 	   	       	  user.IdentityProvider = 'Salesforce';  user.Role ='customer';  domain.IdentityProvider = 'Salesforce'; domain.id = userList[0].id;
 	   	    	  
 	   	       } else if (userList[0].FederationIdentifier != null){ 	   	       	
 	   	       	  user.IdentityProvider = 'Salesforce'; user.Role ='employee'; domain.IdentityProvider = 'AD'; domain.id = userList[0].FederationIdentifier; 
 	   	    	     	       	
 	   	       } else {
 	   	       	
 	   	       	  user.IdentityProvider = 'Salesforce';
 	   	    	  user.Role ='employee';
 	   	    	  domain.IdentityProvider = 'Salesforce';
 	   	    	  domain.id = userList[0].UserID18__c; 	
 	   	       	
 	   	       }   	       
 	    	
 	    	
 	    	   // Assign domain to user json object.
 	   	    user.domain = domain;
 	    	
 	    	
 	    	
 	   	
 	   	    // Assign user id (18 digit salesforce user id)
        	user.Id = userList[0].UserID18__c;   	 
        	
        	// Retrieve Contact object details associated with the user record
        	if(userList[0].ContactId != null){
        		Contact contact = [Select c.Name, c.Id, c.Email, c.Contact_ID__c, c.AccountId From Contact c where c.Id = :userList[0].ContactId];
        		
 	   	        // Retrieve the account record details associated with the contact and assign company, account id and license information to the User Json object.
 	   	        if(contact != null && contact.AccountId != null) {
 	   	    	    Account account = [Select a.OwnerId, a.Name, a.Id, a.AccountNumber,a.Parent.ParentId, a.Parent.Id, a.ParentId From Account a where a.Id = :contact.AccountId ];
 	   	    	    user.AccountName = account.Name;
 	   	    	     	   	    	    
 	   	    	    // Get all parent account id associated with the contact and assign the same to the user Json object.
 	   	    	    List<Id>  accountIds = new List<Id>();
 	   	    	    accountIds.add(account.Id);
 	   	    	    GetParentAccount(account.Id, accountIds ); 	   	    	    
 	   	    	    user.AccountIds = accountIds;
 	   	    	    
 	   	    	    // Invoke the get Serialized asset associated with the Contact object.
 	   	    	    Licenses = getSerializedAssets(contact.Id);
 	   	            user.Licenses  = Licenses;
 	   	    	
 	   	        }
        		
        	}  	
 	   	 
 	   	  
 	   	    licenseOwner.user = user;
 	   	    
 	   	    returnWrapper.LicenseOwner =  licenseOwner;
 	   	
 	   	    
      
            returnWrapper.Status = 'Success';
            returnWrapper.Message = Licenses.size() +' License Information(s) Found ';
            
            return returnWrapper;
        }
        else
        {
            returnWrapper.ErrorCode = '404';
            returnWrapper.Status = 'Error';
            returnWrapper.Message = 'License Information Not Found';
        }
        
        }
         else {
         	 returnWrapper.ErrorCode = '404';
             returnWrapper.Status = 'Error';
             returnWrapper.Message = 'Invalid Input: Required salesforce username as input';
         }
        return returnWrapper;
    }
 
 
    public static void GetParentAccount(ID accountId, List<Id>  accountIds){        
         for(Account acc :[SELECT ID, ParentID FROM Account WHERE ID = :accountId]){
          if(acc.ParentId != null){ 
          	
            accountIds.add(acc.ParentId);
            GetParentAccount(acc.ParentId, accountIds);
         } 
       }        
     }
 
       
     
	@RemoteAction
	global static List<KUKA_WrapperUtils.License> getSerializedAssets(Id contactId) 
    {
       
        List<KUKA_WrapperUtils.License> lstLicenseWrapper = new List<KUKA_WrapperUtils.License>();
        if(contactId != null)
		{
			
			for(APTSDMP_Serialized_License_Asset__c obj: [SELECT Id,Contact__c, APTSDMP_License_Product__r.ProductCode, APTSDMP_Expiration_Date__c,APTSDMP_Integration_Status__c,APTSDMP_License_Product__c,APTSDMP_License_Product__r.Name,APTSDMP_Robot_Asset__c,APTSDMP_Status__c,APTSDMP_Activation_Date__c,APTSDMP_Product_Name__c FROM APTSDMP_Serialized_License_Asset__c WHERE Contact__c =: contactId AND APTSDMP_Status__c=:'Active'])
			{
				KUKA_WrapperUtils.License licenseWrap = new KUKA_WrapperUtils.License();
                
                licenseWrap.Id = obj.Id;
                licenseWrap.Article = obj.APTSDMP_License_Product__r.ProductCode;
				licenseWrap.Name = obj.APTSDMP_License_Product__r.Name;	
				licenseWrap.ActivationDate = obj.APTSDMP_Activation_Date__c;
				licenseWrap.ExpirationDate = obj.APTSDMP_Expiration_Date__c;
			
				lstLicenseWrapper.add(licenseWrap);
			}
		
		}
       return lstLicenseWrapper;
           
    }
 
 
   
}