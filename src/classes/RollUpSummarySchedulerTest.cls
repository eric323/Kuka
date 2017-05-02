/**********************************************************************
Name:  RollUpSummarySchedulerTest
======================================================
Purpose:  Scheduler class for RollUpSummaryScheduler
======================================================
History
-------
Date        AUTHOR                          DETAIL
05/04/2017  bmohammed                  INITIAL Version
25/04/2017  Arokia Joseph              (DC-1321/ DC-1322)
*********************************************************************/

@IsTest
private class RollUpSummarySchedulerTest {

    static testMethod void schedulerTest() {
        Test.startTest();

         string CRON_EXP = '0 0 * * * ?';
        // Schedule the test job
        String jobId = System.schedule('testRollUpSummaryScheduledApex',
                CRON_EXP,
                new RollUpSummaryScheduler());
                // Get the information from the CronTrigger API object
                CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,
                        NextFireTime
                FROM CronTrigger WHERE id = :jobId];

                // Verify the expressions are the same

                System.assertEquals(CRON_EXP,
                        ct.CronExpression);

                // Verify the job has not run

                System.assertEquals(0, ct.TimesTriggered);

        


                Test.stopTest();
    }
}