/**
 * Created by bmohammed on 05/04/2017.
 */

trigger ProjectTrigger on Project__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerDispatcher.Run(new ProjectRollUpTriggerHelper());
}