global class KUKACustomerProjectStatisticsBatch implements Database.Batchable<sObject>, Database.Stateful {

   global final String Query;
   
   global  List<Project__c> customerProjList; 
  

   global KUKACustomerProjectStatisticsBatch(String q){

      Query=q;
      customerProjList = new List<Project__c>();
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
   	
   	for(sObject s : scope){
   		Project__c customerProject = (Project__c) s;
   		
   		
   		List<Opportunity> oppList = customerProject.Opportunities__r;
   		
   		Decimal amountWon = 0.0;
   		Decimal quantityWon = 0.0;
   		Decimal amountInPipeline = 0.0;
   		Decimal quantityInPipeLine = 0.0;
   		
   		for(Opportunity opp : customerProject.Opportunities__r){
   			
   			if(opp.IsWon){
   				
   				if(opp.Amount != null){
   					amountWon = amountWon + opp.Amount;
   					
   				}
   				
   				if(opp.TotalOpportunityQuantity != null){
   					quantityWon = quantityWon + opp.TotalOpportunityQuantity;
   					
   				}
   				
   			}
   			
   			if(!opp.IsClosed){
   				
   				
   				if(opp.Amount != null){
   					amountInPipeline = amountInPipeline + opp.Amount;
   					
   				}
   				
   				if(opp.TotalOpportunityQuantity != null){
   					quantityInPipeLine = quantityInPipeLine + opp.TotalOpportunityQuantity;
   					
   				}
   			}
   			
   			
   		}
   		
   		customerProject.Amount_Won__c = amountWon.setScale(2);
   		customerProject.Quantity_Won__c = quantityWon.setScale(2);
   		customerProject.Amount_in_Pipeline__c = amountInPipeline.setScale(2);
   		customerProject.Quantity_in_Pipeline__c = quantityInPipeLine.setScale(2);
   		customerProject.Recalculation_Pending__c  = false;
   		
   		customerProjList.add(customerProject);
   		
   		System.debug('--Project List--1'+customerProjList);
   		
   	}
   	
   	System.debug('--Project List--2'+customerProjList);
    
    }

   global void finish(Database.BatchableContext BC){
   	
   	 System.debug('-----Project List--3'+customerProjList);
   	if(!customerProjList.isEmpty()){
   		System.debug('-----Project List--4'+customerProjList);
   		Database.update(customerProjList);
   	}
   }


    
}