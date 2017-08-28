/**
*   @Author:    Shruti Mishra & Heena Tanna
*   @Date:      23.09.2016
*   @Jira:      LPDCR-531, LPDCR-616
*   @Purpose:   Test class for LPDCR_ExpenseEditController
*/
@isTest
private class LPDCR_ExpenseEditControllerTest 
{
    static testMethod void testExpenseEditActions() 
    {
        User pu = LPDCR_TestUtil.getCommunityUser();
        SellingSupportProgramYear__c expenseyear = null;
        System.RunAs(pu){
            
            Test.startTest();
            //Insert Account 
            Account ac = LPDCR_TestUtil.getAccountRecord();
            //ApexPages.currentPage().getParameters().put('Accountid',ac.id);      
            //Insert SellingSupportProgramYear record
             expenseyear = LPDCR_TestUtil.getSSProgramYear();
            
            AMASellingSupportExpense__c expense = LPDCR_TestUtil.getSSExpenseRecord();
            //ApexPages.currentPage().getParameters().put('Accountid',expense.UltimateParentAR__c); 
            AMASellingSupportExpenseLineItem__c li = LPDCR_TestUtil.getSSExpenseLineItemRecord(expense.Id);            
            BusinessBuilderRules__c businessRules= LPDCR_TestUtil.getBBRuleRecord();
            System.debug('++++' + businessRules.Id);
            
            LPDCR_ExpenseEditController.upsertLineItem(null,String.valueOf(expense.Id), '50','50', 'Line Item Description','Education and Training',String.valueof(Date.Today()), 'Show VIP');
            LPDCR_ExpenseEditController.upsertLineItem(String.valueOf(li.Id),expense.Id,'50', '50', 'Line Item Description','Education and Training',String.valueof(Date.Today()), 'Show VIP');
            AMASellingSupportExpense__c reimburseExObj = [Select Id, Name from AMASellingSupportExpense__c where Id=: expense.Id];
            String expenseId = LPDCR_ExpenseEditController.saveExpense(String.valueOf(ac.Id),'Description',expenseyear.Id);
            LPDCR_ExpenseEditController.getProgramYears(ac.Id,expenseyear.Id);
            //Set PageReference
            PageReference pageRef = Page.LPDCR_ExpenseEdit;
            System.Test.setCurrentPage(pageRef);
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(reimburseExObj);
            ApexPages.currentPage().getParameters().put('Accountid',expense.UltimateParentAR__c);
            
            LPDCR_ExpenseEditController controller = new LPDCR_ExpenseEditController(stdController);
            
            
            //Test all Properties
            List<SelectOption> expenseTypes=null;
            expenseTypes = controller.expenseTypes;
            controller.expenseTypes = expenseTypes;
            
            //Test all Methods
            
            LPDCR_ExpenseEditController.getParentAccount(expenseyear.Id);
            LPDCR_ExpenseEditController.getAllCategories(expenseyear.Name);
            LPDCR_ExpenseEditController.getSubCategories('Show VIP',expenseyear.Name);
            LPDCR_ExpenseEditController.getAmountBySubCategories('Education and Training');
            LPDCR_ExpenseEditController.getExpenseDetail(expense.Id);
            LPDCR_ExpenseEditController.deleteLineItem(li.Id);
            LPDCR_ExpenseEditController.submitForApproval(expense.Id);
            String attachment = LPDCR_ExpenseEditController.uploadAttachment(String.ValueOf(expense.Id), 'Test attachmentBody', 'Test attachmentName', null);
            LPDCR_ExpenseEditController.uploadAttachment(String.ValueOf(expense.Id), 'Test attachmentBody', 'Test attachmentName', attachment);
            System.assertEquals(controller !=null,true);
            Test.stopTest();
            
        }
        
        
        //LPDCR_ExpenseEditController.getAllCategories(expenseyear.Name);
    }
    
