/**
*   @Author:    Shruti Mishra
*   @Date:      19.09.2016
*   @Jira:      LPDCR-563
*   @Purpose:   Trigger to Update ExpenseLineItem fields
*
*/
trigger AMASSExpenseLineItemTrigger on AMASellingSupportExpenseLineItem__c (before insert,after insert,before update,after update) 
{
    List<AMASellingSupportExpenseLineItem__c> lineItemList = Trigger.isDelete ? Trigger.old : Trigger.new;
    if(Trigger.isBefore && Trigger.isInsert)
         AMASSExpenseLineItemTriggerHandler.populateLineItemFields(lineItemList);
    
    if(Trigger.isBefore && Trigger.isUpdate)
        AMASSExpenseLineItemTriggerHandler.updateLineItem(lineItemList,Trigger.oldMap);
        
}