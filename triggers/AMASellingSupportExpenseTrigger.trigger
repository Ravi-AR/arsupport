/**
*   @Author:    Usman Ali (Magnet 360 )
*   @Date:      09.02.2016
*   @Jira:      LPDCR-234
*   @Purpose:   Trigger to Update UltimateParentAR field from related Dealer( Account.UltimateParentAR )
*
*/

trigger AMASellingSupportExpenseTrigger on AMASellingSupportExpense__c(before insert,before update, after insert, after update, after delete ) 
{
    List<AMASellingSupportExpense__c> expenses = Trigger.isDelete ? Trigger.old : Trigger.new ;
    Set<Id> expenseIdSet = new Set<ID>();
    // Populate Dealer's UltimateParentAccount Id
    if( Trigger.isBefore && Trigger.isInsert ) AMASellingSupportExpenseTriggerHandler.populateUltimateParentAR(expenses);
    
   
    // Create ExpenseLineItems 
    if( Trigger.isAfter && Trigger.isInsert )  AMASellingSupportExpenseTriggerHandler.createExpenseLineItems(expenses);
         
    // Set Amount on UltimateParentAR(Account) for Insert, Update and Delete
   if( Trigger.isAfter ) 
    {
        //AMASellingSupportExpenseTriggerHandler.createAccountShares(expenses); // Simon Fortune - 09.07.2016 - commented out method as removed from Class.
       // AMASellingSupportExpenseTriggerHandler.setAMASellingSupportAdjustment(expenses);
        
        if(trigger.isUpdate)
        {
        AMASellingSupportExpenseTriggerHandler.updateExpenseLineItemsStatus(trigger.newMap,trigger.oldMap);//Heena Tanna - 23rd Sep 2016 LPDCR-568
        AMASellingSupportExpenseTriggerHandler.getExpenseForClone(trigger.newMap,trigger.oldMap);
        //LPDCR -1206 Heena Tanna
        AMASellingSupportExpenseTriggerHandler.getCurrentApprover(trigger.newMap,trigger.oldMap);
        }
    }
}