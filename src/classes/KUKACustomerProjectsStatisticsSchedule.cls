global class KUKACustomerProjectsStatisticsSchedule implements Schedulable{
	
	 global void execute(SchedulableContext SC) {
	 	String query = 'Select Id, Recalculation_Pending__c, Quantity_in_Pipeline__c, Quantity_Won__c, Amount_in_Pipeline__c, Amount_Won__c, (Select Id, Amount, TotalOpportunityQuantity, IsClosed, IsWon From Opportunities__r) From Project__c  where Recalculation_Pending__c = true';
      	KUKACustomerProjectStatisticsBatch custProjectStaticsBatch = new KUKACustomerProjectStatisticsBatch(query);
      	
      	Database.executeBatch(custProjectStaticsBatch,50);
   	}
    
}