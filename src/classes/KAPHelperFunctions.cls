/**********************************************************************
Name:  KAPHelperFunctions
======================================================
Purpose: Helper Functions for KAP Classes
======================================================
History
-------
Date        AUTHOR                          DETAIL
22/07/2016  Wolfram von Reitzenstein        INITIAL

*********************************************************************/

public class KAPHelperFunctions {

    public static Set <ID> getAllAccountIDsForKeyAccount(ID inputAccountID){
        
        //preparation of return list of Account IDs
        Set<ID> setResultAccIDs = new Set<ID>();
        setResultAccIDs.add(inputAccountID);
        
        //preparation of Account ID for recursive search
        Set<Id> setSearchAccIDs = new Set<Id>();
        setSearchAccIDs.add(inputAccountID);
        
        //Start recursive search of Account ID and return value
        return getAccountIDsbyHierarchy(setSearchAccIDs, setResultAccIDs);      
    }
    
    public static Set<Id> getAccountIDsbyHierarchy(Set<Id> setInputSearchIDs, Set<Id> setInputResultIDs) {
    
        //Write input values to internal variables
        Set<Id> setSearchIDs = setInputSearchIDs;
        Set<Id> setResultIDs = setInputResultIDs;
        
        //Initialize empty Set for IDs for a possible next search
        Set<Id> setNextSearchIDs = new Set<Id>(); 
 
        //Search all Account IDs for a (Key) Account accross 4 levels
        for (Integer i=0;i<setSearchIDs.size();i++) { 
            Map<Id,Account> subordinate_accounts =
            new Map<Id,Account>([
                SELECT Id, Name,
                       ParentID,
                       Parent.ParentID,
                       Parent.Parent.ParentID,
                       Parent.Parent.Parent.ParentID
                FROM   Account
                WHERE (ParentId IN :setSearchIDs) OR
                      (Parent.ParentId IN :setSearchIDs) OR
                      (Parent.Parent.ParentId IN :setSearchIDs) OR
                      (Parent.Parent.Parent.ParentId IN :setSearchIDs)]);
 
            //Add Accounts from all 4 levels to Result Set
            for (Account acc : subordinate_accounts.values()) {
                if (acc.ParentId != null) {
                    if (setSearchIDs.contains(acc.ParentId)) {  
                            setResultIDs.add(acc.id);
                    }
                    else if (acc.Parent.ParentId != null) {
                        if (setSearchIDs.contains(acc.Parent.ParentId)) {
                            setResultIDs.add(acc.id);
                        }
                        else if (acc.Parent.Parent.ParentId != null) {
                            if (setSearchIDs.contains(acc.Parent.Parent.ParentId)) {
                                setResultIDs.add(acc.id);
                            }
                            else if (acc.Parent.Parent.Parent.ParentId != null) {
                                if (setSearchIDs.contains(acc.Parent.Parent.Parent.ParentId)) {
                                    setResultIDs.add(acc.id);
                                    //Store all Account IDs on level 4 as input Set for next search
                                    setNextSearchIDs.add(acc.id);
                                }
                            }
                        }
                    }
                }
            }
            //Recursive call of function to search the next 4 levels
            if (setNextSearchIDs.size() > 0) {
                setResultIDs = getAccountIDsbyHierarchy(setNextSearchIDs, setResultIDs);
            }
        }
    //Return complet Set of Account ID accross all levels
    return setResultIDs;
    }
}