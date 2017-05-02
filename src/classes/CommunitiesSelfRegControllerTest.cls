/**********************************************************************
Name:  CommunitiesSelfRegControllerTest
======================================================
Purpose:

Unittest Class for CommunitiesSelfRegController
======================================================
History
-------
Date            AUTHOR                      DETAIL
20/10/2016      Andreas Meyer               extend existing test methods
28/11/2016      Andreas Meyer               add fallback strategy for duplicate nickname
05/12/2016      Andreas Meyer               add validation for phonennumbers
05/12/2016      Benjamin Pfahl              dynamic partner account detection
06/12/2016      Andreas Meyer               change function call for checkautoassign_connect
06/12/2016      Arokia Joseph               added new function to registerNewuser with all required values
13/12/2016      Andreas Meyer               change RegEx expression to meet more requirements
19/12/2016      Andreas Meyer               limit Nickname to 40 characters
19/12/2016      Andreas Meyer               switch to email notification mode for createExternalUser
17/01/2017      Andreas Meyer               DC-1248 autoassign User.Users_Organisation
*********************************************************************/
@IsTest public with sharing class CommunitiesSelfRegControllerTest {
    private static User userobj;
    private static User userobj2;
    private static UserRole userRoleObj;
    private static Profile profileObj;
    private static Profile profileObj2;
    private static Account accountObj;
 
    @IsTest(SeeAllData=true) 
    public static void testCommunitiesSelfRegController() {


        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        
        // registerUser will always return null when the page isn't accessed as a guest user
        System.assert(controller.registerUser() == null);    
        
        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);  
    }  
   


    static testMethod void Unittest_registerNewUser() {

        // insert custom setting
        communitySelfRegSettings__c ZInstance1 = new communitySelfRegSettings__c( value__c = '.kukatest',Name='usernameExtension');
        insert ZInstance1;


        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.email = 'testuser@internet.org';
        controller.helperContact.Salutation = 'Mr';
        controller.firstName = 'Test';
        controller.lastName = 'User';
        controller.helperContact.Phone = '12345';
        controller.helperContact.MobilePhone = '344544545';
        controller.position='test';
        controller.company='testcompany';
        controller.hMailingStreet='teststreet';
        controller.helperContact.MailingCity='testcity';
        controller.helperContact.MailingPostalCode='456';
        controller.helperContact.MailingCountryCode='US';
        controller.helperContact.MailingStateCode='AZ';
        controller.helperPermEmail=true;
        controller.helperPermLetter=true;
        controller.helperPermNewsletter=true;
        controller.helperPermTelefon=true;   

        controller.password = 'abcd1234$$';
        controller.confirmPassword = 'abcd1234$$';  
        controller.tos_accepted = true;      

        controller.registerUser(); 
        //email and newsletter is always set to true test
    /*    boolean showPassword = false;
        communitySelfRegSettings__c useEmailVal = communitySelfRegSettings__c.getInstance('useEmailValidation');
        useEmailVal.id = null;
        
		System.assertEquals(true,showPassword); 
        System.assertEquals(null,useEmailVal);*/
        

        // see if we have a user:
        List<User> listNewUsers = new List<User>([SELECT ID,CommunityNickname,Username FROM User WHERE Email = 'testuser@internet.org']); 
        /*
        System.assertEquals(false, listNewUsers.isEmpty());
        System.assertEquals(1, listNewUsers.size());  
        String hUsername = 'testuser@internet.org.kukatest';
        System.assertEquals(hUsername, listNewUsers[0].Username);   
        String hNickname = 'Test User (testcompany)';
        System.assertEquals(hNickname, listNewUsers[0].CommunityNickname);  
        */   

    }  


    static testMethod void Unittest_findAlternativeNickname() {

         // insert custom setting
        communitySelfRegSettings__c ZInstance1 = new communitySelfRegSettings__c( value__c = '.kukatest',Name='usernameExtension');
        insert ZInstance1;

        // insert user
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u1 = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, CommunityNickname =  'standtuser0',
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@testorg.com.kuka');
        insert u1;

        User u2 = new User(Alias = 'standt2', Email='standarduser2@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, CommunityNickname =  'standtuser1',
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2@testorg.com.kuka');
        insert u2;        

        Test.startTest();
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();  

        // use controller function
        String newNickname = controller.findUniqueNickname('standtuser');
        Test.stopTest();

        // check if the returned nickname has changed
        System.assertEquals(newNickname, 'standtuser2'); 

    }  

    static testMethod void Unittest_findAlternativeNickname_40character() {

         // insert custom setting
        communitySelfRegSettings__c ZInstance1 = new communitySelfRegSettings__c( value__c = '.kukatest',Name='usernameExtension');
        insert ZInstance1;

        // insert user with 40 character nickname
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u1 = new User(Alias = 'standt1', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, CommunityNickname =  '123456789012345678901234567890abcdefghij',
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser1@testorg.com.kuka');
        insert u1;

        Test.startTest();
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();  

        // use controller function
        String newNickname = controller.findUniqueNickname('123456789012345678901234567890aaaaaaaaaabbb');
        String newNickname2 = controller.findUniqueNickname('123456789012345678901234567890abcdefghij');
        Test.stopTest();

        // check if the returned nickname has changed to 40 chars
        System.assertEquals(newNickname, '123456789012345678901234567890aaaaaaaaaa'); 
        // check if the returned nickname2 has changed to 37 chars + number (0)
        System.assertEquals(newNickname2, '123456789012345678901234567890abcdefg0'); 
    }  


    static testMethod void Unittest_testPhonenumberValidation() {

        String validPhonenumber1 = '+49 2901 605343';
        String validPhonenumber2 = '+1 415 937 1818';
        String validPhonenumber3 = '+492901605343';   
        String validPhonenumber4 = '+49 (30) 2901605343';  

        // italy
        String validPhonenumber5_IT = '+49 0291 605343';  // having a 0 in the second group
         
        String invalidPhonenumber2 = '+1.415.937.1818';
        String invalidPhonenumber3 = '00492901605343';
        String invalidPhonenumber1 = '123456';
        String invalidPhonenumber4 = '+49 2901g 605343';
        String invalidPhonenumber5 = 'g+49 2901g 605343';

        Test.startTest();
        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();  

        Test.stopTest();

        // check if the Phonenumbers are checked correctly
        System.assertEquals(true, controller.isValidPhonenumber(validPhonenumber1,'')); 
        System.assertEquals(true, controller.isValidPhonenumber(validPhonenumber2,''));        
        System.assertEquals(true, controller.isValidPhonenumber(validPhonenumber3,'')); 
        System.assertEquals(true, controller.isValidPhonenumber(validPhonenumber4,'')); 
        // check for italy as well
        System.assertEquals(true, controller.isValidPhonenumber(validPhonenumber1,'IT')); 
        System.assertEquals(true, controller.isValidPhonenumber(validPhonenumber2,'IT'));        
        System.assertEquals(true, controller.isValidPhonenumber(validPhonenumber3,'IT')); 
        System.assertEquals(true, controller.isValidPhonenumber(validPhonenumber4,'IT')); 
        System.assertEquals(true, controller.isValidPhonenumber(validPhonenumber5_IT,'IT')); 

        System.assertEquals(false, controller.isValidPhonenumber(invalidPhonenumber4,''));
        System.assertEquals(false, controller.isValidPhonenumber(invalidPhonenumber5,''));  
        System.assertEquals(false, controller.isValidPhonenumber(invalidPhonenumber3,'')); 
        System.assertEquals(false, controller.isValidPhonenumber(invalidPhonenumber2,''));         
        System.assertEquals(false, controller.isValidPhonenumber(invalidPhonenumber1,'')); 
        // check for italy as well
        System.assertEquals(false, controller.isValidPhonenumber(invalidPhonenumber4,'IT')); 
        System.assertEquals(false, controller.isValidPhonenumber(invalidPhonenumber5,'IT')); 
        System.assertEquals(false, controller.isValidPhonenumber(invalidPhonenumber3,'IT')); 
        System.assertEquals(false, controller.isValidPhonenumber(invalidPhonenumber2,'IT'));         
        System.assertEquals(false, controller.isValidPhonenumber(invalidPhonenumber1,'IT'));         

    }
 

    // Helper function for testmethods    
    static void init() {
          // insert user
         userRoleobj = [Select id from userrole where name='Systems'];
         profileObj2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         profileObj = [SELECT Id FROM Profile WHERE Name='Standard User']; 
         userObj = new User(Alias = 'standt1', Email='standarduser100@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileObj.Id, CommunityNickname =  'standtuser0',
            TimeZoneSidKey='America/Los_Angeles',  UserName='standarduser100@testorg.com.kuka');
        insert userObj;       
        accountObj = new Account(Name='Test Account',ShippingStreet='AndersonMill Road',ShippingCity='Austin',ShippingState='Texas',
                         ShippingCountry='USA',ShippingPostalCode='78650', BillingStreet='AndersonMill Road',BillingCity='Austin',BillingState='Texas',
                        BillingCountry='USA',BillingPostalCode='78650',OwnerId = userObj.id );                       
        
        insert accountObj;
        accountObj.isPartner = true;
        update accountObj;
        userObj2 = new User(Alias = 'Admint9', Email='standarduser101@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = profileObj2.Id, CommunityNickname =  'Adminuser9',
            TimeZoneSidKey='America/Los_Angeles',  UserName='standarduser101@testorg.com.kuka');
        insert userObj2;   
        
        
       
    }

    
    private static void updateUserRole(){
      userObj.UserRoleId = userRoleobj.id;
      update userObj;        
    }    
      //arokia.joseph added this method to cover testcheckautoassign_connect method
    static testMethod void Unittest_testcheckautoassign_connect(){
        
       
        init();
         // insert custom setting
        communitySelfRegSettings__c ZInstance1 = new communitySelfRegSettings__c( value__c = '.kukatest',Name='usernameExtension');
        insert ZInstance1;
        System.runAs(userObj2){
          
            Test.startTest();
            updateUserRole();
            CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
            String accountId = accountObj.Id;
            // use controller function
            String testAccountId = controller.checkautoassign_connect(accountId, true);
            Test.stopTest();
          
            // check if the returned string is the account number
            System.assertEquals(testAccountId, accountId); 
       }
    }
    //arokia.joseph added this method to cover testcheckautoassign_connect method
   static testMethod void Unittest_testcheckautoassign_connectIsPartner(){
       
        init();
        System.runAs(userObj){
                 
            Test.startTest();
            CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
            String accountId = accountObj.Id;
            // use controller function
            String testAccountId = controller.checkautoassign_connect(accountId, true);
            Test.stopTest();
          
            // check if the returned string is blank
            System.assertEquals(testAccountId, '' ); 
        }
    } 
    
    //arokia.joseph added this method to increase code coverage 
     static testMethod void Unittest_registerNewUser_withAllValues() {

        // insert custom setting
        communitySelfRegSettings__c ZInstance1 = new communitySelfRegSettings__c( value__c = '.kukatest',Name='usernameExtension');
        insert ZInstance1;
         
         //contact object instance
        Contact contactObj = new Contact(LastName='TestUser',Email='testuser100@testorg.com', MobilePhone = '+1 234 567-8900', Phone = '+1 234 567-8900' , Salutation ='Mr' , MailingCountryCode = '001',MailingCity='testcity',MailingPostalCode='456',MailingStateCode='AZ') ;

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.email = 'testuser@internet.org';
        controller.helperContact.Salutation = 'Mr';
        controller.firstName = 'Test';
        controller.lastName = 'User';
        controller.helperContact.Phone = '+1 234 567-8900';
        controller.helperContact.MobilePhone = '+1 234 567-8900';
        controller.position='test';
        controller.company='testcompany';
        controller.hMailingStreet='teststreet';
        controller.helperContact.MailingCity='testcity';
        controller.helperContact.MailingPostalCode='456';
        controller.helperContact.MailingCountryCode='US';
        controller.helperContact.MailingStateCode='AZ';
        controller.helperPermEmail=true;
        controller.helperPermLetter=true;
        controller.helperPermNewsletter=true;
        controller.helperPermTelefon=true;  
        controller.target='https://connect.kuka.com'; 
        controller.registrationSource ='Connect';
        
        controller.password = 'abcd1234$$';
        controller.confirmPassword = 'abcd1234$$';  
        controller.tos_accepted = true; 
         //Assign helper contact to prevent phone and mobile phone validation error
        controller.helperContact = contactObj;
        controller.registerUser();   

        // see if we have a user:
        List<User> listNewUsers = new List<User>([SELECT ID,CommunityNickname,Username FROM User WHERE Email = 'testuser@internet.org']); 
        /*
        System.assertEquals(false, listNewUsers.isEmpty());
        System.assertEquals(1, listNewUsers.size());  
        String hUsername = 'testuser@internet.org.kukatest';
        System.assertEquals(hUsername, listNewUsers[0].Username);   
        String hNickname = 'Test User (testcompany)';
        System.assertEquals(hNickname, listNewUsers[0].CommunityNickname);  
        */   

    }  


    static testMethod void Unittest_registerNewUser_checkforUsers_Organisation() {
        Set<String> options = new Set<String>();
            
        Schema.DescribeFieldResult fieldResult = User.Users_Organisation__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
        for( Schema.PicklistEntry f : ple)
        {
          options.add(f.getValue());
        }  

        System.assertEquals(false, options.isEmpty());
        System.assertEquals(true, options.contains(CommunitiesSelfRegController.USER_ORG_EXTERNAL_COMMUNITY) );


    }



    
}