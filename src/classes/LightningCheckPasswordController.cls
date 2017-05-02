public class LightningCheckPasswordController {
 public LightningCheckPasswordController() {

    }
    // Method to retrieve the User Registration source system based on username.
 @AuraEnabled
 public static String getSourceSystem(String userName) {
      
     try{
         
     
      User userRecord = [SELECT id,UserRegistrationSource__c FROM User WHERE Username = :userName LIMIT 1];
     
      
      if( userRecord != null && null != userRecord.UserRegistrationSource__c && !String.isBlank(userRecord.UserRegistrationSource__c)   && !userRecord.UserRegistrationSource__c.equalsIgnoreCase('Community')) {
       //	System.debug('Inside loop' + userRecord.UserRegistrationSource__c);
        RedirectURLConfig__c redirectURLConfig = RedirectURLConfig__c.getInstance(userRecord.UserRegistrationSource__c.toUpperCase());
       //  System.debug('UserRegistrationSource__c'+ userRecord.UserRegistrationSource__c);
        if(null != redirectURLConfig && redirectURLConfig.targetURL__c != null){
       //  System.debug('redirectURLConfig.targetURL__c'+ redirectURLConfig.targetURL__c);
          return redirectURLConfig.targetURL__c;
         }
       
      }
      
      return null;
     } catch(Exception ex){
         
         return null; 
     }
    }
}