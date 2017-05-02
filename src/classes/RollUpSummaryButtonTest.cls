/**********************************************************************
Name:  RollUpSummaryButtonTest
======================================================
Purpose:  Test Class for RollUpSummaryButton
======================================================
History
-------
Date        AUTHOR                          DETAIL
06/04/2017  bmohammed                  INITIAL Version
25/04/2017  Arokia Joseph              (DC-1321/ DC-1322)
*********************************************************************/
@IsTest
private class RollUpSummaryButtonTest {
    public static RollUpSummaryTest testHandler = RollUpSummaryTest.getInstance();
    @testSetup static void testSetup() {
        testHandler.initTestSetUp();

    }
    static testMethod void aggregateAmountQuantityTest() {
        Map<String,Project__c> projectMap = new Map<String,Project__c>([SELECT Id FROM Project__c]);
        List<String> ids = new List<String>();
        ids.addAll(projectMap.keySet());
        Test.startTest();
        string response = RollUpSummaryButton.aggregateAmountQuantity(ids, 'Project__c');
        system.assertEquals('success', response, 'Successfully Updated');

        string response1 = RollUpSummaryButton.aggregateAmountQuantity(ids, 'Project__c');
        system.assertEquals('updated', response1, 'Saved data is uptodate, no need of recalculation.');
        Test.stopTest();

    }
}