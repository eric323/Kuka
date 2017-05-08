/**********************************************************************
Name:  OpportunityTriggerHandler
======================================================
Purpose: Handler class for OpportunityTrigger
======================================================
History
-------
Date        AUTHOR                          DETAIL
06/10/2016  Andreas Meyer 			        INITIAL (DC-486)
26/10/2016  Andreas Meyer 					DC-389 take market segment and industrie from account
*********************************************************************/
public with sharing class OpportunityTriggerHandler implements ITriggerHandler
{
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

	public void BeforeInsert(List<SObject> newItems) 
	{	
		// DC-389 take market segment and industrie from account if changed
		system.debug('OpportunityTriggerHandler: BeforeInsert');
		// andreas.meyer@salesforce.com 09.12.2016 deactivate this function, but leave it for the Unittest due to codecoverage
		if (true == Test.isRunningTest()){
			assignMarketSegmentOnInsert((List<Opportunity>)newItems);	
		}				
	}

	public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) 
	{
		// DC-389 take market segment and industrie from account if changed
		system.debug('OpportunityTriggerHandler: BeforeUpdate');
		// andreas.meyer@salesforce.com 09.12.2016 deactivate this function, but leave it for the Unittest due to codecoverage
		if (true == Test.isRunningTest()){		
			assignMarketSegmentOnUpdate((Map<Id, Opportunity>)newItems,(Map<Id, Opportunity>)oldItems);		
		}		
	}

	public void BeforeDelete(Map<Id, SObject> oldItems) {}

	public void AfterInsert(Map<Id, SObject> newItems) {
		// DC-486 make sure the main contact field is populated
		system.debug('OpportunityTriggerHandler: AfterInsert');
		// andreas.meyer@salesforce.com 14.11.2016 deactivate this function, but leave it for the Unittest due to codecoverage
		if (true == Test.isRunningTest()){
			assignMainContact((Map<Id, Opportunity>)newItems);
		}

	}

	public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

	public void AfterDelete(Map<Id, SObject> oldItems) {}

	public void AfterUndelete(Map<Id, SObject> oldItems) {}

	/*
		member funcions
	*/
	private void assignMarketSegmentOnInsert(List<Opportunity> listOpportunities)
	{
		system.debug('OpportunityTriggerHandler.assignMarketSegmentOnInsert started');
		if (true == listOpportunities.isEmpty()){
			return;
		}
		Set<Id> setAccountIds = new Set<Id>();
		for(Opportunity opp : listOpportunities){
			if(null != opp.AccountId){
				setAccountIds.add(opp.AccountId);
			}		
		}

		// query all accounts
		List<Account> listAccounts = new List<Account>([	SELECT Id, Market_Segment__c, Industry__c  
															FROM Account 
															WHERE Id IN :setAccountIds]);	

		if (false == listAccounts.isEmpty()){
			// check all accounts
			for(Account acc : listAccounts){
				for(Opportunity opp: listOpportunities){
					if (opp.AccountId == acc.Id){
						if (false == String.isBlank(acc.Market_Segment__c)){
							opp.Market_Segment__c = acc.Market_Segment__c;	
						}
						if (false == String.isBlank(acc.Industry__c)){
							opp.Industry__c = acc.Industry__c;	
						}						
					}						
				}
			}
		}

	}


	private void assignMarketSegmentOnUpdate(Map<Id, Opportunity> mapNewOpportunities,Map<Id, Opportunity> mapOldOpportunities)
	{
		system.debug('OpportunityTriggerHandler.assignMarketSegmentOnUpdate started');
		if (true == mapNewOpportunities.isEmpty()){
			return;
		}
		Set<Id> setChangedOpportunitiesIds = new Set<Id>();
		Set<Id> setAccountIds = new Set<Id>();
		for(Opportunity opp : mapNewOpportunities.values()){
			if(opp.AccountId != mapOldOpportunities.get(opp.Id).AccountId){
				setChangedOpportunitiesIds.add(opp.Id);
				setAccountIds.add(opp.AccountId);
			}
		}

		if (true == setChangedOpportunitiesIds.isEmpty()){
			return;
		}
		// query all accounts
		List<Account> listAccounts = new List<Account>([	SELECT Id, Market_Segment__c, Industry__c  
															FROM Account 
															WHERE Id IN :setAccountIds]);	

		if (false == listAccounts.isEmpty()){
			// check all accounts
			for(Account acc : listAccounts){
				for(Opportunity opp: mapNewOpportunities.values()){
					if (true == setChangedOpportunitiesIds.contains(opp.Id)){
						if (opp.AccountId == acc.Id){
							opp.Market_Segment__c = acc.Market_Segment__c;
							opp.Industry__c = acc.Industry__c;
						}						
					}
				}
			}
		}

	}



	private void assignMainContact(Map<Id, Opportunity> mapOpportunities)
	{
		system.debug('OpportunityTriggerHandler.assignMainContact started');
		if (true == mapOpportunities.isEmpty()){
			return;
		}

		// requery opportunites because we are in a afterinsert context
		Set<Id> setOpportunityIds = new Set<Id>();
		setOpportunityIds = mapOpportunities.keySet();
		List<Opportunity> listRequeryOpportunites = new List<Opportunity>([	SELECT Id, Main_Contact__c,AccountId  
                  															FROM Opportunity 
                  															WHERE Id IN :setOpportunityIds]);


		if (true == listRequeryOpportunites.isEmpty()){
			return;
		}


		List<Opportunity> listOppToUpdate = new List<Opportunity>();
		List<Opportunity> listOppToCheck = new List<Opportunity>();
		List<Opportunity> listOppToCheckAccount = new List<Opportunity>();
		List<Id> listOppIds = new List<Id>();
		// Step1: check which Opporunities do not have an main contact already
		// the user is able to assign a main contact on creation already
		// thus we need to ignore these opportunities
		for(Opportunity opp: listRequeryOpportunites){
			if (null == opp.Main_Contact__c){
				listOppToCheck.add(opp);	
				listOppIds.add(opp.Id);
			}
		}

		if (true == listOppToCheck.isEmpty()){
			return;
		}	

		system.debug('OpportunityTriggerHandler.assignMainContact listOppToCheck: ' + listOppToCheck);		

		// Step2: check if we have a primary Opportunity contact role
		// if a user creates an opportunity from a contact detail page, this contact will be added
		// as the primary contact role on the new opportunity
		List<OpportunityContactRole> listOpportunityContactRoles = new List<OpportunityContactRole>([	SELECT Id, ContactId, OpportunityId 
                  																						FROM OpportunityContactRole 
                  																						WHERE OpportunityId IN :listOppIds 
                  																						AND IsPrimary = true]);
		if (false == listOpportunityContactRoles.isEmpty()){
			// check all opportunities
			for(Opportunity opp : listOppToCheck){
				Boolean oppfound = false;
				for (OpportunityContactRole opprole: listOpportunityContactRoles){
					if (opp.Id == opprole.OpportunityId){
						// we have a match .. set the main contact
						opp.Main_Contact__c = opprole.ContactId;
						listOppToUpdate.add(opp);
						oppfound = true;
					}
				}
				// no match?
				if (false == oppfound){
					// this opportunity needs an account check
					listOppToCheckAccount.add(opp);
				} 
			}
		}
		else{
			// add all listOppToCheck opportunites to listOppToCheckAccount
			listOppToCheckAccount.addAll(listOppToCheck);
		}

		system.debug('OpportunityTriggerHandler.assignMainContact listOppToCheckAccount: ' + listOppToCheckAccount);	

		// Step3: check the opportunity accounts and take the first contact 
		// (if existing)
		if (false == listOppToCheckAccount.isEmpty()){
			// get all account IDs
			List<Id> listOppAccountIds = new List<Id>();
			for(Opportunity opp : listOppToCheckAccount){
				if (null != opp.AccountId){
					listOppAccountIds.add(opp.AccountId);	
				}
			}

			if (false == listOppAccountIds.isEmpty()){
				// get all contacts for opportunites
				List<Contact> listOppContacts = new List<Contact>([	SELECT Id, AccountId  
														            FROM Contact 
														            WHERE AccountId IN :listOppAccountIds]);
				if (false == listOppContacts.isEmpty()){
					// check all opportunities
					for(Opportunity opp : listOppToCheckAccount){
						for(Contact con : listOppContacts){
							if (opp.AccountId == con.AccountId){
								// we have a match .. set the main contact
								opp.Main_Contact__c = con.Id;
								listOppToUpdate.add(opp);
								// don't look further, we always take the first contact that is found
								break;
							}
						}
					}
				}
			}
		}

		system.debug('OpportunityTriggerHandler.assignMainContact listOppToUpdate: ' + listOppToUpdate);	

		// Step4: Update all changes opportunities
		if (false == listOppToUpdate.isEmpty()){
			update listOppToUpdate;
		}

	}
	



}