@IsTest(SeeAllData = false)
public with sharing class LightningCheckPasswordControllerTest {

 /* Verifies that LightningForgotPasswordController object is instantiated correctly. */
 @IsTest
 static void LightningCheckPasswordControllerInstantiation() {
  LightningCheckPasswordController controller = new LightningCheckPasswordController();
  System.assertNotEquals(controller, null);
 }
    
     /* Verifies that LightningCheckPasswordControllerGetUser returns user details */
 @IsTest
 static void LightningCheckPasswordgetSourceSystemInvalid() {
  LightningCheckPasswordController controller = new LightningCheckPasswordController();
  String sourceSystem =   LightningCheckPasswordController.getSourceSystem('qweqeqweqeq');
  System.assertEquals(sourceSystem, null); 
     
 }
    
         /* Verifies that LightningCheckPasswordControllerGetUser returns user details */
 @IsTest
 static void LightningCheckPasswordGetSourceSystemValid() {
  LightningCheckPasswordController controller = new LightningCheckPasswordController();
   RedirectURLConfig__c ZInstance1 = new RedirectURLConfig__c( targetURL__c = 'https://kuka.connect.com',Name='CONNECT');
        insert ZInstance1;
   
         
  String sourceSystem =   LightningCheckPasswordController.getSourceSystem(getUser().Username);
  System.assertNotEquals(sourceSystem, null); 
     
 }
    
     public static User getUser(){
        User newUser = new User();
        newUser.LastName = 'System Administrator1';
        newUser.Alias = 'user1';
        newUser.UserRegistrationSource__c = 'Connect';
        newUser.Email = 'user1@email.bg';
        newUser.Username = 'test1_@email.bg';
        newUser.CommunityNickname = 'test1_@email.bg';
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