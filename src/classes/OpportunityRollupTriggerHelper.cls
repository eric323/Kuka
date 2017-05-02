/**********************************************************************
Name:  OpportunityRollupTriggerHelper
======================================================
Purpose:  Handler class for OpportunityRollupTrigger
======================================================
History
-------
Date        AUTHOR                          DETAIL
05/04/2017  bmohammed                  INITIAL Version
25/04/2017  Arokia Joseph              (DC-1321/ DC-1322)
*********************************************************************/
public class OpportunityRollupTriggerHelper implements ITriggerHandler {

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
        //system.debug('OpportunityRollUpTriggerHelper : AfterInsert >>>>>>>>>>>>>>');
        recalPendingInsertDeleteUndelete((Map<Id, Opportunity>)newItems);
    }

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        recalPendingUpdate((Map<Id, Opportunity>)oldItems,(Map<Id, Opportunity>)newItems);
    }

    public void AfterDelete(Map<Id, SObject> oldItems) {

        recalPendingInsertDeleteUndelete((Map<Id, Opportunity>)oldItems);

    }

    public void AfterUndelete(Map<Id, SObject> oldItems) {
        recalPendingInsertDeleteUndelete((Map<Id, Opportunity>)oldItems);
    }

	/*
		member funcions
	*/
    private void recalPendingInsertDeleteUndelete(Map<Id, Opportunity> oppMap) {


        Map<Id, SObject> masterRecordMap = new Map<Id, SObject>();
        try{
            for(Opportunity opp: oppMap.values()){
                if(opp.TotalOpportunityQuantity != null || opp.Amount != null){
                    if(opp.Project__c != null){
                        masterRecordMap.put(opp.Project__c, new Project__c(id=opp.Project__c, Recalculation_Pending__c=true));
                    }
                    else if(opp.ContractId != null){
                        masterRecordMap.put(opp.ContractId, new Contract(id=opp.ContractId, Recalculation_Pending__c=true));
                    }
                }
            }
            if(masterRecordMap.size()>0)
                update masterRecordMap.values();
        }
        catch (Exception ex){
            system.debug('Exception in OpportunityRollupTriggerHelper.recalPendingInsertDeleteUndelete>>>>>> '+ex);
        }

    }

    private void recalPendingUpdate(Map<Id, Opportunity> oldOppMap, Map<Id, Opportunity> newOppMap) {

        Map<Id, SObject> masterRecordMap = new Map<Id, SObject>();

        try{
            for(Opportunity oppNew: newOppMap.values()){
                Opportunity oppOld =  oldOppMap.get(oppNew.Id);

                // update the new & old parent records if reparenting is executed on the opportunity record

                if(oppNew.Project__c <> oppOld.Project__c){

                    if(oppNew.Project__c != null){
                        masterRecordMap.put(oppNew.Project__c, new Project__c(id=oppNew.Project__c, Recalculation_Pending__c=true));
                        if(oppNew.Project__r.Related_Contract__c == null && oppNew.ContractId != null){
                            masterRecordMap.put(oppNew.ContractId, new Contract(id=oppNew.ContractId, Recalculation_Pending__c=true));
                        }
                    }
                    else if(oppNew.ContractId != null)
                        masterRecordMap.put(oppNew.ContractId, new Contract(id=oppNew.ContractId, Recalculation_Pending__c=true));

                    if(oppOld.Project__c != null){
                        masterRecordMap.put(oppOld.Project__c, new Project__c(id=oppOld.Project__c, Recalculation_Pending__c=true));
                        if(oppOld.Project__r.Related_Contract__c == null && oppOld.ContractId != null){
                            masterRecordMap.put(oppOld.ContractId, new Contract(id=oppOld.ContractId, Recalculation_Pending__c=true));
                        }
                    }
                    else if(oppOld.ContractId != null)
                        masterRecordMap.put(oppOld.ContractId, new Contract(id=oppOld.ContractId, Recalculation_Pending__c=true));

                }
                else{
                    if(oppNew.Project__c == null && oppNew.ContractId <> oppOld.ContractId){

                        if(oppNew.ContractId != null)
                            masterRecordMap.put(oppNew.ContractId, new Contract(id=oppNew.ContractId, Recalculation_Pending__c=true));
                        if(oppOld.ContractId != null)
                            masterRecordMap.put(oppOld.ContractId, new Contract(id=oppOld.ContractId, Recalculation_Pending__c=true));
                    }
                    if(oppNew.TotalOpportunityQuantity <> oppOld.TotalOpportunityQuantity || oppNew.Amount <> oppOld.Amount || oppNew.IsClosed <> oppOld.IsClosed){
                        if(oppNew.Project__c != null){
                            masterRecordMap.put(oppNew.Project__c, new Project__c(id=oppNew.Project__c, Recalculation_Pending__c=true));
                            if(oppNew.Project__r.Related_Contract__c == null && oppNew.ContractId != null){
                                masterRecordMap.put(oppNew.ContractId, new Contract(id=oppNew.ContractId, Recalculation_Pending__c=true));
                            }
                        }
                        else if(oppNew.ContractId != null){
                            masterRecordMap.put(oppNew.ContractId, new Contract(id=oppNew.ContractId, Recalculation_Pending__c=true));
                        }
                    }
                }
            }
            if(masterRecordMap.size()>0)
                update masterRecordMap.values();
        }
        catch (Exception ex){
            system.debug('Exception in OpportunityRollupTriggerHelper.recalPendingUpdate>>>>>> '+ex);
        }
    }
}