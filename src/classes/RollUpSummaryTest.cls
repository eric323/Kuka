/**********************************************************************
Name:  RollUpSummaryTest
======================================================
Purpose:  Test Data setup Class for RollUpSummary functionality
======================================================
History
-------
Date        AUTHOR                          DETAIL
05/04/2017  bmohammed                  INITIAL Version
25/04/2017  Arokia Joseph              (DC-1321/ DC-1322)
*********************************************************************/

public class RollUpSummaryTest {

    private static RollUpSummaryTest instance = null;
    private RollUpSummaryTest(){
    }
    public static RollUpSummaryTest getInstance(){

        if(instance == null)
            instance = new RollUpSummaryTest();
        return instance;

    }

    public void initTestSetUp(){
        Account testAccount = new Account(  Name='Test Account',
                KUKA_Group_Key_Account__c = true,
                BillingStreet = 'Teststreet',
                BillingPostalCode = '12345',
                BillingCity = 'Test City',
                Duns__c = '123456789',
                BillingCountry = 'Germany',
                Market_Segment__c = 'Automotive',
                Industry__c = 'Auto Body Shop');

        insert testAccount;

        List<Contract> testContracts = new List<Contract>();
        for(integer i=0;i<2;i++){
            testContracts.add( new Contract(Name='Test Contract '+i,
                    AccountId=testAccount.Id,
                    StartDate=system.today(),
                    Business_Unit__c='KUKA Industries',
                    Status='Draft'));
        }
        insert testContracts;

        List<Project__c> testProjects =  new List<Project__c>();
        for(integer i=0; i<5; i++){

            if(0==math.mod(i, 2)){
                testProjects.add(new Project__c(Name='Test Project '+i, Account__c = testAccount.Id, Related_Contract__c=testContracts[0].Id));
            }
            else{
                testProjects.add(new Project__c(Name='Test Project '+i, Account__c = testAccount.Id));
            }

        }
        insert testProjects;

        List<Opportunity> testOpportunities = new List<Opportunity>();
        for(integer i=0; i<10; i++){
            if(0==math.mod(i, 2)){
                testOpportunities.add(new Opportunity(Name = 'Test Opportunity '+i,
                        AccountId = testAccount.Id,
                        CloseDate = System.today()+5,
                        Business_Unit__c = 'KUKA Industries',
                        Market_Segment__c = 'Automotive',
                        Industry__c = 'Auto Body Shop',
                        Profit_Center__c = 'Advanced Welding Solutions AWS',
                        StageName='Propose',
                        Project__c = testProjects[0].Id,
                        amount = 3000,
                        TotalOpportunityQuantity = 30));
            }
            else{
                if(i==3){
                    testOpportunities.add(new Opportunity(Name = 'Test Opportunity '+i,
                            AccountId = testAccount.Id,
                            CloseDate = System.today()+5,
                            Business_Unit__c = 'KUKA Industries',
                            Market_Segment__c = 'Automotive',
                            Industry__c = 'Auto Body Shop',
                            Profit_Center__c = 'Advanced Welding Solutions AWS',
                            StageName='Propose',
                            Project__c = testProjects[1].Id,
                            ContractId = testContracts[1].Id,
                            amount = 2890,
                            TotalOpportunityQuantity = 600));
                }
                else{
                    testOpportunities.add(new Opportunity(Name = 'Test Opportunity '+i,
                            AccountId = testAccount.Id,
                            CloseDate = System.today()+5,
                            Business_Unit__c = 'KUKA Industries',
                            Market_Segment__c = 'Automotive',
                            Industry__c = 'Auto Body Shop',
                            Profit_Center__c = 'Advanced Welding Solutions AWS',
                            StageName='Propose',
                            ContractId = testContracts[1].Id,
                            amount = 2890,
                            TotalOpportunityQuantity = 600));
                }
            }

        }
        for(integer i=10; i<15; i++){
            if(0==math.mod(i, 2)){
                testOpportunities.add(new Opportunity(Name = 'Test Opportunity '+i,
                        AccountId = testAccount.Id,
                        CloseDate = System.today()+5,
                        Business_Unit__c = 'KUKA Industries',
                        Market_Segment__c = 'Automotive',
                        Industry__c = 'Auto Body Shop',
                        Profit_Center__c = 'Advanced Welding Solutions AWS',
                        StageName='Closed Won',
                        Project__c = testProjects[0].Id,
                        amount = 3000,
                        TotalOpportunityQuantity = 30));
            }
            else{
                testOpportunities.add(new Opportunity(Name = 'Test Opportunity '+i,
                        AccountId = testAccount.Id,
                        CloseDate = System.today()+5,
                        Business_Unit__c = 'KUKA Industries',
                        Market_Segment__c = 'Automotive',
                        Industry__c = 'Auto Body Shop',
                        Profit_Center__c = 'Advanced Welding Solutions AWS',
                        StageName='Closed Won',
                        ContractId = testContracts[1].Id,
                        amount = 2890,
                        TotalOpportunityQuantity = 600));
            }

        }
        insert testOpportunities;
    }
}