/**********************************************************************
Name:  KAPOpportunityViewControllerTest
========================================================
Purpose: Unittest class for KAPOpportunityViewController
========================================================
History
-------
Date        AUTHOR                          DETAIL
09/09/2016  Wolfram von Reitzenstein        INITIAL
14/09/2016  Andreas Meyer                   Bugfixing
14/11/2016  Andreas Meyer                   add Unittests for paginator
*********************************************************************/
@isTest
private class KAPOpportunityViewControllerTest {


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

        Account                     topAccount                      {get;set;}
        Account                     middleAccount                   {get;set;}
        Account                     lowAccount                      {get;set;}
        Account                     lowerAccount                    {get;set;}
        Account                     lowestAccount                   {get;set;}
        KeyAccountPlan__c           testAccountPlan                 {get;set;}
        List<Account>               listTestAccounts                {get;set;}
        List<Opportunity>           listTestOpportunities           {get;set;}
        Integer                     numberOfOpportunitiesPerAccount {get;set;}

        // Standardconstructor
        private Unittest_TestRecordsData() {
            // init default values
            // in case overwrite defaults after creation
            this.numberOfOpportunitiesPerAccount = 2;   
        }
    }

    static void createTestRecordsForKAPOpportunity(Unittest_TestRecordsData testrecords) {

        // Unittest_TestRecordsData must exist
        if (null == testrecords)
            return;

        // create 5 test Accounts in a hirarchy
        testrecords.topAccount = new Account(
                    Name = 'Test Account Top',
                    KUKA_Group_Key_Account__c = true,
                    BillingStreet = 'Street top',
                    BillingPostalCode = '12365',
                    BillingCity = 'Nirgendwo Nord',
                    BillingCountryCode = 'DE' 
            );

        insert testrecords.topAccount;

        System.debug('AccountID: ' + testrecords.topAccount.id +  ' , Name: ' + testrecords.topAccount.Name);

        testrecords.middleAccount = new Account(
                    Name = 'Test Account Middle',
                    ParentID = testrecords.topAccount.Id,
                    KUKA_Group_Key_Account__c = false,
                    BillingStreet = 'Road middle',
                    BillingPostalCode = '654321',
                    BillingCity = 'Somewhere Mitte',
                    BillingCountryCode = 'DE' 
            );

        insert testrecords.middleAccount;

        System.debug('AccountID: ' + testrecords.middleAccount.id +  ' , Name: ' + testrecords.middleAccount.Name +  ' , Parent: ' + testrecords.middleAccount.Parent);

        testrecords.lowAccount = new Account(
                    Name = 'Test Account Low',
                    ParentID = testrecords.middleAccount.Id,
                    KUKA_Group_Key_Account__c = false,
                    BillingStreet = 'Alley low',
                    BillingPostalCode = '454545',
                    BillingCity = 'Nowhere Sued',
                    BillingCountryCode = 'DE' 
            );

        insert testrecords.lowAccount;

        System.debug('AccountID: ' + testrecords.lowAccount.id +  ' , Name: ' + testrecords.lowAccount.Name +  ' , Parent: ' + testrecords.lowAccount.Parent);

        testrecords.lowerAccount = new Account(
                    Name = 'Test Account Lower',
                    ParentID = testrecords.lowAccount.Id,
                    KUKA_Group_Key_Account__c = false,
                    BillingStreet = 'Path lower',
                    BillingPostalCode = '32366',
                    BillingCity = 'City Suedlicher',
                    BillingCountryCode = 'DE' 
            );

        insert testrecords.lowerAccount;

        System.debug('AccountID: ' + testrecords.lowerAccount.id +  ' , Name: ' + testrecords.lowerAccount.Name +  ' , Parent: ' + testrecords.lowerAccount.Parent);

        testrecords.lowestAccount = new Account(
                    Name = 'Test Account Lowest',
                    ParentID = testrecords.lowerAccount.Id,
                    KUKA_Group_Key_Account__c = false,
                    BillingStreet = 'Hallway lowest',
                    BillingPostalCode = '72366',
                    BillingCity = 'End of Suedlichsten',
                    BillingCountryCode = 'DE' 
            );

        insert testrecords.lowestAccount;

        System.debug('AccountID: ' + testrecords.lowestAccount.id +  ' , Name: ' + testrecords.lowestAccount.Name +  ' , Parent: ' + testrecords.lowestAccount.Parent);

        // create Account plan
        Date hStart = System.today();
        Date hEnd = System.today().addDays(100);
        
        testrecords.testAccountPlan = new KeyAccountPlan__c(    Name='Test Account Plan',
                                                                Active__c = true,
                                                                AccountID__c = testrecords.topAccount.Id,
                                                                Start_Date__c = hStart,
                                                                End_Date__c = hEnd  );
        insert testrecords.testAccountPlan;

        //create Opportunities
        testrecords.listTestOpportunities = new List<Opportunity>();

        String marketSegment = 'Automotive';
        String opptyIndustry = 'Auto Body Shop';
        String stage = 'Qualify';
        String businessUnit = 'KUKA Systems';
        Date closeDate = System.today().addDays(100);
        Date opptyOrderIntakeDate = System.today().addDays(100);

        for(Integer i = 0; i < 5; i++){

            for(Integer j = 0; j < testrecords.numberOfOpportunitiesPerAccount; j++){
                    
                    String opptyName = 'Opportunity A' + String.valueOf(i) + ' O'+ String.valueOf(j);   
                    Account acct;
                    
                    if (i == 0) {
                        acct = testrecords.topAccount;
                    } 
                    if (i == 1) {
                        acct = testrecords.middleAccount;
                    } 
                    if (i == 2) {
                        acct = testrecords.lowAccount;
                    } 
                    if (i == 3) {
                        acct = testrecords.lowerAccount;
                    } 
                    if (i == 4) {
                        acct = testrecords.lowestAccount;
                    } 

                    testrecords.listTestOpportunities.add(new Opportunity(
                        Name = opptyName,
                        AccountId = acct.Id,
                        Business_Unit__c = businessUnit,
                        Industry__c = opptyIndustry,
                        Market_Segment__c = marketSegment,
                        StageName = stage,
                        CloseDate = closeDate,
                        Opportunity_Order_Intake_Date__c = opptyOrderIntakeDate
                ));     
            } 
        }     

        insert testrecords.listTestOpportunities; 
    }  
    
    @isTest(SeeAllData=true)
    static void Unittest_InitController_with_no_Data() {
        /**********************************************
        Testing the KAPOpportunityViewController together with the KAPOpportunityView
        Visualforce page. 
        The controller should not find and process any demodata
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // no data should be created
        testdata.numberOfOpportunitiesPerAccount = 0;

        // get standard test objects for test
        createTestRecordsForKAPOpportunity(testdata);

        // create test page
        PageReference pageRef = Page.KAPOpportunityView;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccountPlan);
        KAPOpportunityViewController controller = new KAPOpportunityViewController(stdController);       

        test.stopTest();

        /**********************************************
        check controller:
        - novalues must be true  
        **********************************************/
        System.assertEquals( true , controller.novalues, 'controller.novalues is not true'); 
    }

    @isTest(SeeAllData=true)
    static void Unittest_InitController_with_valid_Data() {
        /**********************************************
        Testing the KAPOpportunityViewController together with the KAPOpportunityView
        Visualforce page. 
        The controller should find and process all valid demodata
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        testdata.numberOfOpportunitiesPerAccount = 10;
        // get standard test objects for test
        createTestRecordsForKAPOpportunity(testdata);

        // create test page
        PageReference pageRef = Page.KAPOpportunityView;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccountPlan);
        KAPOpportunityViewController controller = new KAPOpportunityViewController(stdController);       

        test.stopTest();
    
        /**********************************************
        check controller:
        - novalues must be false
        - check if 6 entries are displayed on page 1 
        **********************************************/
        System.assertEquals( false , controller.novalues, 'controller.novalues is not false'); 
        System.assertEquals(controller.listOpportunitiesByPage.size(), 6, 'wrong number of opportunities displayed on page 1'); 
    }

    @isTest(SeeAllData=true)
    static void Unittest_InitController_with_valid_Data_next_page() {
        /**********************************************
        Testing the KAPOpportunityViewController together with the KAPOpportunityView
        Visualforce page. 
        The controller should find and process all valid demodata
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        testdata.numberOfOpportunitiesPerAccount = 10;
        // get standard test objects for test
        createTestRecordsForKAPOpportunity(testdata);

        // create test page
        PageReference pageRef = Page.KAPOpportunityView;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccountPlan);
        KAPOpportunityViewController controller = new KAPOpportunityViewController(stdController);
         // go to second page
        controller.nextPage();       

        test.stopTest();
    
        /**********************************************
        check controller:
        - novalues must be false
        - check if 4 entries are displayed on page 2 
        **********************************************/
        System.assertEquals( false , controller.novalues, 'controller.novalues is not false'); 
        System.assertEquals(controller.listOpportunitiesByPage.size(), 6, 'wrong number of opportunities displayed on page 2'); 
    }

    @isTest(SeeAllData=true)
    static void Unittest_InitController_with_valid_Data_previous_page() {
        /**********************************************
        Testing the KAPOpportunityViewController together with the KAPOpportunityView
        Visualforce page. 
        The controller should find and process all valid demodata
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        testdata.numberOfOpportunitiesPerAccount = 10;
        // get standard test objects for test
        createTestRecordsForKAPOpportunity(testdata);

        // create test page
        PageReference pageRef = Page.KAPOpportunityView;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccountPlan);
        KAPOpportunityViewController controller = new KAPOpportunityViewController(stdController);

         // go to second page
        controller.nextPage();    

         // go to first page
        controller.previousPage(); 

        controller.updatePage();  
        controller.changeData();      

        test.stopTest();
    
        /**********************************************
        check controller:
        - novalues must be false
        - check if 6 entries are displayed on page 1 
        **********************************************/
        System.assertEquals( false , controller.novalues, 'controller.novalues is not false'); 
        System.assertEquals(controller.listOpportunitiesByPage.size(), 6, 'wrong number of opportunities displayed on page 1'); 
    }
}

