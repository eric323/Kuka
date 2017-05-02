/***************************************************************************
Description - Test Class for RiskAssessmentExtension
***************************************************************************/
@isTest
public class RiskAssessmentExtensionTest {

    private static User testAdminUser;

    private static Account testAccount;

    private static Opportunity testOpportunity;

    private static Opportunity_Review__c testOpportunityReview;

    private static void basicSetup() {
        adminUserSetup();

        system.runAs(testAdminUser) {
            testAccount = new Account(
                Name = 'adidas AG - Germany',
                Market_Segment__c = 'Consumer Goods',
                Industry__c = 'Textiles, Shoes',
                BillingStreet = 'Adi Dassler Str. 1',
                BillingCity = 'Herzogenaurach',
                BillingPostalCode = '91074',
                BillingState = 'Bavaria',
                BillingCountry = 'Germany'
            );
            insert testAccount;

            testOpportunity = new Opportunity(
                Name = 'adidas AG - Germany',
                AccountId = testAccount.Id,
                Business_Unit__c = 'KUKA Industries',
                Industry__c = 'Textiles, Shoes',
                Market_Segment__c = 'Consumer Goods',
                Profit_Center__c = 'Technology Solutions TS',
                StageName = 'Qualify',
                CloseDate = date.today()+365
            );
            insert testOpportunity;

            testOpportunityReview = new Opportunity_Review__c(
                Opportunity__c = testOpportunity.Id,
                Pre_Assessment_Status__c = 'Required / Not Started',
                Technical_Assessment_Status__c = 'Required / Not Started',
                Export_Control_Status__c = 'Required / Not Started',
                Basic_Risk_Assessment_Status__c = 'Required / Not Started',
                Extended_Risk_Assessment_Status__c = 'Required / Not Started'
            );
            insert testOpportunityReview;
        }    
    }

    private static void dataSetupPreWithoutQuestions() {
        basicSetup();
        system.runAs(testAdminUser) {

            List<Risk_Assessment_Template__c> allPreRATs = createAssessmentTemplates('Pre-Assessment', 5, false, 'Yes/No Question');
            insert allPreRATs;
        }
    }

    private static void dataSetupPreWithQuestions() {
        basicSetup();
        system.runAs(testAdminUser) {

            List<Risk_Assessment_Question__c> allPreRAQs = createAssessmentQuestions(testOpportunityReview,'Pre-Assessment', 5, false, 'Yes/No Question');
            insert allPreRAQs;
        }
    }

    private static void dataSetupBasicWithoutQuestions() {
        basicSetup();
        system.runAs(testAdminUser) {

            List<Risk_Assessment_Template__c> allBasicRATs = createAssessmentTemplates('Basic Risk Assessment', 5, false, 'Yes/No Question');
            insert allBasicRATs;
        }
    }

    private static void dataSetupBasicWithQuestions() {
        basicSetup();
        system.runAs(testAdminUser) {

            List<Risk_Assessment_Question__c> allBasicRAQs = createAssessmentQuestions(testOpportunityReview,'Basic Risk Assessment', 5, false, 'Yes/No Question');
            insert allBasicRAQs;
        }
    }

    private static void dataSetupExtendedWithoutQuestions() {
        basicSetup();
        system.runAs(testAdminUser) {

            List<Risk_Assessment_Template__c> allExtendedRATs = createAssessmentTemplates('Extended Risk Assessment', 5, true, 'Low/Medium/High Question');
            insert allExtendedRATs;
        }
    }

    private static void dataSetupExtendedWithQuestions() {
        basicSetup();
        system.runAs(testAdminUser) {

            List<Risk_Assessment_Question__c> allExtendedRAQs = createAssessmentQuestions(testOpportunityReview,'Extended Risk Assessment', 5, true, 'Low/Medium/High Question');
            insert allExtendedRAQs;
        }
    }

