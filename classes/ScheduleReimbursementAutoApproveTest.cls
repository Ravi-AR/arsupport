/**
*   @Author:    Heena Tanna
*   @Date:      02.11.2016
*   @Jira:      LPDCR-686(Sub Task-841)
*   @Purpose:   Test class for code coverage of ScheduleReimbursementAutoApprove
*/


@isTest
public class ScheduleReimbursementAutoApproveTest
{
     public static String CRON_EXP = '0 0 6 1/1 * ? *';
    public static testmethod void testSchedule()
        {
 
                   
        AMASellingSupportExpense__c expense = LPDCR_TestUtil.getSSExpenseRecord();
        
       
        // Create an approval request for the expense
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(expense.id);
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(Userinfo.getUserId());
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('AMAExpenseApprovalRequest');
        //req1.setSkipEntryCriteria(true);
        // Submit the approval request for the expense
        Approval.ProcessResult result = Approval.process(req1);
        // Verify the result
        System.assert(result.isSuccess());
        
        
       expense.Submitted_for_Approval_Date__c = Date.Today()-8;
       update expense;

             Test.StartTest();
             ScheduleReimbursementAutoApprove schRe = new ScheduleReimbursementAutoApprove();
             // Schedule the test job
             String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP,schRe);
             Test.StopTest();

        }
}