//Sample code for future extension of unit test
 /**********************************************

        for(Integer i = 0; i < testrecords.numberOfAccountLevels; i++){
            
            String accountName = 'Test Account ' + String.valueOf(i);
            String billingStreet = 'Test Street ' + String.valueOf(i);
            String billingPostalCode = '1234' + String.valueOf(i);
            String billingCity = 'Test City' + String.valueOf(i);

                testrecords.listTestAccounts.add(new Account(
                    Name = accountName,
                    KUKA_Group_Key_Account__c = true,
                    BillingStreet = billingStreet,
                    BillingPostalCode = billingPostalCode,
                    BillingCity = billingCity,
                    BillingCountry = 'Germany' 
                ));

        } 

        insert testrecords.listTestAccounts;

        // create Account Hierarchy

        for(Integer i = 0; i < testrecords.listTestAccounts.size(); i++){
 
            if(i != 0) {
                Account acct = testrecords.listTestAccounts[i];
                acct.Parent = testrecords.listTestAccounts[i-1];
                testrecords.listTestAccounts[i] = acct;
            } 
        } 

        update testrecords.listTestAccounts;

        

        

        testrecords.listTestOpportunities = new List<Opportunity>();

        for (Integer i = 0; i < testrecords.listTestAccounts.size(); i++){
        
            // create Opportunities 
            
            String marketSegment = 'Automotive';
            String opptyIndustry = 'Auto Body Shop';
            String stage = 'Qualify';
            String businessUnit = 'Systems';
            Date closeDate = System.today().addDays(100);
            Date opptyOrderIntakeDate = System.today().addDays(100);
            
            if ( 0 < testrecords.numberOfOpportunitiesPerAccount){
                
                //create Opportunities

                for(Integer j = 0; j < testrecords.numberOfOpportunitiesPerAccount; j++){
                    String opptyName = 'Opportunity A' + String.valueOf(i) + ' O' + String.valueOf(j);       
                    testrecords.listTestOpportunities.add(new Opportunity(
                        Name = opptyName,
                        Account = testrecords.listTestAccounts[i],
                        Business_Unit__c = businessUnit,
                        Industry__c = opptyIndustry,
                        Market_Segment__c = marketSegment,
                        StageName = stage,
                        CloseDate = closeDate,
                        Opportunity_Order_Intake_Date__c = opptyOrderIntakeDate
                    ));
                
                } 
            }     
        } 
        insert testrecords.listTestOpportunities; 

        **********************************************/