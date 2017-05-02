/**
 * Created by bmohammed on 05/04/2017.
 */

public with sharing class ProjectRollUpTriggerHelper implements ITriggerHandler{
    public static Boolean TriggerDisabled = false;

	/*
		Checks to see if the trigger has been disabled. For example, you could check a custom setting here.
		In this example, a static property is used to disable the trigger.
		In a unit test, you could use AccountTriggerHandler.TriggerDisabled = true to completely disable the trigger.
	*/
    public Boolean IsDisabled()
    {
        return TriggerDisabled;
    }


    public void BeforeInsert(List<SObject> newItems) {}

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

    public void BeforeDelete(Map<Id, SObject> oldItems) {}

    public void AfterInsert(Map<Id, SObject> newItems) {
        //system.debug('ProjectRollUpTriggerHelper : AfterInsert >>>>>>>>>>>>>>');
        recalPendingInsertDeleteUndelete((Map<Id, Project__c>)newItems);
    }

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        //system.debug('ProjectRollUpTriggerHelper : AfterUpdate >>>>>>>>>>>>>>');
        recalPendingUpdate((Map<Id, Project__c>)oldItems,(Map<Id, Project__c>)newItems);
    }

    public void AfterDelete(Map<Id, SObject> oldItems) {
        //system.debug('ProjectRollUpTriggerHelper : AfterDelete >>>>>>>>>>>>>>');
        recalPendingInsertDeleteUndelete((Map<Id, Project__c>)oldItems);

    }

    public void AfterUndelete(Map<Id, SObject> oldItems) {
        //system.debug('ProjectRollUpTriggerHelper : AfterUndelete>>>>>>>>>>>>>>');
        recalPendingInsertDeleteUndelete((Map<Id, Project__c>)oldItems);
    }

    private void recalPendingInsertDeleteUndelete(Map<Id, Project__c> newProjMap) {

        Map<Id, SObject> masterRecordMap = new Map<Id, SObject>();
        try{
            for(Project__c proj: newProjMap.values()){
                if(proj.Related_Contract__c != NULL){
                    if(proj.Amount_in_Pipeline__c <> null || proj.Amount_Won__c != null || proj.Quantity_in_Pipeline__c <> null || proj.Quantity_Won__c <> null || proj.Recalculation_Pending__c){
                        masterRecordMap.put(proj.Related_Contract__c, new Contract(id=proj.Related_Contract__c, Recalculation_Pending__c=true));
                    }
                }
            }
            if(masterRecordMap.size()>0) {
                update masterRecordMap.values();
            }
        }
        catch (Exception ex){
            system.debug('Exception in ProjectRollupTriggerHelper.recalPendingInsertDeleteUndelete>>>>> '+ex);
        }
    }

    private void recalPendingUpdate(Map<Id, Project__c> oldProjMap, Map<Id, Project__c> newProjMap) {

        Map<Id, SObject> masterRecordMap = new Map<Id, SObject>();
        try{
            for(Project__c newProj: newProjMap.values()){
                Project__c oldProj = oldProjMap.get(newProj.Id);

                if(newProj.Related_Contract__c <> oldProj.Related_Contract__c){
                    if(newProj.Related_Contract__c != null) {
                        masterRecordMap.put(newProj.Related_Contract__c, new Contract(id = newProj.Related_Contract__c, Recalculation_Pending__c = true));
                    }
                    if(oldProj.Related_Contract__c != null) {
                        masterRecordMap.put(oldProj.Related_Contract__c, new Contract(id = oldProj.Related_Contract__c, Recalculation_Pending__c = true));
                    }
                }
                else if(newProj.Recalculation_Pending__c && newProj.Related_Contract__c <> NULL){
                    masterRecordMap.put(newProj.Related_Contract__c, new Contract(id = newProj.Related_Contract__c, Recalculation_Pending__c = true));
                }
            }

            if(masterRecordMap.size()>0){
                update masterRecordMap.values();
            }
        }
        catch (Exception ex){
            system.debug('Exception in ProjectRollupTriggerHelper.recalPendingUpdate>>>>> '+ex);
        }
    }

}