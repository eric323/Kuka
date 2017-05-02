/**********************************************************************
Name:  AccountCompChartControllerTest
======================================================
Purpose: Unittest class for AccountCompChartController
======================================================
History
-------
Date        AUTHOR                          DETAIL
15/09/2016  Andreas Meyer 			        INITIAL
25/10/2016	Andreas Meyer 					DC-666 restore functionality by adding duns number to account
14/11/2016  Andreas Meyer                   Unittest code coverage
*********************************************************************/
@isTest
private class AccountCompChartControllerTest {

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
		List<AccountCompetitor__c> 	listAccCompetitors		 		{get;set;}
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

	static void createTestRecordsForAccCompetitors(Unittest_TestRecordsData testrecords) {

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

		// create objectives
		testrecords.listAccCompetitors = new List<AccountCompetitor__c>();
		// insert units objectives
		if ( 0 < testrecords.numberOfCompetitors){
			for(Integer i = 0; i < testrecords.numberOfCompetitors; i++){

				//String hname = 'KAPCompetitor' + String.valueOf(i);
				String hname = testrecords.listCompetitors[i];
				testrecords.listAccCompetitors.add(new  AccountCompetitor__c(
									KUKA_Competitor_List__c = hname,
	        						Business_Unit__c=  testrecords.defaultBusinessUnit1,
	        						AccountID__c = testrecords.testAccount.Id
	        					));
			}
		}
		insert testrecords.listAccCompetitors;
	}

    static testMethod void Unittest_InitController_with_no_Data() {
    	/**********************************************
    	Testing the AccountCompChartController together with the AccountCompChart
    	Visualforce page. 
    	The controller should not find and process any demodata
    	**********************************************/

    	// create data container
    	Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
    	// no data should be created
    	testdata.numberOfCompetitors = 0;

    	// get standard test objects for test
    	createTestRecordsForAccCompetitors(testdata);

    	// create test page
    	PageReference pageRef = Page.AccountCompChart;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccount);
        AccountCompChartController controller = new AccountCompChartController(stdController);       

		test.stopTest();
    	/**********************************************
    	check controller:
    	- novalues must be true	
    	**********************************************/
		System.assertEquals( true , controller.novalues, 'controller.novalues is not true'); 
    }


	static testMethod void Unittest_InitController_with_valid_Data() {
    	/**********************************************
    	Testing the AccountCompChartController together with the AccountCompChart
    	Visualforce page. 
    	The controller should find and process all valid demodata
    	**********************************************/

    	// create data container
    	Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
    	// get standard test objects for test
    	createTestRecordsForAccCompetitors(testdata);

    	// create test page
    	PageReference pageRef = Page.AccountCompChart;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccount);
        AccountCompChartController controller = new AccountCompChartController(stdController);    

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