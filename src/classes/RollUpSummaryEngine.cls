/***************************************************************************************************
Name:  RollUpSummaryEngine
==================================================================================================
Purpose:  This class does the rollupsummary calculation for the Customer project and Contracts object
           based on the opportunity relationship.
======================================================================================================
History
-------
Date        AUTHOR                          DETAIL
05/04/2017  bmohammed                  INITIAL Version
25/04/2017  Arokia Joseph              (DC-1321/ DC-1322)
********************************************************************************************************/

public class RollUpSummaryEngine {

    public static List<SObject> calculateRollUpSummary(Map<Id,SObject> sObjectMap){
        Map<Id, SObject> returnSObjectMap = new Map<Id, SObject>();


        try{
            //Get All opportunities related to the projects that needs to be updated & the opportunities which dont have a project but have a conbtract associated.
            for(Opportunity opp: [SELECT Id, Project__c, ContractId, Amount, TotalOpportunityQuantity, IsClosed, IsWon, Project__r.Related_Contract__c FROM Opportunity WHERE (Project__c IN: sObjectMap.keySet() OR (Project__c =: NULL AND ContractId IN: sObjectMap.keySet()) OR(Project__r.Related_Contract__c =: NULL AND ContractId IN: sObjectMap.keySet()) ) AND (Amount !=: NULL OR TotalOpportunityQuantity !=: NULL) AND (IsClosed !=: True OR (IsClosed =: True AND IsWon !=: false))]){
                if(opp.Project__c <> null){
                    if(!returnSObjectMap.containsKey(opp.Project__c)){
                        returnSObjectMap.put(opp.Project__c, new Project__c(Id = opp.Project__c, Amount_in_Pipeline__c = 0, Amount_Won__c = 0, Quantity_in_Pipeline__c = 0, Quantity_Won__c = 0, Recalculation_Pending__c = False));
                    }

                    Project__c projToUpdate = (Project__c)returnSObjectMap.get(opp.Project__c);
                    if(opp.IsWon){
                        projToUpdate.Quantity_Won__c += opp.TotalOpportunityQuantity != null ? opp.TotalOpportunityQuantity : 0;
                        projToUpdate.Amount_Won__c += opp.Amount != null ? opp.Amount : 0;
                    }
                    else{
                        projToUpdate.Quantity_in_Pipeline__c += opp.TotalOpportunityQuantity != null ? opp.TotalOpportunityQuantity : 0;
                        projToUpdate.Amount_in_Pipeline__c += opp.Amount != null ? opp.Amount : 0;
                    }
                    returnSObjectMap.put(opp.Project__c, projToUpdate);


                    if(opp.Project__r.Related_Contract__c == null && opp.ContractId <> null){
                        if(!returnSObjectMap.containsKey(opp.ContractId)){
                            returnSObjectMap.put(opp.ContractId, new Contract(Id = opp.ContractId, Amount_Pipeline_Project_Related__c = 0, Amount_Won_Project_Related__c = 0, Quantity_Pipeline_Project_Related__c = 0, Quantity_Won_Project_Related__c = 0,Amount_Pipeline_Contract_Related__c = 0, Amount_Won_Contract_Related__c = 0, Quantity_Pipeline_Contract_Related__c = 0, Quantity_Won_Contract_Related__c = 0, Recalculation_Pending__c = False));
                        }

                        returnSObjectMap.put(opp.ContractId, updateContractfromOpportunity(opp, (Contract)returnSObjectMap.get(opp.ContractId)));
                    }

                }
                else if(opp.ContractId <> null){
                    if(!returnSObjectMap.containsKey(opp.ContractId)){
                        returnSObjectMap.put(opp.ContractId, new Contract(Id = opp.ContractId, Amount_Pipeline_Project_Related__c = 0, Amount_Won_Project_Related__c = 0, Quantity_Pipeline_Project_Related__c = 0, Quantity_Won_Project_Related__c = 0,Amount_Pipeline_Contract_Related__c = 0, Amount_Won_Contract_Related__c = 0, Quantity_Pipeline_Contract_Related__c = 0, Quantity_Won_Contract_Related__c = 0, Recalculation_Pending__c = False));
                    }

                    returnSObjectMap.put(opp.ContractId, updateContractfromOpportunity(opp, (Contract)returnSObjectMap.get(opp.ContractId)));
                }
            }

            //Get all the projects associated with a contract & calculate the roll up summary based on the retrieved data & previously calculated data

            for(Project__c proj: [SELECT Id, Related_Contract__c, Amount_in_Pipeline__c, Amount_Won__c, Quantity_in_Pipeline__c, Quantity_Won__c FROM Project__c WHERE Related_Contract__c IN: sObjectMap.keySet()]){
                if(!returnSObjectMap.containsKey(proj.Related_Contract__c)){
                    returnSObjectMap.put(proj.Related_Contract__c, new Contract(Id = proj.Related_Contract__c, Amount_Pipeline_Project_Related__c = 0, Amount_Won_Project_Related__c = 0, Quantity_Pipeline_Project_Related__c = 0, Quantity_Won_Project_Related__c = 0,Amount_Pipeline_Contract_Related__c = 0, Amount_Won_Contract_Related__c = 0, Quantity_Pipeline_Contract_Related__c = 0, Quantity_Won_Contract_Related__c = 0, Recalculation_Pending__c = False));
                }

                if(returnSObjectMap.containsKey(proj.Id)){
                    returnSObjectMap.put(proj.Related_Contract__c,updateContractfromProject((Project__c)returnSObjectMap.get(proj.Id), (Contract)returnSObjectMap.get(proj.Related_Contract__c)));
                }
                else{
                    returnSObjectMap.put(proj.Related_Contract__c,updateContractfromProject(proj, (Contract)returnSObjectMap.get(proj.Related_Contract__c)));
                }

            }

        }
        catch (Exception ex){
            system.debug('Exception in RollUpSummaryEngine.calculateRollUpSummary>>> '+ex);
        }


        //system.debug(returnSObjectMap);
        return returnSObjectMap.values();
    }
    public static Contract updateContractfromProject(Project__c proj, Contract contr){

        contr.Quantity_Won_Project_Related__c += proj.Quantity_Won__c != null ? proj.Quantity_Won__c : 0;
        contr.Quantity_Pipeline_Project_Related__c += proj.Quantity_in_Pipeline__c != null ? proj.Quantity_in_Pipeline__c : 0;
        contr.Amount_Pipeline_Project_Related__c += proj.Amount_in_Pipeline__c != null ? proj.Amount_in_Pipeline__c : 0;
        contr.Amount_Won_Project_Related__c += proj.Amount_Won__c != null ? proj.Amount_Won__c : 0;

        return contr;
    }
    public static Contract updateContractfromOpportunity(Opportunity opp, Contract contractToUpdate){
        if(opp.IsWon){
            contractToUpdate.Quantity_Won_Contract_Related__c += opp.TotalOpportunityQuantity != null ? opp.TotalOpportunityQuantity : 0;
            contractToUpdate.Amount_Won_Contract_Related__c += opp.Amount != null ? opp.Amount : 0;
        }
        else{
            contractToUpdate.Quantity_Pipeline_Contract_Related__c += opp.TotalOpportunityQuantity != null ? opp.TotalOpportunityQuantity : 0;
            contractToUpdate.Amount_Pipeline_Contract_Related__c += opp.Amount != null ? opp.Amount : 0;
        }
        return contractToUpdate;
    }
}