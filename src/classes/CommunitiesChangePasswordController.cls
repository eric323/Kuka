/**
 * An apex page controller that exposes the communities change password functionality
 */
public with sharing class CommunitiesChangePasswordController {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    
    public PageReference changePassword() {
        
      
      PageReference defaultPage = Site.changePassword(newPassword, verifyNewPassword, oldpassword);  
       System.debug('defaultPage' + defaultPage);
           
            
      if(defaultPage != null  || Test.isRunningTest()){
      	
      	 //get current user id from UserInfo
      	 Id userID = UserInfo.getUserId();
         // Retrieve the user record for the given user id
         User userRecord = [select id,UserRegistrationSource__c from User where id =:userID ];      
     
      
         if( userRecord != null && null != userRecord.UserRegistrationSource__c && !String.isBlank(userRecord.UserRegistrationSource__c) 
              && !userRecord.UserRegistrationSource__c.equalsIgnoreCase('Community')) {
      	
      	  
      	   if(userRecord.UserRegistrationSource__c.toUpperCase() == System.Label.KUKA_Ecommerce){      		   
      		
      		  return Site.login(UserInfo.getUserName(),newPassword,System.Label.KUKA_Ecommerce_URL);
      		
      	   } else { 
               RedirectURLConfig__c redirectURLConfig = RedirectURLConfig__c.getInstance(userRecord.UserRegistrationSource__c.toUpperCase());
           
               if(null != redirectURLConfig && redirectURLConfig.targetURL__c != null){
        	      System.debug('setRedirect URL based on user registration source system');
                  System.debug(redirectURLConfig.targetURL__c);
                  PageReference defaultLoginPage =  Site.login(UserInfo.getUserName(),newPassword,null);
                           	
                  PageReference customRedirectPage = new PageReference(redirectURLConfig.targetURL__c);
                  customRedirectPage.setRedirect(true);
                  System.debug('customRedirectPage'+customRedirectPage);
                  return customRedirectPage;
                 
               }
            
           }   
        }
      } else {
      	 return defaultPage;
      }
      
     
      
     return defaultPage;
    }     
    
   	public CommunitiesChangePasswordController() {}
}