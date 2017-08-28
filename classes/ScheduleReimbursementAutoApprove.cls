/**
*   @Author:    Heena Tanna
*   @Date:      28.10.2016
*   @Jira:      LPDCR-686
*   @Purpose:   Scheduler class for Approval Process
*
*/
public class ScheduleReimbursementAutoApprove implements Schedulable {

    public void execute(SchedulableContext sc)
    {
        ReimbursementAutoApproveBatch ob = new ReimbursementAutoApproveBatch ();
        Database.executeBatch(ob);
    }
}