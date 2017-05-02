/**********************************************************************
Name:  ITriggerHandler
======================================================
Purpose: Interface class based on ChrisAldridge/Lightweight-Trigger-Framework

https://github.com/ChrisAldridge/Lightweight-Trigger-Framework/blob/master/src/classes/ITriggerHandler.cls

======================================================
History
-------
Date        AUTHOR                          DETAIL
06/10/2016  Andreas Meyer 			        INITIAL
*********************************************************************/
public interface ITriggerHandler 
{
	void BeforeInsert(List<SObject> newItems);

	void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);

	void BeforeDelete(Map<Id, SObject> oldItems);

	void AfterInsert(Map<Id, SObject> newItems);

	void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);

	void AfterDelete(Map<Id, SObject> oldItems);

	void AfterUndelete(Map<Id, SObject> oldItems);

	// This method needs to be implemented to check whether or not trigger logic should run. You can remove this if this is not a requirement.
	Boolean IsDisabled();
}