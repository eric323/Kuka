@IsTest(SeeAllData = false)
public with sharing class CommunitiesCheckEmailControllerTest {

 /* Verifies that CommunitiesCheckEmailController object is instantiated correctly. */
 @IsTest
 static void CommunitiesCheckEmailControllerInstantiation() {
  CommunitiesCheckEmailController controller = new CommunitiesCheckEmailController();
  System.assertNotEquals(controller, null);
 }
    
     /* Verifies that CommunitiesCheckEmailController returns user details */
 @IsTest
 static void CheckPasswordgetSourceSystemInvalid() {
  CommunitiesCheckEmailController controller = new CommunitiesCheckEmailController();
  String sourceSystem =   LightningCheckPasswordController.getSourceSystem('qweqeqweqeq');
  System.assertEquals(sourceSystem, null); 
     
 }
    
         /* Verifies that CommunitiesCheckEmailController returns user source system */
 @IsTest
 static void CheckPasswordGetSourceSystemValid() {
  Test.setCurrentPageReference(new PageReference('Page.KUKA_communitiesPasswordConfirmation')); 
  System.currentPageReference().getParameters().put('username',getUser().Username);
      
 
  RedirectURLConfig__c ZInstance1 = new RedirectURLConfig__c( targetURL__c = 'https://kuka.connect.com',Name='CONNECT');
  insert ZInstance1;
  CommunitiesCheckEmailController controller = new CommunitiesCheckEmailController();
         
  PageReference sourceSystem =   controller.getSourceSystem();
     
  System.debug('Source System' + sourceSystem);
  
  System.assertNotEquals(sourceSystem, null); 
     
 }
    
    
    
         /* Verifies that CommunitiesCheckEmailController returns source system */
 @IsTest
 static void CheckPasswordGetSourceSystemValidWithParam() {
  CommunitiesCheckEmailController controller = new CommunitiesCheckEmailController();
  RedirectURLConfig__c ZInstance1 = new RedirectURLConfig__c( targetURL__c = 'https://kuka.connect.com',Name='CONNECT');
  insert ZInstance1;
   
         
  PageReference sourceSystem =   controller.getSourceSystem();
  
  System.assertNotEquals(sourceSystem, null); 
     
 }
    
     public static User getUser(){
        User newUser = new User();
        newUser.LastName = 'System Administrator2';
        newUser.Alias = 'user2';
        newUser.UserRegistrationSource__c = 'Connect';
        newUser.Email = 'user1@email1.bg';
        newUser.Username = 'test1_@email1.bg';
        newUser.CommunityNickname = 'test1_@email1.bg';
        newUser.ProfileId = [SELECT id
                             FROM Profile
                            WHERE name= 'System Administrator'].id;
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.LocaleSidKey = 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';
        newUser.IsActive = true;
        Profile p = [select id from profile where name='Standard User'];
        newUser.ProfileId = p.id;
        insert newUser;
        System.assertNotEquals(null, newUser);
        return newUser;
    }
}