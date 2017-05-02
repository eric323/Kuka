/*************************************************************
@Name: APTSSP_CreateOp
@Author: Monika Morrisonoa
@CreateDate: 14.11.2016
@Description: class auto-create opportunity for internal spare parts.
@UsedBy: APTSSP_UpdateOppTrigger on Propososal
******************************************************************
@ModifiedBy: Author who modified this process.
@ModifiedDate: Date the process was modified.
@ChangeDescription: A brief description of what was modified.
******************************************************************/

public with sharing class APTSSP_CreateOpp {
     
   public Id createOpportunity( Apttus_Proposal__Proposal__c objProposal) 
   {
    Opportunity objOpp = new Opportunity();
 
        objOpp.RecordTypeId ='0123E0000008aiq';
        objOpp.owner = objProposal.owner;
        objOpp.ownerid = objProposal.ownerid;
        objOpp.name = 'Internal Spare Parts - '+ objProposal.Apttus_Proposal__Proposal_Name__c.left(90) + ' - ' + Date.today().format();
        objOpp.accountId = objProposal.Apttus_Proposal__Account__c;
        objOpp.type = 'New';
        objOpp.StageName = 'Proposal';
        objOpp.CloseDate = Date.today().addDays(30);
        objOpp.CurrencyIsoCode = objProposal.CurrencyIsoCode;
        
       insert objOpp;
        
       return objOpp.id;
 }
}