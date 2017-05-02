/*************************************************************
@Name: APTSSP_QuoteProposalTrigger
@Author: Monika Morrisonoa
@CreateDate: 30.11.2016
@Description: This trigger is written on Propsal Object to handle Buisness requirments.
******************************************************************
@ModifiedBy: Author who modified this process.
@ModifiedDate: Date the process was modified.
@ChangeDescription: A brief description of what was modified.
******************************************************************/
trigger APTSSP_QuoteProposalTrigger on Apttus_Proposal__Proposal__c (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){ 
            APTSSP_QuoteProposalTriggerHandler instanceofAPTSSP_QuoteProposalTriggerHandler = new APTSSP_QuoteProposalTriggerHandler();
            instanceofAPTSSP_QuoteProposalTriggerHandler.onBeforeInsert(trigger.new);
        }
    }
}