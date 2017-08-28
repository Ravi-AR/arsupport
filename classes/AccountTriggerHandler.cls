public without sharing class AccountTriggerHandler {

    public static Boolean RUN_ONCE_ULTIMATE_PARENT = false;
    
    public static void beforeUpdate(List<Account> accounts) {
       if(!AccountTriggerHandler.RUN_ONCE_ULTIMATE_PARENT) {
            //populateUltimateParentField(accounts);
            AccountTriggerHandler.RUN_ONCE_ULTIMATE_PARENT = true;
        }        
    } // End: Method beforeUpdate
    
    public static void beforeInsert (List<Account> accounts) {
       if(!AccountTriggerHandler.RUN_ONCE_ULTIMATE_PARENT) {
            //populateUltimateParentField(accounts);
            AccountTriggerHandler.RUN_ONCE_ULTIMATE_PARENT = true;
        }
    } // End: Method beforeInsert
    
    public static void afterInsert (List<Account> accounts) {
            
        createACL(accounts);
        //start My code      
        
         //PopulateAcctTeamMembers.populateTeamMembersForNewChildAcct(Trigger.new);
       
        //end of My code
        
        
    } // End: Method afterInsert
   @TestVisible
    private static void populateUltimateParentField(List<Account> newAccounts) {
        
        Set<ID> parentAccountIds = new Set<ID>();
        for(Account a : newAccounts) {
            parentAccountIds.add(a.ParentId);
        }
        
        List<Account> directParents = [SELECT Id, ParentId FROM Account 
                                       WHERE ParentId != NULL 
                                        AND Id IN :parentAccountIds];
        
        Map<ID, ID> accIdToParentAccId = new Map<ID, ID>();
        for(Account a : directParents) {
            accIdToParentAccId.put(a.Id, a.ParentId);
        }
        
        // Iterate upto no. of levels or until no furthur parents are available
        // Query the account where parent account is not null
        // populate account to parent Account map
        Boolean isParentAvailable = true;
        final Integer NO_OF_LEVEL = 6;
        for(Integer i=0; i < NO_OF_LEVEL && isParentAvailable; ++i) {
            List<Account> accounts = [SELECT Id, ParentId FROM Account 
                                      WHERE ParentId != NULL 
                                        AND Id IN :accIdToParentAccId.values()];
            if(!accounts.isEmpty()) {
                for(Account a : accounts) {
                    accIdToParentAccId.put(a.Id, a.ParentId);
                }
            }
            else {
                isParentAvailable = false;
            }
        } // End: for loop
        
        system.debug('accIdToParentAccId: ' + accIdToParentAccId);
        
        for(Account a : newAccounts) {
            
            Id currentParentId = a.ParentId;
            Boolean isUltimateParentSet = false;
            while(currentParentId != null && !isUltimateParentSet) {
                Id nextParentId = accIdToParentAccId.get(currentParentId);
                if(nextParentId == null) {
                    a.Ultimate_Parent__c = currentParentId;
                    isUltimateParentSet = true;
                }
                else {
                    currentParentId = nextParentId;
                    nextParentId = null;
                }
            } // End: while
            
        } // End: for
        
    } // End: Method populateUltimateParentField
    
    private static void createACL(Account[] accounts) {
        
        List<Animal_Count_Lifestage__c> acls = new List<Animal_Count_Lifestage__c>();
        
        for(Account a : accounts) {
            
            if (a.Animal_Count_1__c != null && a.Animal_Type_1__c != null) {
                acls.add (new Animal_Count_Lifestage__c(Lifestage__c = a.Lifestage_1__c, 
                                                        Animal_Count__c = a.Animal_Count_1__c,
                                                        Animals_Served__c = a.Animals_Served_1__c, 
                                                        Account__c = a.Id, 
                                                        Animal_Type__c = a.Animal_Type_1__c));
            }
            if (a.Animal_Count_2__c != null && a.Animal_Type_2__c != null) {
                acls.add (new Animal_Count_Lifestage__c(Lifestage__c = a.Lifestage_2__c, 
                                                        Animal_Count__c = a.Animal_Count_2__c,
                                                        Animals_Served__c = a.Animals_Served_2__c, 
                                                        Account__c = a.Id, 
                                                        Animal_Type__c = a.Animal_Type_2__c));
            }
            if (a.Animal_Count_3__c != null && a.Animal_Type_3__c != null) {
                acls.add (new Animal_Count_Lifestage__c(Lifestage__c = a.Lifestage_3__c, 
                                                        Animal_Count__c = a.Animal_Count_3__c,
                                                        Animals_Served__c = a.Animals_Served_3__c, 
                                                        Account__c = a.Id, 
                                                        Animal_Type__c = a.Animal_Type_3__c));
            }
            if (a.Animal_Count_4__c != null && a.Animal_Type_4__c != null) {
                acls.add (new Animal_Count_Lifestage__c(Lifestage__c = a.Lifestage_4__c, 
                                                        Animal_Count__c = a.Animal_Count_4__c,
                                                        Animals_Served__c = a.Animals_Served_4__c, 
                                                        Account__c = a.Id, 
                                                        Animal_Type__c = a.Animal_Type_4__c));
            }
            if (a.Animal_Count_5__c != null && a.Animal_Type_5__c != null) {
                acls.add (new Animal_Count_Lifestage__c(Lifestage__c = a.Lifestage_5__c, 
                                                        Animal_Count__c = a.Animal_Count_5__c, 
                                                        Animals_Served__c = a.Animals_Served_5__c,
                                                        Account__c = a.Id, 
                                                        Animal_Type__c = a.Animal_Type_5__c));
            }

        } // End: for
        
        if (!acls.isEmpty()) {
            insert acls;
        }
        
    } // End: Method createACL
/**
*   @Author:    Heena Tanna
*   @Date:      12.11.2016
*   @Jira:      LPDCR-831
*   @Purpose:   Method to check Account Approvers
**/
public static String accountApprovers(Map<Id,Account> accountNewMap,Map<Id,Account> accountOldMap)
{
    
    try{
    Set<Id> accountIdSet = new Set<Id>();
    Set<Id> accountTeamIdSet = new Set<Id>();
    List<Account> accounts = new List<Account>();
    List<AccountTeamMember> accountTeam = new List<AccountTeamMember>();
    List<AMASellingSupportExpense__c> expenseList = new List<AMASellingSupportExpense__c>();
    Map<Id,Account> accApproverMap = new Map<Id,Account>();
    Set<String> statusSet = new Set<String>{'Approved by Sales Specialist','Approved by Area Sales Manager','Saved','Submitted for Approval'};
    String errorMessage = '0';
    
    for(Id accountId:accountNewMap.keySet())
    {
        Account newRecord = accountNewMap.get(accountId);
        Account oldRecord = accountOldMap.get(accountId);
        
        if((newRecord.ASM_BB_Approver__c != null && newRecord.ASM_BB_Approver__c != oldRecord.ASM_BB_Approver__c ) ||
        (newRecord.Business_Builder_Reimbursement_Approver__c != null && newRecord.Business_Builder_Reimbursement_Approver__c != oldRecord.Business_Builder_Reimbursement_Approver__c) )
        {
            accountIdSet.add(accountId);
            accApproverMap.put(accountId,accountNewMap.get(accountId));
        }
    }   
        System.debug('accountID++++' + accountIdSet);
      
         for(Account acc :[Select Id, ASM_BB_Approver__c,Business_Builder_Reimbursement_Approver__c
         From Account Where Id IN :accountIdSet])
        {   
                       
            System.debug('+++++'+ acc.ASM_BB_Approver__c);
            System.debug('+++++'+ acc.Business_Builder_Reimbursement_Approver__c);
           
           if(acc!=null)
            {
                
                  for(AMASellingSupportExpense__c expense:[Select Id,DealerAccount__c,Bill_To_Sold_To_Account__c,
                  Area_Sales_Manager__c,Sales_Representative__c,Internal_Status__c,ApprovalStatus__c,CurrentApprover__c,CurrentUserIsApprover__c 
                  FROM AMASellingSupportExpense__c WHERE DealerAccount__c =: accountIdSet])
                  {
                      System.debug('check' + expense.DealerAccount__c);
                   Account accApprover = accApproverMap.get(expense.DealerAccount__c);
                   
                   if(accApprover!=null)
                   {
                       if(statusSet.contains(expense.Internal_Status__c) && expense.Internal_Status__c == 'Saved')//LPDCR-1109
                       {
                       expense.Area_Sales_Manager__c = accApprover.ASM_BB_Approver__c;
                       expense.Sales_Representative__c = accApprover.Business_Builder_Reimbursement_Approver__c;
                       }
                        if(statusSet.contains(expense.Internal_Status__c) && expense.Internal_Status__c == 'Approved by Area Sales Manager')//LPDCR-1109
                       {
                       expense.Area_Sales_Manager__c = accApprover.ASM_BB_Approver__c;
                       expense.Sales_Representative__c = accApprover.Business_Builder_Reimbursement_Approver__c;
                       }  
                       //1538
                       if(statusSet.contains(expense.Internal_Status__c) && expense.Internal_Status__c == 'Submitted for Approval')//LPDCR-1538
                       {
                       expense.Area_Sales_Manager__c = accApprover.ASM_BB_Approver__c;
                       expense.Sales_Representative__c = accApprover.Business_Builder_Reimbursement_Approver__c;
                       expense.CurrentApprover__c = accApprover.Business_Builder_Reimbursement_Approver__c;//1538
                       }
                       if(statusSet.contains(expense.Internal_Status__c) && expense.Internal_Status__c == 'Approved by Sales Specialist')//LPDCR-1538
                       {
                       expense.Area_Sales_Manager__c = accApprover.ASM_BB_Approver__c;
                       expense.Sales_Representative__c = accApprover.Business_Builder_Reimbursement_Approver__c;
                       expense.CurrentApprover__c = accApprover.ASM_BB_Approver__c;//1538
                       }

                   }
                   expenseList.add(expense);
                  }
                  
            System.debug('expenseASM'+ expenseList);
            
            } 
                
        }
        upsert expenseList;
        System.debug('upsertexpenseASM'+ expenseList);
        return errorMessage ;                                         
     }
     catch(Exception ex)
       {
           System.debug('Exception occurred- '+ex);
           return null;
       }
 }
 
 //1538
 public static void updateProcessInstance(Map<Id,Account> accountNewMap, Map<Id,Account> accountOldMap)
 {  
      
     //List <AMASellingSupportExpense__c> expObjList = new List<AMASellingSupportExpense__c>();
     Set<String> statusSet = new Set<String>{'Approved by Sales Specialist','Submitted for Approval'};
     //Set<ID> expenseIdSet = new Set<Id>();
     //Set<ID> accountIdSet = new Set<ID>();
     Map<Id,Account> accApproverMap = new Map<Id,Account>();
     Map<Id,AMASellingSupportExpense__c> expenseRequestMap = new Map<Id,AMASellingSupportExpense__c>();
     try
     {      for(Id accountId:accountNewMap.keySet())
             {
                 Account newRecord = accountNewMap.get(accountId);
                 Account oldRecord = accountOldMap.get(accountId);
                if((newRecord.Business_Builder_Reimbursement_Approver__c != oldRecord.Business_Builder_Reimbursement_Approver__c) || (newRecord.ASM_BB_Approver__c != oldRecord.ASM_BB_Approver__c) )
                {
                    //accountIdSet.add(accountId);
                    accApproverMap.put(accountId,newRecord);
                }
             }
            for(AMASellingSupportExpense__c expObj : [Select ID,Name,Sales_Representative__c,Area_Sales_Manager__c,Internal_Status__c, DealerAccount__c,CurrentApprover__c FROM AMASellingSupportExpense__c WHERE Internal_Status__c IN:statusSet AND DealerAccount__c =: accApproverMap.keySet()]) 
                {
                                
                    expenseRequestMap.put(expObj.Id, expObj);
                    //expenseIdSet.add(expObj);
                                
                }
                     
                List<ProcessInstanceWorkitem> workItemList = [Select ProcessInstance.Status,ProcessInstance.TargetObjectId,ProcessInstanceId,OriginalActorId,ActorId,Actor.Name FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN: expenseRequestMap.keySet() AND (ProcessInstance.Status ='Pending'OR ProcessInstance.Status ='Reassigned')];

                      for(ProcessInstanceWorkitem workItem:workItemList)
                      {
                            Id accountId = expenseRequestMap.get(workItem.ProcessInstance.TargetObjectId).DealerAccount__c;
                            String approveStatus = expenseRequestMap.get(workItem.ProcessInstance.TargetObjectId).Internal_Status__c;
                            
                            Account newRecord = new Account();
                            
                            if(accountId != null)
                                newRecord = accApproverMap.get(accountId);
                            
                            if(newRecord.Id != null && approveStatus == 'Submitted for Approval' ){
                                 //workItem.ActorId =newRecord.Business_Builder_Reimbursement_Approver__c;
                               workItem.OriginalActorId =newRecord.Business_Builder_Reimbursement_Approver__c;//new added
                                
                                }  
                           else if(newRecord.Id != null && approveStatus =='Approved by Sales Specialist')
                           {
                              //workItem.ActorId =newRecord.ASM_BB_Approver__c;
                               workItem.OriginalActorId =newRecord.ASM_BB_Approver__c;//new added
                           }
                          
                      }
                      
                if(workItemList.size()>0){
                    update workItemList;
                }
            
         
     }
    
    catch(Exception ex)
       {
           System.debug('Exception occurred- '+ex);
           
       }
     
 }
  

} // End: AccountTriggerHandler