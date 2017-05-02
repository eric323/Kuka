/**
* Description - This apex class is test class for APTSSP_QuoteProposalTriggerHandler and APTSSP_QuoteProposalTriggerHelper.
* Created By - Mausam Padhiyar
* Created Date - 16th Feb, 2017
*/
@isTest
private class APTSSP_QuoteProposalTriggerHandlerTest {
    static testMethod void testMethod1() {
        
        //product
        Product2 testProduct = APTSMD_testUtils.getproduct();
        //insert testProduct;
        
        //price list
        Apttus_Config2__PriceList__c testPriceList = APTSMD_testUtils.getPriceList();
        
        //price list item
        Apttus_Config2__PriceListItem__c testPLI = APTSMD_testUtils.getPriceListItem(testProduct, testPriceList);
        
        //account
        Account testAccount = APTSMD_testUtils.getAccount();
        
        //contact
        Contact testContact = APTSMD_testUtils.getContact(testAccount);
        testContact.FirstName = 'Guest';
        testContact.LastName = 'User';
        update testContact;
        
        //opportunity
        opportunity testOpportunity = APTSMD_testUtils.getOpportunity(testAccount);
        
        //proposal
        Apttus_Proposal__Proposal__c testProposal = APTSMD_testUtils.getProposal(testAccount, testOpportunity, testPriceList);
        
        list<Apttus_Proposal__Proposal__c> newProposalList = new list<Apttus_Proposal__Proposal__c>();
        newProposalList.add(testProposal);
        
        APTSSP_QuoteProposalTriggerHandler controller = new APTSSP_QuoteProposalTriggerHandler();
        
        test.startTest();
        
        controller.onBeforeInsert(newProposalList);
        
        list<opportunity> listOpportunity = [SELECT Id FROM Opportunity WHERE accountId =: testAccount.Id];
        system.assert(listOpportunity != null);
        
        test.stopTest();
    }
    
    static testMethod void testMethod2() {
        
        //product
        Product2 testProduct = APTSMD_testUtils.getproduct();
        //insert testProduct;
        
        //price list
        Apttus_Config2__PriceList__c testPriceList = APTSMD_testUtils.getPriceList();
        
        //price list item
        Apttus_Config2__PriceListItem__c testPLI = APTSMD_testUtils.getPriceListItem(testProduct, testPriceList);
        
        //account
        Account testAccount = APTSMD_testUtils.getAccount();
        
        //contact
        Contact testContact = APTSMD_testUtils.getContact(testAccount);
        testContact.FirstName = 'Guest';
        testContact.LastName = 'User';
        update testContact;
        
        //opportunity
        opportunity testOpportunity = APTSMD_testUtils.getOpportunity(testAccount);
        
        //proposal
        Apttus_Proposal__Proposal__c testProposal = APTSMD_testUtils.getProposal(testAccount, testOpportunity, testPriceList);
        testProposal.Apttus_Proposal__Opportunity__c =null;
        update testProposal;
        
        list<Apttus_Proposal__Proposal__c> newProposalList = new list<Apttus_Proposal__Proposal__c>();
        newProposalList.add(testProposal);
        
        APTSSP_QuoteProposalTriggerHandler controller = new APTSSP_QuoteProposalTriggerHandler();
        
        test.startTest();
        
        controller.onBeforeInsert(newProposalList);
        
        list<opportunity> listOpportunity = [SELECT Id FROM Opportunity WHERE accountId =: testAccount.Id];
        system.assert(listOpportunity != null);
        
        test.stopTest();
    }
    
    static testMethod void testMethod3() {
        
        //product
        Product2 testProduct = APTSMD_testUtils.getproduct();
        //insert testProduct;
        
        //price list
        Apttus_Config2__PriceList__c testPriceList = APTSMD_testUtils.getPriceList();
        
        //price list item
        Apttus_Config2__PriceListItem__c testPLI = APTSMD_testUtils.getPriceListItem(testProduct, testPriceList);
        
        //account
        Account testAccount = APTSMD_testUtils.getAccount();
        
        //contact
        Contact testContact = APTSMD_testUtils.getContact(testAccount);
        testContact.FirstName = 'Guest';
        testContact.LastName = 'User';
        update testContact;
    
        //opportunity
        opportunity testOpportunity = APTSMD_testUtils.getOpportunity(testAccount);
        
        //proposal
        Apttus_Proposal__Proposal__c testProposal = APTSMD_testUtils.getProposal(testAccount, testOpportunity, testPriceList);
        testProposal.Apttus_Proposal__Account__c = null;
        update testProposal;
        
        list<Apttus_Proposal__Proposal__c> newProposalList = new list<Apttus_Proposal__Proposal__c>();
        newProposalList.add(testProposal);
        
        APTSSP_QuoteProposalTriggerHandler controller = new APTSSP_QuoteProposalTriggerHandler();
        
        test.startTest();
        
        controller.onBeforeInsert(newProposalList);
        
        list<opportunity> listOpportunity = [SELECT Id FROM Opportunity WHERE accountId =: testAccount.Id];
        system.assert(listOpportunity != null);
        
        test.stopTest();
    }
    
    /**
    static testMethod void testMethod4() {
        
        //product
        Product2 testProduct = APTSMD_testUtils.getproduct();
        //insert testProduct;
        
        //price list
        Apttus_Config2__PriceList__c testPriceList = APTSMD_testUtils.getPriceList();
        
        //price list item
        Apttus_Config2__PriceListItem__c testPLI = APTSMD_testUtils.getPriceListItem(testProduct, testPriceList);
        
        //account
        Account testAccount = APTSMD_testUtils.getAccount();
        
        //contact
        Contact testContact = APTSMD_testUtils.getContact(testAccount);
        testContact.FirstName = 'Guest';
        testContact.LastName = 'User';
        update testContact;
    
        //opportunity
        opportunity testOpportunity = APTSMD_testUtils.getOpportunity(testAccount);
        
        //proposal
        Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c();
        testProposal.Apttus_Proposal__Account__c = testAccount.Id;
        testProposal.Apttus_Proposal__Proposal_Name__c = testOpportunity.Name;
        testProposal.Apttus_Proposal__Opportunity__c = testOpportunity.Id;
        testProposal.Apttus_QPConfig__PriceListId__c = testPriceList.Id;
        testProposal.Apttus_Proposal__ExpectedStartDate__c = Date.today();
        testProposal.Apttus_Proposal__ExpectedEndDate__c = Date.today().addMonths(12);
        insert testProposal;
        
        list<Apttus_Proposal__Proposal__c> newProposalList = new list<Apttus_Proposal__Proposal__c>();
        newProposalList.add(testProposal);
        
        APTSSP_QuoteProposalTriggerHandler controller = new APTSSP_QuoteProposalTriggerHandler();
        
        test.startTest();
        
        controller.onBeforeInsert(newProposalList);
        
        test.stopTest();
    }
    **/
    
}