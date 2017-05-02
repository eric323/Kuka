/**********************************************************************
Name:  UserTriggerHandlerTest
======================================================
Purpose: Unittest class for UserTriggerHandler
======================================================
History
-------
Date        AUTHOR                          DETAIL
15/12/2016  Andreas Meyer                   INITIAL (DC-1175)
15/12/2016  Andreas Meyer 			        Update eCommerce update criteria (DC-1175)
*********************************************************************/
@isTest
private class UserTriggerHandlerTest {


    /***********************************************************************
    Class:  Unittest_TestRecordsData
    ==============================================================
    Purpose:
    Container for all test data that is used in each testMethod
    The Standard Constructor sets the default values, overwrite them before
    you pass the object to a 'createTestRecords' function of the parent class.
    ==============================================================
    **********************************************************************/
    private class Unittest_TestRecordsData {

        Account                     testAccount                     {get;set;}
        Contact                     testContact                     {get;set;}
        String                      defaultMarketingSegment         {get;set;}
        String                      defaultIndustry                 {get;set;}
        Profile 					defaultProfileUser				{get;set;}

        // Standardconstructor
        private Unittest_TestRecordsData() {
            // init default values
            defaultMarketingSegment = 'Automotive';
            defaultIndustry = 'Auto Body Shop';
        }
    }

    static void createTestRecordsForUserTrigger(Unittest_TestRecordsData testrecords) {

        // Unittest_TestRecordsData must exist
        if (null == testrecords)
            return;

         // get role
         UserRole userRoleobj = [Select Id From UserRole Where PortalType = 'None' Limit 1];
         // get profile admin
         Profile profileObj2 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         // get profile user
         testrecords.defaultProfileUser = [SELECT Id FROM Profile WHERE Name='Customer Community Plus User']; 

         User userObj = new User(	Alias = 'standt1',
	         						Email='standarduser100@testorg.com',
	            					EmailEncodingKey='UTF-8', 
	            					LastName='Testing', 
	            					LanguageLocaleKey='en_US', 
	            					LocaleSidKey='en_US', 
	            					ProfileId = profileObj2.Id, 
	            					UserRoleId = userRoleobj.Id,
	            					CommunityNickname =  'standtuser0',
	            					TimeZoneSidKey='America/Los_Angeles',  
	            					UserName='standarduser100@testorg.com.kuka');
        insert userObj;       

        // create account
        System.runAs ( userObj ) {
	        testrecords.testAccount = new Account(  Name='Test Account',
	                                                BillingStreet = 'Teststreet',
	                                                BillingPostalCode = '12345',
	                                                BillingCity = 'Test City',
	                                                BillingCountryCode = 'DE',
	                                                OwnerId = userObj.id  );


	        insert testrecords.testAccount;
	        // update partner setting
	        testrecords.testAccount.IsPartner = true;
	        update testrecords.testAccount;

		    // create contact
		    testrecords.testContact = new Contact(  FirstName='Test',
		                                            Salutation='Mr',
		                                            LastName='Contact',
		                                            Email = 'testcontact@internet.org',
		                                            AccountId = testrecords.testAccount.Id);

		    insert testrecords.testContact;

	    }
    }


   static testMethod void Unittest_createUser_with_eCommerceRegion() {
        /**********************************************
        Testing the User Trigger with an User 
        The user countrycode must be !0 'US'
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // get standard test objects for test
        createTestRecordsForUserTrigger(testdata);

        Test.startTest();
        // create test data with CountryCode MX (Mexico)
		User testuser = new User(	Alias = 'standt2',
									Email='standarduser200@testorg.com',
									EmailEncodingKey='UTF-8', 
									LastName='Testing2', 
									LanguageLocaleKey='en_US', 
									LocaleSidKey='en_US', 
									ProfileId = testdata.defaultProfileUser.Id, 
									CommunityNickname =  'standtuser2',
									TimeZoneSidKey='America/Los_Angeles',
									CountryCode='MX',  
									UserName='standarduser200@testorg.com.kuka',
									ContactID = testdata.testContact.Id); 

        insert testuser;

        Test.stopTest();

        // requery user
        List<User> listUsers = new List<User>([   SELECT Id, APTSDMP_eCommerce_Region__c, DefaultCurrencyIsoCode  
                                                                        FROM User 
                                                                        WHERE Id = :testuser.Id]);       

        /**********************************************
        check listUsers:
        - listUsers must not be empty
        - listUsers must have a size of 1
        - listUsers[0].APTSDMP_eCommerce_Region__c must be 'Supported Region'
        - istUsers[0].DefaultCurrencyIsoCode must be 'USD'
        **********************************************/
        System.assertEquals( false , listUsers.isEmpty(), 'listUsers is empty'); 
        System.assertEquals( 1 , listUsers.size(), 'listUsers size is != 1'); 
        System.assertEquals( 'Supported Region', listUsers[0].APTSDMP_eCommerce_Region__c, 'APTSDMP_eCommerce_Region__c wont match'); 
        System.assertEquals( 'USD', listUsers[0].DefaultCurrencyIsoCode, 'DefaultCurrencyIsoCode wont match'); 

    }

