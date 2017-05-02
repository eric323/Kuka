/**********************************************************************
Name:  OpportunityTrigger
======================================================
Purpose: trigger class for Opportunity
======================================================
History
-------
Date        AUTHOR                          DETAIL
06/10/2016  Andreas Meyer                   INITIAL (DC-486)
*********************************************************************/
trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    // Call the trigger dispatcher and pass it an instance of the OpportunityTriggerHandler
    TriggerDispatcher.Run(new OpportunityTriggerHandler());
    TriggerDispatcher.Run(new OpportunityRollUpTriggerHelper());
}