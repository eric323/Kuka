/*
 * EditableList_Test.cls / Copyright (c)2013, Michael Welburn / License: MIT
 * Usage: Test class for EditableList.cls
 * 
 * VERSION; DATE (YYYY-MM-DD); AUTHOR; "CHANGE"
 * 1.0; 2016-11-14; John Kuhne; "Replaced (1.) Account with Opportunity and (2.) Contact with RiskAssessmentQuestion__c throughout.  Added myAcc record for required field on myOpp." 
 */
@isTest
private class EditableList_Test 
{   
  /*
   * Mock implementation of abstract class used for testing
   */
    private class MockEditableList extends EditableList
  {
    public MockEditableList(ApexPages.StandardController stdController)
    {
      super(stdController);
    } 
  }

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
    
    @isTest static void test_EditableList() 
  {
        setupData();

    Test.startTest();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    MockEditableList mock = new MockEditableList(std);

    Test.stopTest();

    System.assertEquals(0, mock.ZERO);
    System.assertEquals(0, mock.childList.size());
    System.assertEquals(0, mock.removeChildList.size());
    }
    
  @isTest static void test_getHasChildren()
  {
    setupData();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    MockEditableList mock = new MockEditableList(std);

    Test.startTest();

    System.assertEquals(false, mock.getHasChildren());

    mock.childList.add(new RiskAssessmentQuestion__c());

    System.assertEquals(true, mock.getHasChildren());

    Test.stopTest();
  }

  @isTest static void test_initChildRecord()
  {
    setupData();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    MockEditableList mock = new MockEditableList(std);

    Test.startTest();

    System.assert(mock.initChildRecord() instanceof Contact);
    
    Test.stopTest();
  }

  @isTest static void test_addToList()
  {
    setupData();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    MockEditableList mock = new MockEditableList(std);

    System.assertEquals(0, mock.childList.size());

    Test.startTest();

    mock.addToList();

    Test.stopTest();

    System.assertEquals(1, mock.childList.size());
  }

  @isTest static void test_removeFromList()
  {
    setupData();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    MockEditableList mock = new MockEditableList(std);

    mock.childList.add(myRAQ1);
    mock.childList.add(myRAQ2);

    Test.startTest();

    mock.removeIndex = '1';
    mock.removeFromList();

    Test.stopTest();

    System.assertEquals(1, mock.childList.size());
    System.assertEquals(myRAQ2.Id, mock.childList[0].Id);
    System.assertEquals(1, mock.removeChildList.size());
    System.assertEquals(myRAQ1.Id, mock.removeChildList[0].Id);
  }

  @isTest static void test_getSuccessURL_param()
  {
    setupData();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    MockEditableList mock = new MockEditableList(std);

    String retURL = '/test';
    PageReference pr = new PageReference('/');
    pr.getParameters().put('retURL', retURL);

    Test.setCurrentPageReference(pr);
    Test.startTest();

    System.assertEquals(retURL, mock.getSuccessURL().getUrl());

    Test.stopTest();
  }

  @isTest static void test_getSuccessURL_noParam()
  {
    setupData();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    MockEditableList mock = new MockEditableList(std);

    PageReference pr = new PageReference('/');

    Test.setCurrentPageReference(pr);
    Test.startTest();

    System.assertEquals(std.view().getUrl(), mock.getSuccessURL().getUrl());

    Test.stopTest();
  }


  @isTest static void test_save_failure()
  {
    setupData();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    MockEditableList mock = new MockEditableList(std);

    mock.childList.add(myRAQ1);

    // Purposely leave out required fields 
    RiskAssessmentQuestion__c badRAQ = new RiskAssessmentQuestion__c();
    badRAQ.isLowMediumHigh__c = false;

    mock.childList.add(badRAQ);

    Test.startTest();

    System.assertEquals(null, mock.save());

    Test.stopTest();

    System.assertEquals(2, ApexPages.getMessages().size());
    System.assertEquals(ApexPages.Severity.ERROR, ApexPages.getMessages()[0].getSeverity());
    
  }

  @isTest static void test_save_success()
  {
    setupData();

    ApexPages.StandardController std = new ApexPages.StandardController(myOpp);
    MockEditableList mock = new MockEditableList(std);

    mock.childList.add(myRAQ1);
    mock.removeChildList.add(myRAQ2);

    RiskAssessmentQuestion__c newRAQ = new RiskAssessmentQuestion__c();
    newRAQ.Opportunity__c = myOpp.Id;
    newRAQ.Question__c = 'New Risk Assessment Question';
    newRAQ.Sequence_Number__c = 10.0;
    newRAQ.isLowMediumHigh__c = false;
    newRAQ.isNumericResult__c = false;
    newRAQ.isYesNo__c = true;

    mock.childList.add(newRAQ);

    Test.startTest();

    System.assertEquals(mock.getSuccessURL().getUrl(), mock.save().getUrl());

    Test.stopTest();

    List<sObject> results = [SELECT Id FROM RiskAssessmentQuestion__c WHERE Opportunity__c =: myOpp.Id ORDER BY CreatedDate];
    System.assertEquals(2, results.size());
    System.assertEquals(myRAQ1.Id, results[0].Id);
    System.assertNotEquals(myRAQ2.Id, results[1].Id);
  }
}