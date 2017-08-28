/**
*   @Author:    Shruti Mishra
*   @Date:      19.09.2016
*   @Jira:      LPDCR-563
*   @Purpose:   Trigger Handler to Update ExpenseLineItem fields
*/

public without sharing class AMASSExpenseLineItemTriggerHandler
{
    public static void populateLineItemFields(List<AMASellingSupportExpenseLineItem__c> lineItemObjLst)
    {
    
    System.debug(',,,'+lineItemObjLst.size());
     Set<Id> expenseIdSet = new Set<Id>();  //Set to store Expense Record Ids
     List<AMASellingSupportExpenseLineItem__c> updatedLineItems=new List<AMASellingSupportExpenseLineItem__c>();
     
     //Map to store Expense Records
     Map<Id,AMASellingSupportExpense__c> expenseToExpenseRecordMap = new Map<Id,AMASellingSupportExpense__c>();
     
     
     //Loop Expense Line Items to populate set of Expense Ids
     for(AMASellingSupportExpenseLineItem__c exliObj: lineItemObjLst)
     {
     if(exliObj!=null && exliObj.Expense__c!=null){
     System.debug('..=='+exliObj.Expense__c);
      expenseIdSet.add(exliObj.Expense__c);//To add value of Expense Id to the Variable defined as Set
      }
     }
     
     System.debug('====='+expenseIdSet);
     //Query Expense object to populate map     
     for(AMASellingSupportExpense__c exObj: [Select Id, Sales_Representative__c, Line_Item_Total__c, Area_Sales_Manager__c FROM AMASellingSupportExpense__c WHERE Id IN: expenseIdSet])
     {
         System.debug('==='+exObj);
         expenseToExpenseRecordMap.put(exObj.id,exObj);
     }
     
     List<BusinessBuilderRules__c> bbRules = [Select Name, JDEPARTNUMBER__c,  Category__c, Description__c, Max_Reimbursement__c, Checkpoint_Multiplier__c, Reimbursement_Percentage__c, Reimbursement_Subcategory__c, Active__c from BusinessBuilderRules__c where Active__c=true];
     
     //Loop Expense Line Items to assign required fields
     for(AMASellingSupportExpenseLineItem__c exliObj:lineItemObjLst)
     {
         //Assign expense record from map
         AMASellingSupportExpense__c expenseRecord = expenseToExpenseRecordMap.get(exliObj.Expense__c);
         
         for(BusinessBuilderRules__c rule:bbRules){
             if(exliObj.Reimbursement_Category__c != null && exliObj.Reimbursement_Sub_category__c !=null && rule.Reimbursement_Subcategory__c == exliObj.Reimbursement_Sub_category__c && rule.Category__c == exliObj.Reimbursement_Category__c){
                 AMASellingSupportExpense__c expObj = [Select Id, Internal_Status__c, Line_Item_Total__c, AMABalanceFF__c, Selling_Support_Program_Year__r.Available_Balance__c, Selling_Support_Program_Year__r.Total_Pending_Requests__c from AMASellingSupportExpense__c where Id=:exliObj.Expense__c];
                 exliObj.Reimbursement_Percentage__c = rule.Reimbursement_Percentage__c;
                 exliObj.JDEPARTNUMBER__c = rule.JDEPARTNUMBER__c;
                 exliObj.BB_Description__c = rule.Description__c;
                    
                 //Remaining Amount Calculation starts
                 If (((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) > (expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c))
                     &&((rule.Max_Reimbursement__c==null && ((expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c) < expObj.Selling_Support_Program_Year__r.Available_Balance__c) )
                     ||(rule.Max_Reimbursement__c!=null && ((expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c) < rule.Max_Reimbursement__c))
                     )){
                         
                             System.debug('In ifffff');
                             exliObj.ExpenseAmount__c = expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c;
                         
                     }
                 
                 //Remaining Amount Calculation ends
                 
                     
                //If Amount requested * percentage < Max Amount and < Avail Balance Then use Amount * percentage
                //Amount requested * percentage > Max Amount and < Avail Balance Then use Max Amount
                else if((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) <= expObj.Selling_Support_Program_Year__r.Available_Balance__c ){
                    if(rule.Max_Reimbursement__c==null || (rule.Max_Reimbursement__c!=null && ((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) <= rule.Max_Reimbursement__c))){
                        exliObj.ExpenseAmount__c = exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100;
                    }
                    else if(rule.Max_Reimbursement__c!=null && ((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) > rule.Max_Reimbursement__c)){
                        exliObj.ExpenseAmount__c = rule.Max_Reimbursement__c;
                    }
                    
                }
                
                //Amount requested * percentage < Max Amount and > Avail Balance Then use Available Balance
                //Amount requested * percentage > Max Amount and > Avail Balance Then use Minimum(Max Amount, Avail Balance)
                else if((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) > expObj.Selling_Support_Program_Year__r.Available_Balance__c){
                    if(rule.Max_Reimbursement__c==null || (rule.Max_Reimbursement__c!=null && ((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) <= rule.Max_Reimbursement__c))){
                        if(expObj.Internal_Status__c!='Rework')
                            exliObj.ExpenseAmount__c = expObj.Selling_Support_Program_Year__r.Available_Balance__c;
                    }
                    else if(rule.Max_Reimbursement__c!=null && ((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) > rule.Max_Reimbursement__c)){
                        if(rule.Max_Reimbursement__c <= expObj.Selling_Support_Program_Year__r.Available_Balance__c)
                            exliObj.ExpenseAmount__c = rule.Max_Reimbursement__c;
                        else
                            exliObj.ExpenseAmount__c = expObj.Selling_Support_Program_Year__r.Available_Balance__c;
                    }
                    
                }
                     
                 System.debug('PopulateLineItem-->'+exliObj.ExpenseAmount__c );
             }
         }   
         exliObj.BB_Approver_Sales_Specialist__c = expenseRecord.Sales_Representative__c; // assign the value to related field
         exliObj.Area_Sales_Manager__c = expenseRecord.Area_Sales_Manager__c; // assign the value to the related field
         
     }
    }
    
    
    public static void updateLineItem(List<AMASellingSupportExpenseLineItem__c> lineItemObjLst, map<Id, AMASellingSupportExpenseLineItem__c> oldMap){
        List<BusinessBuilderRules__c> bbRules = [Select Name,JDEPARTNUMBER__c,Category__c,Description__c,Max_Reimbursement__c,Checkpoint_Multiplier__c,Reimbursement_Percentage__c,Reimbursement_Subcategory__c, Active__c from BusinessBuilderRules__c where Active__c=true];
        for(AMASellingSupportExpenseLineItem__c exliObj:lineItemObjLst)
         {
            for(BusinessBuilderRules__c rule:bbRules){
                 if(exliObj.Reimbursement_Category__c != null && exliObj.Reimbursement_Sub_category__c !=null && rule.Reimbursement_Subcategory__c == exliObj.Reimbursement_Sub_category__c && rule.Category__c == exliObj.Reimbursement_Category__c){
                       
                     AMASellingSupportExpense__c expObj = [Select Id,Internal_Status__c,Line_Item_Total__c,AMABalanceFF__c,Selling_Support_Program_Year__r.Available_Balance__c,Selling_Support_Program_Year__r.Total_Pending_Requests__c from AMASellingSupportExpense__c where Id=:exliObj.Expense__c];
                     exliObj.Reimbursement_Percentage__c = rule.Reimbursement_Percentage__c;
                     exliObj.JDEPARTNUMBER__c = rule.JDEPARTNUMBER__c;
                     exliObj.BB_Description__c = rule.Description__c;
                     
                     /*Decimal amountToCompare = 0;
                     for(Id li:oldMap.keySet()){
                         if(li!=exliObj.Id){
                             amountToCompare += oldMap.get(li).ExpenseAmount__c;
                         }
                     }
                     System.debug('AmountToCompare--'+amountToCompare);
                     
                     if(((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) > (expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c))
                        &&((rule.Max_Reimbursement__c==null && ((expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c) < expObj.Selling_Support_Program_Year__r.Available_Balance__c))
                        ||(rule.Max_Reimbursement__c!=null && ((expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c) < rule.Max_Reimbursement__c))
                        )){
                            System.debug('exliObj----'+exliObj.ExpenseAmount__c);
                            if((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100)> expObj.Selling_Support_Program_Year__r.Available_Balance__c - amountToCompare){
                                exliObj.ExpenseAmount__c = expObj.Selling_Support_Program_Year__r.Available_Balance__c - amountToCompare;
                            }
                            else{
                                exliObj.ExpenseAmount__c = (exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100);
                            }
                            System.debug('exliObj----'+exliObj.ExpenseAmount__c);
                            
                        }*/
                        
                        if(((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) > (expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c))
                            &&((rule.Max_Reimbursement__c==null && ((expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c) < expObj.Selling_Support_Program_Year__r.Available_Balance__c) )
                            ||(rule.Max_Reimbursement__c!=null && ((expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c) < rule.Max_Reimbursement__c))
                            )){
                            System.debug('exliObj...'+exliObj);
                             if(exliObj.Approval_Status__c == 'Saved'){
                             //&&(expObj.Selling_Support_Program_Year__r.Available_Balance__c!=0)
                                 System.debug('In ifffff');
                                    Decimal amountToCompare = expObj.Line_Item_Total__c - oldMap.get(exliObj.Id).ExpenseAmount__c; // +  exliObj.Total_Spend__c;
                                    amountToCompare = expObj.Selling_Support_Program_Year__r.Available_Balance__c - amountToCompare ;
                                    //If(exliObj.Total_Spend__c > amountToCompair){
                                    if((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100)> amountToCompare ){
                                        exliObj.ExpenseAmount__c = amountToCompare;
                                    }
                                    else{
                                        //exliObj.ExpenseAmount__c = exliObj.Total_Spend__c;
                                        exliObj.ExpenseAmount__c = (exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100);
                                    }                                    
                              }
                              
                              System.debug('exliObj...'+exliObj);
                            }
                        
                     
                     //If Amount requested * percentage < Max Amount and < Avail Balance Then use Amount * percentage
                     //Amount requested * percentage > Max Amount and < Avail Balance Then use Max Amount
                     else if((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) <= expObj.Selling_Support_Program_Year__r.Available_Balance__c ){
                        //if(exliObj.Approval_Status__c != 'Submitted for Approval' && exliObj.Approval_Status__c != 'Rework'){
                        if(rule.Max_Reimbursement__c==null || (rule.Max_Reimbursement__c!=null && ((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) <= rule.Max_Reimbursement__c))){
                            exliObj.ExpenseAmount__c = exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100;
                        }
                        else if(rule.Max_Reimbursement__c!=null && ((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) > rule.Max_Reimbursement__c)){
                            exliObj.ExpenseAmount__c = rule.Max_Reimbursement__c;
                        }
                        //}
                    }
                    
                    //Amount requested * percentage < Max Amount and > Avail Balance Then use Available Balance
                    //Amount requested * percentage > Max Amount and > Avail Balance Then use Minimum(Max Amount, Avail Balance)
                    else if((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) > expObj.Selling_Support_Program_Year__r.Available_Balance__c){
                        //if(exliObj.Approval_Status__c != 'Submitted for Approval' && exliObj.Approval_Status__c != 'Rework'){
                        if(rule.Max_Reimbursement__c==null || (rule.Max_Reimbursement__c!=null && ((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) <= rule.Max_Reimbursement__c))){
                            exliObj.ExpenseAmount__c = expObj.Selling_Support_Program_Year__r.Available_Balance__c;
                        }
                        else if(rule.Max_Reimbursement__c!=null && ((exliObj.Total_Spend__c*exliObj.Reimbursement_Percentage__c/100) > rule.Max_Reimbursement__c)){
                            if(rule.Max_Reimbursement__c <= expObj.Selling_Support_Program_Year__r.Available_Balance__c)
                                exliObj.ExpenseAmount__c = rule.Max_Reimbursement__c;
                            else
                                exliObj.ExpenseAmount__c = expObj.Selling_Support_Program_Year__r.Available_Balance__c;
                        }
                        //}
                    }
                     
                 }
             }
         }
    }
    
    
}