/**
 * An apex page controller that exposes the change password functionality
 */
@IsTest(SeeAllData=false) 
public with sharing class CommunitiesChangePasswordControllerTest {
   	@IsTest
   	public static void testChangePasswordController_connect() {
        // Instantiate a new controller with all parameters in the page
        CommunitiesChangePasswordController controller = new CommunitiesChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';    
         // insert custom setting
        RedirectURLConfig__c ZInstance1 = new RedirectURLConfig__c( targetURL__c = 'https://kuka.connect.com',Name='CONNECT');
        insert ZInstance1;
       System.runAs(getUser()) {
            System.assertNotEquals(controller.changePassword(),null);         
      }
    }  
        
    @IsTest
   	public static void testChangePasswordController_shop() {
        // Instantiate a new controller with all parameters in the page
        CommunitiesChangePasswordController controller = new CommunitiesChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty2'; 
        controller.verifyNewPassword = 'qwerty2';    
         // insert custom setting
        RedirectURLConfig__c ZInstance1 = new RedirectURLConfig__c( targetURL__c = 'https://shop.kuka.com',Name='ECOMMERCE');
        insert ZInstance1;
       System.runAs(getUser1()) {
            System.assertEquals(controller.changePassword(),null);         
      }
        
                        
    }  
    public enum PortalType { CSPLiteUser, PowerPartner, PowerCustomerSuccess, CustomerSuccess }
    
     public static User getUser(){
        User newUser = new User();
        newUser.LastName = 'System Administrator12';
        newUser.Alias = 'user2';
        newUser.UserRegistrationSource__c = 'Connect';
        newUser.Email = 'user2@email3.bg';
        newUser.Username = 'test2_@email3.bg';
        newUser.CommunityNickname = 'test2_@email3.bg';
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
    
      public static User getUser1(){
        User newUser = new User();
        newUser.LastName = 'System Administrator13';
        newUser.Alias = 'user2';
        newUser.UserRegistrationSource__c = 'Connect';
        newUser.Email = 'user2@email4.bg';
        newUser.Username = 'test2_@email4.bg';
        newUser.CommunityNickname = 'test2_@email3.bg';
        newUser.ProfileId = [SELECT id
                             FROM Profile
                            WHERE name= 'System Administrator'].id;
        newUser.TimeZoneSidKey = 'America/Los_Angeles';
        newUser.UserRegistrationSource__c = 'Ecommerce';
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