    public static testMethod void testPreAssessmentWithoutQuestions() {
        dataSetupPreWithoutQuestions();
        system.debug(+testOpportunityReview);

        
        system.runAs(testAdminUser) {
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunityReview);
            PageReference pageRef = new PageReference('/apex/RiskAssessment?Id=' + testOpportunityReview.Id + '&' + 'AssessmentType=' + 'Pre');
            system.debug(+ApexPages.currentPage().getParameters().get('Id'));
            system.debug(+ApexPages.currentPage().getParameters().get('AssessmentType'));
            Test.setCurrentPage(pageRef);
            RiskAssessmentExtension controller = new RiskAssessmentExtension(sc);
            PageReference redirectedURL = controller.save();
            Test.stopTest();

            system.debug(+URL.getSalesforceBaseUrl().toExternalForm() + '/' + testOpportunityReview.id);
            system.debug(+redirectedURL);
        }

    }

    public static testMethod void testPreAssessmentWithQuestions() {
        dataSetupPreWithQuestions();
        system.debug(+testOpportunityReview);

        
        system.runAs(testAdminUser) {
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunityReview);
            PageReference pageRef = new PageReference('/apex/RiskAssessment?Id=' + testOpportunityReview.Id + '&' + 'AssessmentType=' + 'Pre');
            system.debug(+ApexPages.currentPage().getParameters().get('Id'));
            system.debug(+ApexPages.currentPage().getParameters().get('AssessmentType'));
            Test.setCurrentPage(pageRef);
            RiskAssessmentExtension controller = new RiskAssessmentExtension(sc);
            PageReference redirectedURL = controller.save();
            Test.stopTest();

            system.debug(+URL.getSalesforceBaseUrl().toExternalForm() + '/' + testOpportunityReview.id);
            system.debug(+redirectedURL);
        }

    }

    public static testMethod void testBasicRiskAssessmentWithoutQuestions() {
        dataSetupBasicWithoutQuestions();
        system.debug(+testOpportunityReview);

        
        system.runAs(testAdminUser) {
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunityReview);
            PageReference pageRef = new PageReference('/apex/RiskAssessment?Id=' + testOpportunityReview.Id + '&' + 'AssessmentType=' + 'Basic');
            system.debug(+ApexPages.currentPage().getParameters().get('Id'));
            system.debug(+ApexPages.currentPage().getParameters().get('AssessmentType'));
            Test.setCurrentPage(pageRef);
            RiskAssessmentExtension controller = new RiskAssessmentExtension(sc);
            PageReference redirectedURL = controller.save();
            Test.stopTest();

            system.debug(+URL.getSalesforceBaseUrl().toExternalForm() + '/' + testOpportunityReview.id);
            system.debug(+redirectedURL);
        }

    }

    public static testMethod void testBasicRiskAssessmentWithQuestions() {
        dataSetupBasicWithQuestions();
        system.runAs(testAdminUser) {
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunityReview);
            PageReference pageRef = new PageReference('/apex/RiskAssessment?Id=' + testOpportunityReview.Id + '&' + 'AssessmentType=' + 'Basic');
            Test.setCurrentPage(pageRef);
            RiskAssessmentExtension controller = new RiskAssessmentExtension(sc);
            PageReference redirectedURL = controller.save();
            Test.stopTest();
        }
    }

    public static testMethod void testExtendedRiskAssessmentWithoutQuestions() {
        dataSetupExtendedWithoutQuestions();
        system.runAs(testAdminUser) {
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunityReview);
            PageReference pageRef = new PageReference('/apex/RiskAssessment?Id=' + testOpportunityReview.Id + '&' + 'AssessmentType=' + 'Extended');
            Test.setCurrentPage(pageRef);
            RiskAssessmentExtension controller = new RiskAssessmentExtension(sc);
            PageReference redirectedURL = controller.save();
            Test.stopTest();
        }
    }

     public static testMethod void testExtendedRiskAssessmentWithQuestions() {
        dataSetupExtendedWithQuestions();
        system.runAs(testAdminUser) {
            Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunityReview);
            PageReference pageRef = new PageReference('/apex/RiskAssessment?Id=' + testOpportunityReview.Id + '&' + 'AssessmentType=' + 'Extended');
            Test.setCurrentPage(pageRef);
            RiskAssessmentExtension controller = new RiskAssessmentExtension(sc);
            PageReference redirectedURL = controller.save();
            Test.stopTest();
        }
    }

    private static List<Risk_Assessment_Template__c> createAssessmentTemplates (String assessmentType, Integer count, Boolean rfqController, String entityType) {
        List<Risk_Assessment_Template__c> createdRATs = new List<Risk_Assessment_Template__c>();
        for (Integer i=0; i<count; i++) {
            Risk_Assessment_Template__c RAT = new Risk_Assessment_Template__c(
                Business_Unit__c = 'KUKA Industries',
                Entry_Type__c = entityType,
                isActive__c = true,
                HelpText__c = '',
                HelpTextCN__c = '',
                HelpTextDE__c = '',
                IsFinancialRisk__c = false,
                IsRFQController__c = rfqController,
                IsSuperCriterion__c = false,
                Question__c = 'Question'+i,
                QuestionCN__c = 'Question'+i+'CN',
                QuestionDE__c = 'Question'+i+'DE',
                Question_Set__c ='',
                Risk_Assessment_Type__c = assessmentType
            ); 
            createdRATs.add(RAT);   
        }
        return createdRATs;
    }

    private static List<Risk_Assessment_Question__c> createAssessmentQuestions (Opportunity_Review__c oppReview, String assessmentType, Integer count, Boolean rfqController, String entityType) {
        List<Risk_Assessment_Question__c> createdRAQs = new List<Risk_Assessment_Question__c>();
        for (Integer i=0; i<count; i++) {
            Risk_Assessment_Question__c RAQ = new Risk_Assessment_Question__c(
                Business_Unit__c = 'KUKA Industries',
                Entry_Type__c = entityType,
                HelpText__c = '',
                HelpTextCN__c = '',
                HelpTextDE__c = '',
                IsFinancialRisk__c = false,
                IsRFQController__c = rfqController,
                IsSuperCriterion__c = false,
                Question__c = 'Question'+i,
                QuestionCN__c = 'Question'+i+'CN',
                QuestionDE__c = 'Question'+i+'DE',
                Question_Set__c ='',
                Risk_Assessment_Type__c = assessmentType,
                Opportunity_Review__c = oppReview.Id
            ); 
            createdRAQs.add(RAQ);   
        }
        return createdRAQs;
    }

    private static void adminUserSetup(){
        Id adminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        Id roleId = [SELECT Id FROM UserRole WHERE DeveloperName = 'Industries' LIMIT 1].Id;

        if (adminProfileId != null && roleId != null) {
            testAdminUser = new User(
                FirstName = 'Test',
                LastName = 'Admin',
                Country = 'Germany',
                Email = 'testadmin@kuka.com.example.com',
                LanguageLocaleKey = 'en_US',
                IsActive = true,
                LocaleSidKey = 'de_DE_EURO',
                ProfileId = adminProfileId,
                Username = 'testadmin@kuka.com.example.com',
                UserRoleId = roleId,
                Users_Legal_Entity__c = 'KUKA Industries GmbH',
                Users_Organisation__c = 'KUKA Industries',
                Users_Sales_Region__c = 'EMEA',
                EmailEncodingKey = 'ISO-8859-1',
                TimeZoneSidKey = 'Europe/Berlin',
                Alias = 'tadmin'
                );
            insert testAdminUser;
            system.debug(+testAdminUser);
        }
    }
}