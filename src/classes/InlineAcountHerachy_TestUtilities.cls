/**
* Generate the enviroment for the Unit Tests
* @author Sebastian Muñoz - Force.com Labs
* @createddate 06/08/2010
*/
/**********************************************************************
======================================================
History
-------
Date        AUTHOR                          DETAIL
13/10/2016  Andreas Meyer                   change demo data due to change to country picklists
14/11/2016  Andreas Meyer                   Update Uinittest integrity
*********************************************************************/

public with sharing class InlineAcountHerachy_TestUtilities{
	
	//Lists
	public List<User>		 	testUserList { get; set; }
 	public List<Account>	 	testAccList  { get; set; }
 	public List<Lead>		 	testLeadList { get; set; }
 	public List<Opportunity>  	testOppList  { get; set; }
 	public List<Contact>	 	testConList  { get; set; }
 	public List<Task>		 	testTaskList { get; set; }
	
	//Objects
	public User			testUser { get; set; }
 	public Account		testAcc  { get; set; }
 	public Lead			testLead { get; set; }
 	public Opportunity	testOpp  { get; set; }
 	public Contact		testCon  { get; set; }
 	public Task			testTask { get; set; }
 	
 	
  	/**
  	* Check over all object field if the loged User has right over Object
  	* @parms sObject , CRUD check ( isCreateable, isDeleteable, isUpdateable ) 
  	* @return Boolean
  	*/
  	public Boolean checkObjectCrud( String objName, Set<String> fieldsToCheck, String crudType ){  		
  		
  		// Get the global describe
        Schema.DescribeSObjectResult objectResult = Schema.getGlobalDescribe().get( objName ).getDescribe();

  		for( String fieldToCheck : objectResult.fields.getMap().keySet() ){	
  			
  			Schema.DescribeFieldResult current_field = objectResult.fields.getMap().get( fieldToCheck ).getDescribe();
  			
  			if( fieldsToCheck.contains( current_field.getName() ) ) {
  			
	  			if( 'create'.equalsIgnoreCase( crudType ) && !current_field.isCreateable()){
		  			return false;
		  		}
		  		else if( 'update'.equalsIgnoreCase( crudType ) && !current_field.isUpdateable() ){
		  			return false;
		  		}
  			}
  		}
  		
  		return true;
  	}
  	
  	/**
  	* Create Account's
  	* @params accountToCreate ( the total amount of account )
  	*/
  	public void createAccounts( Integer accountToCreate, Set<String> fieldsToCheck ){

  		List<Account> auxList = new List<Account>();
  		
  		for( Integer i = 1; i <= accountToCreate; i++ ){
  			Account accAux 				= new Account();
  			accAux.Name 				= this.createRandomWord();
  			//accAux.ShippingStreet 		= '1 Main St.' + String.valueOf( i );
        accAux.ShippingStreet     = this.createRandomWord();
  			//accAux.ShippingState		= 'Virginia';
        accAux.ShippingStateCode    = 'AZ';
  			//accAux.ShippingPostalCode	= '12345' + String.valueOf( i );
        accAux.ShippingPostalCode = this.createRandomNumber();
  			//accAux.ShippingCountry		= 'United States';
        accAux.ShippingCountryCode    = 'US';
  			//accAux.ShippingCity			= 'Anytown' + String.valueOf( i );
        accAux.ShippingCity     = this.createRandomWord();

  			accAux.Description			= 'This is a test account' + String.valueOf( i );
  			//accAux.BillingStreet		= '1 Main St.' + String.valueOf( i );
        accAux.BillingStreet    = this.createRandomWord();
  			//accAux.BillingState			= 'Virginia';
        accAux.BillingStateCode     = 'AZ';
  			//accAux.BillingPostalCode	= '12345' + String.valueOf( i );
        accAux.BillingPostalCode  = this.createRandomNumber();
  			//accAux.BillingCountry 		= 'United States';
        accAux.BillingCountryCode     = 'US';
  			//accAux.BillingCity			= 'Anytown' + String.valueOf( i );
        accAux.BillingCity      = this.createRandomWord();
  			accAux.AnnualRevenue		= 10000;
  			accAux.ParentId				= null;
			auxList.add( accAux );
  		}
  		
  		if ( this.checkObjectCrud('Account', fieldsToCheck, 'create') ){
  			try{
  				insert auxList;
  			}
  			catch( Exception ex ){
 				System.assert( false ,'Pre deploy test failed, This may be because of custom validation rules in your Org. You can check ignore apex errors or temporarily deactivate your validation rules for Accounts and try again.: '+ ex.getMessage());
 			}
 			this.testAccList = new List<Account>();
 			this.testAccList.addAll( auxList );
  		}
  		else{
  			System.Assert(false , 'You need right over Account Object');
  		}
  	}
  	
  	/**
    * Method for Update a Account
    * @param fieldsToCheck
    */
  	public void updateAccountList( Set<String> fieldsToCheck ){ 
  		
  		if ( this.checkObjectCrud('Account', fieldsToCheck, 'create') && !this.testAccList.isEmpty() ){
  			try{
  				update this.testAccList;
  			}
  			catch( Exception ex ){
 				System.assert( false ,'Pre deploy test failed, This may be because of custom validation rules in your Org. You can check ignore apex errors or temporarily deactivate your validation rules for Accounts and try again.');
 			}
  		}
  		else{
  			System.Assert(false , 'You need right over Account Object');
  		}
  	}
  	
  	/**
    * Random words are required for testing 
    * as you will likely run into any word I can insert
    * during a test class and produce false test results.
    */
    public String createRandomWord(){
      String ret = 'word' + math.rint( math.random() * 100000 );
      
      return ret;
    }

    /**
    * Random words are required for testing 
    * as you will likely run into any word I can insert
    * during a test class and produce false test results.
    */
    public String createRandomNumber(){
      String ret = '' + math.rint( math.random() * 100000 );
      
      return ret;
    }

}