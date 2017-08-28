/**
*   @Author:    Heena Tanna
*   @Date:      09.20.2016
*   @Jira:      LPDCR-565
*   @Purpose:   Test class for code coverage of AMASSExpenseLineItemTriggerHandler
*
*/
@isTest
public class AMASSExpenseLineItemTriggerHandlTest
{
  static testMethod void testLineItemFields()
  {
    BusinessBuilderRules__c businessRules= LPDCR_TestUtil.getBBRuleRecord();
    SellingSupportProgramYear__c expenseYear =LPDCR_TestUtil.getSSProgramYear();
    //AMASellingSupportExpense__c expense =  LPDCR_TestUtil.getSSExpenseRecord();
    AMASellingSupportExpenseLineItem__c expenseLineItem = LPDCR_TestUtil.getSSExpenseLineItemRecord();
    List<AMASellingSupportExpenseLineItem__c> expenseLineItemList = new List<AMASellingSupportExpenseLineItem__c>();
    expenseLineItemList.add(expenseLineItem); 
    
    Map<Id,AMASellingSupportExpenseLineItem__c> expenseLineItemMap = new Map<Id,AMASellingSupportExpenseLineItem__c>();
    expenseLineItemMap.put(expenseLineItem.id,expenseLineItem);
    
      
      //test all methods
      //Condition 1
      AMASSExpenseLineItemTriggerHandler.populateLineItemFields(expenseLineItemList);
      AMASSExpenseLineItemTriggerHandler.updateLineItem(expenseLineItemList,expenseLineItemMap);
      
      //Condition 2
      Test.startTest();
      expenseLineItem.Total_Spend__c = 2000001;
      expenseLineItem.Approval_Status__c = 'Saved';
      update expenseLineItem;
      
      AMASSExpenseLineItemTriggerHandler.populateLineItemFields(expenseLineItemList);
      AMASSExpenseLineItemTriggerHandler.updateLineItem(expenseLineItemList,expenseLineItemMap);
      
      //Condition 3
      
      businessRules= new BusinessBuilderRules__c(Name = 'Education and Training', Reimbursement_Percentage__c = 100.00,
                                                    Active__c = true, Description__c = 'Business rule', Category__c = 'Education and Training', 
                                                    Checkpoint_Multiplier__c= 2, Max_Reimbursement__c= 0 ,Reimbursement_Subcategory__c = 'Show VIP',ApplicableYears__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
      insert businessRules;
      expenseLineItem.Total_Spend__c = 2000001;
      update expenseLineItem;
      
      AMASSExpenseLineItemTriggerHandler.populateLineItemFields(expenseLineItemList);
      AMASSExpenseLineItemTriggerHandler.updateLineItem(expenseLineItemList,expenseLineItemMap);
      System.assertEquals(businessRules!=null,true);
	  
      //Condition 4 Max_Reimbursment__c = null
      businessRules= new BusinessBuilderRules__c(Name = 'Education and Training', Reimbursement_Percentage__c = 100.00,
                                                    Active__c = true, Description__c = 'Business rule', Category__c = 'Education and Training', 
                                                    Checkpoint_Multiplier__c= 2, Max_Reimbursement__c= null ,Reimbursement_Subcategory__c = 'Show VIP',ApplicableYears__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
      insert businessRules;
      expenseLineItem.Total_Spend__c = 2000001;
      update expenseLineItem;
      //update expense;
      
      AMASSExpenseLineItemTriggerHandler.populateLineItemFields(expenseLineItemList);
      AMASSExpenseLineItemTriggerHandler.updateLineItem(expenseLineItemList,expenseLineItemMap);
      
      //Condition 5 Total_Spend__c < Max_Reimbursment__c
      businessRules= new BusinessBuilderRules__c(Name = 'Education and Training', Reimbursement_Percentage__c = 100.00,
                                                    Active__c = true, Description__c = 'Business rule', Category__c = 'Education and Training', 
                                                    Checkpoint_Multiplier__c= 2, Max_Reimbursement__c= 200 ,Reimbursement_Subcategory__c = 'Show VIP',ApplicableYears__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
      insert businessRules;
      expenseLineItem.Reimbursement_Percentage__c=100;
      expenseLineItem.Total_Spend__c = 3000;
      update expenseLineItem;
      
      AMASSExpenseLineItemTriggerHandler.populateLineItemFields(expenseLineItemList);
      AMASSExpenseLineItemTriggerHandler.updateLineItem(expenseLineItemList,expenseLineItemMap);
      Test.stopTest();
      
  }

}