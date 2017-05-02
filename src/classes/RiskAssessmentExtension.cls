/*********************************************************
Description - Extension Controller for RiskAssessment page
*********************************************************/
public class RiskAssessmentExtension {

    private static final String PREASSESSMENTTYPE = 'Pre-Assessment';

    private static final String BASICASSESSMENTTYPE = 'Basic Risk Assessment';

    private static final String EXTENDEDASSESSMENTTYPE = 'Extended Risk Assessment';

    public Boolean isPreAssessment {get;set;}

    public Boolean isBasicAssessment {get;set;}

    public Boolean isExtendedAssessment {get;set;}

    public Boolean isUpdate = false;

    public Boolean goAhead {get;set;}

    public static String ASSESSMENTTYPE = '';

    public Opportunity_Review__c currentOpportunityReviewRecord {get;set;}

    public List<Risk_Assessment_Template__c> allTemplateQuestions {get;set;}

    public List<Risk_Assessment_Question__c> allRAQs {get;set;}

    public List<Risk_Assessment_Question__c> oldRAQs = new List<Risk_Assessment_Question__c>();

    public Map<Id, Risk_Assessment_Question__c> oldRAQsMap = new Map<Id, Risk_Assessment_Question__c>();

    public User currentUser {get;set;}

    public User deligatedApprover {get;set;}

    public User currentOppOwner {get;set;}

    public User approverLevelB {get;set;}

