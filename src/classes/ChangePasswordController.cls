/**
 * An apex page controller that exposes the change password functionality
 */
public with sharing class ChangePasswordController {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    
    public PageReference changePassword() {
        
      
      PageReference defaultPage = Site.changePassword(newPassword, verifyNewPassword, oldpassword);  
      
      Id userID = UserInfo.getUserId();
      
      User userRecord = [select id,UserRegistrationSource__c from User where id =:userID ];      
     
      
      if( userRecord != null && null != userRecord.UserRegistrationSource__c && !String.isBlank(userRecord.UserRegistrationSource__c)   && !userRecord.UserRegistrationSource__c.equalsIgnoreCase('Community')) {
      	
      	
      	if(userRecord.UserRegistrationSource__c.toUpperCase() == System.Label.KUKA_Ecommerce){
      		 return Site.login(UserInfo.getUserName(),newPassword,System.Label.KUKA_Ecommerce_URL);
      		
      	} else {
            RedirectURLConfig__c redirectURLConfig = RedirectURLConfig__c.getInstance(userRecord.UserRegistrationSource__c.toUpperCase());
        
            if(null != redirectURLConfig && redirectURLConfig.targetURL__c != null){
        	
              PageReference page =  new PageReference(redirectURLConfig.targetURL__c);
              System.debug('setRedirect URL based on user registration source system');
              page.setRedirect(true);
              return page;
          
             }
        }   
       
      
      }
      
      return defaultPage;
    }     
    
   	public ChangePasswordController() {}
}