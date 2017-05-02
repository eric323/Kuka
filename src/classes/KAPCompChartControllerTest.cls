/**********************************************************************
Name:  KAPCompChartControllerTest
======================================================
Purpose: Unittest class for KAPCompChartController
======================================================
History
-------
Date        AUTHOR                          DETAIL
14/09/2016  Andreas Meyer 			        INITIAL
25/10/2016	Andreas Meyer 					DC-666 restore functionality by adding duns number to account
14/11/2016  Andreas Meyer                   Unittest code coverage
*********************************************************************/
@isTest
private class KAPCompChartControllerTest {

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

		Account 					testAccount 					{get;set;}
		KeyAccountPlan__c 			testAccountPlan					{get;set;}
		List<KAPCompetitor__c> 		listKAPCompetitors		 		{get;set;}
		Integer 					numberOfCompetitors		 		{get;set;}
		String 						defaultBusinessUnit1 			{get;set;}
		List<String>				listCompetitors					{get;set;}

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

	static void createTestRecordsForKAPCompetitors(Unittest_TestRecordsData testrecords) {

		// Unittest_TestRecordsData must exist
		if (null == testrecords)
			return;


		// create account
		testrecords.testAccount = new Account(	Name='Test Account',
												KUKA_Group_Key_Account__c = true,
												BillingStreet = 'Teststreet',
												BillingPostalCode = '12345',
												BillingCity = 'Test City',
												Duns__c = '123456789',
												BillingCountry = 'Germany'	);
    	insert testrecords.testAccount;

    	// create Account plan
    	
    	Date hStart = System.today();
    	Date hEnd = System.today().addDays(100);
    	
		testrecords.testAccountPlan = new KeyAccountPlan__c(	Name='Test Account Plan',
																Active__c = true,
																AccountID__c = testrecords.testAccount.Id,
																Start_Date__c = hStart,
																End_Date__c = hEnd	);
		insert testrecords.testAccountPlan;

		// create objectives
		testrecords.listKAPCompetitors = new List<KAPCompetitor__c>();
		// insert units objectives
		if ( 0 < testrecords.numberOfCompetitors){
			for(Integer i = 0; i < testrecords.numberOfCompetitors; i++){

				//String hname = 'KAPCompetitor' + String.valueOf(i);
				String hname = testrecords.listCompetitors[i];
				testrecords.listKAPCompetitors.add(new  KAPCompetitor__c(
									KUKA_Competitor_List__c = hname,
	        						Business_Unit__c=  testrecords.defaultBusinessUnit1,
	        						KeyAccountPlanID__c = testrecords.testAccountPlan.Id
	        					));
			}
		}
		insert testrecords.listKAPCompetitors;
	}


    static testMethod void Unittest_InitController_with_no_Data() {
    	/**********************************************
    	Testing the KAPCompChartController together with the KAPCompChart
    	Visualforce page. 
    	The controller should not find and process any demodata
    	**********************************************/

    	// create data container
    	Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
    	// no data should be created
    	testdata.numberOfCompetitors = 0;

    	// get standard test objects for test
    	createTestRecordsForKAPCompetitors(testdata);

    	// create test page
    	PageReference pageRef = Page.KAPCompChart;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccountPlan);
        KAPCompChartController controller = new KAPCompChartController(stdController);       

		test.stopTest();
    	/**********************************************
    	check controller:
    	- novalues must be true	
    	**********************************************/
		System.assertEquals( true , controller.novalues, 'controller.novalues is not true'); 
    }


	static testMethod void Unittest_InitController_with_valid_Data() {
    	/**********************************************
    	Testing the KAPCompChartController together with the KAPCompChart
    	Visualforce page. 
    	The controller should find and process all valid demodata
    	**********************************************/

    	// create data container
    	Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
    	// get standard test objects for test
    	createTestRecordsForKAPCompetitors(testdata);

    	// create test page
    	PageReference pageRef = Page.KAPCompChart;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccountPlan);
        KAPCompChartController controller = new KAPCompChartController(stdController);   

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