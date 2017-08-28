/**
*   @Author:    Heena Tanna
*   @Date:      16.02.2017
*   @Jira:      LPDCR-1771
*   @Purpose:   Test class for code coverage of LPDCR_ReimbursementLineItemController
*
*/




@isTest
public class LPDCR_ReimbursementLineItemContTest
{
     public static testMethod void saveLineItem() 
    {
       //User pu = LPDCR_TestUtil.getCommunityUser();
      //  System.RunAs(pu)
        {
             /*Account ac = LPDCR_TestUtil.getAccountRecord();
             
             BusinessBuilderProgramYear__c businessyear = LPDCR_TestUtil.getBBProgramYear();
             SellingSupportProgramYear__c ssYear = LPDCR_TestUtil.getSSProgramYear();
             AMASellingSupportExpenseLineItem__c expenseLineItem = LPDCR_TestUtil.getSSExpenseLineItemRecord();*/
             //Insert Account
            Account acc = new Account( Name = 'TestAccountBalance',Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId());
            insert acc ; 
            BusinessBuilderProgramYear__c businessyear = new BusinessBuilderProgramYear__c(Name ='2016',StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20));
            insert businessyear;
            SellingSupportProgramYear__c expenseYear = new SellingSupportProgramYear__c(Account__c=acc.Id,Name ='2016',BusinessBuilderProgramYear__c = businessyear.Id,BusinessBuilderProgramStatus__c ='Enrolled');
            insert expenseYear;
              BusinessBuilderRules__c businessRules= new BusinessBuilderRules__c(Name = 'Education and Training', Reimbursement_Percentage__c = 100.00,
                                                    Active__c = true, Description__c = 'Business rule', Category__c = 'Education and Training', 
                                                    Checkpoint_Multiplier__c= 2, Max_Reimbursement__c= 500000 ,Reimbursement_Subcategory__c = 'Show VIP',ApplicableYears__c = '2016');
        insert businessRules;
            //Insert AMASellingSupportExpense record
             AMASellingSupportExpense__c expObj= new AMASellingSupportExpense__c(DealerAccount__c= acc.Id,UltimateParentAR__c =acc.Id,Type__c = 'Expense',SalesOperationsBalanceAdjustment__c = 100,Selling_Support_Program_Year__c = expenseYear.Id,ApprovalStatus__c = 'Submitted for Approval',Internal_Status__c ='Submitted for Approval');
              insert expObj;
       //Insert AMASellingSupportExpenseLineItem record
             AMASellingSupportExpenseLineItem__c expLineItemObj= new AMASellingSupportExpenseLineItem__c(Expense__c=expObj.Id, Reimbursement_Category__c = 'Education and Training', Reimbursement_Sub_category__c = 'Show VIP', Total_Spend__c= 100, Approval_Status__c ='Approved');            
              insert expLineItemObj;
             
             
             PageReference pageRef = Page.LPDCR_ReimbursementLineItem;
             pageRef.getParameters().put('id', String.valueOf(expLineItemObj.Id));
             Test.setCurrentPage(pageRef);
             
             
             //LPDCR_ReimbursementLineItemController controller = new LPDCR_ReimbursementLineItemController();
             
             ApexPages.StandardController sc = new ApexPages.StandardController(expLineItemObj);
             LPDCR_ReimbursementLineItemController testexp = new LPDCR_ReimbursementLineItemController(sc);
             testexp.saveLineItem();
             testexp.getCategorySelectList();
             testexp.getSubCategorySelectList();
             testexp.backMethod();
             
        }
         
    }
    public static Integer getRandomNumber(Integer size){
          Double d = math.random() * size;
          return d.intValue();
    }

}