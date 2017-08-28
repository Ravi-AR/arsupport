@isTest
public class AccountTriggerHandlerTest {

    public static testMethod void testCreateACL() {
        
        final Integer NO_OF_RECORDS = 10;
        
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i < NO_OF_RECORDS; ++i) {
            Account a = new Account();
            a.Name = 'test account ' + (i + 1);
            
            a.Animal_Count_1__c = (i + 1);
            a.Animals_Served_1__c = (i + 1);
            a.Animal_Type_1__c = 'Cattle';
            // a.Lifestage_1__c = 'Cattle';
            
            a.Animal_Count_2__c = (i + 2);
            a.Animals_Served_2__c = (i + 2);
            a.Animal_Type_2__c = 'Cattle';
            // a.Lifestage_2__c = 'Cattle';
            
            a.Animal_Count_3__c = (i + 3);
            a.Animals_Served_3__c = (i + 3);
            a.Animal_Type_3__c = 'Cattle';
            // a.Lifestage_3__c = 'Cattle';
            
            a.Animal_Count_4__c = (i + 4);
            a.Animals_Served_4__c = (i + 4);
            a.Animal_Type_4__c = 'Cattle';
            // a.Lifestage_4__c = 'Cattle';
            
            a.Animal_Count_5__c = (i + 5);
            a.Animals_Served_5__c = (i + 5);
            a.Animal_Type_5__c = 'Cattle';
            // a.Lifestage_5__c = 'Cattle';
           
            
            accounts.add (a);
        }
        
        Test.startTest();
        insert accounts;
        Test.stopTest();
        
        List<Animal_Count_Lifestage__c> acls = [SELECT Id, Lifestage__c, Animal_Count__c, Animal_Type__c FROM Animal_Count_Lifestage__c WHERE Account__c IN :accounts];
        //System.assertEquals (NO_OF_RECORDS * 10, acls.size());
        
    } // End: method testCreateACL
    
    public static testMethod void TestPopulateUltimateParent() {
        
        Test.startTest();
        
        Account gpAccount = new Account(Name = 'Grand Parent Account');
        insert gpAccount;
        AccountTriggerHandler.RUN_ONCE_ULTIMATE_PARENT = false;
        
        Account pAccount = new Account(Name = 'Parent Account',
                                       ParentId = gpAccount.Id
                                      );
        insert pAccount;
        AccountTriggerHandler.RUN_ONCE_ULTIMATE_PARENT = false;
        
        Account childAccount = new Account(Name = 'Child Account', 
                                           ParentId = pAccount.Id);
        insert childAccount;
        AccountTriggerHandler.RUN_ONCE_ULTIMATE_PARENT = false;
        
        Account gcAccount = new Account(Name = 'Grand Child Account',
                                        ParentId = childAccount.Id
                                       );
        insert gcAccount;
        
        Test.stopTest();
        
        Account A = [SELECT Id, Ultimate_Parent__c FROM Account WHERE Id = :gpAccount.Id];
        System.assertEquals(null, A.Ultimate_Parent__c);
        //Test Method
        List<Account> accList = new List<Account>();
        accList.add(gcAccount);
        AccountTriggerHandler.populateUltimateParentField(accList);
        
        //Account B = [SELECT Id, Ultimate_Parent__c FROM Account WHERE Id = :pAccount.Id];
        //System.assertEquals(gpAccount.Id, B.Ultimate_Parent__c);
        
        //Account C = [SELECT Id, Ultimate_Parent__c FROM Account WHERE Id = :childAccount.Id];
        //System.assertEquals(gpAccount.Id, C.Ultimate_Parent__c);
        
        //Account D = [SELECT Id, Ultimate_Parent__c FROM Account WHERE Id = :gcAccount.Id];
        //System.assertEquals(gpAccount.Id, D.Ultimate_Parent__c);
        
    } // End: Method TestPopulateUltimateParent
