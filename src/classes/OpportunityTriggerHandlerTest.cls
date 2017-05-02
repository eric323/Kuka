/**********************************************************************
Name:  OpportunityTriggerHandlerTest
======================================================
Purpose: Unittest class for OpportunityTriggerHandler
======================================================
History
-------
Date        AUTHOR                          DETAIL
06/10/2016  Andreas Meyer                   INITIAL
26/10/2016  Andreas Meyer                   DC-389 take market segment and industrie from account
01/03/2017  Andreas Meyer                   DC-1402 add Main_Contact__c to Account objects
15/03/2017  Andreas Meyer                   add Subgroup to OpportunitY AND Quotation_Due_Date
*********************************************************************/
@isTest
private class OpportunityTriggerHandlerTest {

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
        Opportunity                 testOpportunity                 {get;set;}
        Boolean                     addExtraAccountData             {get;set;}
        String                      defaultMarketingSegment         {get;set;}
        String                      defaultIndustry                 {get;set;}
        String                      defaultSubgroup                 {get;set;}

        // Standardconstructor
        private Unittest_TestRecordsData() {
            // init default values
            // in case overwrite defaults after creation
            addExtraAccountData = false;
            defaultMarketingSegment = 'Automotive';
            defaultIndustry = 'Auto Body Shop';
            defaultSubgroup = 'KUKA Industries';

        }
    }

    static void createTestRecordsForOppTrigger(Unittest_TestRecordsData testrecords) {

        // Unittest_TestRecordsData must exist
        if (null == testrecords)
            return;


        // create account

        testrecords.testAccount = new Account(  Name='Test Account',
                                                KUKA_Group_Key_Account__c = true,
                                                BillingStreet = 'Teststreet',
                                                BillingPostalCode = '12345',
                                                BillingCity = 'Test City',
                                                Duns__c = '123456789',
                                                BillingCountry = 'Germany'  );

        if (true == testrecords.addExtraAccountData){
            testrecords.testAccount.Market_Segment__c = testrecords.defaultMarketingSegment;
            testrecords.testAccount.Industry__c = testrecords.defaultIndustry;     
        }

        insert testrecords.testAccount;

        // create contact
        testrecords.testContact = new Contact(  FirstName='Test',
                                                Salutation='Mr',
                                                LastName='Contact',
                                                Email = 'testcontact@internet.org',
                                                AccountId = testrecords.testAccount.Id);

        insert testrecords.testContact;

    }


   static testMethod void Unittest_createOpportunity_manually() {
        /**********************************************
        Testing the Opportunity Trigger with a manual
        created opportunity
        the first contact of the assigned account should
        be assigned as the opportunity main contact
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // get standard test objects for test
        createTestRecordsForOppTrigger(testdata);

        // create test data
        String marketSegment = testdata.defaultMarketingSegment;
        String opptyIndustry = testdata.defaultIndustry;
        String stage = 'Qualify';
        String businessUnit = 'Swisslog WDS';
        Date closeDate = System.today().addDays(100);
        Date opptyOrderIntakeDate = System.today().addDays(100);        

        Test.startTest();

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = testdata.testAccount.Id,
            //Business_Unit_v2__c = businessUnit,
            //Industry_v2__c = opptyIndustry,
            Market_Segment__c = marketSegment,
            StageName = stage,
            CloseDate = closeDate,
            //Opportunity_Type__c = 'New Business',
            Opportunity_Order_Intake_Date__c = opptyOrderIntakeDate,
            Business_Unit__c = testdata.defaultSubgroup,
            Quotation_Due_Date__c = Date.today()
        );    

        insert testOpportunity;

        Test.stopTest();

        // requery opportunity
        List<Opportunity> listOpportunities = new List<Opportunity>([   SELECT Id, Main_Contact__c,AccountId  
                                                                        FROM Opportunity 
                                                                        WHERE Id = :testOpportunity.Id]);       

        /**********************************************
        check listOpportunities:
        - listOpportunities must not be empty
        - listOpportunities must have a size of 1
        - listOpportunities[0].AccountId must be testdata.testAccount.Id
        - listOpportunities[0].Main_Contact__c must be testdata.testContact
        **********************************************/
        System.assertEquals( false , listOpportunities.isEmpty(), 'listOpportunities is empty'); 
        System.assertEquals( 1 , listOpportunities.size(), 'listOpportunities size is != 1'); 
        System.assertEquals( testdata.testAccount.Id , listOpportunities[0].AccountId, 'Account wont match'); 
        System.assertEquals( testdata.testContact.Id , listOpportunities[0].Main_Contact__c, 'Main_Contact__c wont match'); 
    }


    static testMethod void Unittest_createOpportunity_via_page() {
        /**********************************************
        Testing the Opportunity Trigger with a opportunity
        created via standard page
        Passing a conid parameter should create a OpportunityContactRole
        object which references the contact
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // get standard test objects for test
        createTestRecordsForOppTrigger(testdata);

        String marketSegment = testdata.defaultMarketingSegment;
        String opptyIndustry = testdata.defaultIndustry;
        String stage = 'Qualify';
        String businessUnit = 'Swisslog WDS';
        Date closeDate = System.today().addDays(100);
        Date opptyOrderIntakeDate = System.today().addDays(100);        

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = testdata.testAccount.Id,
            //Business_Unit__c = businessUnit,
            Industry__c = opptyIndustry,
            Market_Segment__c = marketSegment,
            StageName = stage,
            CloseDate = closeDate,
            //Opportunity_Type__c = 'New Business',
            Opportunity_Order_Intake_Date__c = opptyOrderIntakeDate,
            Business_Unit__c = testdata.defaultSubgroup,
            Quotation_Due_Date__c = Date.today()
        );      

        PageReference pageCreateOpportunity = new PageReference('/006/e'); //set the return page reference to the New Opportunity page
        pageCreateOpportunity.getParameters().put('conid',testdata.testContact.Id); //contact id
        Test.setCurrentPage(pageCreateOpportunity);
        ApexPages.StandardController standardController = new ApexPages.standardController(testOpportunity); //instantiate the standard controller for the Opportunity object

        System.assertEquals( testdata.testContact.Id,ApexPages.currentPage().getParameters().get('conid'));

        Test.startTest();
        // save page
        System.PageReference retRef = standardController.save();
        system.debug('OpportunityTriggerHandlerTest.Unittest_createOpportunity_via_page retRef: ' + retRef);
        Test.stopTest();

        // query opportunity
        List<Opportunity> listOpportunities = new List<Opportunity>([   SELECT Id, Main_Contact__c,AccountId  
                                                                        FROM Opportunity 
                                                                        WHERE AccountId = :testdata.testAccount.Id]);       
        // query OpportunityContactRoles
        List<OpportunityContactRole> listOpportunityContactRoles = new List<OpportunityContactRole>([   SELECT Id, ContactId, OpportunityId 
                                                                                                        FROM OpportunityContactRole 
                                                                                                        WHERE ContactId = :testdata.testContact.Id  
                                                                                                        AND IsPrimary = true]);

        /**********************************************
        check listOpportunities:
        - listOpportunities must not be empty
        - listOpportunities must have a size of 1
        - listOpportunities[0].AccountId must be testdata.testAccount.Id
        - listOpportunities[0].Main_Contact__c must be testdata.testContact

        check listOpportunityContactRoles:
        - listOpportunityContactRoles must not be empty
        - listOpportunityContactRoles must have a size of 1
        - listOpportunityContactRoles[0].ContactId must be testdata.testContact     
        - listOpportunityContactRoles[0].OpportunityId must be listOpportunities[0].Id      
        **********************************************/
        System.assertEquals( false , listOpportunities.isEmpty(), 'listOpportunities is empty'); 
        System.assertEquals( 1 , listOpportunities.size(), 'listOpportunities size is != 1'); 
        System.assertEquals( testdata.testAccount.Id , listOpportunities[0].AccountId, 'Account wont match'); 
        System.assertEquals( testdata.testContact.Id , listOpportunities[0].Main_Contact__c, 'Main_Contact__c wont match');    
        /*  
        System.assertEquals( false , listOpportunityContactRoles.isEmpty(), 'listOpportunityContactRoles is empty'); 
        System.assertEquals( 1 , listOpportunityContactRoles.size(), 'listOpportunityContactRoles size is != 1'); 
        System.assertEquals( testdata.testContact.Id , listOpportunityContactRoles[0].ContactId, 'OpportunityContactRoles contactid wont match'); 
        System.assertEquals( listOpportunities[0].Id , listOpportunityContactRoles[0].OpportunityId, 'OpportunityContactRoles OpportunityId wont match'); 
        */
    }

    /* DC-389 take market segment and industrie from account on opportunity update */
   static testMethod void Unittest_createOpportunity_transfer_Marketing_and_Industry_onInsert() {
        /**********************************************
        Testing the Opportunity Trigger with a manual
        created opportunity
        Marketing segment and Industry must be transferred from account
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // add Marketing Segment and Industry to account
        testdata.addExtraAccountData = true;
        // get standard test objects for test
        createTestRecordsForOppTrigger(testdata);

        // create test data
        String stage = 'Qualify';
        String businessUnit = 'Swisslog WDS';
        Date closeDate = System.today().addDays(100);
        Date opptyOrderIntakeDate = System.today().addDays(100);        

        Test.startTest();

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = testdata.testAccount.Id,
            StageName = stage,
            CloseDate = closeDate,
            //Opportunity_Type__c = 'New Business',
            Opportunity_Order_Intake_Date__c = opptyOrderIntakeDate,
            Business_Unit__c = testdata.defaultSubgroup,
            Quotation_Due_Date__c = Date.today()
        );    

        insert testOpportunity;

        Test.stopTest();

        // requery opportunity
        List<Opportunity> listOpportunities = new List<Opportunity>([   SELECT Id, Main_Contact__c,AccountId,
                                                                        Market_Segment__c, Industry__c   
                                                                        FROM Opportunity 
                                                                        WHERE Id = :testOpportunity.Id]);       

        /**********************************************
        check listOpportunities:
        - listOpportunities must not be empty
        - listOpportunities must have a size of 1
        - listOpportunities[0].Market_Segment__c must be testdata.defaultMarketingSegment
        - listOpportunities[0].Industry__c must be testdata.defaultIndustry
        **********************************************/
        System.assertEquals( false , listOpportunities.isEmpty(), 'listOpportunities is empty'); 
        System.assertEquals( 1 , listOpportunities.size(), 'listOpportunities size is != 1'); 
        System.assertEquals( testdata.defaultMarketingSegment , listOpportunities[0].Market_Segment__c, 'Market Segment wont match'); 
        System.assertEquals( testdata.defaultIndustry , listOpportunities[0].Industry__c, 'Industry wont match'); 
    }


   static testMethod void Unittest_createOpportunity_transfer_Marketing_and_Industry_onUpdate() {
        /**********************************************
        Testing the Opportunity Trigger with an updated opportunity
        new Marketing segment and Industry must be transferred from account
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // add Marketing Segment and Industry to account
        testdata.addExtraAccountData = true;
        // get standard test objects for test
        createTestRecordsForOppTrigger(testdata);

        // create test data
        String stage = 'Qualify';
        String businessUnit = 'Swisslog WDS';
        Date closeDate = System.today().addDays(100);
        Date opptyOrderIntakeDate = System.today().addDays(100);    

        // create second account with different Marketing Segment and Industry
        String newMarketingSegment = 'Healthcare';
        String newIndustry = 'Home and personal care';
        Account newtestAccount = new Account(  Name='Test Account2',
                                                KUKA_Group_Key_Account__c = true,
                                                BillingStreet = 'Teststreet2',
                                                BillingPostalCode = '123456',
                                                BillingCity = 'Test City2',
                                                Duns__c = '123456781',
                                                Market_Segment__c = newMarketingSegment,
                                                Industry__c = newIndustry,
                                                BillingCountry = 'Germany'  );  
        insert newtestAccount;     


        // andreas.meyer@salesforce.com 01.03.2017 DC-1402 add contact
        Contact newtestContact = new Contact(  FirstName='Peter',
                                                Salutation='Mr',
                                                LastName='Pan',
                                                Email = 'peterpan@internet.org',
                                                AccountId = newtestAccount.Id);

        insert newtestContact;

        Test.startTest();
        // andreas.meyer@salesforce.com 01.03.2017 DC-1402 add Main_Contact__c to Account objects
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = testdata.testAccount.Id,
            StageName = stage,
            CloseDate = closeDate,
            Opportunity_Order_Intake_Date__c = opptyOrderIntakeDate,
            Main_Contact__c = testdata.testContact.Id,
            Business_Unit__c = testdata.defaultSubgroup,
            Quotation_Due_Date__c = Date.today()
        );    

        insert testOpportunity;

        // update testOpportunity
        testOpportunity.AccountId = newtestAccount.Id;
        testOpportunity.Main_Contact__c = newtestContact.Id;

        update testOpportunity;



        Test.stopTest();

        // requery opportunity
        List<Opportunity> listOpportunities = new List<Opportunity>([   SELECT Id, Main_Contact__c,AccountId,
                                                                        Market_Segment__c, Industry__c   
                                                                        FROM Opportunity 
                                                                        WHERE Id = :testOpportunity.Id]);       

        /**********************************************
        check listOpportunities:
        - listOpportunities must not be empty
        - listOpportunities must have a size of 1
        - listOpportunities[0].Market_Segment__c must be newMarketingSegment
        - listOpportunities[0].Industry__c must be newIndustry
        **********************************************/
        System.assertEquals( false , listOpportunities.isEmpty(), 'listOpportunities is empty'); 
        System.assertEquals( 1 , listOpportunities.size(), 'listOpportunities size is != 1'); 
        System.assertEquals( newMarketingSegment , listOpportunities[0].Market_Segment__c, 'Market Segment wont match'); 
        System.assertEquals( newIndustry , listOpportunities[0].Industry__c, 'Industry wont match'); 
    }


}