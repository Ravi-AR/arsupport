/**
* This is the code that excutes LPDCR_ReimbursementRequestNotification
* Why, well that's because it's just how Salesforce works.  You need to
* create an object to call an object so that the scheduler is happy?!?!?
* 
* @Date: 01.30.2017
* @Author: Ron Soppeland
* 
* @Updates:
*/

global class LPDCR_ReimbursementRequestNotify_Sched implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        LPDCR_ReimbursementRequestNotification job = new LPDCR_ReimbursementRequestNotification();
        database.executeBatch(job, 2000);
    }

}