/**
*   @Author:    Heena Tanna
*   @Date:      15.11.2016
*   @Jira:      LPDCR-831
*   @Purpose:   Test class to cover the method accountApprovers
**/   
    public static testMethod void testaccountApprovers()
    {
       User usr = new User(alias = 'test', email='test.test@mail.com.dev12', userroleid = UserInfo.getUserRoleId(),
                                    emailencodingkey='UTF-8', lastname='Test', languagelocalekey='en_US',
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(),
                                    timezonesidkey='America/Los_Angeles', username='test.test@mail.com.dev111');
        insert usr;
        System.runAs(usr){
        //Test.StartTest();
        //User cguest = [Select Id,Name from User where Name='Heena Tanna'];

        Account up = new Account( Name = 'Ultimate Parent ');
        insert up;
        //List<Account> accc = new List<Account>();
        Account acc = new Account(Name = 'TestAccount', BusinessBuilderProgramStatus__c='Eligible', Member_Type_catcode1__c = '010-Cooperative', ParentId = up.Id,Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',AR_customer_group_JDE__C = 'RE',Business_Builder_Program_Tier__c='Certified Expert Dealer');
        //accc.add(ac);
        insert acc;//   insert ac;
        


        BusinessBuilderProgramYear__c businessyear = new BusinessBuilderProgramYear__c(Name = String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20),BBPYExternal_ID__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
        insert businessyear;
        SellingSupportProgramYear__c expenseyear = new SellingSupportProgramYear__c(Account__c= acc.Id,Name =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),BusinessBuilderProgramYear__c = businessyear.Id,Program_Year_Allocation__c = 1000000,BusinessBuilderProgramStatus__c ='Enrolled');
        insert expenseyear;
        
        List<AMASellingSupportExpense__c> expObjList = new List<AMASellingSupportExpense__c>();

        expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id, Type__c = 'Expense',Selling_Support_Program_Year__c = expenseyear.Id ,
                                                                                    Bill_To_Sold_To_Account__c = acc.id,Description__c ='Test Description1',
                                                                                    SalesOperationsBalanceAdjustment__c = 500, ApprovalStatus__c = 'Saved',
                                                                                    Internal_Status__c ='Saved', Area_Sales_Manager__c = acc.ASM_BB_Approver__c , 
                                                                                    Sales_Representative__c =acc.Business_Builder_Reimbursement_Approver__c));
        expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id, Type__c = 'Expense',Selling_Support_Program_Year__c = expenseyear.Id ,
                                                                                    Bill_To_Sold_To_Account__c = acc.id,Description__c ='Test Description2',
                                                                                    SalesOperationsBalanceAdjustment__c = 500, ApprovalStatus__c = 'Saved',
                                                                                    Internal_Status__c ='Saved', Area_Sales_Manager__c = acc.ASM_BB_Approver__c , 
                                                                                    Sales_Representative__c =acc.Business_Builder_Reimbursement_Approver__c,CurrentApprover__c = acc.Business_Builder_Reimbursement_Approver__c));
       expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id, Type__c = 'Expense',Selling_Support_Program_Year__c = expenseyear.Id ,
                                                                                    Bill_To_Sold_To_Account__c = acc.id,Description__c ='Test Description3',
                                                                                    SalesOperationsBalanceAdjustment__c = 500, ApprovalStatus__c = 'Saved',
                                                                                    Internal_Status__c ='Saved', Area_Sales_Manager__c = acc.ASM_BB_Approver__c , 
                                                                                    Sales_Representative__c =acc.Business_Builder_Reimbursement_Approver__c));
        expObjList.add(new AMASellingSupportExpense__c(DealerAccount__c= acc.Id, Type__c = 'Expense',Selling_Support_Program_Year__c = expenseyear.Id ,
                                                                                    Bill_To_Sold_To_Account__c = acc.id,Description__c ='Test Description4',
                                                                                    SalesOperationsBalanceAdjustment__c = 500, ApprovalStatus__c = 'Saved',
                                                                                    Internal_Status__c ='Saved', Area_Sales_Manager__c = acc.ASM_BB_Approver__c , 
                                                                                    Sales_Representative__c =acc.Business_Builder_Reimbursement_Approver__c,CurrentApprover__c = acc.ASM_BB_Approver__c));
     
       insert expObjList;
       Set<Id> expenseIdSet = new Set<Id>();

       expenseIdSet.add(expObjList[0].Id);
       expenseIdSet.add(expObjList[1].Id);
       expenseIdSet.add(expObjList[2].Id);
       expenseIdSet.add(expObjList[3].Id);
       
         Set<Id> accountId = new Set<id>();
         accountid.add(acc.Id);
         List<Account> accountList = [Select Id,Name,Business_Builder_Reimbursement_Approver__c,ASM_BB_Approver__c FROM Account where Id IN:accountid];
         accountList[0].Business_Builder_Reimbursement_Approver__c =usr.Id;
         accountList[0].ASM_BB_Approver__c =usr.Id;
         update accountList;
       
       List<AMASellingSupportExpense__c> expenseUpdateList = [SELECT Id,ApprovalStatus__c,Internal_Status__c,DealerAccount__c  FROM AMASellingSupportExpense__c WHERE DealerAccount__c =:accountList[0].Id];
       expenseUpdateList[0].Internal_Status__c = 'Saved';
       expenseUpdateList[0].Sales_Representative__c=accountList[0].Business_Builder_Reimbursement_Approver__c;
       expenseUpdateList[0].Area_Sales_Manager__c=accountList[0].ASM_BB_Approver__c;
       expenseUpdateList[1].Internal_Status__c = 'Submitted for Approval';
       expenseUpdateList[1].Sales_Representative__c=accountList[0].Business_Builder_Reimbursement_Approver__c;
       expenseUpdateList[1].Area_Sales_Manager__c=accountList[0].ASM_BB_Approver__c;
       expenseUpdateList[1].CurrentApprover__c =accountList[0].Business_Builder_Reimbursement_Approver__c;
       expenseUpdateList[2].Internal_Status__c = 'Approved by Sales Specialist';
       expenseUpdateList[2].Sales_Representative__c=accountList[0].Business_Builder_Reimbursement_Approver__c;
       expenseUpdateList[2].Area_Sales_Manager__c=accountList[0].ASM_BB_Approver__c;
       expenseUpdateList[3].Internal_Status__c = 'Approved by Area Sales Manager';
       expenseUpdateList[3].Sales_Representative__c=accountList[0].Business_Builder_Reimbursement_Approver__c;
       expenseUpdateList[3].Area_Sales_Manager__c=accountList[0].ASM_BB_Approver__c;
       update expenseUpdateList;
        //Test.StopTest();
        }
    }
    
    public static testmethod void updateProcessInstanceTest(){
         User usr;
         Account acc;
      /*  User usr = new User(alias = 'test', email='test.test@mail.com.dev12', userroleid = UserInfo.getUserRoleId(),
                                    emailencodingkey='UTF-8', lastname='Test', languagelocalekey='en_US',
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(),
                                    timezonesidkey='America/Los_Angeles', username='test.test@mail.com.dev111');
           insert usr;*/
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs(thisUser){
        Account up = new Account( Name = 'Ultimate Parent ');
        insert up;
        acc = new Account(Name = 'TestAccount', BusinessBuilderProgramStatus__c='Eligible', Member_Type_catcode1__c = '010-Cooperative', ParentId = up.Id,Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),ASM_BB_Approver__c=userinfo.getUserId(), Account_External_ID_JDE__c = '12345',AR_customer_group_JDE__C = 'RE',Business_Builder_Program_Tier__c='Certified Expert Dealer');
        insert acc;

        BusinessBuilderProgramYear__c businessyear = new BusinessBuilderProgramYear__c(Name = String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),StartDate__c = System.Today(),EndDate__c = System.Today().addDays(20),BBPYExternal_ID__c =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)));
        insert businessyear;
        SellingSupportProgramYear__c expenseyear = new SellingSupportProgramYear__c(Account__c= acc.Id,Name =String.valueOf(LPDCR_TestUtil.getRandomNumber(9999)),BusinessBuilderProgramYear__c = businessyear.Id,Program_Year_Allocation__c = 1000000,BusinessBuilderProgramStatus__c ='Enrolled');
        insert expenseyear;
        AMASellingSupportExpense__c expense = new AMASellingSupportExpense__c(DealerAccount__c= acc.Id, Type__c = 'Expense',Selling_Support_Program_Year__c = expenseyear.Id,
                                                                                    Bill_To_Sold_To_Account__c = acc.id,Description__c ='Test Description1',
                                                                                    SalesOperationsBalanceAdjustment__c = 500, ApprovalStatus__c = 'Submitted for Approval',
                                                                                    Internal_Status__c ='Submitted for Approval', Area_Sales_Manager__c = acc.ASM_BB_Approver__c , 
                                                                                    Sales_Representative__c =acc.Business_Builder_Reimbursement_Approver__c);
         insert expense;  
         
         
         Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
         req.setComments('Approve.');
         req.setObjectId(expense.Id);
         req.setSubmitterId(Userinfo.getUserId());
         req.setProcessDefinitionNameOrId('AMAExpenseApprovalRequest');
         //req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
         //Submit the approval request
         Approval.ProcessResult result = Approval.process(req);
         System.assert(result.isSuccess());  
         System.assertEquals('Pending', result.getInstanceStatus()); 
         
         List<Id> newWorkItemIds = result.getNewWorkitemIds();
         Approval.ProcessWorkitemRequest req2 = 
         new Approval.ProcessWorkitemRequest();
         req2.setComments('Approving request.');
         req2.setAction('Approve');
         req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});  
         req2.setWorkitemId(newWorkItemIds.get(0));
         Approval.ProcessResult result2 =  Approval.process(req2);
         System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
            System.assertEquals('Pending', result2.getInstanceStatus());
            }
        
           usr = new User(alias = 'test', email='test.test@mail.com.dev12', userroleid = UserInfo.getUserRoleId(),
                                    emailencodingkey='UTF-8', lastname='Test', languagelocalekey='en_US',
                                    localesidkey='en_US', profileid = UserInfo.getProfileId(),
                                    timezonesidkey='America/Los_Angeles', username='test.test@mail.com.dev111');
           insert usr;
         System.runAs(usr){
         Set<Id> accountId = new Set<id>();
         accountid.add(acc.Id);
         List<Account> accountList = [Select Id,Name,Business_Builder_Reimbursement_Approver__c FROM Account where Id IN:accountid];
         accountList[0].Business_Builder_Reimbursement_Approver__c =usr.Id;
         update accountList;
         
         List<AMASellingSupportExpense__c> expenseUpdateList = [SELECT Id,ApprovalStatus__c,Internal_Status__c,DealerAccount__c,Sales_Representative__c,CurrentApprover__c  FROM AMASellingSupportExpense__c WHERE DealerAccount__c IN:accountList];
         expenseUpdateList[0].Sales_Representative__c  = accountList[0].Business_Builder_Reimbursement_Approver__c;
         expenseUpdateList[0].CurrentApprover__c = accountList[0].Business_Builder_Reimbursement_Approver__c;
         update expenseUpdateList;    }
                                                                       
        
    }
    
} // End: AccountTriggerHandlerTest