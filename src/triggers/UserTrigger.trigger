/**********************************************************************
Name:  UserTrigger
======================================================
Purpose: trigger class for User
======================================================
History
-------
Date        AUTHOR                          DETAIL
15/12/2016  Andreas Meyer                   INITIAL (DC-1175)
*********************************************************************/
trigger UserTrigger on User (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    // Call the trigger dispatcher and pass it an instance of the UserTriggerHandler
    TriggerDispatcher.Run(new UserTriggerHandler());
}