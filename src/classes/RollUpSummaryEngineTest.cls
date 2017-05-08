/**********************************************************************
Name:  RollUpSummaryEngineTest
======================================================
Purpose:  Test class for RollUpSummaryEngine
======================================================
History
-------
Date        AUTHOR                          DETAIL
05/04/2017  bmohammed                  INITIAL Version
25/04/2017  Arokia Joseph              (DC-1321/ DC-1322)
*********************************************************************/
@IsTest
private class RollUpSummaryEngineTest {

    public static RollUpSummaryTest testHandler = RollUpSummaryTest.getInstance();
    @testSetup static void testSetup() {
        testHandler.initTestSetUp();

    }
    static testMethod void calculateRollUpSummaryTest() {
        Map<Id, SObject> sObjMap = new Map<Id, SObject>();
        for( Project__c proj : [SELECT Id, Name, Recalculation_Pending__c FROM Project__c WHERE Recalculation_Pending__c = true] ) {
            sObjMap.put(proj.Id,proj);
        }

        for( Contract contr : [SELECT Id, Name, Recalculation_Pending__c FROM Contract WHERE Recalculation_Pending__c = true] ) {
            sObjMap.put(contr.Id,contr);
        }
        Test.startTest();
            List<SObject> testSobjects = RollUpSummaryEngine.calculateRollUpSummary(sObjMap);
            system.assertNotEquals(null, testSobjects.size());
        Test.stopTest();
        
        //system.debug('calculateRollUpSummaryTest>>> '+testSobjects);
    }
}