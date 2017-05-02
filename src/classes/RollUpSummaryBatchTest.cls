/**
 * Created by bmohammed on 06/04/2017.
 */

@IsTest
private class RollUpSummaryBatchTest {
    public static RollUpSummaryTest testHandler = RollUpSummaryTest.getInstance();
    @testSetup static void testSetup() {
        testHandler.initTestSetUp();

    }
    static testMethod void rollupSummarybatchClassTest() {
        Contract contr = [SELECT Id, Recalculation_Pending__c from Contract WHERE Recalculation_Pending__c =: true LIMIT 1];

        system.assertEquals(true, contr.Recalculation_Pending__c);
        Test.startTest();
            RollUpSummaryBatch batchJob = new RollUpSummaryBatch();
            Database.executebatch(batchJob, 200);
        Test.stopTest();
        /*Contract contr1 = [SELECT Id, Recalculation_Pending__c from Contract WHERE Id =: contr.Id];
        system.assertEquals(false, contr.Recalculation_Pending__c);*/
    }
}