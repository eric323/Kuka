public class RiskAssessment {

    public static List<RiskAssessmentQuestion__c> displayRATs(id oppId, string RiskAssessmentType, string BusinessUnit){
        List<RiskAssessmentQuestion__c> raqs = new List<RiskAssessmentQuestion__c>();
        RiskAssessmentQuestion__c raq = new RiskAssessmentQuestion__c();

        for (RiskAssessmentTemplate__c rat : [SELECT Business_Unit__c,
                Id,
                isActive__c,
                IsDeleted,
                isLowMediumHigh__c,
                isNumericResult__c,
                isYesNo__c,
                Question_Approval_Level__c,
                Question__c,
                Risk_Assessment_Type__c,
                Sequence_Number__c
              FROM RiskAssessmentTemplate__c 
              WHERE isActive__c = True
              AND IsDeleted = False
              AND Business_Unit__c = :BusinessUnit 
              AND Risk_Assessment_Type__c = :RiskAssessmentType
              ORDER BY Sequence_Number__c ASC NULLS FIRST]){
            System.debug(rat.Question__c);
                
            raq = new RiskAssessmentQuestion__c();
            raq.Business_Unit__c = rat.Business_Unit__c;
            raq.isLowMediumHigh__c = rat.isLowMediumHigh__c;
            raq.isNumericResult__c = rat.isNumericResult__c;
            raq.isYesNo__c = rat.isYesNo__c;
            raq.Question_Approval_Level__c = rat.Question_Approval_Level__c;
            raq.Question__c = rat.Question__c;
            raq.Risk_Assessment_Type__c = rat.Risk_Assessment_Type__c;
            raq.Sequence_Number__c = rat.Sequence_Number__c;
            raq.Opportunity__c = oppId;

            raqs.add(raq);
            System.debug(raq.Question__c);
        }
        return raqs;
    }
    

        public static void createRAQs(id oppId, string RiskAssessmentType, string BusinessUnit){
        List<RiskAssessmentQuestion__c> raqs = new List<RiskAssessmentQuestion__c>();
        RiskAssessmentQuestion__c raq = new RiskAssessmentQuestion__c();

        for (RiskAssessmentTemplate__c rat : [SELECT Business_Unit__c,
                Id,
                isActive__c,
                IsDeleted,
                isLowMediumHigh__c,
                isNumericResult__c,
                isYesNo__c,
                Question_Approval_Level__c,
                Question__c,
                Risk_Assessment_Type__c,
                Sequence_Number__c
              FROM RiskAssessmentTemplate__c 
              WHERE isActive__c = True
              AND IsDeleted = False
              AND Business_Unit__c = :BusinessUnit 
              AND Risk_Assessment_Type__c = :RiskAssessmentType
              ORDER BY Sequence_Number__c ASC NULLS FIRST]){
            System.debug(rat.Question__c);
                
            raq = new RiskAssessmentQuestion__c();
            raq.Business_Unit__c = rat.Business_Unit__c;
            raq.isLowMediumHigh__c = rat.isLowMediumHigh__c;
            raq.isNumericResult__c = rat.isNumericResult__c;
            raq.isYesNo__c = rat.isYesNo__c;
            raq.Question_Approval_Level__c = rat.Question_Approval_Level__c;
            raq.Question__c = rat.Question__c;
            raq.Risk_Assessment_Type__c = rat.Risk_Assessment_Type__c;
            raq.Sequence_Number__c = rat.Sequence_Number__c;
            raq.Opportunity__c = oppId;

            raqs.add(raq);
            System.debug(raq.Question__c);
        }
        insert(raqs);
    }


    public static boolean hasQuickAssessmentQuestions(id oppId){
        if([SELECT count() FROM RiskAssessmentQuestion__c 
            WHERE Risk_Assessment_Type__c = 'Quick Assessment'
            AND Opportunity__c = :oppId] == 0){
                return False;
        }
        else{
            return True;
        }
    }

    public static boolean hasBasicAssessmentQuestions(id oppId){
        if([SELECT count() FROM RiskAssessmentQuestion__c 
            WHERE Risk_Assessment_Type__c = 'Basic Assessment'
            AND Opportunity__c = :oppId] == 0){
                return False;
        }
        else{
            return True;
        }
    }

    public static boolean hasExtendedAssessmentQuestions(id oppId){
        if([SELECT count() FROM RiskAssessmentQuestion__c 
            WHERE Risk_Assessment_Type__c = 'Extended Assessment'
            AND Opportunity__c = :oppId] == 0){
                return False;
        }
        else{
            return True;
        }
    }



}