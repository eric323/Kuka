// Original Source:
// https://raw.githubusercontent.com/mshanemc/processBuilderBlocks/master/src/classes/PBBUtilities.cls

public with sharing class PBBUtilities {
    
    public static list<string> dedupe(list<string> input){
        set<string> temp = new set<string>(input);
        return new list<string>(temp);
    }

    public class PBException extends Exception {}   
}