@isTest
public class OpportunityReviewTriggerHandlerTest {

    private static User testAdminUser;

    private static Account testAccount;

    private static Opportunity testOpportunity;

    private static Opportunity_Review__c testOpportunityReview;

    private static List<User> allUsers;

    private static final String APPROVALTYPE1 = 'Risk Assessment';

    private static final String APPROVALTYPE2 = 'Pre-Assessment';

    private static final String APPROVALTYPE3 = 'Export Control';

    private static final String APPROVALTYPE4 = 'Technical Assessment';

    private static final String TECHNICALAPPROVALTYPE1 = 'Welding';

    private static final String TECHNICALAPPROVALTYPE2 = 'Geometrical';

    private static final String TECHNICALAPPROVALTYPE3 = 'Technical';

    private static final String GLCAPPROVERTYPE1 = 'GLC';

    private static final String GLCAPPROVERTYPE2 = 'GLC Deputy';

    private static final String GLCAPPROVERTYPE3 = 'GLC Local';

    private static final String GLCAPPROVERTYPE4 = 'GLC Profit Center';    

    private static final String APPROVALLEVELA = 'A';

    private static final String APPROVALLEVELB = 'B';

    private static final String APPROVALLEVELC = 'C';

    private static final String APPROVALLEVELD = 'D';

    private static void basicSetup() {
        adminUserSetup();
        createUsers(10);
        for(User u:allUsers) {
            system.debug(+u);   
        }
        createApprovers();
    }

    private static void dataSetup() {
       
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        //system.runAs(thisUser) {
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
                Approver_Level_A__c = allUsers[0].Id
            );
            system.debug('Approver Details-----' + testOpportunityReview.Approver_Level_A__c);
            insert testOpportunityReview;
            
        }    
    }

    private static void createApprovers(){
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runAs(thisUser) {
            createApprover (APPROVALTYPE1, APPROVALLEVELA, '', '', '', allUsers[0]);
            createApprover (APPROVALTYPE1, APPROVALLEVELB, '', '', '', allUsers[1]);
            createApprover (APPROVALTYPE1, APPROVALLEVELC, '', 'Approver 1', '', allUsers[2]);
            createApprover (APPROVALTYPE1, APPROVALLEVELC, '', 'Approver 2', '', allUsers[3]);
            createApprover (APPROVALTYPE1, APPROVALLEVELD, '', 'Approver 1', '', allUsers[4]);
            createApprover (APPROVALTYPE1, APPROVALLEVELD, '', 'Approver 2', '', allUsers[5]);

            createApprover (APPROVALTYPE2, '', GLCAPPROVERTYPE1, '', '', allUsers[0]);
            createApprover (APPROVALTYPE2, '', GLCAPPROVERTYPE2, '', '', allUsers[1]);
            createApprover (APPROVALTYPE2, '', GLCAPPROVERTYPE3, '', '', allUsers[2]);
            createApprover (APPROVALTYPE2, '', GLCAPPROVERTYPE4, '', '', allUsers[3]);

            createApprover (APPROVALTYPE3, '', '', '', '', allUsers[0]);

            createApprover (APPROVALTYPE4, '', '', '', TECHNICALAPPROVALTYPE1, allUsers[0]);
            createApprover (APPROVALTYPE4, '', '', '', TECHNICALAPPROVALTYPE1, allUsers[1]);
            createApprover (APPROVALTYPE4, '', '', '', TECHNICALAPPROVALTYPE1, allUsers[2]);
            createApprover (APPROVALTYPE4, '', '', '', TECHNICALAPPROVALTYPE2, allUsers[3]);
            createApprover (APPROVALTYPE4, '', '', '', TECHNICALAPPROVALTYPE2, allUsers[4]);
            createApprover (APPROVALTYPE4, '', '', '', TECHNICALAPPROVALTYPE3, allUsers[5]);
            createApprover (APPROVALTYPE4, '', '', '', TECHNICALAPPROVALTYPE3, allUsers[6]);
 
        }
    }

    public static testMethod void testAssignApproversOnInsert () {
        basicSetup();
        dataSetup();
        system.debug(+testOpportunityReview);
    }

    
    private static void createApprover (String appType, String appLevel, String glcType, String levelCD, String technicalType, User approver) {
        Opportunity_Approver__c opa = new Opportunity_Approver__c(
            Approval_Level__c = appLevel,
            Approval_Type__c = appType,
            Approver__c = approver.Id,
            Business_Unit__c = 'KUKA Industries',
            Legal_Entity__c = 'KUKA Industries GmbH',
            Profit_Center__c = 'Technology Solutions TS',
            GLC_Approver_Type__c = glcType,
            Level_C_or_D_Approvers_1_or_2__c = levelCD,
            Technical_Approver_Type__c = technicalType
        );
        insert opa;
    }

    private static void createUsers (Integer count) {
        Id adminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        Id roleId = [SELECT Id FROM UserRole WHERE DeveloperName = 'Industries' LIMIT 1].Id;
        allUsers = new List<User>();

        if (adminProfileId != null && roleId != null) {
            for (Integer i=0; i<count; i++) {
                User testApprover = new User(
                    FirstName = 'Test',
                    LastName = 'Approver'+i,
                    Country = 'Germany',
                    Email = 'testapprover'+i+'@kuka.com.example.com',
                    LanguageLocaleKey = 'en_US',
                    IsActive = true,
                    LocaleSidKey = 'de_DE_EURO',
                    ProfileId = adminProfileId,
                    Username = 'testapprover'+i+'@kuka.com.example.com',
                    UserRoleId = roleId,
                    Users_Legal_Entity__c = 'KUKA Industries GmbH',
                    Users_Organisation__c = 'KUKA Industries',
                    Users_Sales_Region__c = 'EMEA',
                    EmailEncodingKey = 'ISO-8859-1',
                    TimeZoneSidKey = 'Europe/Berlin',
                    Alias = 'tapr'+i
                );
                system.debug(+testapprover);
                allUsers.add(testApprover);
            }
            system.debug(+allUsers);
        }
        insert allUsers;
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