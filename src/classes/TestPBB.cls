/*
If this class is giving you problems, the most likely cause is your org-specific settings.  

Check validation rules and required fields for account and user, the objects that are used for testing.
If needed, modify the last two methods here (for test data creation) to follow your org's rules


*/

@isTest
private class TestPBB {
	

    @isTest static void testUnLock(){
		list<id> acctIds = getIds(createAccts(5));
		PBBUnLock.UnLockRecord(acctIds);
    }

	//test helpers below

	public static list<id> getIds (list<sobject> sobjects){
		list<id> output = new list<id>();
		for (sobject SO:sobjects){
			output.add((id)So.get('Id'));
		}
		return output;
	}

	public static list<account> createAccts(integer numberOfAccounts){
		list<account> output = new list<account>();

		for (integer i=0; i<numberOfAccounts; i++){
			account a = new Account(Name = 'Test Account' + string.valueof(i), 
				    Market_Segment__c = 'Automotive',
				    Industry__c = 'Battery',
				    BillingStreet = '1 River Road Building 37',
				    BillingPostalCode = '12345',
				    BillingCity = 'Schenectady',
				    BillingCountry = 'USA'
				);
			output.add(a);
		}

		insert output;
		return output;
	}




}