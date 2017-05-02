/*******************************************************************************************************
Name:  RollUpSummaryBatch
========================================================================================================
Purpose:  Batch class to Re calculate the Rollup Summary fields for Customer Project and Contract fields. 
          This batch job will be invoked on a hourly basis.
=========================================================================================================
History
-------
Date        AUTHOR                          DETAIL
05/04/2017  bmohammed                  INITIAL Version
25/04/2017  Arokia Joseph              (DC-1321/ DC-1322)
*********************************************************************************************************/
public class RollUpSummaryBatch implements Database.Batchable<sObject>{

    // Start Method
    /*public Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select Id, Name, Recalculation_Pending__c from Project__c where Recalculation_Pending__c = true';
        return Database.getQueryLocator(query);
    }*/


   
   public Iterable<Sobject> start(Database.batchableContext info){

        Iterable<SObject> reCalIterable = (Iterable<SObject>) new RollUpSummaryIterable();
        //system.debug('reCalIterable>>> '+reCalIterable);
        return reCalIterable;
    }

    // Execute Logic
    public void execute(Database.BatchableContext BC, List<sObject>scope){
        // Logic to be Executed batch wise


        List<sObject> recordsToUpdate = new List<SObject>();
        Map<Id,SObject> returnSObjectMap = new Map<Id,SObject>(scope);


        recordsToUpdate.addAll(RollUpSummaryEngine.calculateRollUpSummary(returnSObjectMap));

        try{
            update recordsToUpdate;
        }
        catch(Exception ex){
            system.debug('Exception in RollUpSummaryBatch Execute Method>>> '+ex);
        }

        //system.debug(scope);


    }

    public void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }


    public class RollUpSummaryIterable implements Iterable<SObject>, Iterator<SObject>{

        List<SObject> sobjs {get; set;}
        Integer i {get; set;}
        public RollUpSummaryIterable(){
            sobjs = new List<SObject>();

            for( Project__c proj : [SELECT Id, Name, Recalculation_Pending__c FROM Project__c WHERE Recalculation_Pending__c = true] ) {
                sobjs.add(proj);
            }

            for( Contract contr : [SELECT Id, Name, Recalculation_Pending__c FROM Contract WHERE Recalculation_Pending__c = true] ) {
                sobjs.add(contr);
            }
            i = 0;
        }
        public Iterator<SObject> iterator() { return this; }
        public boolean hasNext(){
            if(i >= sobjs.size())
                return false;
            else
                    return true;
        }
        public SObject next(){
            if(i == sobjs.size()){ return null;}
            i=i+1;
            return sobjs[i-1];
        }
    }
}