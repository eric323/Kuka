/**********************************************************************
Name:  UserTriggerHandler
======================================================
Purpose: Handler class for UserTrigger
======================================================
History
-------
Date        AUTHOR                          DETAIL
15/12/2016  Andreas Meyer 			        INITIAL (DC-1175)
15/12/2016  Andreas Meyer 			        Update eCommerce update criteria (DC-1175)
*********************************************************************/
//public with sharing class UserTriggerHandler implements ITriggerHandler
public class UserTriggerHandler implements ITriggerHandler
{
	public static Boolean TriggerDisabled = false;

	/*
		Checks to see if the trigger has been disabled. For example, you could check a custom setting here.
		In this example, a static property is used to disable the trigger.
		In a unit test, you could use UserTriggerHandler.TriggerDisabled = true to completely disable the trigger.
	*/
	public Boolean IsDisabled()
	{
		return TriggerDisabled;
	}

	public void BeforeInsert(List<SObject> newItems) 
	{	
		// DC-1175
		system.debug('UserTriggerHandler: BeforeInsert');
		assignEcommerceRegionOnInsert((List<User>)newItems);	
			
	}

	public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

	public void BeforeDelete(Map<Id, SObject> oldItems) {}

	public void AfterInsert(Map<Id, SObject> newItems) {
		// DC-1175
		system.debug('UserTriggerHandler: AfterInsert');
		assignTransferCommunityDataOnInsert((Map<Id, User>)newItems);

	}