   static testMethod void Unittest_createUser_with_eCommerceRegion_EUR() {
        /**********************************************
        Testing the User Trigger with an User 
        The user countrycode must be !0 'US'
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // get standard test objects for test
        createTestRecordsForUserTrigger(testdata);

        Test.startTest();
        // create test data with CountryCode MX (Mexico)
		User testuser = new User(	Alias = 'standt2',
									Email='standarduser200@testorg.com',
									EmailEncodingKey='UTF-8', 
									LastName='Testing2', 
									LanguageLocaleKey='en_US', 
									LocaleSidKey='en_US', 
									ProfileId = testdata.defaultProfileUser.Id, 
									CommunityNickname =  'standtuser2',
									TimeZoneSidKey='America/Los_Angeles',
									CountryCode='SE',  
									UserName='standarduser200@testorg.com.kuka',
									ContactID = testdata.testContact.Id); 

        insert testuser;

        Test.stopTest();

        // requery user
        List<User> listUsers = new List<User>([   SELECT Id, APTSDMP_eCommerce_Region__c, DefaultCurrencyIsoCode  
                                                                        FROM User 
                                                                        WHERE Id = :testuser.Id]);       

        /**********************************************
        check listUsers:
        - listUsers must not be empty
        - listUsers must have a size of 1
        - listUsers[0].APTSDMP_eCommerce_Region__c must be 'Supported Region'
        - istUsers[0].DefaultCurrencyIsoCode must be 'EUR'
        **********************************************/
        System.assertEquals( false , listUsers.isEmpty(), 'listUsers is empty'); 
        System.assertEquals( 1 , listUsers.size(), 'listUsers size is != 1'); 
        System.assertEquals( 'Supported Region', listUsers[0].APTSDMP_eCommerce_Region__c, 'APTSDMP_eCommerce_Region__c wont match'); 
        System.assertEquals( 'EUR', listUsers[0].DefaultCurrencyIsoCode, 'DefaultCurrencyIsoCode wont match'); 

    }    

   static testMethod void Unittest_createUser_with_eCommerceRegion_unsupported_EUR() {
        /**********************************************
        Testing the User Trigger with an User 
        The user countrycode must be !0 'US'
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // get standard test objects for test
        createTestRecordsForUserTrigger(testdata);

        Test.startTest();
        // create test data with CountryCode MX (Mexico)
		User testuser = new User(	Alias = 'standt2',
									Email='standarduser200@testorg.com',
									EmailEncodingKey='UTF-8', 
									LastName='Testing2', 
									LanguageLocaleKey='en_US', 
									LocaleSidKey='en_US', 
									ProfileId = testdata.defaultProfileUser.Id, 
									CommunityNickname =  'standtuser2',
									TimeZoneSidKey='America/Los_Angeles',
									CountryCode='BA',  
									UserName='standarduser200@testorg.com.kuka',
									ContactID = testdata.testContact.Id); 

        insert testuser;

        Test.stopTest();

        // requery user
        List<User> listUsers = new List<User>([   SELECT Id, APTSDMP_eCommerce_Region__c, DefaultCurrencyIsoCode  
                                                                        FROM User 
                                                                        WHERE Id = :testuser.Id]);       

        /**********************************************
        check listUsers:
        - listUsers must not be empty
        - listUsers must have a size of 1
        - listUsers[0].APTSDMP_eCommerce_Region__c must be 'Unsupported Region'
        - istUsers[0].DefaultCurrencyIsoCode must be 'EUR'
        **********************************************/
        System.assertEquals( false , listUsers.isEmpty(), 'listUsers is empty'); 
        System.assertEquals( 1 , listUsers.size(), 'listUsers size is != 1'); 
        System.assertEquals( 'Unsupported Region', listUsers[0].APTSDMP_eCommerce_Region__c, 'APTSDMP_eCommerce_Region__c wont match'); 
        System.assertEquals( 'EUR', listUsers[0].DefaultCurrencyIsoCode, 'DefaultCurrencyIsoCode wont match'); 

    }   

