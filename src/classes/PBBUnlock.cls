// Original Source:
// https://raw.githubusercontent.com/mshanemc/processBuilderBlocks/master/src/classes/PBBUnlock.cls
//
// Edit from Original Source:
// Removed "with sharing" from the class definition

public class PBBUnlock {
    
    @InvocableMethod(label='UnLock a record')
    public static void UnLockRecord(list<string> recordIds) {
        Approval.unlock(PBBUtilities.dedupe(recordIds));
    }
}