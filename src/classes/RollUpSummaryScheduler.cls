/**********************************************************************
Name:  RollUpSummaryScheduler
======================================================
Purpose:  Scheduler class for RollUpSummaryBatch
======================================================
History
-------
Date        AUTHOR                          DETAIL
05/04/2017  bmohammed                  INITIAL Version
25/04/2017  Arokia Joseph              (DC-1321/ DC-1322)
*********************************************************************/
public class RollUpSummaryScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        RollUpSummaryBatch batchJob = new RollUpSummaryBatch();
        Database.executebatch(batchJob, 100);
    }
}