   static testMethod void Unittest_createUser_with_CommunityContact() {
        /**********************************************
        Testing the User Trigger with an User with a given 
        contact.
        The contact must be updated
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // get standard test objects for test
        createTestRecordsForUserTrigger(testdata);

        Test.startTest();
        // create test data
		User testuser = new User(	Alias = 'standt2',
									Email='standarduser200@testorg.com',
									EmailEncodingKey='UTF-8', 
									LastName='Testing2', 
									LanguageLocaleKey='en_US', 
									LocaleSidKey='en_US', 
									ProfileId = testdata.defaultProfileUser.Id, 
									CommunityNickname =  'standtuser2',
									TimeZoneSidKey='America/Los_Angeles',
									UserName='standarduser200@testorg.com.kuka',
									CustomerNumber__c = '12345',
									E_Mail__c = 'Allow',
									Letter__c = 'Allow',
									Newsletter__c = 'Allow',
									Telephone__c = 'Allow',
									MobilePhone = '+49 30 123455',
									Salutation__c = 'Mr',
									Title = 'Dr',
									City = 'Munich',
									CountryCode = 'DE',
									PostalCode = '86101',
									StateCode = '09',
									Street = 'Teststreet',
									DefaultCurrencyIsoCode = 'EUR',		
									PortalRole = 'Manager',						
									ContactId = testdata.testContact.Id); 

        insert testuser;


        Test.stopTest();







        // requery contact
        List<Contact> listContacts = new List<Contact>([   SELECT 	Id,
																	CommunityCustomerNumber__c,
																	E_Mail__c,
																	Letter__c,
																	Newsletter__c,
																	Telephone__c,
																	MobilePhone,
																	Salutation,
																	Title ,
																	MailingCity,
																	MailingCountryCode,
																	MailingPostalCode ,
																	MailingStateCode,
																	MailingStreet,
																	CurrencyIsoCode         	
	                                                                FROM Contact 
	                                                                WHERE Id = :testdata.testContact.Id]);       

        /**********************************************
        check listContacts:
        - listContacts must not be empty
        - listContacts must have a size of 1
        - check all transferred values 
        **********************************************/
        System.assertEquals( false , listContacts.isEmpty(), 'listContacts is empty'); 
        System.assertEquals( 1 , listContacts.size(), 'listContacts size is != 1'); 
		System.assertEquals(listContacts[0].CommunityCustomerNumber__c , testuser.CustomerNumber__c, 'CustomerNumber__c wont match');
		System.assertEquals(listContacts[0].E_Mail__c , testuser.E_Mail__c, 'E_Mail__c wont match');
		System.assertEquals(listContacts[0].Letter__c , testuser.Letter__c, 'Letter__c wont match');
		System.assertEquals(listContacts[0].Newsletter__c , testuser.Newsletter__c, 'Newsletter__c wont match');
		System.assertEquals(listContacts[0].Telephone__c , testuser.Telephone__c, 'Telephone__c wont match');
		System.assertEquals(listContacts[0].MobilePhone , testuser.MobilePhone, 'MobilePhone wont match');
		System.assertEquals(listContacts[0].Salutation , testuser.Salutation__c, 'Salutation__c wont match');
		System.assertEquals(listContacts[0].Title , testuser.Title, 'Title wont match');
		System.assertEquals(listContacts[0].MailingCity , testuser.City, 'City wont match');
		System.assertEquals(listContacts[0].MailingCountryCode , testuser.CountryCode, 'CountryCode wont match');
		System.assertEquals(listContacts[0].MailingPostalCode , testuser.PostalCode, 'PostalCode wont match');
		System.assertEquals(listContacts[0].MailingStateCode , testuser.StateCode, 'StateCode wont match');
		System.assertEquals(listContacts[0].MailingStreet , testuser.Street, 'Street wont match');     
		System.assertEquals(listContacts[0].CurrencyIsoCode , testuser.DefaultCurrencyIsoCode, 'DefaultCurrencyIsoCode wont match');   

    }

   static testMethod void Unittest_updateUser_with_CurrencyIsoCode() {
        /**********************************************
        Testing the User Trigger with an User.
        The contact isocode must be updated
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // get standard test objects for test
        createTestRecordsForUserTrigger(testdata);

        
        // create test data
		User testuser = new User(	Alias = 'standt2',
									Email='standarduser200@testorg.com',
									EmailEncodingKey='UTF-8', 
									LastName='Testing2', 
									LanguageLocaleKey='en_US', 
									LocaleSidKey='en_US', 
									ProfileId = testdata.defaultProfileUser.Id, 
									CommunityNickname =  'standtuser2',
									TimeZoneSidKey='America/Los_Angeles',
									CountryCode='DE',  
									DefaultCurrencyIsoCode = 'EUR',
									UserName='standarduser200@testorg.com.kuka',
									ContactID = testdata.testContact.Id); 

        insert testuser;

		Test.startTest();

		// update user object
		testuser.DefaultCurrencyIsoCode = 'USD';
		update testuser;

        Test.stopTest();

        // requery contact
        List<Contact> listContacts = new List<Contact>([   SELECT 	Id,
																	CurrencyIsoCode         	
	                                                                FROM Contact 
	                                                                WHERE Id = :testdata.testContact.Id]);        

        /**********************************************
        check listContacts:
        - listContacts must not be empty
        - listContacts must have a size of 1
        - check currency on contact
        **********************************************/
        System.assertEquals( false , listContacts.isEmpty(), 'listContacts is empty'); 
        System.assertEquals( 1 , listContacts.size(), 'listContacts size is != 1'); 
		System.assertEquals(listContacts[0].CurrencyIsoCode , testuser.DefaultCurrencyIsoCode, 'DefaultCurrencyIsoCode wont match');   

    }


}