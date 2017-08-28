/**
*   @Author:    Usman Ali (Magnet 360 )
*   @Date:      09.02.2016
*   @Jira:      LPDCR-234, LPDCR-235, LPDCR-327
*   @Purpose:   Trigger to Update UltimateParentAR field from related Dealer( Account.UltimateParentAR )
*
*/
public without sharing class AMASellingSupportExpenseTriggerHandler 
{
    //Heena Tanna 22st Sep 2016 LPDCR-566
    
    public static String STR_APPROVED = 'Approved' ;    
    public static String STR_APPROVEDWITHCREDIT =  'Approved with Credit Memo'; 
    public static String STR_SUBMITTEDFORAPPROVAL =  'Submitted for Approval'; 
    public static String STR_ENTEREDBYSALESADMIN =  'Entered by Sales Admin'; 
    
    public static void populateUltimateParentAR(List<AMASellingSupportExpense__c> expenses ) 
    {
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Id> accountIdToUltimateParentId = new Map<Id,Id>();
        Map<Id,Account> accountIdToAccountRecordMap = new Map<Id,Account>();
        try{
        // Iterate over inserted records and get dealer(Account) Ids
        for( AMASellingSupportExpense__c ex : expenses )
        {
            if(ex.DealerAccount__c != null ) accountIds.add(ex.DealerAccount__c);
        }
        System.debug('UAC: accountIds ' + accountIds);
        
        // No need to further process if no account(dealer) Id found
        if( accountIds.size() == 0 ) return ;

        // Get Dealers detail from Account 
        for( Account ac : [SELECT Id, ParentId,Business_Builder_Reimbursement_Approver__c, ASM_BB_Approver__c,Business_Builder_Reimbursement_Approver__r.ManagerId FROM Account WHERE ID IN :accountIds ])
        {
            accountIdToUltimateParentId.put(ac.Id, (ac.ParentId == null ? ac.Id : ac.ParentId ));
            accountIdToAccountRecordMap.put(ac.Id,ac);
        }
        System.debug('UAC: accountIdToUltimateParentId ' + accountIdToUltimateParentId);

        // No need to further process if no account(dealer) information found
        if( accountIdToUltimateParentId.size() == 0 ) return ; 

        // Iterate again over inserted records and populate Ultimate ParentAR 
        for( AMASellingSupportExpense__c ex : expenses )
        {
            if(ex.DealerAccount__c != null && accountIdToUltimateParentId.containsKey(ex.DealerAccount__c) )
            
            {
            ex.UltimateParentAR__c = accountIdToUltimateParentId.get(ex.DealerAccount__c);
                
            // Heena Tanna-19th Sept,2016; LPDCR-561- Updating Sales_Representative__c and Area_Sales_Manager__c with the corresponding values of DealerAccount__c
            ex.Sales_Representative__c = accountIdToAccountRecordMap.get(ex.DealerAccount__c).Business_Builder_Reimbursement_Approver__c;
            //ex.Area_Sales_Manager__c = accountIdToAccountRecordMap.get(ex.DealerAccount__c).Business_Builder_Reimbursement_Approver__r.ManagerId;
            ex.Area_Sales_Manager__c = accountIdToAccountRecordMap.get(ex.DealerAccount__c).ASM_BB_Approver__c;
            System.debug('Sales Representative'+ ex);
            }  
           
          
        }
        }
        catch(Exception ex)
       {
           System.debug('Exception occurred- '+ex);
       }
    }
    
    public static void setAMASellingSupportAdjustment(List<AMASellingSupportExpense__c> expenses )
    {
        Set<Id> ultimateParentAccountIds = new Set<Id>();
        Map<String, Decimal> accountIdToAjustmentAmount = new Map<String, Decimal>();
        List<Account> accountsToUpdate = new List<Account>();
        Set<String> approvedAndNotSubmittedStatuses = new Set<String>{STR_APPROVED, STR_APPROVEDWITHCREDIT, STR_SUBMITTEDFORAPPROVAL};
        try{
        // Iterate over inserted records and get dealer(Account) Ids
        for( AMASellingSupportExpense__c ex : expenses )
        {
            if(ex.UltimateParentAR__c != null ) ultimateParentAccountIds.add(ex.UltimateParentAR__c);
        }
        System.debug('UAC: ultimateParentAccountIds ' + ultimateParentAccountIds);

        // No need to further process if no account(dealer) Id found
        if( ultimateParentAccountIds.size() == 0 ) return ;

        for( AggregateResult ar : [ SELECT ApprovalStatus__c, UltimateParentAR__c  
                                    FROM AMASellingSupportExpense__c
                                    WHERE UltimateParentAR__c IN :ultimateParentAccountIds AND ApprovalStatus__c IN :approvedAndNotSubmittedStatuses 
                                    GROUP BY ApprovalStatus__c, UltimateParentAR__c ] )
        {
            accountIdToAjustmentAmount.put( (Id)ar.get('UltimateParentAR__c') + (String)ar.get('ApprovalStatus__c') , (Decimal)ar.get('Amount') );
        }
        System.debug('UAC: accountIdToAjustmentAmount ' + accountIdToAjustmentAmount);

        // No need to further process if no Amount found for ultimateParent
        if( accountIdToAjustmentAmount.size() == 0 ) return ;
// Heena Tanna--Code of Calculation deleted as per LPDCR-736  19-Oct
      
        }
        catch(Exception ex)
       {
           System.debug('Exception occurred- '+ex);
       }
    }
    
    public static void createExpenseLineItems(List<AMASellingSupportExpense__c> expenses )
    {
        List<AMASellingSupportExpenseLineItem__c> insertableLineItems = new List<AMASellingSupportExpenseLineItem__c>();
        try{
        // Iterate over inserted records and get dealer(Account) Ids
        for( AMASellingSupportExpense__c ex : expenses )
        {
            if(ex.SalesOperationsBalanceAdjustment__c != null) 
            // Shruti Mishra-19th Sept,2016; LPDCR-563- Updating BB_Approver_Sales_Specialist__c and Area_Sales_Manager__c fields of AMASellingSupportExpenseLineItem__c
            insertableLineItems.add( new AMASellingSupportExpenseLineItem__c( Description__c = ex.Description__c, Expense__c = ex.Id, Total_Spend__c = ex.SalesOperationsBalanceAdjustment__c,BB_Approver_Sales_Specialist__c =ex.Sales_Representative__c,Area_Sales_Manager__c = ex.Area_Sales_Manager__c, Approval_Status__c = 'Approved'));
        }
        System.debug('UAC: insertableLineItems ' + insertableLineItems);
        
        // Insert ExpenseLineItems under inserted expenses records 
        if( insertableLineItems.size() > 0 ) insert insertableLineItems ;
        }
        catch(Exception ex)
       {
           System.debug('Exception occurred- '+ex);
       }
    }
    //Heena Tanna -23rd Sep 2016 LPDCR-568- To Update status of ExpenseLineItems same as Expense record for status 'Not Submitted','Submitted for Approval', 'Entered by Sales Admin'
    //LPDCR-740 AMASellingSupportExpense.Internal_Status__c is Approved Sales Operations/Saved/Submitted for Approval
   public static void updateExpenseLineItemsStatus(Map<Id,AMASellingSupportExpense__c> expensesNewMap, Map<Id,AMASellingSupportExpense__c> expensesOldMap)      
    {
        Map<Id,AMASellingSupportExpense__c> expenseWithApprovalStatus = new Map<Id,AMASellingSupportExpense__c>();
        Set<String> statusSet = new Set<String>{'Approved by Sales Specialist','Approved Sales Operations','Saved','Submitted for Approval','Entered by Sales Admin'};
        List<AMASellingSupportExpenseLineItem__c> updatedLineItem = new List<AMASellingSupportExpenseLineItem__c>(); 
       try{
        for(Id expenseId:expensesNewMap.keySet())
        {
        if(expensesNewMap.get(expenseId).Internal_Status__c != expensesOldMap.get(expenseId).Internal_Status__c)
            expenseWithApprovalStatus.put(expenseId, expensesNewMap.get(expenseId));
        }
        for (AMASellingSupportExpenseLineItem__c updateLineItemStatus : [SELECT id,Expense__c,Approval_Status__c FROM AMASellingSupportExpenseLineItem__c WHERE Expense__c in:expenseWithApprovalStatus.keySet() AND Expense__r.Internal_Status__c IN:statusSet])
      
         {
        System.debug ('Check---' + updateLineItemStatus );
         
            AMASellingSupportExpense__c parentStatus = expenseWithApprovalStatus.get(updateLineItemStatus.Expense__c);
            
             
            if((statusSet.contains(parentStatus.Internal_Status__c)) && (parentStatus.Internal_Status__c == 'Saved'))
             updateLineItemStatus.Approval_Status__c ='Saved';
             
             System.debug ('Saved----' + updateLineItemStatus );
             
            if((statusSet.contains(parentStatus.Internal_Status__c)) &&
                ( 
                    ( parentStatus.Internal_Status__c == 'Submitted for Approval') || 
                    ( parentStatus.Internal_Status__c == 'Entered by Sales Admin')
                )) 
             updateLineItemStatus.Approval_Status__c ='Submitted for Approval';

            
            System.debug ('Submitted for Approval----' + updateLineItemStatus );
             //LPDCR - 1950 added condition updateLineItemStatus.Approval_Status__c == 'Submitted for Approval'               
             if((statusSet.contains(parentStatus.Internal_Status__c)) && (parentStatus.Internal_Status__c =='Approved Sales Operations') && ((updateLineItemStatus.Approval_Status__c == 'In Progress') || (updateLineItemStatus.Approval_Status__c == 'Submitted for Approval')))
             updateLineItemStatus.Approval_Status__c ='Approved';
             
             System.debug ('Sales Operation---' + updateLineItemStatus );
            //updateLineItemStatus.Approval_Status__c = parentStatus.ApprovalStatus__c;
            
            //LPDCR-1225 new condition for Approved by Sales Specialist
            if((statusSet.contains(parentStatus.Internal_Status__c)) && (parentStatus.Internal_Status__c =='Approved by Sales Specialist') && (updateLineItemStatus.Approval_Status__c != 'Rework'))
             updateLineItemStatus.Approval_Status__c ='In Progress';
            
            updatedLineItem.add(updateLineItemStatus);
        }
        update updatedLineItem;
       }
       catch(Exception ex)
       {
           System.debug('Exception occurred- '+ex);
       }
    }
    
    //Heena Tanna - 28-Oct-2016 LPDCR-755- As a Dealer, I want my rejected Reimbursement request lines to spawn a new Reimbursement Req.
    //Method to Clone Expense with Internal_Status = 'Complete - Partially Paid' OR 'Complete - Not Paid'and related Line Items with Approval_Status__c = Rework.
    
    public static void getExpenseForClone(Map<Id,AMASellingSupportExpense__c> expensesNewMap, Map<Id,AMASellingSupportExpense__c> expensesOldMap)
   {
    try
    {
        Set<Id> expenseIdSet = new Set<Id>();
        for(Id expenseId:expensesNewMap.keySet())
        {
            
            //Fetch new and old records
            AMASellingSupportExpense__c newRecord = expensesNewMap.get(expenseId);
            AMASellingSupportExpense__c oldRecord = expensesOldMap.get(expenseId);

            //Compare values
           // if(newRecord.Internal_Status__c!= oldRecord.Internal_Status__c && (newRecord.Internal_Status__c.equalsIgnoreCase('Complete - Partially Paid') || newRecord.Internal_Status__c.equalsIgnoreCase('Complete - Not Paid')))
           //As per task LPDCR-1338
           if(newRecord.Internal_Status__c!= oldRecord.Internal_Status__c && 
           newRecord.Internal_Status__c.equalsIgnoreCase('Approved Sales Operations') && 
           newRecord.Rejected_Line_Item_Count__c > 0)// Condition Rejected_Line_Item_Count__c > 0 updated as per task LPDCR-1516 
            {
                //Add to set for performing clone operation
                expenseIdSet.add(expenseId);
            }
        }
        System.debug('+++++' + expenseIdSet);
        System.debug('+++++' + expenseIdSet.size());
        
        if(expenseIdSet.size()>0)
        AMASellingSupportExpenseTriggerHandler.cloneExpenses(expenseIdSet);
        
    }
    catch(Exception ex)
    {
        
        System.debug('Exception occurred- '+ex);
    }
    
  }

//Heena Tanna - 28th Oct-2016 LPDCR-755
//Future method to perform clone operation. Future method is used because create operation under trigger for the same object is not a best practice.

@future
public static void cloneExpenses(Set<Id> expenseIdSet)

    
{
    try
    {
    //print set which is coming as parameter
    System.debug('++++' + expenseIdSet);
    
   //List to store new record to inserted
   List<AMASellingSupportExpense__c> expInsertList = new List<AMASellingSupportExpense__c>();
   List<AMASellingSupportExpenseLineItem__c> expItemInsertList = new List<AMASellingSupportExpenseLineItem__c>();
   List<Attachment> attachmentInsertList = new List<Attachment>();
   
   // Map to store Id of Old record and New created Record.
   Map<Id,Id> oldCloneRecordIdMap = new Map<Id,Id>();
   Map<Id,Id> oldCloneLineRecordIdMap = new Map<Id,Id>();
   
   //Query AMASellingSupportExpense__c obj if AMASellingSupportExpense.Internal_Status = 'Complete - Partially Paid' OR 'Complete - Not Paid'
   for(AMASellingSupportExpense__c expObj : [Select Id,Internal_Status__c,ApprovalStatus__c,Selling_Support_Program_Year__c,
   DealerAccount__c,Type__c,Description__c,Bill_To_Sold_To_Account__c,Sales_Representative__c,Area_Sales_Manager__c,
   CreatedById,CreatedBy.Profile.Name,CreatedBy.UserType,CreatedBy.IsPortalEnabled,CreatedDate, LastModifiedById, LastModifiedDate
    FROM AMASellingSupportExpense__c WHERE ID IN: expenseIdSet])   
    {
    //initialize Clone on parent object
    
    AMASellingSupportExpense__c expenseCloneObj = expObj.Clone(false,true,true,false);
    //change values
    //if condition as per LPDCR-1534
    if(expObj.CreatedBy.UserType =='PowerPartner' && expObj.CreatedBy.IsPortalEnabled ==true){
    expenseCloneObj.ApprovalStatus__c = 'Action Required'; //as per LPDCR -1524'Saved'
    expenseCloneObj.Internal_Status__c = 'Action Required';//as per LPDCR -1524'Rework'
    expenseCloneObj.Cloned_Expense_From__c = expObj.Id;
    expenseCloneObj.CloneExpensefromCreatedByUser__c =expObj.CreatedById;//Added as per task LPDCR-1327
    expInsertList.add(expenseCloneObj);
    } //LPDCR-1534
    
    }
    //insert cloned expense record
    if(expInsertList.size()>0)
        insert expInsertList;
      
    
    Set<Id> clonedRecordIdSet = new Set<Id>();
    
    //Create set of cloned records
    for(AMASellingSupportExpense__c expObj : expInsertList)
        clonedRecordIdSet.add(expObj.Id);
    
    //Create Map of old Expense Record ID and new Cloned Record Id
    for(AMASellingSupportExpense__c expObj : [SELECT Id, Cloned_Expense_From__c FROM AMASellingSupportExpense__c WHERE Id IN: clonedRecordIdSet])
        oldCloneRecordIdMap.put(expObj.Cloned_Expense_From__c, expObj.Id);
      
      
   //Use id of parent object to initialize clone on child object   
   for(AMASellingSupportExpenseLineItem__c expLineObj :[SELECT Id,Expense__c,Approval_Status__c,Description__c,Cloned_Expense_Line_From__c,
    Reimbursement_Category__c,Reimbursement_Sub_category__c,Total_Spend__c,Quantity_Multiplier__c,Reimbursement_Percentage__c,
    ExpenseAmount__c,BB_Approver_Sales_Specialist__c,Area_Sales_Manager__c,CreatedById, CreatedDate, 
    CreatedBy.Name,LastModifiedById, LastModifiedDate FROM AMASellingSupportExpenseLineItem__c WHERE Approval_Status__c = 'Rework' AND Expense__c =:expenseIdSet])
  {
    //Initialize clone for Line Item   
     AMASellingSupportExpenseLineItem__c expLineCloneObj = expLineObj.Clone(false,true,true,false);
    //change values
    
    //Fetch new Expense ID from the map based on old Expense ID
    expLineCloneObj.Expense__c = oldCloneRecordIdMap.get(expLineObj.Expense__c);
    expLineCloneObj.Approval_Status__c ='Action Required';//as per LPDCR -1524 'Saved';
    expLineCloneObj.Cloned_Expense_Line_From__c = expLineObj.Id;
    expLineCloneObj.CloneExpensefromCreatedByUser__c =expLineObj.CreatedById;//Added as per task LPDCR-1327
    expItemInsertList.add(expLineCloneObj);
    
    }
    
    //Insert cloned line item records
    if(expItemInsertList.size()>0)
        insert expItemInsertList;
    
    Set<Id> clonedLineRecordIdSet = new Set<ID>();
    
    //Create set of newly added line items
    for(AMASellingSupportExpenseLineItem__c expLineObj:expItemInsertList)
        clonedLineRecordIdSet.add(expLineObj.Id);
    
    //Create Map of old Expense Line Item Record ID and new Cloned Record Id
        for(AMASellingSupportExpenseLineItem__c expLineObj : [SELECT Id, Cloned_Expense_Line_From__c FROM AMASellingSupportExpenseLineItem__c WHERE Id IN: clonedLineRecordIdSet])
        oldCloneLineRecordIdMap.put(expLineObj.Cloned_Expense_Line_From__c, expLineObj.Id);
        
    //Use id of child object to initialize clone on attachment object
        for(Attachment att:[Select Id,Name,ParentId,Body FROM Attachment WHERE ParentId IN: oldCloneLineRecordIdMap.keySet()])
        {
            //Initialize clone for attachment        
            Attachment clonedAtt = att.Clone(false,true);
            //change value of ParentId 
            clonedAtt.ParentId = oldCloneLineRecordIdMap.get(att.ParentId);
            attachmentInsertList.add(clonedAtt);
            
        }
    //Insert Cloned Attachments
    if(attachmentInsertList.size()>0)
        insert attachmentInsertList;
    }
    catch(Exception ex){
        
        System.debug('Exception occurred- '+ex);
    }
  }
 //Heena Tanna 7th-Dec-2016
 //Method to update CurrentApprover__c field with the Apporver ID. Task LPDCR-1206 (Sub-Task-LPDCR-1299)
public static void getCurrentApprover(Map<Id,AMASellingSupportExpense__c> expensesNewMap, Map<Id,AMASellingSupportExpense__c> expensesOldMap)
{
    try
    {
         Set<Id> expenseIdSet = new Set<Id>();
         for(Id expenseId:expensesNewMap.keySet())
         {
            //Fetch new and old records
            AMASellingSupportExpense__c newRecord = expensesNewMap.get(expenseId);
            AMASellingSupportExpense__c oldRecord = expensesOldMap.get(expenseId); 
            
            //Condition
            if (newRecord.Internal_Status__c!= oldRecord.Internal_Status__c)
            {
                //Add to set
                expenseIdSet.add(expenseId);
            }
 
            System.debug('+++++' + expenseIdSet);
            System.debug('+++++' + expenseIdSet.size());
                
         }
         if(expenseIdSet.size()>0)
         setCurrentApprover(expenseIdSet);
         
         
    }
    
    catch(Exception ex)
    {
        
        System.debug('Exception occurred- '+ex);
    }
    
}
@future
public static void setCurrentApprover(Set<Id> expenseIdSet)
{
       try
       {
        if(expenseIdSet!=null && expenseIdSet.size()>0)
        { 
        //Get List of expense for 
        List<AMASellingSupportExpense__c> expenseList =[Select Id,Internal_Status__c,ApprovalStatus__c,Sales_Representative__c,Area_Sales_Manager__c,
        CurrentApprover__c,CurrentUserIsApprover__c FROM AMASellingSupportExpense__c WHERE ID IN: expenseIdSet];
        
        System.debug('++++' + expenseList);
        
                   
        List<ProcessInstanceWorkitem> workItemList = [Select ProcessInstance.Status,ProcessInstance.TargetObjectId,ProcessInstanceId,
        OriginalActorId,ActorId,Actor.Name FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN: expenseIdSet AND (ProcessInstance.Status ='Pending'OR ProcessInstance.Status ='Reassigned') ];
        
        Set<Id> userIdSet = new Set<Id>();
        
        for( ProcessInstanceWorkitem piwObj :workItemList )
        {
               //userIdSet.add(piwObj.ActorId);
               userIdSet.add(piwObj.OriginalActorId);
            System.debug('OriginalActor ID----'+ userIdSet);
            
        }
        update workItemList;
        Map<Id,User> userMap = new Map<Id,User>([SELECT Id,DelegatedApproverId FROM User WHERE Id IN:userIdSet]);
        
        
               
         System.debug('workItemList++++' + workItemList);   
         if(workItemList.size()>0)
         { 
                
                Map<String,String>  actIDMap = new Map<String,String>();
                
                for(ProcessInstanceWorkitem workItem:workItemList )
                {
                      ///actIDMap.put( workItem.ProcessInstance.TargetObjectId, workItem.ActorId);
                      actIDMap.put( workItem.ProcessInstance.TargetObjectId, workItem.OriginalActorId);     
                }

                for(AMASellingSupportExpense__c exp:expenseList ) 
                {
                    if(actIDMap.containsKey(exp.Id))  
                    {
                        Id approverId = actIDMap.get(exp.Id);
                        exp.CurrentApprover__c = approverId;
                        System.debug('approverId++++'+ approverId);
                        if(userMap.containsKey(approverId))
                        {
                        exp.CurrentApproverDelegate__c = userMap.get(approverId).DelegatedApproverId ;
                        }
                    }
                    System.debug('ExpenseID'+exp.Id);
                    System.debug('CurrentApprover__c++++'+ exp.CurrentApprover__c);
                    System.debug('CurrentApprover__r.DelegatedApproverId++++'+ exp.CurrentApprover__r.DelegatedApproverId);
                }
            
         }
         
         if(expenseList.size()>0)
             update expenseList; 
   }
  }
   catch(Exception ex)
    {
        
        System.debug('Exception occurred- '+ex);
    }
    
}    
}