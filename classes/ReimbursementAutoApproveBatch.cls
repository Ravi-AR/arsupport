/**
*   @Author:    Heena Tanna
*   @Date:      28.10.2016
*   @Jira:      LPDCR-686
*   @Purpose:   Batch class for Approval Process
*
*/
global class ReimbursementAutoApproveBatch implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'Select Id,ApprovalStatus__c,Internal_Status__c,Submitted_for_Approval_Date__c FROM AMASellingSupportExpense__c WHERE Internal_Status__c = \'Submitted for Approval\' AND Submitted_for_Approval_Date__c < LAST_N_DAYS:7 ';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<AMASellingSupportExpense__c> expenseList)
    {
         Set<ID> expIds = new Set<ID>();
         List<Approval.ProcessWorkitemRequest> appProcessList = new List<Approval.ProcessWorkitemRequest>();
         
         for(AMASellingSupportExpense__c expObj:expenseList)
         expIds.add(expObj.id);     
         
         for(ProcessInstanceWorkitem ob :[ SELECT Id FROM ProcessInstanceWorkitem
         WHERE ProcessInstance.TargetObjectId IN: expIds
         AND ProcessInstance.Status = 'Pending'])
       {
         Approval.ProcessWorkitemRequest appProcessItem = new Approval.ProcessWorkitemRequest();
         
          appProcessItem.setComments('Auto Approved by System after 7 days');
          appProcessItem.setAction('Approve');
          appProcessItem.setWorkitemId(ob.Id);
          appProcessList.add(appProcessItem);
       }
         
         if(appProcessList.size()>0)
         {
           List<Approval.ProcessResult> resultList =  Approval.process(appProcessList);
         }   
        
    }
    global void finish(Database.BatchableContext BC)
    {
    
    }
}