	public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		// DC-1175
		system.debug('UserTriggerHandler: AfterUpdate');
		assignTransferCurrencyOnUpdate((Map<Id, User>)newItems,(Map<Id, User>)oldItems);			
	}

	public void AfterDelete(Map<Id, SObject> oldItems) {}

	public void AfterUndelete(Map<Id, SObject> oldItems) {}

	/*
		member funcions
	*/

	private void assignTransferCommunityDataOnInsert(Map<Id, User> mapUsers)
	{
		system.debug('UserTriggerHandler.assignTransferCommunityDataOnInsert started');
		if (true == mapUsers.isEmpty()){
			return;
		}

		Set<Id> setContactIds = new Set<Id>();
		for(User usr : mapUsers.values()){
			if(usr.ContactId != null){
				setContactIds.add(usr.ContactId);
			}
		}

		if (true == setContactIds.isEmpty()){
			return;
		}
		// query all contacts
		List<Contact> listChangedContacts = new List<Contact>();
		Map<ID,Contact> mapContacts = new Map<ID,Contact>([	SELECT Id, CurrencyIsoCode  
															FROM Contact 
															WHERE Id IN :setContactIds]);	

		if (false == mapContacts.isEmpty()){
			// check all contacts
			for(User usr : mapUsers.values()){
				if(usr.ContactId != null){
					if (true == mapContacts.containsKey(usr.ContactId)){
						Contact changedContact = mapContacts.get(usr.ContactId);
						// change all community data
						changedContact.CommunityCustomerNumber__c = usr.CustomerNumber__c;
						changedContact.E_Mail__c = usr.E_Mail__c;
						changedContact.Letter__c = usr.Letter__c;
						changedContact.Newsletter__c = usr.Newsletter__c;
						changedContact.Telephone__c = usr.Telephone__c;
						changedContact.MobilePhone = usr.MobilePhone;
						changedContact.Salutation = usr.Salutation__c;
						changedContact.Title = usr.Title;
						changedContact.MailingCity = usr.City;
						changedContact.MailingCountryCode = usr.CountryCode;
						changedContact.MailingPostalCode = usr.PostalCode;
						changedContact.MailingStateCode = usr.StateCode;
						changedContact.MailingStreet = usr.Street;

						// change APTTUS data
						changedContact.CurrencyIsoCode = usr.DefaultCurrencyIsoCode;
						listChangedContacts.add(changedContact);
					}
				}
			}
		}

		// update contacts
		
		if (false == listChangedContacts.isEmpty()){
	        try {
	        	// avoid MIXED DML Operations for Unittests
	        	if (Test.isRunningTest()) {
					System.runAs(new User(Id = Userinfo.getUserId())) {
						update listChangedContacts;
					}	
				}
				else{
					update listChangedContacts;	
				}        		        	
	        }
	        catch(Exception e){
	        	System.debug('UserTriggerHandler.assignTransferCommunityDataOnInsert Catch exception: ' + e.getMessage());
			}
		}	
																			


	}


	private void assignEcommerceRegionOnInsert(List<User> listUsers)
	{
		system.debug('UserTriggerHandler.assignEcommerceRegionOnInsert started');
		if (true == listUsers.isEmpty()){
			return;
		}
		for(User usr : listUsers){
			// set DefaultCurrencyIsoCode
			Set<String> setOfCountryCodesISO = new Set<String>();
			setOfCountryCodesISO.add('US');
			setOfCountryCodesISO.add('MX');
			setOfCountryCodesISO.add('CA');

			if(  setOfCountryCodesISO.contains(usr.CountryCode) ){
				usr.DefaultCurrencyIsoCode = 'USD';
			}	
			else{
				usr.DefaultCurrencyIsoCode = 'EUR';	
			}	

			// set eCommerce_Region
			Set<String> setOfCountryCodes = new Set<String>();
			setOfCountryCodes.add('US');
			setOfCountryCodes.add('MX');
			setOfCountryCodes.add('CA');
			setOfCountryCodes.add('AL');
			setOfCountryCodes.add('AD');
			setOfCountryCodes.add('AM');
			setOfCountryCodes.add('AT');
			setOfCountryCodes.add('AZ');
			setOfCountryCodes.add('BY');
			setOfCountryCodes.add('BE');
			setOfCountryCodes.add('BG');
			setOfCountryCodes.add('HR');
			setOfCountryCodes.add('CY');
			setOfCountryCodes.add('CZ');
			setOfCountryCodes.add('DK');
			setOfCountryCodes.add('EE');
			setOfCountryCodes.add('FI');
			setOfCountryCodes.add('FR');
			setOfCountryCodes.add('GE');
			setOfCountryCodes.add('DE');
			setOfCountryCodes.add('GR');
			setOfCountryCodes.add('HU');
			setOfCountryCodes.add('IS');
			setOfCountryCodes.add('IE');
			setOfCountryCodes.add('IT');
			setOfCountryCodes.add('KZ');
			//setOfCountryCodes.add('KO');  //Kosovo not in Country & Territories list !!!!
			setOfCountryCodes.add('LV');
			setOfCountryCodes.add('LI');
			setOfCountryCodes.add('LT');
			setOfCountryCodes.add('LU');
			setOfCountryCodes.add('MK');
			setOfCountryCodes.add('MT');
			setOfCountryCodes.add('MD');
			setOfCountryCodes.add('MC');
			setOfCountryCodes.add('ME');
			setOfCountryCodes.add('NL');
			setOfCountryCodes.add('NO');
			setOfCountryCodes.add('PL');
			setOfCountryCodes.add('PT');
			setOfCountryCodes.add('RO');
			setOfCountryCodes.add('RU');
			setOfCountryCodes.add('SM');
			setOfCountryCodes.add('RS');
			setOfCountryCodes.add('SK');
			setOfCountryCodes.add('SI');
			setOfCountryCodes.add('ES');
			setOfCountryCodes.add('SE');
			setOfCountryCodes.add('CH');
			setOfCountryCodes.add('TR');
			setOfCountryCodes.add('UA');	

			if( setOfCountryCodes.contains(usr.CountryCode) ){
				usr.APTSDMP_eCommerce_Region__c = 'Supported Region';
			}	
			else{
				usr.APTSDMP_eCommerce_Region__c = 'Unsupported Region';
			}		
		}	
	}



	private void assignTransferCurrencyOnUpdate(Map<Id, User> mapNewUsers,Map<Id, User> mapOldUsers)
	{
		system.debug('UserTriggerHandler.assignTransferCurrencyOnUpdate started');
		if (true == mapNewUsers.isEmpty()){
			return;
		}

		Set<Id> setContactIds = new Set<Id>();
		for(User usr : mapNewUsers.values()){
			if(usr.ContactId != null){
				setContactIds.add(usr.ContactId);
			}
		}

		if (true == setContactIds.isEmpty()){
			return;
		}
		// query all contacts
		List<Contact> listChangedContacts = new List<Contact>();
		Map<ID,Contact> mapContacts = new Map<ID,Contact>([	SELECT Id, CurrencyIsoCode  
															FROM Contact 
															WHERE Id IN :setContactIds]);	

		if (false == mapContacts.isEmpty()){
			// check all contacts
			for(User usr : mapNewUsers.values()){
				if(usr.ContactId != null){
					if (true == mapContacts.containsKey(usr.ContactId)){
						Contact changedContact = mapContacts.get(usr.ContactId);
						changedContact.CurrencyIsoCode = usr.DefaultCurrencyIsoCode;
						listChangedContacts.add(changedContact);
					}
				}
			}
		}

		// update contacts
		if (false == listChangedContacts.isEmpty()){
	        try {
	        	// avoid MIXED DML Operations for Unittests
	        	if (Test.isRunningTest()) {
					System.runAs(new User(Id = Userinfo.getUserId())) {
						update listChangedContacts;
					}	
				}
				else{
					update listChangedContacts;	
				}   
	        }
	        catch(Exception e){
	        	System.debug('UserTriggerHandler.assignTransferCurrencyOnUpdate: ' + e.getMessage());
			}
		}
	}


}