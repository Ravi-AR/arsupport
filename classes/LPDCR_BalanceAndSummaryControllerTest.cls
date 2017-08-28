/**
*   @Author:    Heena Tanna
*   @Date:      24.02.2017
*   @Jira:      LPDCR-1811
*   @Purpose:   Test class for code coverage of LPDCR_BalanceAndSummaryController
*
*/

@isTest
public class LPDCR_BalanceAndSummaryControllerTest
{
    static testMethod void testExpenseLineItemsStatus()
    {
         User pu = LPDCR_TestUtil.getCommunityUser();
          System.RunAs(pu)
        {
            //Insert Account
           Account acc = new Account( Name = 'TestAccountBalance',Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId());
            insert acc ; 

            BusinessBuilderProgramYear__c businessyear = new BusinessBuilderProgramYear__c(Name ='2020',StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20));
            insert businessyear;
            RecordType rt = [SELECT Id FROM RecordType WHERE Name='Standard' AND SobjectType='SellingSupportProgramYear__c'];
            SellingSupportProgramYear__c expenseYear = new SellingSupportProgramYear__c(recordTypeId=rt.id,Account__c=acc.Id,Name ='2020',BusinessBuilderProgramYear__c = businessyear.Id,Program_Year_Allocation__c = 1000000,BusinessBuilderProgramStatus__c ='Enrolled');
            insert expenseYear;
            //Insert AMASellingSupportExpense records
           List<AMASellingSupportExpense__c> expObjList = new List<AMASellingSupportExpense__c>();
        
              expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id,UltimateParentAR__c =acc.Id,Type__c = 'Expense',SalesOperationsBalanceAdjustment__c = 100,ApprovalStatus__c = 'In Progress',Selling_Support_Program_Year__c = expenseYear.id,Internal_Status__c ='Approved by Sales Specialist'));
              expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id,UltimateParentAR__c =acc.id,Type__c = 'Expense',SalesOperationsBalanceAdjustment__c = 200,ApprovalStatus__c = 'Saved',Selling_Support_Program_Year__c = expenseYear.id,Internal_Status__c ='Saved'));
              expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id,UltimateParentAR__c =acc.id,Type__c = 'Expense',SalesOperationsBalanceAdjustment__c = 300,ApprovalStatus__c = 'Saved',Selling_Support_Program_Year__c = expenseYear.id,Internal_Status__c ='Saved'));   
              
              insert expObjList;
            
              
                //Insert AMASellingSupportExpenseLineItem records
          List<AMASellingSupportExpenseLineItem__c> expLineItemObjList= new List<AMASellingSupportExpenseLineItem__c>();
              expLineItemObjList.add(new AMASellingSupportExpenseLineItem__c(Expense__c=expObjList[0].Id, Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP', Total_Spend__c= 100, Approval_Status__c ='In Progress',ExpenseAmount__c=100));
              expLineItemObjList.add(new AMASellingSupportExpenseLineItem__c(Expense__c=expObjList[1].Id, Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP', Total_Spend__c= 100, Approval_Status__c ='Saved',ExpenseAmount__c=100));
              expLineItemObjList.add(new AMASellingSupportExpenseLineItem__c(Expense__c=expObjList[2].Id, Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP', Total_Spend__c= 100, Approval_Status__c ='Saved',ExpenseAmount__c=100));
              
              insert expLineItemObjList;
              
            Set<Id> expenseIdSet = new Set<Id>();

            expenseIdSet.add(expObjList[0].Id);
            expenseIdSet.add(expObjList[1].Id);
            expenseIdSet.add(expObjList[2].Id);
            
            //Update AMASellingSupportExpense records
            List<AMASellingSupportExpense__c> expenseUpdateList = [SELECT Id,ApprovalStatus__c,Internal_Status__c  FROM AMASellingSupportExpense__c WHERE ID IN:expenseIdSet];
            
            expenseUpdateList[0].Internal_Status__c = 'Approved by Sales Specialist';
            expenseUpdateList[1].Internal_Status__c = 'Approved Sales Operations';
            expenseUpdateList[2].Internal_Status__c = 'Complete - Paid in Full';
            
            update expenseUpdateList;  
            
            
            Set<Id> expenseLineIdSet = new Set<Id>();

            expenseLineIdSet.add(expLineItemObjList[0].Id);
            expenseLineIdSet.add(expLineItemObjList[1].Id);
            expenseLineIdSet.add(expLineItemObjList[2].Id);
            
            
          List<AMASellingSupportExpenseLineItem__c> expenseLineUpdateList = [SELECT Id,Approval_Status__c  FROM AMASellingSupportExpenseLineItem__c WHERE ID IN:expLineItemObjList];
            expenseLineUpdateList[0].Approval_Status__c = 'In Progress';
            expenseLineUpdateList[1].Approval_Status__c ='Approved';
            expenseLineUpdateList[2].Approval_Status__c = 'Approved';
            update expenseLineUpdateList;
           
            
            
            PageReference pref = Page.LPDCR_BalanceAndSummary;
            Test.setCurrentPage(pref);
            
            ApexPages.currentPage().getParameters().put('BBYear',businessyear.Id);
            ApexPages.currentPage().getParameters().put('selectedAccountId',acc.Id);
                    
            LPDCR_BalanceAndSummaryController controller = new LPDCR_BalanceAndSummaryController();
            //LPDCR_BalanceAndSummaryController stdController = new LPDCR_BalanceAndSummaryController(new ApexPages.StandardController(expObjList[0]));
            
            controller.initialize();
            ApexPages.currentPage().getParameters().put('selectedAccountId',null);
            Test.startTest();
            controller.initialize();
            Test.stopTest();
            
            LPDCR_BalanceAndSummaryController.CategoryWrapper ob = new LPDCR_BalanceAndSummaryController.CategoryWrapper();
            LPDCR_BalanceAndSummaryController.SubCategoryWrapper ob2 = new LPDCR_BalanceAndSummaryController.SubCategoryWrapper();
            
            
            
            }
    }

}