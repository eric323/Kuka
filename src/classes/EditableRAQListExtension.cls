/*
 * PURPOSE:
 * This controller extension results Risk Assessment Questions depending on
 * their Risk Assessment Type (Quick/Basic/Extended)
 * 
 * VERSION; DATE (YYYY-MM-DD); AUTHOR; "CHANGE"
 * 0.5; 2016-10-17; John Kuhne; "Ian changed a picklist and broke this code; replaced Business_Unit_v2__c with new Business_Unit__c field" 
 * 0.4; 2016-09-21; John Kuhne; "Display RATs instead of an empty page if there are no RAQs"
 * 0.3; 2016-09-19; John Kuhne; "Added controller code for 'Create' buttons"
 * 0.2; 2016-09-17; Wolfram von Reitzenstein; "Added logic to control the selection of Quick/Basic/Extended records"
 * 0.1; 2016-09-13; John Kuhne; "Added code from http://michaelwelburn.com/Visualforce-Edit-Multiple-Records/"
 * 
 * Based on:
 * EditableContactListExtension.cls
 * Copyright (c)2013, Michael Welburn.
 * License: MIT
 * Usage:
 *   This is the implementation class where Object specific references
 *   need to be defined. Please see EditableList.cls for more information
 *   on what each method is responsible for.
 * Required methods:
 *   - EditableContactListExtension(ApexPages.StandardController)
 *   - getChildren()
 *   - initChildRecord()
 */
