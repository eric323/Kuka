/**********************************************************************
Name:  KAPObjectiveViewController
======================================================
Purpose: Controller for KAPObjectiveView page
======================================================
History
-------
Date        AUTHOR                          DETAIL
30/08/2016  Andreas Meyer 			        INITIAL
13/09/2016	Andreas Meyer 					allow multiple values for year/businessunit
14/09/2016	Andreas Meyer 					switch from Decimal to AccountSalesGoal__c
*********************************************************************/
public with sharing class KAPObjectiveViewController {

	private KeyAccountPlan__c obj;
	public boolean novalues {get;set;} 

	public PlanDataWrapper PlanRevenue {get;set;}
	public PlanDataWrapper PlanQuantity {get;set;}  
	public List<String> listYears {get;set;}
	public List<String> listBusinessUnits {get;set;}
	public String cIsoCode {get;set;}


	public class PlanDataWrapper {
	
	    public Map<String,AccountSalesGoal__c> mapTotalPlanGoalValue						{get; set;}
	    public Map<String,Map<String,AccountSalesGoal__c>> mapYearsToBusinessUnitValues		{get; set;}

	    
	    // constructor
	    public PlanDataWrapper(List<String> listYears,List<String> listBusinessUnits)
	    {
	    	// init maps with 0.00 values for all businessunits/years
	    	mapYearsToBusinessUnitValues = new Map<String,Map<String,AccountSalesGoal__c>>();
	    	mapTotalPlanGoalValue = new Map<String,AccountSalesGoal__c>();

          	if (false == listYears.IsEmpty() && false == listBusinessUnits.IsEmpty()){

		    	// init aggregators
		    	for (String year : listYears) {
		    		AccountSalesGoal__c hGoal = new AccountSalesGoal__c(Value__c = 0.00, Units__c = 0);
					//mapTotalPlanGoalValue.put(year, 0.00);
					mapTotalPlanGoalValue.put(year, hGoal);
				}
				// init matrix
				for (String bu : listBusinessUnits) {
					Map<String,AccountSalesGoal__c> mapYears = new Map<String,AccountSalesGoal__c>();
					for (String year : listYears) {
						AccountSalesGoal__c hGoal = new AccountSalesGoal__c(Value__c = 0.00, Units__c = 0);
						//mapYears.put(year, 0.00);
						mapYears.put(year, hGoal);
					}
					mapYearsToBusinessUnitValues.put(bu, mapYears);
				}
          	}	    	
	    }	    
	}	


	public  List<String> getPicklistValues(String ObjectApi_name,String Field_name){ 

		List<String> lstPickvals=new List<String>();

	  	Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
	    Sobject Object_name = targetType.newSObject();
	  	Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
	    Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
	    Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
	    List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
	    
	    for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list

	      lstPickvals.add(a.getValue());//add the value  to our final list

	   	}

	  return lstPickvals;
	}


	public void readObjectiveData() {
		if (null == this.PlanRevenue.mapYearsToBusinessUnitValues || null == this.PlanQuantity.mapYearsToBusinessUnitValues){
			return;
		}

		if (null == this.obj){
			return;
		}

		List<AccountSalesGoal__c> listAccountSalesGoals = new List<AccountSalesGoal__c>([
					SELECT 	BusinessUnit__c, 
							Units__c, 
							Units_Year__c,
							Value__c,
							Id,
							Value_Year__c 
							FROM AccountSalesGoal__c 
							WHERE KeyAccountPlanID__c =: obj.Id 
					]);
					
		if (false == listAccountSalesGoals.IsEmpty()){
			for (AccountSalesGoal__c goal : listAccountSalesGoals) {
				// check if a value is given:
				if (null != goal.Value__c && false == String.isBlank(goal.Value_Year__c) && false == String.isBlank(goal.BusinessUnit__c)){
					novalues = false;
					// add to aggregator
					if (true == this.PlanRevenue.mapTotalPlanGoalValue.containsKey(goal.Value_Year__c)){
						//Decimal aggrValue = this.PlanRevenue.mapTotalPlanGoalValue.get(goal.Value_Year__c) + goal.Value__c;
						AccountSalesGoal__c existGoal = this.PlanRevenue.mapTotalPlanGoalValue.get(goal.Value_Year__c);
						existGoal.Value__c = existGoal.Value__c + goal.Value__c;
						this.PlanRevenue.mapTotalPlanGoalValue.put(goal.Value_Year__c, existGoal);
					}
					// lookup business unit and year
					if (true == this.PlanRevenue.mapYearsToBusinessUnitValues.containsKey(goal.BusinessUnit__c)){
						Map<String,AccountSalesGoal__c> hmapYears = this.PlanRevenue.mapYearsToBusinessUnitValues.get(goal.BusinessUnit__c);
						if (true == hmapYears.containsKey(goal.Value_Year__c)){
							//Decimal aggrSingleValue = hmapYears.get(goal.Value_Year__c) + goal.Value__c;
							AccountSalesGoal__c existGoal = hmapYears.get(goal.Value_Year__c);
							existGoal.Value__c = existGoal.Value__c + goal.Value__c;
							//hmapYears.put(goal.Value_Year__c, goal.Value__c);
							hmapYears.put(goal.Value_Year__c, existGoal);
						}						
					}
				}
				else if (null != goal.Units__c && false == String.isBlank(goal.Units_Year__c) && false == String.isBlank(goal.BusinessUnit__c)){
					novalues = false;
					// add to aggregator
					if (true == this.PlanQuantity.mapTotalPlanGoalValue.containsKey(goal.Units_Year__c)){
						//Decimal aggrValue = this.PlanQuantity.mapTotalPlanGoalValue.get(goal.Units_Year__c) + goal.Units__c;
						AccountSalesGoal__c existGoal = this.PlanQuantity.mapTotalPlanGoalValue.get(goal.Units_Year__c);
						existGoal.Units__c = existGoal.Units__c + goal.Units__c;
						//this.PlanQuantity.mapTotalPlanGoalValue.put(goal.Units_Year__c, aggrValue);
						this.PlanQuantity.mapTotalPlanGoalValue.put(goal.Units_Year__c, existGoal);
					}
					// lookup business unit and year
					if (true == this.PlanQuantity.mapYearsToBusinessUnitValues.containsKey(goal.BusinessUnit__c)){
						Map<String,AccountSalesGoal__c> hmapYears = this.PlanQuantity.mapYearsToBusinessUnitValues.get(goal.BusinessUnit__c);
						if (true == hmapYears.containsKey(goal.Units_Year__c)){
							//Decimal aggrSingleValue = hmapYears.get(goal.Units_Year__c) + goal.Units__c;
							AccountSalesGoal__c existGoal = hmapYears.get(goal.Units_Year__c);
							existGoal.Units__c = existGoal.Units__c + goal.Units__c;						
							//hmapYears.put(goal.Units_Year__c, aggrSingleValue);	
							hmapYears.put(goal.Units_Year__c, existGoal);							
							//hmapYears.put(goal.Units_Year__c, goal.Units__c);
						}						
					}
				}

			}	
		}

		return;
	}

    public KAPObjectiveViewController(ApexPages.StandardController controller) {

          // Sets flag initially to true --> if later AccountSalesGoal are found is has to be set to false
          novalues = true;

          // add custom fields
          if (false == Test.isRunningTest()){
            controller.addFields(new List<String>{'CurrencyIsoCode'});  
          }          

          // get the current KeyAccountPlan object
          this.obj = (KeyAccountPlan__c) controller.getRecord();  

          cIsoCode = this.obj.CurrencyIsoCode;

          // get picklist values for years
          this.listYears = this.getPicklistValues('AccountSalesGoal__c','Units_Year__c');
          this.listBusinessUnits = this.getPicklistValues('AccountSalesGoal__c','BusinessUnit__c');

          if (false == listYears.IsEmpty() && false == listBusinessUnits.IsEmpty()){
	          // create wrapper
	          this.PlanRevenue = new PlanDataWrapper(this.listYears,listBusinessUnits);
	          this.PlanQuantity = new PlanDataWrapper(this.listYears,listBusinessUnits);   

	          // populate maps
	          readObjectiveData();   	
          }


    }
}