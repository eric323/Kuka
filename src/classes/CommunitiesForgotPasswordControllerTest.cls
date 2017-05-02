/**
 * An apex page controller that exposes the site forgot password functionality
 */
@IsTest 
public with sharing class CommunitiesForgotPasswordControllerTest {
    
    @IsTest(SeeAllData=false) 
    public static void testCommunitiesForgotPasswordController() {
         
        communitySelfRegSettings__c ZInstance1 = new communitySelfRegSettings__c( Name = 'usernameExtension',value__c='.kukaTest');
        insert ZInstance1;
    	// Instantiate a new controller with all parameters in the page
    	CommunitiesForgotPasswordController controller = new CommunitiesForgotPasswordController();
    	controller.username = 'test1_@email.bg';     	
        PageReference page = controller.forgotPassword();
    	System.assertEquals(page,null); 
    }
    
     public static User getUserRec(){
        User newUser = new User();
        newUser.LastName = 'System Administrator1';
        newUser.Alias = 'user1';
        newUser.UserRegistrationSource__c = 'Connect';
        newUser.Email = 'user1@email.bg';
        newUser.Username = 'test1_@email.bg.kukaTest';
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