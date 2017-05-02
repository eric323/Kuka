/**
 * Created by bmohammed on 06/04/2017.
 */

@IsTest
private class ProjectRollUpTriggerHelperTest {

    public static RollUpSummaryTest testHandler = RollUpSummaryTest.getInstance();
    @testSetup static void testSetup() {
        testHandler.initTestSetUp();

    }

    static testMethod void recalInsertTest() {
        List<Account> accounts = [SELECT Id FROM Account];
        List<Contract> contracts = [SELECT Id, Recalculation_Pending__c FROM Contract];

        List<Project__c> testProjects =  new List<Project__c>();
        Test.startTest();
        for(integer i=0; i<5; i++){
            testProjects.add(new Project__c(Name='Test Project '+i, Account__c = accounts[0].Id, Related_Contract__c=contracts[0].Id, Amount_in_Pipeline__c=300, Amount_Won__c=3000, Quantity_in_Pipeline__c=20, Quantity_Won__c = 30));
        }

        insert testProjects;
        Test.stopTest();

        Contract contr = [SELECT Id, Recalculation_Pending__c FROM Contract WHERE Id =: contracts[0].Id];

        System.assertEquals( true , contr.Recalculation_Pending__c, 'Recalculation is pending for contract');

    }
    static testMethod void recalUpdateTest() {
        List<Account> accounts = [SELECT Id FROM Account];
        List<Contract> contracts = [SELECT Id, Recalculation_Pending__c FROM Contract];

        List<Project__c> testProjects =  new List<Project__c>();
        Test.startTest();
        for(Project__c pro: [SELECT Id, Related_Contract__c, Recalculation_Pending__c FROM Project__c]){
            if(pro.Related_Contract__c != null && pro.Related_Contract__c == contracts[0].Id){
                pro.Related_Contract__c = contracts[1].Id;
            }
            else{
                pro.Related_Contract__c = contracts[0].Id;
            }
            pro.Recalculation_Pending__c =  true;

            testProjects.add(pro);
        }

        update testProjects;
        Test.stopTest();

        Contract contr = [SELECT Id, Recalculation_Pending__c FROM Contract WHERE Id =: contracts[0].Id];

        System.assertEquals( true , contr.Recalculation_Pending__c, 'Recalculation is pending for contract');

    }
    static testMethod void recalDeleteTest() {
        List<Account> accounts = [SELECT Id FROM Account];
        List<Contract> contracts = [SELECT Id, Recalculation_Pending__c FROM Contract];

        List<Project__c> testProjects =  new List<Project__c>();
        Test.startTest();
        for(Project__c pro: [SELECT Id, Related_Contract__c, Recalculation_Pending__c FROM Project__c]){
            if(pro.Related_Contract__c != null && pro.Related_Contract__c == contracts[0].Id){
                pro.Related_Contract__c = contracts[1].Id;
            }
            else{
                pro.Related_Contract__c = contracts[0].Id;
            }
            pro.Recalculation_Pending__c =  true;

            testProjects.add(pro);
        }

        delete testProjects;
        Test.stopTest();

        Contract contr = [SELECT Id, Recalculation_Pending__c FROM Contract WHERE Id =: contracts[0].Id];

        System.assertEquals( true , contr.Recalculation_Pending__c, 'Recalculation is pending for contract');

    }
    static testMethod void recalUnDeleteTest() {
        List<Account> accounts = [SELECT Id FROM Account];
        List<Contract> contracts = [SELECT Id, Recalculation_Pending__c FROM Contract];

        List<Project__c> testProjects =  new List<Project__c>();
        Test.startTest();
        for(Project__c pro: [SELECT Id, Related_Contract__c, Recalculation_Pending__c FROM Project__c]){
            if(pro.Related_Contract__c != null && pro.Related_Contract__c == contracts[0].Id){
                pro.Related_Contract__c = contracts[1].Id;
            }
            else{
                pro.Related_Contract__c = contracts[0].Id;
            }
            pro.Recalculation_Pending__c =  true;

            testProjects.add(pro);
        }

        delete testProjects;
        undelete testProjects;
        Test.stopTest();

        Contract contr = [SELECT Id, Recalculation_Pending__c FROM Contract WHERE Id =: contracts[0].Id];

        System.assertEquals( true , contr.Recalculation_Pending__c, 'Recalculation is pending for contract');

    }
}