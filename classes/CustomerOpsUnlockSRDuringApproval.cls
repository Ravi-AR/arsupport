// CustomerOpsUnlockSRDuringApproval
// CustomerOpsUnlockSRDuringApproval is used by the Customer Care Rep profile 
// on the Service Request screen to unlock and lock records, 
// particularly when in Awaiting Approval status.
//------------------------------------------------------------------------------
// Author					Date			Description
// -----------------------------------------------------------------------------
// Mark Purick				10/14/2016		Created
// Juan Rivera				10/17/2016		Updated to user Try Catch blocks 

// Using global in order to call its methods via custom button
global class CustomerOpsUnlockSRDuringApproval {
    // Unlock or lock Service Request, depending on the status of the record
    webservice static string lockUnlockSR(Id srId) {
        String results = null;
        try{
            if(Approval.isLocked(srId)) {
                Approval.UnlockResult unlockRes = Approval.unlock(srId, false); 
                if(unlockRes.isSuccess()) {
                    results = 'Record unlocked successfully!';
                }
            }
            else {
                Approval.LockResult lockRes = Approval.lock(srId, false);
                if(lockRes.isSuccess()) {
                    results = 'Record locked successfully!';
                }              
            }          
        }catch(Exception e){
            results = 'The following exception occurred: ' + e.getMessage();
        } 
        return results;
    }
}