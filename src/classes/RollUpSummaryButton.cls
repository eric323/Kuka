/**********************************************************************
Name:  RollUpSummaryButton
======================================================
Purpose:  
======================================================
History
-------
Date        AUTHOR                          DETAIL
06/04/2017  bmohammed                  INITIAL Version
25/04/2017  Arokia Joseph              (DC-1321/ DC-1322)
*********************************************************************/
global class RollUpSummaryButton {

    webservice static String aggregateAmountQuantity(List<String> recIds, String objectType)
    {
        boolean isPending = true;
        String query = 'SELECT Id, Recalculation_Pending__c FROM '+objectType+' Where Id IN: recIds AND Recalculation_Pending__c =: isPending';
        system.debug(query);
        Map<Id, SObject> sObjectMap = new Map<Id, SObject>(Database.query(query));

        if(sObjectMap.size() > 0){
            try{
                List<SObject> sObjectList = RollUpSummaryEngine.calculateRollUpSummary(sObjectMap);
                if(sObjectList.size()>0){
                    update sObjectList;
                }
                return 'success';
            }
            catch(Exception ex){
                return 'error';
            }
        }
        else{
            return 'updated';
        }

        //system.debug(sObjectMap);
    }
}