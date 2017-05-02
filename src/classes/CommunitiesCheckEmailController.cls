/**
 * An apex page controller that exposes the Check Email 
 */
public with sharing class CommunitiesCheckEmailController {
  
   public String username {get; set;}   
   	
	
   public CommunitiesCheckEmailController() {
      username = ApexPages.currentPage().getParameters().get('username');  
   }
  
   
   public  PageReference getSourceSystem() {
      
     try{
         
         
       if(String.isNotEmpty(username)){
      User userRecord = [SELECT id,UserRegistrationSource__c FROM User WHERE Username = :username LIMIT 1];
     
      
      if( userRecord != null && null != userRecord.UserRegistrationSource__c && !String.isBlank(userRecord.UserRegistrationSource__c)   && !userRecord.UserRegistrationSource__c.equalsIgnoreCase('Community')) {
       	System.debug('Inside loop' + userRecord.UserRegistrationSource__c);
        RedirectURLConfig__c redirectURLConfig = RedirectURLConfig__c.getInstance(userRecord.UserRegistrationSource__c.toUpperCase());
         System.debug('UserRegistrationSource__c'+ userRecord.UserRegistrationSource__c);
        if(null != redirectURLConfig && redirectURLConfig.targetURL__c != null){
         System.debug('redirectURLConfig.targetURL__c'+ redirectURLConfig.targetURL__c);        
           PageReference page =  new PageReference(redirectURLConfig.targetURL__c);
           System.debug('setRedirect URL based on user registration source system');
           page.setRedirect(true);
           return page;
         }
       
      }
       }
      
      return new PageReference('javascript:window.close()');
     } catch(Exception ex){           return null;     }
    }
}