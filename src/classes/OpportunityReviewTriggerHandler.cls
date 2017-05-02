public with sharing class OpportunityReviewTriggerHandler implements ITriggerHandler {
    
    public static Boolean TriggerDisabled = false;

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

    private static final String APPROVERONE = 'Approver 1';

    private static final String APPROVERTWO = 'Approver 2';

    private static final String ASSESSMENTSTATUSREQUIRED = 'Required / Not Started';

    private static final String ASSESSMENTSTATUSIGNORED = 'Ignore / Not Required';

    private static final String STATUSOVERVIEWCOLORS1 = 'GyRdRdRd';

    private static final String STATUSOVERVIEWCOLORS2 = 'RdRdRdRd';

    private static final String STATUSOVERVIEWCOLORS3 = 'RdGyGyGy';

    private static final String STATUSOVERVIEWCOLORS4 = 'GyGyGyGy';

    private static final String SUBGROUPINDUSTRIES = 'KUKA Industries';

    private static final String SUBGROUPSWISSLOGWDS = 'Swisslog WDS';

    private static final String SUBGROUPROBOTICS= 'KUKA Robotics';

    private static final String SUBGROUPSWISSLOGHCS = 'Swisslog HCS';

    private static final String PROFITCENTERTES = 'Technology Services TES';

    private static final String NOTAPPLICABLE = 'Not Applicable';

    /*
      Checks to see if the trigger has been disabled. For example, you could check a custom setting here.
      In this example, a static property is used to disable the trigger.
      In a unit test, you could use AccountTriggerHandler.TriggerDisabled = true to completely disable the trigger.
    */
    public Boolean IsDisabled() {
        return TriggerDisabled;
    }

    public void BeforeInsert(List<SObject> newItems) {  
        assignApprovers((List<Opportunity_Review__c>)newItems);  
    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        List<Opportunity_Review__c> newList = new List<Opportunity_Review__c>();
        for (sObject sobj: newItems.values()){
            newList.add((Opportunity_Review__c)sobj);    
        }
        assignApprovers(newList);    
    }

    public void BeforeDelete(Map<Id, SObject> oldItems) {}

    public void AfterInsert(Map<Id, SObject> newItems) {}

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

    public void AfterDelete(Map<Id, SObject> oldItems) {}

    public void AfterUndelete(Map<Id, SObject> oldItems) {}

    private void assignApprovers(List<Opportunity_Review__c> newItems) {

        Set<String> subGroups = new Set<String>();
        List<Opportunity_Approver__c> allOppApprovers = new List<Opportunity_Approver__c>();

        for (Opportunity_Review__c op: newItems) {
            if (op.KUKA_subgroup__c != null) {
              subGroups.add(op.KUKA_subgroup__c);
            }
        }
        system.debug('Subgroups ---->' +subGroups);

        if (subGroups.size() > 0) {
            allOppApprovers =  [SELECT
                                  Id,
                                  Name,
                                  Approval_Level__c,
                                  Approval_Type__c,
                                  Approver__c,
                                  Business_Unit__c,
                                  Legal_Entity__c,
                                  Profit_Center__c,
                                  GLC_Approver_Type__c,
                                  Level_C_or_D_Approvers_1_or_2__c,
                                  Technical_Approver_Type__c
                                FROM
                                  Opportunity_Approver__c 
                                WHERE
                                  Business_Unit__c IN :subGroups
                                ORDER BY
                                  CreatedDate];


        }
        system.debug('All Approvers----->' +allOppApprovers);

        if (!allOppApprovers.isEmpty()) {
            for (Opportunity_Review__c opr: newItems) {
                for (Opportunity_Approver__c opa: allOppApprovers) {
                    if (opr.KUKA_subgroup__c == opa.Business_Unit__c && opr.Legal_Entity__c == opa.Legal_Entity__c) {
                        if (opa.Approval_Type__c == APPROVALTYPE1) {
                            if (opr.Approver_Level_A__c == null && opa.Approval_Level__c == APPROVALLEVELA 
                                && opr.Profit_Center__c != null && opr.Profit_Center__c == opa.Profit_Center__c) {
                                system.debug(+opa.Profit_Center__c+'------->'+opr.Profit_Center__c);
                                opr.Approver_Level_A__c = opa.Approver__c;
                            }
                            if (opr.Approver_Level_B__c == null && opa.Approval_Level__c == APPROVALLEVELB) {
                                opr.Approver_Level_B__c = opa.Approver__c;
                            }
                            if (opr.Approver_Level_C__c == null && opa.Approval_Level__c == APPROVALLEVELC
                                && opa.Level_C_or_D_Approvers_1_or_2__c == APPROVERONE) {
                                    opr.Approver_Level_C__c = opa.Approver__c;
                            }
                            if (opr.Approver2_Level_C__c == null && opa.Approval_Level__c == APPROVALLEVELC
                                && opa.Level_C_or_D_Approvers_1_or_2__c == APPROVERTWO) {
                                    opr.Approver2_Level_C__c = opa.Approver__c;
                            }
                            if (opr.Approver_Level_D__c == null && opa.Approval_Level__c == APPROVALLEVELD
                                && opa.Level_C_or_D_Approvers_1_or_2__c == APPROVERONE) {
                                    opr.Approver_Level_D__c = opa.Approver__c;
                            }
                            if (opr.Approver2_Level_D__c == null && opa.Approval_Level__c == APPROVALLEVELD
                                && opa.Level_C_or_D_Approvers_1_or_2__c == APPROVERTWO) {
                                    opr.Approver2_Level_D__c = opa.Approver__c;
                            }
                        } else if (opa.Approval_Type__c == APPROVALTYPE2) {
                            if (opr.GLC_Approver_1__c == null && opa.GLC_Approver_Type__c == GLCAPPROVERTYPE1) {
                                opr.GLC_Approver_1__c = opa.Approver__c;
                            }
                            if (opr.GLC_Approver_2__c == null && opa.GLC_Approver_Type__c == GLCAPPROVERTYPE2) {
                                opr.GLC_Approver_2__c = opa.Approver__c;
                            }
                            if (opr.GLC_Approver_3__c == null && opa.GLC_Approver_Type__c == GLCAPPROVERTYPE3) {
                                opr.GLC_Approver_3__c = opa.Approver__c;
                            }
                            if (opr.GLC_Approver_4__c == null && opa.GLC_Approver_Type__c == GLCAPPROVERTYPE4 
                                && opr.Profit_Center__c != null && opr.Profit_Center__c == opa.Profit_Center__c) {
                                system.debug(+opa.Profit_Center__c+'------->'+opr.Profit_Center__c);
                                opr.GLC_Approver_4__c = opa.Approver__c;
                            }
                        } else if (opa.Approval_Type__c == APPROVALTYPE3) {
                            if (opr.Export_Control_Approver__c == null) {
                                opr.Export_Control_Approver__c = opa.Approver__c;
                            }   
                        } else if (opa.Approval_Type__c == APPROVALTYPE4) {

                            if (opr.Welding_Approver_1__c == null && opa.Technical_Approver_Type__c == TECHNICALAPPROVALTYPE1 
                                && opr.Profit_Center__c != null && opr.Profit_Center__c == opa.Profit_Center__c) {
                                opr.Welding_Approver_1__c = opa.Approver__c;
                            } else if (opr.Welding_Approver_2__c == null && opa.Technical_Approver_Type__c == TECHNICALAPPROVALTYPE1 
                                && opr.Profit_Center__c != null && opr.Profit_Center__c == opa.Profit_Center__c) {
                                opr.Welding_Approver_2__c = opa.Approver__c;
                            } else if (opr.Welding_Approver_3__c == null && opa.Technical_Approver_Type__c == TECHNICALAPPROVALTYPE1 
                                && opr.Profit_Center__c != null && opr.Profit_Center__c == opa.Profit_Center__c) {
                                opr.Welding_Approver_3__c = opa.Approver__c;
                            }
                            if (opr.Geometric_Approver_1__c == null && opa.Technical_Approver_Type__c == TECHNICALAPPROVALTYPE2 
                                && opr.Profit_Center__c != null && opr.Profit_Center__c == opa.Profit_Center__c) {
                                opr.Geometric_Approver_1__c = opa.Approver__c;
                            } else if (opr.Geometric_Approver_2__c == null && opa.Technical_Approver_Type__c == TECHNICALAPPROVALTYPE2 
                                && opr.Profit_Center__c != null && opr.Profit_Center__c == opa.Profit_Center__c) {
                                opr.Geometric_Approver_2__c = opa.Approver__c;
                            }
                            if (opr.Technical_Approver_1__c == null && opa.Technical_Approver_Type__c == TECHNICALAPPROVALTYPE3 
                                && opr.Profit_Center__c != null && opr.Profit_Center__c == opa.Profit_Center__c) {
                                opr.Technical_Approver_1__c = opa.Approver__c;
                            } else if (opr.Technical_Approver_2__c == null && opa.Technical_Approver_Type__c == TECHNICALAPPROVALTYPE3 
                                && opr.Profit_Center__c != null && opr.Profit_Center__c == opa.Profit_Center__c) {
                                opr.Technical_Approver_2__c = opa.Approver__c;
                            }   
                        }
                    }       
                }         
            }

            for (Opportunity_Review__c opr: newItems) {

                //Remove Duplicate values
                if (opr.GLC_Approver_1__c != null && opr.GLC_Approver_1__c == opr.GLC_Approver_2__c) {
                    opr.GLC_Approver_2__c = null;
                }
                if (opr.GLC_Approver_2__c != null && opr.GLC_Approver_2__c == opr.GLC_Approver_3__c) {
                    opr.GLC_Approver_3__c = null;
                }
                if (opr.GLC_Approver_3__c != null && opr.GLC_Approver_3__c == opr.GLC_Approver_4__c) {
                    opr.GLC_Approver_4__c = null;
                } 
                if (opr.Welding_Approver_1__c != null && opr.Welding_Approver_1__c == opr.Welding_Approver_2__c) {
                    opr.Welding_Approver_2__c = null;
                }
                if (opr.Welding_Approver_2__c != null && opr.Welding_Approver_2__c == opr.Welding_Approver_3__c) {
                    opr.Welding_Approver_3__c = null;
                }
                if (opr.Geometric_Approver_1__c != null && opr.Geometric_Approver_1__c == opr.Geometric_Approver_2__c) {
                    opr.Geometric_Approver_2__c = null;
                }
                if (opr.Technical_Approver_1__c != null && opr.Technical_Approver_1__c == opr.Technical_Approver_2__c) {
                    opr.Technical_Approver_2__c = null;
                }

                //Assign Approvers in order
                if (opr.GLC_Approver_1__c == null && opr.GLC_Approver_2__c != null) {
                    opr.GLC_Approver_1__c = opr.GLC_Approver_2__c;
                    opr.GLC_Approver_2__c = null;
                }
                if (opr.GLC_Approver_2__c == null && opr.GLC_Approver_3__c != null) {
                    opr.GLC_Approver_2__c = opr.GLC_Approver_3__c;
                    opr.GLC_Approver_3__c = null;
                }
                if (opr.GLC_Approver_3__c == null && opr.GLC_Approver_4__c != null) {
                    opr.GLC_Approver_3__c = opr.GLC_Approver_4__c;
                    opr.GLC_Approver_4__c = null;
                }
                if (opr.Welding_Approver_1__c == null && opr.Welding_Approver_2__c != null) {
                    opr.Welding_Approver_1__c = opr.Welding_Approver_2__c;
                    opr.Welding_Approver_2__c = null;
                }
                if (opr.Welding_Approver_2__c == null && opr.Welding_Approver_3__c != null) {
                    opr.Welding_Approver_2__c = opr.Welding_Approver_3__c;
                    opr.Welding_Approver_3__c = null;
                }
                if (opr.Geometric_Approver_1__c == null && opr.Geometric_Approver_2__c != null) {
                    opr.Geometric_Approver_1__c = opr.Geometric_Approver_2__c;
                    opr.Geometric_Approver_2__c = null;
                }
                if (opr.Technical_Approver_1__c == null && opr.Technical_Approver_2__c != null) {
                    opr.Technical_Approver_1__c = opr.Technical_Approver_2__c;
                    opr.Technical_Approver_2__c = null;
                }

                //Set Pre-Assessment Approver Level A
                if (opr.Approver_Level_A__c != null) {
                    opr.Approver_for_PreAssessment_Level_A__c = opr.Approver_Level_A__c;
                }
            }
        }
    }
}