    static testMethod void testExpensesave() 
    {   User pu = LPDCR_TestUtil.getCommunityUser();
     System.RunAs(pu){
             Contact con;
             Account accc;  
            List<User> userList = new List<User>(); 
            List<Account> acList = new List<Account>();
            acList.add(new Account(Name = 'TestAcc',Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',BusinessBuilderProgramStatus__c ='Registration Approved',Business_Builder_Program_Tier__c='Certified Expert Dealer',Billing_Address_Type_JDE__c = 'X - Active Parent/Child Customer'));
            insert acList;
            accc = (new Account(Name = 'TestAcc',Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',BusinessBuilderProgramStatus__c ='Registration Approved',Business_Builder_Program_Tier__c='Certified Expert Dealer',Billing_Address_Type_JDE__c = 'X - Active Parent/Child Customer'));
            insert accc;
            con = (new Contact(AccountId = accc.id, lastname = 'Dealer'));
            insert con;
            BusinessBuilderProgramYear__c businessyear = new BusinessBuilderProgramYear__c(Name = String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20),BBPYExternal_ID__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
            insert businessyear;
            RecordType ssRecType = [Select Id From RecordType  Where SobjectType = 'SellingSupportProgramYear__c' and DeveloperName = 'Standard'];
            SellingSupportProgramYear__c expenseyear = new SellingSupportProgramYear__c(Account__c= accc.Id,recordtypeid = ssRecType.id,Name =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),BusinessBuilderProgramYear__c = businessyear.Id,Program_Year_Allocation__c = 10000,BusinessBuilderProgramStatus__c ='Enrolled');
            insert expenseyear;
            BusinessBuilderRules__c businessRules= new BusinessBuilderRules__c(Name = 'Education and Training', Reimbursement_Percentage__c = 100.00,
                                                    Active__c = true, Description__c = 'Business rule', Category__c = 'Education and Training', 
                                                    Checkpoint_Multiplier__c= 2, Max_Reimbursement__c= 50000 ,Reimbursement_Subcategory__c = 'Show VIP',ApplicableYears__c = String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
            insert businessRules;
            AMASellingSupportExpense__c expenserecord = new AMASellingSupportExpense__c(DealerAccount__c= accc.Id, Type__c = 'Expense', 
                                                                                    Selling_Support_Program_Year__c = expenseyear.Id, Bill_To_Sold_To_Account__c = accc.id,Description__c ='Test Description',                                                                                   SalesOperationsBalanceAdjustment__c = 500, ApprovalStatus__c = 'Submitted for Approval',
                                                                                    Internal_Status__c ='Submitted for Approval', Area_Sales_Manager__c = accc.ASM_BB_Approver__c , 
                                                                                    Sales_Representative__c =accc.Business_Builder_Reimbursement_Approver__c );
            insert expenserecord;
            AMASellingSupportExpenseLineItem__c lineItemObjLst = new AMASellingSupportExpenseLineItem__c(Expense__c = expenserecord.id,
            Approval_Status__c='Submitted',Reimbursement_Category__c ='Education and Training',
            Reimbursement_Sub_category__c='Show VIP',Total_Spend__c =200);
            insert lineItemObjLst;
            Test.startTest();
                    Attachment attach = new Attachment();     
                    attach.Name = 'Unit Test Attachment';
                    Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
                    attach.body = bodyBlob;
                    attach.parentId = lineItemObjLst.id;
                    insert attach; 
                    Attachment attach1 = new Attachment();     
                    attach1.Name = 'Unit Test Attachment1';
                    Blob bodyBlob1 = Blob.valueOf('Unit Test Attachment1 Body');
                    attach1.body = bodyBlob1;
                    attach1.parentId = lineItemObjLst.id;
                    insert attach1; 
                    List<Attachment> att1 = [select id, name from Attachment where parent.id =: lineItemObjLst.id];
                    //System.assertEquals(2, att1.size());
                    delete attach;

                List<Attachment> att2 = [select id, name from Attachment where parent.id =: lineItemObjLst.id];
               //System.assertEquals(1, att2.size());
               AMASellingSupportExpense__c expense = new AMASellingSupportExpense__c(DealerAccount__c= accc.Id, Type__c = 'Expense', 
                                                                                    Selling_Support_Program_Year__c = expenseyear.Id, Bill_To_Sold_To_Account__c = accc.id,Description__c ='Test Description',                                                                                   SalesOperationsBalanceAdjustment__c = 500, ApprovalStatus__c = 'Submitted for Approval',
                                                                                    Internal_Status__c ='Submitted for Approval', Area_Sales_Manager__c = accc.ASM_BB_Approver__c , 
                                                                                    Sales_Representative__c =accc.Business_Builder_Reimbursement_Approver__c );
            insert expense;
                AMASellingSupportExpenseLineItem__c lineItem = new AMASellingSupportExpenseLineItem__c(Expense__c = expense.id,
                    Approval_Status__c='Submitted',Reimbursement_Category__c ='Education and Training',
                    Reimbursement_Sub_category__c='Show VIP',Total_Spend__c =300);
                    insert lineItem;
                List<AMASellingSupportExpenseLineItem__c> deleteLineItem = [Select Id,Name from AMASellingSupportExpenseLineItem__c where Id =:lineItem.id];
                delete lineItem;
                List<AMASellingSupportExpense__c> deleteexpense =[Select Id,Name from AMASellingSupportExpense__c where Id =: expense.id];
                delete deleteexpense;
            
              
        
        String accexpenseId = LPDCR_ExpenseEditController.saveExpense(String.valueOf(accc.Id),'Description',expenseyear.Id);
        LPDCR_ExpenseEditController.saveExpense(String.valueOf(accc.Id),'Description',expenseyear.Id);
        String attachment = LPDCR_ExpenseEditController.uploadAttachment(String.ValueOf(lineItemObjLst.Id), 'Unit Test Attachment Body', 'Unit Test Attachment Body', null); 
        LPDCR_ExpenseEditController.uploadAttachment(String.ValueOf(lineItemObjLst.Id), 'Unit Test Attachment Body', 'Unit Test Attachment Body', attachment); 
        LPDCR_ExpenseEditController.deleteAttachment(attach.id); 
        LPDCR_ExpenseEditController.deleteLineItem(lineItem.id);
        LPDCR_ExpenseEditController.deleteExpense(expenserecord.id);
        Test.stopTest();
        
         
     }  
    }
    
}