    /*********************************************************
        Constructor - Fetch details of Opportunity Review Record
        Constructor - Call method to fetch Assessment Questions based on Assessment Type
    *********************************************************/
    public RiskAssessmentExtension(ApexPages.StandardController controller) {
        ASSESSMENTTYPE = ApexPages.currentPage().getParameters().get('AssessmentType');
        system.debug('ASSESSMENT TYPE-----' +ASSESSMENTTYPE);



        currentUser = getUserDetails(UserInfo.getUserId());
        system.debug('User Details ----->' +currentUser);

        goAhead = true;

        currentOpportunityReviewRecord = [SELECT
                                              Id,
                                              KUKA_subgroup__c,
                                              Question_Set__c,
                                              Question_Language__c,
                                              Opportunity__r.OwnerId,
                                              Approver_Level_B__c
                                          FROM
                                              Opportunity_Review__c
                                          WHERE
                                              Id = :ApexPages.currentPage().getParameters().get('Id')
                                          ];

        currentOppOwner = getUserDetails(currentOpportunityReviewRecord.Opportunity__r.OwnerId);
        system.debug('Owner Details ----->' +currentOppOwner);

        if (currentOpportunityReviewRecord.Approver_Level_B__c != null) {
            approverLevelB = getUserDetails(currentOpportunityReviewRecord.Approver_Level_B__c);
            system.debug(' Approver Level B Details ----->' +approverLevelB);

            If (approverLevelB.DelegatedApproverId != null) {
                deligatedApprover = getUserDetails(approverLevelB.DelegatedApproverId);
                system.debug(' Deligated Details ----->' +deligatedApprover);
            }
        }
            
        if (ASSESSMENTTYPE != '') {
            if (PREASSESSMENTTYPE.contains(ASSESSMENTTYPE)) {
                isPreAssessment = true;
                getAllAssessmentQuestions(PREASSESSMENTTYPE);      
            } else if (BASICASSESSMENTTYPE.contains(ASSESSMENTTYPE)) {
                isBasicAssessment = true;
                getAllAssessmentQuestions(BASICASSESSMENTTYPE);    
            } else if (EXTENDEDASSESSMENTTYPE.contains(ASSESSMENTTYPE)) {
                isExtendedAssessment = true;
                getAllAssessmentQuestions(EXTENDEDASSESSMENTTYPE); 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.Risk_Assessment_Page_Warning_Message));
            }
        }
        
    }

    /*********************************************************
        Method being used to Fetch all Assessment Questions based on Assessment Type
    *********************************************************/
    public void getAllAssessmentQuestions(String assessType) {
        //Step 1 - Fetch all existing Assessment Questions related to Opportunity Review
        allRAQs = getAssessmentQuestions(assessType, currentOpportunityReviewRecord);
        system.debug('Step 1 --->' +allRAQs);



        if (!allRAQs.isEmpty()) {
                isUpdate = true;
        } else {
                system.debug('User Details ----->' +currentOppOwner);
                //Step 2 - Fetch all Template Questions based on provided Question Set in Opp Review
            if (currentOppOwner.CountryCode != null || String.isBlank(currentOppOwner.CountryCode)) {
                system.debug('I am in Step 2');
                allTemplateQuestions = getTemplateQuestions(assessType, currentOpportunityReviewRecord.KUKA_subgroup__c,currentOppOwner.CountryCode);       
                system.debug('Step 2 ---->' +allTemplateQuestions);
            } 
            system.debug('With Country Value------> ' +allTemplateQuestions);

            //Step 3 - Fetch all Template Questions Where Question Set is blank
            if (allTemplateQuestions.isEmpty()){
                system.debug('I am in Step 3');
                allTemplateQuestions = getTemplateQuestions(assessType, currentOpportunityReviewRecord.KUKA_subgroup__c, '');   
                system.debug('Step 3 ---->' +allTemplateQuestions);
            }
                        system.debug('Without Country Value-----> ' +allTemplateQuestions);

                        //Step 4 - Map all Template Questions to Assessment Questions
            if (!allTemplateQuestions.isEmpty()){
                for (Risk_Assessment_Template__c rst:allTemplateQuestions) {
                    Risk_Assessment_Question__c rsq = new Risk_Assessment_Question__c();
                    rsq.Sequence_Number__c = rst.Sequence_Number__c;
                    rsq.Question__c = rst.Question__c;
                    rsq.Entry_Type__c = rst.Entry_Type__c;
                    rsq.Question_Value__c = rst.Question_Value__c;
                    rsq.Risk_Assessment_Type__c = rst.Risk_Assessment_Type__c;
                    rsq.Business_Unit__c = rst.Business_Unit__c;
                    rsq.Opportunity_Review__c = currentOpportunityReviewRecord.Id;
                    rsq.QuestionCN__c = rst.QuestionCN__c;
                    rsq.QuestionDE__c = rst.QuestionDE__c;
                    rsq.HelpText__c = rst.HelpText__c;
                    rsq.HelpTextCN__c = rst.HelpTextCN__c;
                    rsq.HelpTextDE__c = rst.HelpTextDE__c;
                    rsq.Question_Approval_Level__c = rst.Question_Approval_Level__c;
                    rsq.Question_Set__c = rst.Question_Set__c;
                    rsq.isSuperCriterion__c = rst.isSuperCriterion__c;
                    rsq.isFinancialRisk__c = rst.isFinancialRisk__c;
                    rsq.isRFQController__c = rst.isRFQController__c;
                    allRAQs.add(rsq);
                }
            }           
        } 
    }

    /*********************************************************
        Method being used to Insert/Update Assessment Questions
    *********************************************************/
    public PageReference save(){
        Savepoint sp = Database.setSavepoint();
        String tempAssessType = ApexPages.currentPage().getParameters().get('AssessmentType');
        if (EXTENDEDASSESSMENTTYPE.contains(tempAssessType)) {
            oldRAQs = getAssessmentQuestions(EXTENDEDASSESSMENTTYPE, currentOpportunityReviewRecord);
        }
        system.debug('old questions' +oldRAQs);
        for (Risk_Assessment_Question__c raq:oldRAQs) {
            oldRAQsMap.put(raq.Id, raq);
        }
        system.debug(+oldRAQsMap);
        try {
            system.debug('Go Ahead' +goAhead);
            goAhead = true;
            Boolean isAccessable = true;
            for (Risk_Assessment_Question__c rsq:allRAQs) {
                system.debug('Go Ahead' +goAhead);
                if (goAhead == true && rsq.Entry_Type__c == 'Low/Medium/High Question') {
                    if (rsq.isRFQController__c == true) {
                        if (approverLevelB == null ){
                            //goAhead = false;
                            isAccessable = false;
                        } else {
                            if (deligatedApprover != null) {
                                if (currentUser.Id != approverLevelB.Id && currentUser.Id != deligatedApprover.Id) {
                                    isAccessable = false;
                                }
                            } else if (deligatedApprover == null) {
                                if (currentUser.Id != approverLevelB.Id) {
                                    isAccessable = false;
                                }
                            } 
                        }
                        system.debug('I am inside Loop----->'+isAccessable+'----->'+rsq);
                        system.debug('------->'+goAhead);
                        if (isAccessable == false && rsq.Entry_Type__c == 'Low/Medium/High Question' && rsq.Risk_Assessment_Type__c == 'Extended Risk Assessment') {
                            system.debug('I am inside first condition');
                            if (isUpdate == false ) {
                                system.debug('inside Insert');
                                if (rsq.AnswerLowMediumHigh__c != null || rsq.Remark__c != '' || rsq.Financial_Risk__c != null) {
                                    goAhead = false;
                                }
                            } else if (isUpdate == true ) {
                                if(oldRAQsMap.get(rsq.Id).Remark__c == null) {
                                    oldRAQsMap.get(rsq.Id).Remark__c = '';
                                }
                                if (rsq.AnswerLowMediumHigh__c != oldRAQsMap.get(rsq.Id).AnswerLowMediumHigh__c 
                                    || rsq.Remark__c != oldRAQsMap.get(rsq.Id).Remark__c  
                                    || rsq.Financial_Risk__c != oldRAQsMap.get(rsq.Id).Financial_Risk__c) {
                                    goAhead = false;
                                }    
                            }
                        }
                    }
                }

            }
            
            system.debug('Go Ahead' +goAhead);
            if (goAhead == false) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Risk_Assessment_Page_Error_Message));
                return null;
            }else {
                if (isUpdate == false) {
                    insert allRAQs;
                    return getSuccessURL();
                } else {
                    
                    update allRAQs;
                    return getSuccessURL();
                } 
            }      
        } catch(Exception e) {
            Database.rollback(sp);      
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        } 
        
    }

    /*********************************************************
        Method being used to get Success URL
    *********************************************************/
    public PageReference getSuccessURL() {
        PageReference pageRef;

            String retURL = ApexPages.currentPage().getParameters().get('retURL');
            // If retURL doesn't exist, simply return to parent record
            if (String.isBlank(retURL)) {
                pageRef = new ApexPages.StandardController(currentOpportunityReviewRecord).view();
            } else {
                pageRef = new PageReference(retURL);
            }
            
            pageRef.setRedirect(true);
            return pageRef;
    }

    /*********************************************************
        Method being used to rerender sections in page based on Assessment Questions
    *********************************************************/
    public Boolean getHasQuestions(){
        return !allRAQs.isEmpty();
    }

    /*********************************************************
        Method being used to return List of Assessment Questions
    *********************************************************/
    public List<Risk_Assessment_Question__c> getAssessmentQuestions(String assessType, Opportunity_Review__c currentORRecord){
        List<Risk_Assessment_Question__c> tempList = new List<Risk_Assessment_Question__c>();
        tempList = [SELECT 
                    Id,
                    Sequence_Number__c,
                    Question__c, 
                    Business_Unit__c,
                    AnswerYesNo__c, 
                    AnswerYesNoUnknown__c,
                    Question_Value__c,
                    AnswerLowMediumHigh__c,
                    Remark__c,
                    Financial_Risk__c,
                    Entry_Type__c,
                    QuestionCN__c,
                    QuestionDE__c,
                    HelpText__c,
                    HelpTextCN__c,
                    HelpTextDE__c,
                    Question_Approval_Level__c,
                    Risk_Assessment_Type__c,
                    Question_Set__c,
                    isSuperCriterion__c,
                    isRFQController__c,
                    isFinancialRisk__c
                FROM 
                    Risk_Assessment_Question__c 
                WHERE 
                    Opportunity_Review__c  = :currentOpportunityReviewRecord.Id
                AND   
                    Risk_Assessment_Type__c = :assessType
                AND
                    Business_Unit__c = :currentOpportunityReviewRecord.KUKA_subgroup__c
                ORDER BY 
                    Sequence_Number__c ASC NULLS FIRST]; 
        return tempList;      
    }

    /*********************************************************
        Method being used to return Template Questions
    *********************************************************/
    public List<Risk_Assessment_Template__c> getTemplateQuestions(String assessType, String subGroup, String questionSet) {
        system.debug('Method Values -->' +assessType +'--->' +subGroup +'--->' +questionSet);
        return [SELECT 
                    Id,
                    Sequence_Number__c,
                    Business_Unit__c,
                    Question__c, 
                    Entry_Type__c, 
                    Risk_Assessment_Type__c,
                    QuestionCN__c,
                    QuestionDE__c,
                    HelpText__c,
                    HelpTextCN__c,
                    HelpTextDE__c,
                    Question_Value__c,
                    Question_Approval_Level__c,
                    Question_Set__c,
                    isRFQController__c,
                    isSuperCriterion__c,
                    isFinancialRisk__c
                FROM 
                    Risk_Assessment_Template__c 
                WHERE 
                    isActive__c = true
                AND
                    Risk_Assessment_Type__c = :assessType
                AND
                    Business_Unit__c = :subGroup
                AND
                    Question_Set__c = :questionSet
                ORDER BY 
                    Sequence_Number__c 
                ASC NULLS FIRST];       
    } 

    /*********************************************************
        Method being used to fetch Current User details
    *********************************************************/
    public User getUserDetails(Id userId){
        User userDetails = new User();
        userDetails =  [SELECT
                            Id,
                            Country,
                            CountryCode,
                            LanguageLocaleKey,
                            LocaleSidKey,
                            DelegatedApproverId
                        FROM
                            User
                        WHERE
                            Id = :userId];
        return userDetails;
    }
}