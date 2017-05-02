/**********************************************************************
Name:  OppCompChartControllerTest
======================================================
Purpose: Unittest class for OppCompChartController
======================================================
History
-------
Date        AUTHOR                          DETAIL
15/09/2016  Andreas Meyer                   INITIAL
25/10/2016  Andreas Meyer                   DC-666 restore functionality by adding duns number to account
14/11/2016  Andreas Meyer                   Unittest code coverage
*********************************************************************/
@isTest
private class OppCompChartControllerTest {

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
        Opportunity                 testOpportunity                 {get;set;}
        List<OppCompetitor__c>      listOppCompetitors              {get;set;}
        Integer                     numberOfCompetitors             {get;set;}
        String                      defaultBusinessUnit1            {get;set;}
        List<String>                listCompetitors                 {get;set;}

        // Standardconstructor
        private Unittest_TestRecordsData() {
            // init default values
            // in case overwrite defaults after creation
            this.numberOfCompetitors = 2;
            this.defaultBusinessUnit1 = 'Swisslog WDS';
            this.listCompetitors = new List<String>();
            this.listCompetitors.add('ALS Logistics');
            this.listCompetitors.add('Alstef');
            this.listCompetitors.add('Bastian Solutions');  
        }
    }

    static void createTestRecordsForOppCompetitors(Unittest_TestRecordsData testrecords) {

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
        insert testrecords.testAccount;


        String marketSegment = 'Automotive';
        String opptyIndustry = 'Auto Body Shop';
        String stage = 'Qualify';
        String businessUnit = testrecords.defaultBusinessUnit1;
        Date closeDate = System.today().addDays(100);
        Date opptyOrderIntakeDate = System.today().addDays(100);        


        testrecords.testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            Account = testrecords.testAccount,
            Business_Unit__c = businessUnit,
            Industry__c = opptyIndustry,
            Market_Segment__c = marketSegment,
            StageName = stage,
            CloseDate = closeDate,
            Opportunity_Order_Intake_Date__c = opptyOrderIntakeDate
        ); 

        insert testrecords.testOpportunity;

        // create objectives
        testrecords.listOppCompetitors = new List<OppCompetitor__c>();
        // insert units objectives
        if ( 0 < testrecords.numberOfCompetitors){
            for(Integer i = 0; i < testrecords.numberOfCompetitors; i++){

                //String hname = 'KAPCompetitor' + String.valueOf(i);
                String hname = testrecords.listCompetitors[i];
                testrecords.listOppCompetitors.add(new  OppCompetitor__c(
                                    KUKA_Competitor_List__c = hname,
                                    Business_Unit__c=  testrecords.defaultBusinessUnit1,
                                    OpportunityID__c = testrecords.testOpportunity.Id
                                ));
            }
        }
        insert testrecords.listOppCompetitors;
    }


   static testMethod void Unittest_InitController_with_no_Data() {
        /**********************************************
        Testing the OppCompChartController together with the OppCompChart
        Visualforce page. 
        The controller should not find and process any demodata
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // no data should be created
        testdata.numberOfCompetitors = 0;

        // get standard test objects for test
        createTestRecordsForOppCompetitors(testdata);

        // create test page
        PageReference pageRef = Page.OppCompChart;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testOpportunity);
        OppCompChartController controller = new OppCompChartController(stdController);       

        test.stopTest();
        /**********************************************
        check controller:
        - novalues must be true 
        **********************************************/
        System.assertEquals( true , controller.novalues, 'controller.novalues is not true'); 
    }


    static testMethod void Unittest_InitController_with_valid_Data() {
        /**********************************************
        Testing the OppCompChartController together with the OppCompChart
        Visualforce page. 
        The controller should find and process all valid demodata
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
        // get standard test objects for test
        createTestRecordsForOppCompetitors(testdata);

        // create test page
        PageReference pageRef = Page.OppCompChart;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testOpportunity);
        OppCompChartController controller = new OppCompChartController(stdController);   

        // andreas.meyer@salesforce.com 14.11.2016 getSWOTData
        String data = controller.getSWOTData();     



        /**********************************************
        check controller:
        - novalues must be false
        - strCompetitors must not be empty
        - strDimensionsData must not be empty
        **********************************************/
        System.assertEquals( false , String.IsBlank(controller.strCompetitors), 'controller.strCompetitors is empty string'); 
        System.assertEquals( false , String.IsBlank(controller.strDimensionsData), 'controller.strDimensionsData is empty string'); 
        System.assertEquals( false , String.IsBlank(data), 'controller.getSWOTData returns empty string'); 

   
    }
}