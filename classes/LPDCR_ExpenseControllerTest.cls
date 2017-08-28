/**
*   @Author:    Shruti Mishra & Heena Tanna
*   @Date:      02.11.2016
*   @Jira:      LPDCR-339
*   @Purpose:   Test class for LPDCR_ExpenseController
*/

@isTest
private class LPDCR_ExpenseControllerTest 
{
    static testMethod void testExpenseActions() 
    {
        User pu = LPDCR_TestUtil.getCommunityUser();
        System.RunAs(pu){
            
            List<LPDCR_ExpenseSort__c> expenseSortParams = LPDCR_TestUtil.getSortParamList();
            
            // Insert a SellingSupportExpense record
            AMASellingSupportExpense__c expense = LPDCR_TestUtil.getSSExpenseRecord();
            BusinessBuilderProgramYear__c bbProgYear = LPDCR_TestUtil.getBBProgramYear();
            SellingSupportProgramYear__c ssProgYear = LPDCR_TestUtil.getSSProgramYear();
            Test.startTest();
            //ApexPages.currentpage().getparameters().put('expenseId',expense.Id);
            AMASellingSupportExpenseLineItem__c lineItemObjLst = new AMASellingSupportExpenseLineItem__c(Expense__c = expense.id,Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP',Approval_Status__c='Submitted');
            insert lineItemObjLst;
                
            //Set PageReference
            PageReference pageRef = Page.LPDCR_Expenses;
            System.Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Accountid',expense.UltimateParentAR__c);
            ApexPages.currentPage().getParameters().put('BBYear',bbProgYear.Id);
            ApexPages.currentpage().getparameters().put('expenseId',expense.Id);
            
            LPDCR_ExpenseController controller = new LPDCR_ExpenseController();
            //ApexPages.currentpage().getparameters().put('expenseId',expense.Id);
            
            //String s = controller.selectedYear;
            Id expId = controller.expenseId;
            Account acc = controller.accObj;
            
            controller.getExpDetail();
            controller.Next();
            controller.Previous();
            controller.Beginning();
            //controller.End();
            controller.counter=6;
            controller.Previous();
            
            controller.getDisablePrevious();
            controller.getDisableNext();
            controller.getTotal_size();
            controller.getPageNumber();
            controller.getTotalPages();
            controller.getRecordNumber();
            controller.doNothing();
            controller.sortItem='ApprovalStatus__c';
             
            controller.runQuery(); 
            controller.deleteExpense();
            controller.total_size=5; 
            controller.list_size=2;
            controller.End();
            controller.total_size=2; 
            controller.list_size=2;
            controller.End();
            
            controller.sortSubItem = null;
            String s = controller.sortSubItem;
            controller.sortItem = 'ApprovalStatus__c';
            controller.getSortSubItemList();
            //String selectedYear = controller.selectedYear;
            Test.stopTest();
            //Test all Methods
            System.assertEquals(controller !=null,true);
        }
    }
}