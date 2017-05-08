/**
 * An apex page controller that exposes the change password functionality
 */
@IsTest(SeeAllData=false) 
public with sharing class CommunitiesChangePasswordControllerTest {
	
     private static User userobj;
    private static User userobj2;
    private static UserRole userRoleObj;
    private static Profile profileObj;
    private static Profile profileObj2;
    private static Account accountObj;
	
   	@IsTest
   	public static void testChangePasswordController_connect() {
   		init('CONNECT');
        // Instantiate a new controller with all parameters in the page
        CommunitiesChangePasswordController controller = new CommunitiesChangePasswordController();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';    
         // insert custom setting
       //  User pu = getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        System.runAs(userobj2) {
               RedirectURLConfig__c ZInstance1 = new RedirectURLConfig__c( targetURL__c = 'https://kuka.connect.com',Name='CONNECT');
              insert ZInstance1;
              controller.changePassword(); 
    
      } 
    }  
    
    
     	@IsTest
   	public static void testChangePasswordController_shop1() {
   		init('ECOMMERCE');
        // Instantiate a new controller with all parameters in the page
        CommunitiesChangePasswordController controller = new CommunitiesChangePasswordController();
        controller.oldPassword = '1234561';
        controller.newPassword = 'qwerty12'; 
        controller.verifyNewPassword = 'qwerty12';    
         // insert custom setting
       //  User pu = getPortalUser(APTSMD_testUtils.PortalType.PowerPartner, null, true);
        System.runAs(userobj2) {
              RedirectURLConfig__c ZInstance1 = new RedirectURLConfig__c( targetURL__c = 'https://shop.kuka.com',Name='ECOMMERCE');
     
              insert ZInstance1;
              controller.changePassword(); 
    
      } 
    }  
        
        
    
  // Helper function for testmethods    
    static void init(String source) {
          // insert user
         userRoleobj = [Select id from userrole where name='Systems'];
         profileObj2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         profileObj = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         userObj = new User(Alias = 'standt12', Email='standarduser1100@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileObj.Id, CommunityNickname =  'standtuser10',
            TimeZoneSidKey='America/Los_Angeles',  UserName='standarduser1010@testorg.com.kuka');
        insert userObj;       
        accountObj = new Account(Name='Test1 Acc1ount',ShippingStreet='AndersonMill Road',ShippingCity='Austin',ShippingState='Texas',
                         ShippingCountry='USA',ShippingPostalCode='78650', BillingStreet='AndersonMill Road',BillingCity='Austin',BillingState='Texas',
                        BillingCountry='USA',BillingPostalCode='78650',OwnerId = userObj.id );                       
        
        insert accountObj;
        accountObj.isPartner = true;
        update accountObj;
        userObj2 = new User(Alias = 'Admi1nt9', Email='standardus1er101@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileObj2.Id, CommunityNickname =  'Adm1inuser9',
            TimeZoneSidKey='America/Los_Angeles',UserRegistrationSource__c = source,  UserName='standarduser101@testorg.com.kuka');
        insert userObj2;   
        
        
       
    }
   
   
     private static void updateUserRole(){
      userObj.UserRoleId = userRoleobj.id;
      update userObj;        
    }   
       
    
}