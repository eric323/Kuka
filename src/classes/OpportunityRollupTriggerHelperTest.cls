/**
 * Created by bmohammed on 06/04/2017.
 */

@IsTest
private class OpportunityRollupTriggerHelperTest {

    public static RollUpSummaryTest testHandler = RollUpSummaryTest.getInstance();
    @testSetup static void testSetup() {
        testHandler.initTestSetUp();

    }
    static testMethod void recalPendingInsertTest() {
        List<Account> accounts = [SELECT Id FROM Account];
        List<Project__c> projects = [SELECT Id, Recalculation_Pending__c FROM Project__c];
        List<Contract> contracts = [SELECT Id, Recalculation_Pending__c FROM Contract];

        Test.startTest();
        List<Opportunity> testOpportunities = new List<Opportunity>();
        for(integer i=0; i<2; i++){
            if(0==math.mod(i, 2)){
                testOpportunities.add(new Opportunity(Name = 'Test Opportunity '+i,
                        AccountId = accounts[0].Id,
                        CloseDate = System.today()+5,
                        Business_Unit__c = 'KUKA Industries',
                        Market_Segment__c = 'Automotive',
                        Industry__c = 'Auto Body Shop',
                        Profit_Center__c = 'Advanced Welding Solutions AWS',
                        StageName='Propose',
                        Project__c = projects[0].Id,
                        Amount = 3000,
                        TotalOpportunityQuantity = 200));
            }
            else{
                testOpportunities.add(new Opportunity(Name = 'Test Opportunity '+i,
                        AccountId = accounts[0].Id,
                        CloseDate = System.today()+5,
                        Business_Unit__c = 'KUKA Industries',
                        Market_Segment__c = 'Automotive',
                        Industry__c = 'Auto Body Shop',
                        Profit_Center__c = 'Advanced Welding Solutions AWS',
                        StageName='Propose',
                        ContractId = contracts[1].Id,
                        Amount = 3000,
                        TotalOpportunityQuantity = 200));
            }

        }


        insert testOpportunities;
        Test.stopTest();


        Project__c proj = [SELECT Id, Recalculation_Pending__c FROM Project__c WHERE Id =: projects[0].Id];
        Contract contr = [SELECT Id, Recalculation_Pending__c FROM Contract WHERE Id =: contracts[1].Id];

        System.assertEquals( true , proj.Recalculation_Pending__c, 'Recalculation is pending for project');
        System.assertEquals( true , contr.Recalculation_Pending__c, 'Recalculation is pending for contract');
    }
    static testMethod void recalPendingUpdateTest() {

        List<Project__c> projects = [SELECT Id, Recalculation_Pending__c FROM Project__c];
        List<Contract> contracts = [SELECT Id, Recalculation_Pending__c FROM Contract];

        List<Id> projIds = new List<Id>();
        List<Id> conIds = new List<Id>();

        Test.startTest();
        List<Opportunity> testOpportunities = [SELECT Id, Name, AccountId, ContractId, Project__c, Amount, TotalOpportunityQuantity FROM  Opportunity];
        integer i=0;
        for(Opportunity opp: testOpportunities){
            opp.Amount = 4000;
            opp.TotalOpportunityQuantity = 250;
            if(opp.Project__c != null){

                if(i != 0){
                    opp.Project__c = projects[projects.size()-1].Id;
                    projIds.add(opp.Project__c);
                }


            }
            else if(opp.ContractId != null){

                if(i!=0){
                    opp.ContractId = contracts[0].Id;
                }
                conIds.add(opp.ContractId);
            }


            i++;
        }


        update testOpportunities;
        Test.stopTest();

        if(projIds.size() > 0){
            Project__c proj = [SELECT Id, Recalculation_Pending__c FROM Project__c WHERE Id =: projIds[0]];
            System.assertEquals( true , proj.Recalculation_Pending__c, 'Recalculation is pending for project');
        }
        if(conIds.size() > 0){
            Contract contr = [SELECT Id, Recalculation_Pending__c FROM Contract WHERE Id =: conIds[0]];
            System.assertEquals( true , contr.Recalculation_Pending__c, 'Recalculation is pending for contract');
        }
    }
    static testMethod void recalPendingDeleteTest() {

        List<Id> projIds = new List<Id>();
        List<Id> conIds = new List<Id>();

        Test.startTest();
        List<Opportunity> testOpportunities = [SELECT Id, Name, AccountId, ContractId, Project__c, Amount, TotalOpportunityQuantity FROM  Opportunity];
        for(Opportunity opp: testOpportunities){
            if(opp.Project__c != null){
                projIds.add(opp.Project__c);
            }
            else if(opp.ContractId != null){
                conIds.add(opp.ContractId);
            }
        }

        delete testOpportunities;
        Test.stopTest();

        if(projIds.size() > 0){
            Project__c proj = [SELECT Id, Recalculation_Pending__c FROM Project__c WHERE Id =: projIds[0]];
            System.assertEquals( true , proj.Recalculation_Pending__c, 'Recalculation is pending for project');
        }
        if(conIds.size() > 0){
            Contract contr = [SELECT Id, Recalculation_Pending__c FROM Contract WHERE Id =: conIds[0]];
            System.assertEquals( true , contr.Recalculation_Pending__c, 'Recalculation is pending for contract');
        }
    }
    static testMethod void recalPendingUnDeleteTest() {

        List<Id> projIds = new List<Id>();
        List<Id> conIds = new List<Id>();

        Test.startTest();
        List<Opportunity> testOpportunities = [SELECT Id, Name, AccountId, ContractId, Project__c, Amount, TotalOpportunityQuantity FROM  Opportunity];
        for(Opportunity opp: testOpportunities){
            if(opp.Project__c != null){
                projIds.add(opp.Project__c);
            }
            else if(opp.ContractId != null){
                conIds.add(opp.ContractId);
            }
        }

        delete testOpportunities;
        undelete testOpportunities;
        Test.stopTest();

        if(projIds.size() > 0){
            Project__c proj = [SELECT Id, Recalculation_Pending__c FROM Project__c WHERE Id =: projIds[0]];
            System.assertEquals( true , proj.Recalculation_Pending__c, 'Recalculation is pending for project');
        }
        if(conIds.size() > 0){
            Contract contr = [SELECT Id, Recalculation_Pending__c FROM Contract WHERE Id =: conIds[0]];
            System.assertEquals( true , contr.Recalculation_Pending__c, 'Recalculation is pending for contract');
        }
    }
}