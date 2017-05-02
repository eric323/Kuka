/*************************************************************
@Name: APTSSP_QuoteProposalTriggerHelper
@Author: Monika Morrisonoa
@CreateDate: 30.11.2016
@Description: this is helper class of APTSSP_QuoteProposalTrigger.
@UsedBy: APTSSP_QuoteProposalTrigger on Propososal
******************************************************************
@ModifiedBy: Author who modified this process.
@ModifiedDate: Date the process was modified.
@ChangeDescription: A brief description of what was modified.
******************************************************************/
public class APTSSP_QuoteProposalTriggerHelper {
    public list<Apttus_Proposal__Proposal__c> validateProposal(list<Apttus_Proposal__Proposal__c> newProposalList, map<Id, AccountContactRole> accountIdAccountContactRoleMap){
        list<Apttus_Proposal__Proposal__c> proposalList = new list<Apttus_Proposal__Proposal__c>();
        for(Apttus_Proposal__Proposal__c proposalRecord : newProposalList){ 
            //Checking Account is blank or not..
            if(proposalRecord.Apttus_Proposal__Account__c == null){
                proposalRecord.addError(system.label.APTSSP_AccountShouldNotBlank);                
            }
             //Validation message if Primary Contact is not found on AccountContactRole object...
            //else if(accountIdAccountContactRoleMap.get(proposalRecord.Apttus_Proposal__Account__c) == null){                
                //proposalRecord.addError(System.label.APTSSP_PrimaryContactShouldNotBlank);
            //}
            else{
                proposalList.add(proposalRecord);
            }            
        }
        return proposalList;
    }
    
    public void updateProposal(list<Apttus_Proposal__Proposal__c> proposalList, map<Id, AccountContactRole> accountIdAccountContactRoleMap, map<Integer, Opportunity> proposalNumberWithOpportunityRecord){
        Integer proposalNumber = 0;
        for(Apttus_Proposal__Proposal__c proposalRecord : proposalList){            
            //Assigning Primary Contact on Proposal...
            //if(!accountIdAccountContactRoleMap.isEmpty() && accountIdAccountContactRoleMap.containsKey(proposalRecord.Apttus_Proposal__Account__c) && accountIdAccountContactRoleMap.get(proposalRecord.Apttus_Proposal__Account__c) != null && accountIdAccountContactRoleMap.get(proposalRecord.Apttus_Proposal__Account__c).ContactID != null){
            //    proposalRecord.Apttus_Proposal__Primary_Contact__c = accountIdAccountContactRoleMap.get(proposalRecord.Apttus_Proposal__Account__c).ContactID;
            //}             
            //Assigning Opportunity on Proposal...
            if(proposalRecord.Apttus_Proposal__Opportunity__c == null && !proposalNumberWithOpportunityRecord.isEmpty() && proposalNumberWithOpportunityRecord.containsKey(proposalNumber)){
                Opportunity opportunityRecord = proposalNumberWithOpportunityRecord.get(proposalNumber);
                proposalRecord.Apttus_Proposal__Opportunity__c = opportunityRecord.Id;
            }
            proposalNumber ++;
        }
    }
    
    //Getting Primary Contact records...
    public static list<AccountContactRole> getAccountContactRoleRecord(set<Id> accountIdSet){        
        return [select ContactID, IsPrimary, AccountID 
                from AccountContactRole 
                where isPrimary = true and AccountID =: accountIdSet];            
    }
    
    public map<Integer, Opportunity> createOpportunity(list<Apttus_Proposal__Proposal__c> proposalList){
        list<Opportunity> OpportunityToInsertList = new list<Opportunity>();
        map<Integer, Opportunity> proposalNumberWithOpportunityRecord = new map<Integer, Opportunity>();
        Id RecordtypeId = null;
        //Getting Record Type Id...
        RecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Internal Spare Parts Opportunity').getRecordTypeId();
        Integer proposalNumber = 0;
        for(Apttus_Proposal__Proposal__c proposalRecord : proposalList){
            if(proposalRecord.Apttus_Proposal__Opportunity__c == null) { 
                //Creating Opportunity Records...
                Opportunity opportunityRecord = new Opportunity(); 
                if(RecordtypeId != null){
                    opportunityRecord.RecordTypeId = RecordtypeId;
                }            
                opportunityRecord.owner = proposalRecord.owner;
                opportunityRecord.ownerid = proposalRecord.ownerid;
                opportunityRecord.name = 'Internal Spare Parts - '+ proposalRecord.Apttus_Proposal__Proposal_Name__c.left(90) + ' - ' + Date.today().format();
                opportunityRecord.accountId = proposalRecord.Apttus_Proposal__Account__c;
                opportunityRecord.type = 'New';
                opportunityRecord.StageName = 'Proposal';
                opportunityRecord.CloseDate = Date.today().addDays(30);
                opportunityRecord.Probability = 10;
                opportunityRecord.CurrencyIsoCode = proposalRecord.CurrencyIsoCode;
                OpportunityToInsertList.add(opportunityRecord);
                proposalNumberWithOpportunityRecord.put(proposalNumber ++, opportunityRecord);
            }
        }
        //Inserting Opportunity Records...
        if(!OpportunityToInsertList.isEmpty()){
            try{
                system.debug('==OpportunityToInsertList=='+OpportunityToInsertList);
                Insert OpportunityToInsertList;
            }catch(Exception e){
                System.debug('APTSSP_QuoteProposalTriggerHelper.createOpportunity:: ' + e.getMessage());
            }            
        }        
        return proposalNumberWithOpportunityRecord;
    }
}