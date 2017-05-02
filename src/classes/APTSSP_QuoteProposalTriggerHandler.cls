/*************************************************************
@Name: APTSSP_QuoteProposalTriggerHandler
@Author: Monika Morrisonoa
@CreateDate: 30.11.2016
@Description: this is Handler class of APTSSP_QuoteProposalTrigger.
@UsedBy: APTSSP_UpdateOppTrigger on Propososal
******************************************************************
@ModifiedBy: Author who modified this process.
@ModifiedDate: Date the process was modified.
@ChangeDescription: A brief description of what was modified.
******************************************************************/
public class APTSSP_QuoteProposalTriggerHandler {
    /*
    	call before insert actions
    */
    public void onBeforeInsert(list<Apttus_Proposal__Proposal__c> newProposalList) {
        //Varible declairation...
        list<Apttus_Proposal__Proposal__c> proposalList = new list<Apttus_Proposal__Proposal__c>();
        map<Id, AccountContactRole> accountIdAccountContactRoleMap = new map<Id, AccountContactRole>();
        map<String, Opportunity> opportunityNameRecordMap = new map<String, Opportunity> ();
        
        for(Apttus_Proposal__Proposal__c proposalRecord : newProposalList){
            //Preparing AccountId set...
            if(proposalRecord.Apttus_Proposal__Account__c != null){ 
                accountIdAccountContactRoleMap.put(proposalRecord.Apttus_Proposal__Account__c, null);                
            }
        }
        
        //Getting Primary Contact records...
        if(!accountIdAccountContactRoleMap.keySet().isEmpty()){
            for(AccountContactRole contactRole : APTSSP_QuoteProposalTriggerHelper.getAccountContactRoleRecord(accountIdAccountContactRoleMap.keySet())){
                accountIdAccountContactRoleMap.put(contactRole.AccountId, contactRole);
            }
        }
        
        //Creating Instance of APTSSP_QuoteProposalTriggerHelper class...
        APTSSP_QuoteProposalTriggerHelper instanceofAPTSSP_QuoteProposalTriggerHelper = new APTSSP_QuoteProposalTriggerHelper ();
        //Calling validateProposal method to validate Proposal...         
        for(Apttus_Proposal__Proposal__c proposalRecord : instanceofAPTSSP_QuoteProposalTriggerHelper.validateProposal(newProposalList, accountIdAccountContactRoleMap)){
            proposalList.add(proposalRecord);
        }
           
        if(!proposalList.isEmpty()){            
            //Calling createOpportunity method to Create Opportunity Records for Proposals...            
            map<Integer, Opportunity> proposalNumberWithOpportunityRecord = new map<Integer, Opportunity>();
            proposalNumberWithOpportunityRecord = instanceofAPTSSP_QuoteProposalTriggerHelper.createOpportunity(proposalList);
            //Calling updateProposal method to update Proposals Record...
            instanceofAPTSSP_QuoteProposalTriggerHelper.updateProposal(proposalList, accountIdAccountContactRoleMap, proposalNumberWithOpportunityRecord);
        }        
    }    
}