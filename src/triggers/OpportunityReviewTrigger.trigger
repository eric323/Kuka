trigger OpportunityReviewTrigger on Opportunity_Review__c (before insert, before update) {
    //Call the trigger dispatcher and pass it an instance of the OpportunityReviewTriggerHandler
    TriggerDispatcher.Run(new OpportunityReviewTriggerHandler());
}