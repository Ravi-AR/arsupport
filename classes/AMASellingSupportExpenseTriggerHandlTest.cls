/**
*   @Author:    Usman Ali (Magnet 360 )
*   @Date:      09.02.2016
*   @Jira:      LPDCR-234, LPDCR-235, LPDCR-327
*   @Purpose:   Test class for code coverage of AMASellingSupportExpenseTriggerHandler
*
*/


@isTest
private class AMASellingSupportExpenseTriggerHandlTest 
{
    static testMethod void testUltimateParentAR() 
    {
      
         AMASellingSupportExpenseLineItem__c expenseLineItem = LPDCR_TestUtil.getSSExpenseLineItemRecord();
        
    }
    
   
        static testMethod void testAMASellingSupportAdjustment()
        {

            AMASellingSupportExpense__c expense = LPDCR_TestUtil.getSSExpenseRecord();
            List<AMASellingSupportExpense__c> expenseList = new List<AMASellingSupportExpense__c>();
            expenseList.add(expense);
            
            AMASellingSupportExpenseTriggerHandler expenseobj = new AMASellingSupportExpenseTriggerHandler();
            AMASellingSupportExpenseTriggerHandler.setAMASellingSupportAdjustment(expenseList);
        }
        
  
    //Heena Tanna 23rd Sep 2016 LPDCR-566
    static testMethod void testExpenseLineItemsStatus()
    {
       
            //Insert Account
           Account acc = new Account( Name = 'TestAccountBalance',Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId());
            insert acc ; 

            BusinessBuilderProgramYear__c businessyear = new BusinessBuilderProgramYear__c(Name ='2020',StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20));
            insert businessyear;
            SellingSupportProgramYear__c expenseYear = new SellingSupportProgramYear__c(Account__c=acc.Id,Name ='2020',BusinessBuilderProgramYear__c = businessyear.Id,Program_Year_Allocation__c = 1000000,BusinessBuilderProgramStatus__c ='Enrolled');
            insert expenseYear;
            //Insert AMASellingSupportExpense records
           List<AMASellingSupportExpense__c> expObjList = new List<AMASellingSupportExpense__c>();
        
              expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id,UltimateParentAR__c =acc.Id,Type__c = 'Expense',SalesOperationsBalanceAdjustment__c = 100,ApprovalStatus__c = 'Submitted for Approval',Selling_Support_Program_Year__c = expenseYear.id,Internal_Status__c ='Submitted for Approval'));
              expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id,UltimateParentAR__c =acc.id,Type__c = 'Expense',SalesOperationsBalanceAdjustment__c = 200,ApprovalStatus__c = 'Saved',Selling_Support_Program_Year__c = expenseYear.id,Internal_Status__c ='Saved'));
              expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id,UltimateParentAR__c =acc.id,Type__c = 'Expense',SalesOperationsBalanceAdjustment__c = 300,ApprovalStatus__c = 'In Progress',Selling_Support_Program_Year__c = expenseYear.id,Internal_Status__c ='Approved by Sales Specialist'));   
          
              insert expObjList;
          //Insert AMASellingSupportExpenseLineItem records
          List<AMASellingSupportExpenseLineItem__c> expLineItemObjList= new List<AMASellingSupportExpenseLineItem__c>();
              expLineItemObjList.add(new AMASellingSupportExpenseLineItem__c(Expense__c=expObjList[0].Id, Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP', Total_Spend__c= 100, Approval_Status__c ='Approved'));
              expLineItemObjList.add(new AMASellingSupportExpenseLineItem__c(Expense__c=expObjList[1].Id, Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP', Total_Spend__c= 100, Approval_Status__c ='Approved'));
              expLineItemObjList.add(new AMASellingSupportExpenseLineItem__c(Expense__c=expObjList[2].Id, Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP', Total_Spend__c= 100, Approval_Status__c ='Approved'));
              
              insert expLineItemObjList;
              
            Set<Id> expenseIdSet = new Set<Id>();

            expenseIdSet.add(expObjList[0].Id);
            expenseIdSet.add(expObjList[1].Id);
            expenseIdSet.add(expObjList[2].Id);
            //Update AMASellingSupportExpense records
            List<AMASellingSupportExpense__c> expenseUpdateList = [SELECT Id,ApprovalStatus__c,Internal_Status__c  FROM AMASellingSupportExpense__c WHERE ID IN:expenseIdSet];
            
            expenseUpdateList[0].Internal_Status__c = 'Saved';
            expenseUpdateList[1].Internal_Status__c = 'Approved';
            expenseUpdateList[2].Internal_Status__c = 'Submitted for Approval';
            
            update expenseUpdateList;  
            
            //AMASellingSupportExpenseLineItem__c expenseLineItem = LPDCR_TestUtil.getSSExpenseLineItemRecord();        
            Set<Id> expenseLineIdSet = new Set<Id>();

            expenseLineIdSet.add(expLineItemObjList[0].Id);
            expenseLineIdSet.add(expLineItemObjList[1].Id);
            expenseLineIdSet.add(expLineItemObjList[2].Id);
           // expenseLineIdSet.add(expenseLineItem.Id);
          List<AMASellingSupportExpenseLineItem__c> expenseLineUpdateList = [SELECT Id,Approval_Status__c  FROM AMASellingSupportExpenseLineItem__c WHERE ID IN:expLineItemObjList];
            expenseLineUpdateList[0].Approval_Status__c = 'Saved';
            expenseLineUpdateList[1].Approval_Status__c ='Approved';
            expenseLineUpdateList[2].Approval_Status__c = 'Submitted for Approval';
            update expenseLineUpdateList;
            //update acc;     
            
    }
     static testmethod void cloneExpensesTest()
     { 
         //Insert Account
            Account acc = new Account( Name = 'TestAccountBalance',Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId());
            insert acc ; 
            BusinessBuilderProgramYear__c businessyear = new BusinessBuilderProgramYear__c(Name ='2020',StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20));
            insert businessyear;
            SellingSupportProgramYear__c expenseYear = new SellingSupportProgramYear__c(Account__c=acc.Id,Name ='2020',BusinessBuilderProgramYear__c = businessyear.Id,BusinessBuilderProgramStatus__c ='Enrolled');
            insert expenseYear;
            //Insert AMASellingSupportExpense records
           List<AMASellingSupportExpense__c> expObjList = new List<AMASellingSupportExpense__c>();
        
              expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id,UltimateParentAR__c =acc.Id,Type__c = 'Expense',SalesOperationsBalanceAdjustment__c = 100,ApprovalStatus__c = 'Submitted for Approval',Selling_Support_Program_Year__c = expenseYear.id,Internal_Status__c ='Submitted for Approval'));
              expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id,UltimateParentAR__c =acc.id,Type__c = 'Expense',SalesOperationsBalanceAdjustment__c = 200,ApprovalStatus__c = 'Saved',Selling_Support_Program_Year__c = expenseYear.id,Internal_Status__c ='Saved'));
              expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id,UltimateParentAR__c =acc.id,Type__c = 'Expense',SalesOperationsBalanceAdjustment__c = 300,ApprovalStatus__c = 'In Progress',Selling_Support_Program_Year__c = expenseYear.id,Internal_Status__c ='Approved by Sales Specialist'));   
          
              insert expObjList;
          //Insert AMASellingSupportExpenseLineItem records
          List<AMASellingSupportExpenseLineItem__c> expLineItemObjList= new List<AMASellingSupportExpenseLineItem__c>();
              expLineItemObjList.add(new AMASellingSupportExpenseLineItem__c(Expense__c=expObjList[0].Id, Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP', Total_Spend__c= 100, Approval_Status__c ='Approved'));
              expLineItemObjList.add(new AMASellingSupportExpenseLineItem__c(Expense__c=expObjList[1].Id, Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP', Total_Spend__c= 100, Approval_Status__c ='Approved'));
              expLineItemObjList.add(new AMASellingSupportExpenseLineItem__c(Expense__c=expObjList[2].Id, Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP', Total_Spend__c= 100, Approval_Status__c ='Approved'));
              
              insert expLineItemObjList;
           //AMASellingSupportExpenseLineItem__c expenseLineItem = LPDCR_TestUtil.getSSExpenseLineItemRecord();   
            Set<Id> expenseIdSet = new Set<Id>();

            expenseIdSet.add(expObjList[0].Id);
            expenseIdSet.add(expObjList[1].Id);
            expenseIdSet.add(expObjList[2].Id);
            //expenseIdSet.add(expenseLineItem.Id);
         
         
         Test.startTest();
            AMASellingSupportExpenseTriggerHandler.cloneExpenses(expenseIdSet);
         Test.stopTest();
         
     }
    
    static testmethod void setCurrentApprover()
    {
        //Insert Account
            Account acc = new Account( Name = 'TestAccountBalance',Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId());
            insert acc ; 
            BusinessBuilderProgramYear__c businessyear = new BusinessBuilderProgramYear__c(Name ='2020',StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20));
            insert businessyear;
            SellingSupportProgramYear__c expenseYear = new SellingSupportProgramYear__c(Account__c=acc.Id,Name ='2020',BusinessBuilderProgramYear__c = businessyear.Id,BusinessBuilderProgramStatus__c ='Enrolled');
            insert expenseYear;
            //Insert AMASellingSupportExpense record
             AMASellingSupportExpense__c expObj= new AMASellingSupportExpense__c(DealerAccount__c= acc.Id,UltimateParentAR__c =acc.Id,Type__c = 'Expense',SalesOperationsBalanceAdjustment__c = 100,ApprovalStatus__c = 'Submitted for Approval',Selling_Support_Program_Year__c = expenseYear.id,Internal_Status__c ='Submitted for Approval');
              insert expObj;
       //Insert AMASellingSupportExpenseLineItem record
             AMASellingSupportExpenseLineItem__c expLineItemObj= new AMASellingSupportExpenseLineItem__c(Expense__c=expObj.Id, Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP', Total_Spend__c= 100, Approval_Status__c ='Approved');            
              insert expLineItemObj;
              
              Set<Id> expenseIdSet = new Set<Id>();
              expenseIdSet.add(expObj.Id);
        
            //Initiate Approval Process
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(expObj.Id); 
            //Submit the approval request
            Approval.ProcessResult result = Approval.process(req);
            System.assert(result.isSuccess());
             Test.startTest();
             AMASellingSupportExpenseTriggerHandler.setCurrentApprover(expenseIdSet);
             Test.stopTest();

            
        
    }
}