/*
 * EditableRAQListExtension_Test.cls
 *
 * Copyright (c)2013, Michael Welburn.
 * License: MIT
 *
 * Usage:
 *   Test class for EditableRAQListExtension.cls
 *
 */
@isTest
private class EditableRAQListExtension_Test 
{
  private static Account myAcc;
  private static Opportunity myOpp;
  private static RiskAssessmentQuestion__c myRAQ1;
  private static RiskAssessmentQuestion__c myRAQ2;

  private static void setupData()
  {
    myAcc = new Account();
    myAcc.Name = 'Test Account 1';
    myAcc.Market_Segment__c = 'Automotive';
    myAcc.Industry__c = 'Battery';
    myAcc.BillingStreet = '1 River Road Building 37';
    myAcc.BillingPostalCode = '12345';
    myAcc.BillingCity = 'Schenectady';
    myAcc.BillingCountry = 'USA';
    insert myAcc;

    myOpp = new Opportunity();
    myOpp.Name = 'Test Opportunity 1';
    myOpp.AccountId = myAcc.Id;
    myOpp.Business_Unit__c = 'KUKA Industries';
    myOpp.Market_Segment__c = 'Automotive';
    myOpp.Industry__c = 'Battery';
    myOpp.CloseDate = Date.today();
    myOpp.StageName = 'Qualify';
    myOpp.Probability = 10.0;
    insert myOpp;

    myRAQ1 = new RiskAssessmentQuestion__c();
    myRAQ1.Question__c = 'Risk Assessment Question 1';
    myRAQ1.Opportunity__c = myOpp.Id;
    myRAQ1.Sequence_Number__c = 50.0;
    myRAQ1.isLowMediumHigh__c = false;
    myRAQ1.isNumericResult__c = false;
    myRAQ1.isYesNo__c = true;
    insert myRAQ1;

    myRAQ2 = new RiskAssessmentQuestion__c();
    myRAQ2.Question__c = 'Risk Assessment Question 2';
    myRAQ2.Opportunity__c = myOpp.Id;
    myRAQ2.Sequence_Number__c = 60.0;
    myRAQ2.isLowMediumHigh__c = false;
    myRAQ2.isNumericResult__c = false;
    myRAQ2.isYesNo__c = true;
    insert myRAQ2;
  }


/*********
  @isTest static void test_EditableRAQListExtension()
  {
    setupData();

    Test.startTest();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    EditableRAQListExtension ext = new EditableRAQListExtension(std);

    Test.stopTest();

    System.assertEquals(0, ext.ZERO);
    System.assertEquals(0, ext.removeChildList.size());
    System.assertEquals(2, ext.childList.size());
  }
*****/


  @isTest static void test_getChildren()
  {
    setupData();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    EditableRAQListExtension ext = new EditableRAQListExtension(std);
    
    Test.startTest();

    System.assert(ext.getChildren() instanceof List<RiskAssessmentQuestion__c>);

    Test.stopTest();    
  }

/***********
  @isTest static void test_initChildRecord()
  {
    setupData();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    EditableRAQListExtension ext = new EditableRAQListExtension(std);

    Test.startTest();

    System.assert(ext.initChildRecord() instanceof RiskAssessmentQuestion__c);
    RiskAssessmentQuestion__c myRAQ = (RiskAssessmentQuestion__c)ext.initChildRecord();
    
    Test.stopTest();

    System.assertEquals(myOpp.Id, myRAQ.Opportunity__c);
  }
    *******/

}