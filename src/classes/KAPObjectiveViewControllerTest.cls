/**********************************************************************
Name:  KAPObjectiveViewControllerTest
======================================================
Purpose: Unittest class for KAPObjectiveViewController
======================================================
History
-------
Date        AUTHOR                          DETAIL
07/09/2016  Andreas Meyer 			        INITIAL
14/09/2016	Andreas Meyer 					switch from Decimal to AccountSalesGoal__c
14/11/2016  Andreas Meyer                   Update Uinittest integrity
*********************************************************************/
@isTest
private class KAPObjectiveViewControllerTest {


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
		List<AccountSalesGoal__c> 	listTestAccountSalesGoals 		{get;set;}

		Integer 					numberOfObjectivesUnits 		{get;set;}
		Integer 					numberOfObjectivesValue 		{get;set;}
		String 						defaultBusinessUnit1 			{get;set;}
		String 						defaultBusinessUnit2 			{get;set;}
		Integer 					defaultUnits 			 		{get;set;}
		Decimal 					defaultValue 			 		{get;set;}
		Integer 					startYear 	 			 		{get;set;}

		// Standardconstructor
		private Unittest_TestRecordsData() {
			// init default values
			// in case overwrite defaults after creation
			this.numberOfObjectivesUnits = 4;
			this.numberOfObjectivesValue = 4;
			this.defaultBusinessUnit1 = 'KUKA Systems';
			this.defaultBusinessUnit2 = 'KUKA Robotics';
			this.defaultUnits = 300;
			this.defaultValue = 20.000;
            // andreas.meyer@saleforce.com 14.11.2016 use a valid startyear
            Schema.DescribeFieldResult fieldResultYE = AccountSalesGoal__c.Value_Year__c.getDescribe();
            List<Schema.PicklistEntry> pleYE= fieldResultYE.getPicklistValues();
            if (false == pleYE.isEmpty()){
                this.startYear = Integer.valueOf(pleYE[0].getValue());
            }
            else{
                this.startYear = 2017;    
            }  			

		}
	}

	static void createTestRecordsForKAPObjectives(Unittest_TestRecordsData testrecords) {

		// Unittest_TestRecordsData must exist
		if (null == testrecords)
			return;

		// create account
		testrecords.testAccount = new Account(	Name='Test Account',
												KUKA_Group_Key_Account__c = true,
												BillingStreet = 'Teststreet',
												BillingPostalCode = '12345',
												BillingCity = 'Test City',
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
		testrecords.listTestAccountSalesGoals = new List<AccountSalesGoal__c>();
		// insert units objectives
		if ( 0 < testrecords.numberOfObjectivesUnits){
			for(Integer i = 0; i < testrecords.numberOfObjectivesUnits; i++){

				String hname = 'AccountSalesGoalUnits' + String.valueOf(i);
				Integer currentYear = testrecords.startYear + i- math.mod(i, 2);
				String hyear = String.valueOf(currentYear);
				testrecords.listTestAccountSalesGoals.add(new  AccountSalesGoal__c(
	        						Name=hname,
	        						BusinessUnit__c= (math.mod(i, 2) == 0)?testrecords.defaultBusinessUnit1:testrecords.defaultBusinessUnit2,
	        						KeyAccountPlanID__c = testrecords.testAccountPlan.Id,
	        						Units_Year__c = hyear,
	        						Units__c = testrecords.defaultUnits
	        					));
			}
		}
		// insert value objectives
		if ( 0 < testrecords.numberOfObjectivesValue){
			for(Integer i = 0; i < testrecords.numberOfObjectivesValue; i++){

				String hname = 'AccountSalesGoalValue' + String.valueOf(i);
				Integer currentYear = testrecords.startYear + i - math.mod(i, 2);
				String hyear = String.valueOf(currentYear);
				testrecords.listTestAccountSalesGoals.add(new  AccountSalesGoal__c(
	        						Name=hname,
	        						BusinessUnit__c= (math.mod(i, 2) == 0)?testrecords.defaultBusinessUnit1:testrecords.defaultBusinessUnit2,
	        						KeyAccountPlanID__c = testrecords.testAccountPlan.Id,
	        						Value_Year__c = hyear,
	        						Value__c = testrecords.defaultValue
	        					));
			}
		}
		insert testrecords.listTestAccountSalesGoals;
	}



    static testMethod void Unittest_InitController_with_no_Data() {
    	/**********************************************
    	Testing the KAPObjectiveViewController together with the KAPObjectiveView
    	Visualforce page. 
    	The controller should not find and process any demodata
    	**********************************************/

    	// create data container
    	Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
    	// no data should be created
    	testdata.numberOfObjectivesUnits = 0;
    	testdata.numberOfObjectivesValue = 0;

    	// get standard test objects for test
    	createTestRecordsForKAPObjectives(testdata);

    	// create test page
    	PageReference pageRef = Page.KAPObjectiveView;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccountPlan);
        KAPObjectiveViewController controller = new KAPObjectiveViewController(stdController);       

		test.stopTest();

    	/**********************************************
    	check controller:
    	- novalues must be true	
    	**********************************************/
		System.assertEquals( true , controller.novalues, 'controller.novalues is not true'); 
    }



    static testMethod void Unittest_InitController_with_valid_Data() {
    	/**********************************************
    	Testing the KAPObjectiveViewController together with the KAPObjectiveView
    	Visualforce page. 
    	The controller should find and process all valid demodata
    	**********************************************/

    	// create data container
    	Unittest_TestRecordsData testdata = new Unittest_TestRecordsData();
    	// get standard test objects for test
    	createTestRecordsForKAPObjectives(testdata);

    	// create test page
    	PageReference pageRef = Page.KAPObjectiveView;
        Test.setCurrentPage(pageRef);

        test.startTest();

        ApexPages.StandardController stdController = new ApexPages.StandardController(testdata.testAccountPlan);
        KAPObjectiveViewController controller = new KAPObjectiveViewController(stdController);       

		test.stopTest();

		// prepare testdata
		Set<String> setBusinessUnits = new Set<String>();
		if (false == controller.listBusinessUnits.IsEmpty()){
			for (String bu : controller.listBusinessUnits){
				setBusinessUnits.add(bu);	
			}
		}
	
    	/**********************************************
    	check controller:
    	- novalues must be false
    	- check if both businessunits are in the picklist
    	- PlanRevenue.mapTotalPlanGoalValue[testdata.startYear] must be 2* testdata.defaultValue
    	- PlanQuantity.mapTotalPlanGoalValue[testdata.startYear] must be 2* testdata.defaultUnits
    	- PlanRevenue.mapYearsToBusinessUnitValues[testdata.startYear][defaultBusinessUnit1] must be testdata.defaultValue
    	- PlanRevenue.mapYearsToBusinessUnitValues[testdata.startYear][defaultBusinessUnit2] must be testdata.defaultValue
    	- PlanQuantity.mapYearsToBusinessUnitValues[testdata.startYear][defaultBusinessUnit1] must be testdata.defaultUnits
    	- PlanQuantity.mapYearsToBusinessUnitValues[testdata.startYear][defaultBusinessUnit2] must be testdata.defaultUnits    	
    	**********************************************/
    	System.assertEquals( false , controller.novalues, 'controller.novalues is not false'); 
    	System.assertEquals( true , setBusinessUnits.contains(testdata.defaultBusinessUnit1), 'testdata.defaultBusinessUnit1 is not a valid picklist value'); 
    	System.assertEquals( true , setBusinessUnits.contains(testdata.defaultBusinessUnit2), 'testdata.defaultBusinessUnit2 is not a valid picklist value'); 
		System.assertEquals( controller.PlanRevenue.mapTotalPlanGoalValue.get(String.valueOf(testdata.startYear)).Value__c , 2*testdata.defaultValue, 'wrong PlanRevenue.TotalPlanGoalValue');  
		System.assertEquals( controller.PlanQuantity.mapTotalPlanGoalValue.get(String.valueOf(testdata.startYear)).Units__c , 2*testdata.defaultUnits, 'wrong PlanQuantity.TotalPlanGoalValue');
		System.assertEquals( controller.PlanRevenue.mapYearsToBusinessUnitValues.get(testdata.defaultBusinessUnit1).get(String.valueOf(testdata.startYear)).Value__c , testdata.defaultValue, 'PlanRevenue: wrong value for testdata.startYear/testdata.defaultBusinessUnit1');
		System.assertEquals( controller.PlanRevenue.mapYearsToBusinessUnitValues.get(testdata.defaultBusinessUnit2).get(String.valueOf(testdata.startYear)).Value__c , testdata.defaultValue, 'PlanRevenue: wrong value for testdata.startYear/testdata.defaultBusinessUnit2');
		System.assertEquals( controller.PlanQuantity.mapYearsToBusinessUnitValues.get(testdata.defaultBusinessUnit1).get(String.valueOf(testdata.startYear)).Units__c , testdata.defaultUnits, 'PlanQuantity: wrong units for testdata.startYear/testdata.defaultBusinessUnit1');
		System.assertEquals( controller.PlanQuantity.mapYearsToBusinessUnitValues.get(testdata.defaultBusinessUnit2).get(String.valueOf(testdata.startYear)).Units__c , testdata.defaultUnits, 'PlanQuantity: wrong units for testdata.startYear/testdata.defaultBusinessUnit2');                

    }
}