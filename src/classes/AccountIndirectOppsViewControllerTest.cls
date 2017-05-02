/**********************************************************************
Name:  AccountIndirectOppsViewControllerTest
=============================================================
Purpose: Unittest class for AccountIndirectOppsViewController
=============================================================
History
-------
Date        AUTHOR                          DETAIL
08/09/2016  Wolfram von Reitzenstein        INITIAL
14/11/2016  Andreas Meyer                   Update Uinittest integrity
*********************************************************************/
@isTest
private class AccountIndirectOppsViewControllerTest {


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

        Account                     testAccountOpptys               {get;set;}
        Account                     testAccount                     {get;set;}
        List<Opportunity>           listTestOpportunities           {get;set;}
        List<Partner>               listTestOpportunityPartners     {get;set;}
        Integer                     numberOfOpportunities           {get;set;}
        String                      businessUnit                    {get;set;}
        String                      marketSegment                   {get;set;}


        // Standardconstructor
        private Unittest_TestRecordsData() {
            // init default values
            // in case overwrite defaults after creation
            this.numberOfOpportunities = 10;   
            // andreas.meyer@saleforce.com 14.11.2016 use a valid businessunit
            //this.businessUnit = 'Systems';
            Schema.DescribeFieldResult fieldResultBU = Opportunity.Business_Unit__c.getDescribe();
            List<Schema.PicklistEntry> pleBU= fieldResultBU.getPicklistValues();
            if (false == pleBU.isEmpty()){
                this.businessUnit = pleBU[0].getValue();
            }
            else{
                this.businessUnit = 'Systems';    
            }           
            this.marketSegment = 'Automotive';
        }
    }

    static void createTestRecordsForAccountIndirectOpps(Unittest_TestRecordsData testrecords) {

        // Unittest_TestRecordsData must exist
        if (null == testrecords)
            return;

        // create direct Account for Opportunites
        testrecords.testAccountOpptys = new Account(  Name='Test Account Opptys',
                                                KUKA_Group_Key_Account__c = true,
                                                BillingStreet = 'Teststreet',
                                                BillingPostalCode = '12345',
                                                BillingCity = 'Test City',
                                                BillingCountry = 'Germany'  );
        insert testrecords.testAccountOpptys;
        
        // create indirect Account for Opportunities
        testrecords.testAccount = new Account(  Name='Test Account',
                                                KUKA_Group_Key_Account__c = true,
                                                BillingStreet = 'Anotherstreet',
                                                BillingPostalCode = '54321',
                                                BillingCity = 'Another City',
                                                BillingCountry = 'Germany'  );
        insert testrecords.testAccount;
            
        
        // create Opportunities with Opportunity Partners
        String opptyIndustry = 'Auto Body Shop';
        String stage = 'Qualify';
        Date closeDate = System.today().addDays(100);
        Date opptyOrderIntakeDate = System.today().addDays(100);
        
        testrecords.listTestOpportunities = new List<Opportunity>();
        testrecords.listTestOpportunityPartners = new List<Partner>();
        
        
        if ( 0 < testrecords.numberOfOpportunities){
            
            //create Opportunities
            for(Integer i = 0; i < testrecords.numberOfOpportunities; i++){
                String opptyName = 'Opportunity' + String.valueOf(i);       
                testrecords.listTestOpportunities.add(new Opportunity(
                    Name = opptyName,
                    Account = testrecords.testAccountOpptys,
                    Business_Unit__c = testrecords.businessUnit,
                    Industry__c = opptyIndustry,
                    Market_Segment__c = testrecords.marketSegment,
                    StageName = stage,
                    CloseDate = closeDate,
                    Opportunity_Order_Intake_Date__c = opptyOrderIntakeDate
                ));
            
            } 
            insert testrecords.listTestOpportunities;

            //create Opportunity Partners
            for(Integer i = 0; i < testrecords.numberOfOpportunities; i++){
                Partner opptyPartner = new Partner();
                opptyPartner.Role = 'End Customer';
                opptyPartner.OpportunityId = testrecords.listTestOpportunities[i].id;
                opptyPartner.AccountToId = testrecords.testAccount.id; 
                opptyPartner.IsPrimary = false;
                testrecords.listTestOpportunityPartners.add(opptyPartner);
            } 
            insert testrecords.listTestOpportunityPartners;

            // just for debugging
            //List<OpportunityPartner> listOppPartners = new List<OpportunityPartner>([SELECT Id, OpportunityId FROM OpportunityPartner WHERE AccountToId = :testrecords.testAccount.id]);
            //if (true == listOppPartners.isEmpty()){
            //    System.debug('listOppPartners empty!!');
            //}

            //for (OpportunityPartner p : listOppPartners){
            //    System.debug('PartnerID: ' + p.Id +  ' , OppID: ' + p.OpportunityId);
            //}
        }      
    }  
    
    @isTest(SeeAllData=true)
    static void Unittest_InitController_with_no_Data() {
        /**********************************************
        Testing the AccountIndirectOppsViewController together with the AccountIndirectOppsView
        Visualforce page. 
        The controller should not find and process any demodata
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();

        // no data should be created
        testdata.numberOfOpportunities = 0;

        // get standard test objects for test
        createTestRecordsForAccountIndirectOpps(testdata);

        // create test page
        PageReference pageRef = Page.AccountIndirectOppsView;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccount);
        AccountIndirectOppsViewController controller = new AccountIndirectOppsViewController(stdController);       

        test.stopTest();

        /**********************************************
        check controller:
        - novalues must be true  
        **********************************************/
        System.assertEquals( true , controller.novalues, 'controller.novalues is not true'); 
    }

    @isTest(SeeAllData=true)
    static  void Unittest_InitController_with_valid_Data() {
        /**********************************************
        Testing the AccountIndirectOppsViewController together with the AccountIndirectOppsView
        Visualforce page. 
        The controller should find and process all valid demodata
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();

        // get standard test objects for test
        createTestRecordsForAccountIndirectOpps(testdata);

        // create test page
        PageReference pageRef = Page.AccountIndirectOppsView;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccount);
        AccountIndirectOppsViewController controller = new AccountIndirectOppsViewController(stdController);  

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
    static  void Unittest_InitController_with_valid_Data_test_next_page() {
        /**********************************************
        Testing the AccountIndirectOppsViewController together with the AccountIndirectOppsView
        Visualforce page.  
        The controller should find and process all valid demodata
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();

        // two pages of data should be created
        testdata.numberOfOpportunities = 10; 

        // get standard test objects for test
        createTestRecordsForAccountIndirectOpps(testdata);

        // create test page
        PageReference pageRef = Page.AccountIndirectOppsView;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccount);
        AccountIndirectOppsViewController controller = new AccountIndirectOppsViewController(stdController);     

         // go to second page
        controller.nextPage();     

        test.stopTest();
    
        /**********************************************
        check controller:
        - novalues must be false
        - check if 4 entries are displayed on page 2     
        **********************************************/
        System.assertEquals( false , controller.novalues, 'controller.novalues is not false'); 
        System.assertEquals(controller.listOpportunitiesByPage.size(), 4, 'wrong number of opportunities displayed on page 2'); 
    }

    @isTest(SeeAllData=true)
    static  void Unittest_InitController_with_valid_Data_test_previous_page() {
        /**********************************************
        Testing the AccountIndirectOppsViewController together with the AccountIndirectOppsView
        Visualforce page. 
        The controller should find and process all valid demodata
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();

        // two pages of data should be created
        testdata.numberOfOpportunities = 10; 

        // get standard test objects for test
        createTestRecordsForAccountIndirectOpps(testdata);

        // create test page
        PageReference pageRef = Page.AccountIndirectOppsView;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccount);
        AccountIndirectOppsViewController controller = new AccountIndirectOppsViewController(stdController);     

         // go to second page
        controller.nextPage();     

         // go to first page
        controller.previousPage();  

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
    static  void Unittest_InitController_with_valid_Data_update_page() {
        /**********************************************
        Testing the AccountIndirectOppsViewController together with the AccountIndirectOppsView
        Visualforce page.  
        The controller should find and process all valid demodata
        **********************************************/

        // create data container
        Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();

        // two pages of data should be created
        testdata.numberOfOpportunities = 10; 

        // get standard test objects for test
        createTestRecordsForAccountIndirectOpps(testdata);

        // create test page
        PageReference pageRef = Page.AccountIndirectOppsView;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccount);
        AccountIndirectOppsViewController controller = new AccountIndirectOppsViewController(stdController);  

        controller.updatePage();

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