/**********************************************************************
Name:  AccountCompChartController
======================================================
Purpose: Controller for AccountCompChart page
======================================================
History
-------
Date        AUTHOR                          DETAIL
02/09/2016  Andreas Meyer 			        INITIAL
04/10/2016	Andreas Meyer 					DC-496 add legend for labels
25/10/2016	Andreas Meyer 					DC-666 add subgroup to competitor name
*********************************************************************/
public with sharing class AccountCompChartController {

	private Account obj;
	public boolean novalues {get;set;} 

	public List<String> listCompetitors {get;set;}
	public List<Schema.FieldSetMember> listDimensions {get;set;}
	public String strCompetitors {get;set;}
	public String strDimensionsData {get;set;}
	String queryFields;

	public String getSWOTData()
	{
		String retStr = '';
		    
		Schema.DescribeFieldResult fieldResult =
		AccountCompetitor__c.Brand_Trust__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		    
		for( Schema.PicklistEntry f : ple)
		{
			if(retStr.length() > 0) {
          		retStr += ', ';
      		}	
      		String addStr = '\'' +  f.getLabel() + '\'';
      		retStr += addStr;      				
		}       
		return retStr;
	}

    public AccountCompChartController(ApexPages.StandardController controller) {

        // Sets flag initially to true --> if later AccountSalesGoal are found is has to be set to false
        novalues = true;
        queryFields = '';
        strCompetitors = '';
        strDimensionsData = '';

		// get the current KeyAccountPlan object
		this.obj = (Account) controller.getRecord();   
		String hId = this.obj.Id;
		// read fieldset
		listDimensions = new List<Schema.FieldSetMember>();
		listCompetitors = new List<String>();
		try{
			//Get remaining fields according to FieldSet KAPFieldDetails on Opportunity
			for(Schema.FieldSetMember f : SObjectType.AccountCompetitor__c.FieldSets.CompetitorDimensions.getFields()) {
			  listDimensions.add(f);

		      if(queryFields.length() > 0) {
		          queryFields += ', ';
		      }
		      //String addStr = '\'' +  f.getFieldPath() + '\'';
		      queryFields += f.getFieldPath();
			}
		} catch (Exception e) {
		     //Generic exception handling code here
			System.debug('AccountCompChartController: no fieldset: CompetitorDimensions');
		}

		if (false == listDimensions.isEmpty()){

			// query AccountCompetitor__c
			// andreas.meyer@salesforce.com 25.10.2016 DC-666 add Business_Unit__c
			String oppQuery = 'SELECT Id,KUKA_Competitor_List__c,Business_Unit__c,' + queryFields + ' FROM AccountCompetitor__c WHERE AccountID__c =:hId';
			List<AccountCompetitor__c> listKAPCompetitors = new List<AccountCompetitor__c>();
			listKAPCompetitors = Database.query(oppQuery);
			if (false == listKAPCompetitors.isEmpty()){	
				novalues = false;
				for(AccountCompetitor__c comp : listKAPCompetitors){

					listCompetitors.add(comp.KUKA_Competitor_List__c);
					if(strDimensionsData.length() > 0) {
					  strDimensionsData += ',';
					}
					if(strCompetitors.length() > 0) {
		          		strCompetitors += ', ';
		      		}
		      		// andreas.meyer@salesforce.com 25.10.2016 DC-666 add subgroup to string
		      		//String addStr = '\'' +  comp.KUKA_Competitor_List__c + '\'';
		      		String addStr = '\'' +  comp.KUKA_Competitor_List__c + ' (' + comp.Business_Unit__c + ')' + '\'';		      		
		      		strCompetitors += addStr;
					strDimensionsData += '[';	
					String strData = '';						
					for(Schema.FieldSetMember dim : listDimensions){
						if(strData.length() > 0) {
						  strData += ',';
						}
						// {axis:"Email",value:0.59}
						strData += '{axis:"';
						strData += dim.getLabel();
						strData += '",value:';
						try{
							if (null == comp.get(dim.getFieldPath())){
								strData += '0';
							}
							else{
								strData += comp.get(dim.getFieldPath());
							}
						} catch (Exception e) {
						     //Generic exception handling code here
							System.debug('AccountCompChartController: no value for field: ' + dim);
							strData += '0';
						}						
						strData += '}';
					}
					strDimensionsData += strData;
					strDimensionsData += ']';

				}				
			}
		}
    }
}