public with sharing class EditableRAQListExtension extends EditableList
{
  // Read the explanation in EditableContactListExtension(ApexPages.StandardController)
  // to see when to uncomment the following line.

  // public Opportunity myOpportunity {get; private set;}

  public boolean showBasicAssessmentButton {get;set;}
  public boolean showExtendedAssessmentButton {get;set;}



  public boolean isQuickAssessment {get;set;}  
  public boolean isBasicAssessment {get;set;} 
  public boolean isExtendedAssessment {get;set;} 
  public boolean hasQuickAssessmentQuestions {get;set;}
  public boolean hasBasicAssessmentQuestions {get;set;}
  public boolean hasExtendedAssessmentQuestions {get;set;}
  public boolean isQuickAssessmentComplete {get;set;}  
  public boolean isBasicAssessmentComplete {get;set;} 
  public boolean isExtendedAssessmentComplete {get;set;} 

  private Opportunity myOpportunity;
    

  public EditableRAQListExtension(ApexPages.StandardController stdController) 
  {
    super(stdController);
      
    this.myOpportunity = [SELECT Id, 
                                 Quick_Assessment_Minimum__c, 
                                 Basic_Assessment_Minimum__c,    
                                 Extended_Assessment_Minimum__c,
                                 Business_Unit__c,
                                 Quick_Assessment_Status__c

                          FROM Opportunity
                          WHERE Id =: stdController.getRecord().Id];
    
    if (myOpportunity.Quick_Assessment_Minimum__c >= 1) {
        isQuickAssessmentComplete = true;
    } 
    else {
        isQuickAssessmentComplete = false;
    }
    

    if (myOpportunity.Basic_Assessment_Minimum__c >= 1) {
        isBasicAssessmentComplete = true;
    } 
    else {
        isBasicAssessmentComplete = false;
    }
    
    if (myOpportunity.Extended_Assessment_Minimum__c >= 1) {
        isExtendedAssessmentComplete = true;
    } 
    else {
        isExtendedAssessmentComplete = false;
    }
    
    if ( (myOpportunity.Quick_Assessment_Status__c == 'Please Ignore / Not Required') || (myOpportunity.Quick_Assessment_Status__c == 'Approved')) {
      startBasicAssessment();
    } else  {
      startQuickAssessment();
    }
  }
  /*
   * This method is necessary for reference on the Visualforce page, 
   * in order to reference non-standard fields.
   */
  public List<RiskAssessmentQuestion__c> getChildren()
  {
    return (List<RiskAssessmentQuestion__c>)childList;
  }
    
/*
 * QUICK ASSESSMENT
 */
    public void createQuickAssessmentQuestions() {
        RiskAssessment.createRAQs(mysObject.Id,'Quick Assessment',this.myOpportunity.Business_Unit__c);
    }

  public void startQuickAssessment() {
  
  /*
    if(RiskAssessment.hasQuickAssessmentQuestions(mysObject.Id) == false){
         createQuickAssessmentQuestions();
    }
  */
  
    isQuickAssessment = true;
    isBasicAssessment = false;
    isExtendedAssessment = false;
    
    hasQuickAssessmentQuestions=RiskAssessment.hasQuickAssessmentQuestions(mysObject.Id);
    hasBasicAssessmentQuestions=RiskAssessment.hasBasicAssessmentQuestions(mysObject.Id);
    hasExtendedAssessmentQuestions=RiskAssessment.hasExtendedAssessmentQuestions(mysObject.Id);
    
    if(hasQuickAssessmentQuestions){
      this.childList = [SELECT Id,
                          Sequence_Number__c,
                          Question__c, 
                          Answer__c, 
                          AnswerLowMediumHigh__c,
                          Clarification__c,
                          Financial_Risk__c,
                          isYesNo__c,
                          isLowMediumHigh__c,
                          isNumericResult__c
                        FROM RiskAssessmentQuestion__c 
                        WHERE Opportunity__c  =: mysObject.Id
                        AND Risk_Assessment_Type__c = 'Quick Assessment'
                        ORDER BY Sequence_Number__c ASC NULLS FIRST];
    } else {
        this.childList = RiskAssessment.displayRATs(mysObject.Id,'Quick Assessment',this.myOpportunity.Business_Unit__c);
    }
      

  }  

/*
 * BASIC ASSESSMENT
 */
    public void createBasicAssessmentQuestions() {
        RiskAssessment.createRAQs(mysObject.Id,'Basic Assessment','KUKA Industries');
    }
    public void startBasicAssessment() {

/*
    if(RiskAssessment.hasBasicAssessmentQuestions(mysObject.Id) == false){
         createBasicAssessmentQuestions();
    }
*/

    isQuickAssessment = false;
    isBasicAssessment = true;
    isExtendedAssessment = false;
    
    hasQuickAssessmentQuestions=RiskAssessment.hasQuickAssessmentQuestions(mysObject.Id);
    hasBasicAssessmentQuestions=RiskAssessment.hasBasicAssessmentQuestions(mysObject.Id);
    hasExtendedAssessmentQuestions=RiskAssessment.hasExtendedAssessmentQuestions(mysObject.Id);

        
    if(hasBasicAssessmentQuestions){
      this.childList = [SELECT Id,
                        Sequence_Number__c,
                        Question__c, 
                        Answer__c, 
                        AnswerLowMediumHigh__c,
                        Clarification__c,
                        Financial_Risk__c,
                        isYesNo__c,
                        isLowMediumHigh__c,
                        isNumericResult__c
                      FROM RiskAssessmentQuestion__c 
                      WHERE Opportunity__c  =: mysObject.Id
                      AND Risk_Assessment_Type__c = 'Basic Assessment'
                      ORDER BY Sequence_Number__c ASC NULLS FIRST];
    } else {
      this.childList = RiskAssessment.displayRATs(mysObject.Id,'Basic Assessment',this.myOpportunity.Business_Unit__c);
    }
  }

/*
 * EXTENDED ASSESSMENT
 */
    public void createExtendedAssessmentQuestions() {
        RiskAssessment.createRAQs(mysObject.Id,'Extended Assessment','KUKA Industries');
    }

    public void startExtendedAssessment() {

/*
    if(RiskAssessment.hasExtendedAssessmentQuestions(mysObject.Id) == false){
         createExtendedAssessmentQuestions();
    }
*/

    isQuickAssessment = false;
    isBasicAssessment = false;
    isExtendedAssessment = true;

    hasQuickAssessmentQuestions=RiskAssessment.hasQuickAssessmentQuestions(mysObject.Id);
    hasBasicAssessmentQuestions=RiskAssessment.hasBasicAssessmentQuestions(mysObject.Id);
    hasExtendedAssessmentQuestions=RiskAssessment.hasExtendedAssessmentQuestions(mysObject.Id);

    if(hasExtendedAssessmentQuestions)
    {
      this.childList = [SELECT Id,
                          Sequence_Number__c,
                          Question__c, 
                          Answer__c, 
                          AnswerLowMediumHigh__c,
                          Clarification__c,
                          Financial_Risk__c,
                          isYesNo__c,
                          isLowMediumHigh__c,
                          isNumericResult__c
                        FROM RiskAssessmentQuestion__c 
                        WHERE Opportunity__c  =: mysObject.Id
                        AND Risk_Assessment_Type__c = 'Extended Assessment'
                        ORDER BY Sequence_Number__c ASC NULLS FIRST];
    } else {
        this.childList = RiskAssessment.displayRATs(mysObject.Id,'Extended Assessment',this.myOpportunity.Business_Unit__c);
    }
  }  

}