/**
*   @Author:    Heena Tanna
*   @Date:      16.02.2017
*   @Jira:      LPDCR-1811
*   @Purpose:   Controller behind LPDCR_BalanceAndSummary page
*/

public without sharing class LPDCR_BalanceAndSummaryController
{
     public Attachment expenseRep{get;set;}
     public String reimbursementHeader = 'Reimbursement #,Line Item Total ($),Description,Status (dealer facing),Submitted for Approval Date,Credit Memo #,Approved Line Item Total ($),Reimbursement Category,Reimbursement Sub-category,Description,Reimbursement Amount ($)';
    
     public BusinessBuilderProgramYear__c BBProgYear{get;set;}
     public Account account{get;set;}
     public String accountName {get;set;}
     public String bbYearName{get;set;}
     public Account selectedAcc{get;set;}
     public User userName{get;set;}
     public Contact contactObj{get;set;}
     public List<Account> accLst{get;set;}
     public List<SellingSupportProgramYear__c> ssProgYearList{get;set;}
     public List<BusinessBuilderProgramYear__c> bbProgYearList{get;set;}
     public SellingSupportProgramYear__c ssProgYearRec{get;set;}
     public List<AMASellingSupportExpense__c> expBalRecList{get;set;}
     public List<AMASellingSupportExpense__c> expApprovedList{get;set;}
     public List<AMASellingSupportExpense__c> expPendingList{get;set;}
     //public Id selectedAccountId;
     public String s{get;set;}
     public List<CategoryWrapper> grpPendCatList{get;set;}
     public List<SubCategoryWrapper> grpPendSubCatList{get;set;}
     public Id expenseId{get;set;}
     public List<CategoryWrapper> grpApprCatList{get;set;}
     public List<SubCategoryWrapper> grpApprSubCatList{get;set;}
     Set<String> pendingStatusSet = new Set<String>{'Entered by Sales Admin','Approved Sales Operations','Approved by Sales Specialist','Submitted for Approval','Approved by Area Sales Manager'};
     Set<String> approvedStatusSet = new Set<String>{'Approved Sales Operations','Complete - Partially Paid','Complete - Paid in Full'};       
     public String selectedAccountId{get;set;}
     Id bbyearID = ApexPages.currentPage().getParameters().get('BBYear');
     Id accountID= ApexPages.currentPage().getParameters().get('selectedAccountId');
    
    
    public LPDCR_BalanceAndSummaryController()
    {
        BBProgYear =[Select Id,Name from BusinessBuilderProgramYear__c where Id=:bbyearID];
        bbYearName = BBProgYear.Name;
        account = [Select Id, Name from Account where Id =:accountID];
        accountName = account.Name;
        //initialize(); 
       
        
    }
    public LPDCR_BalanceAndSummaryController(ApexPages.StandardController controller)
    {
         expenseId = controller.getRecord().Id;
    }
    
     public void initialize(){
        //Get User Detail
        try{
        
            selectedAccountId = LPDCR_ChangeAccountController.getSelectedAccId();              
            System.debug('BSselectedAccountId'+ Cache.Session.get('selectedAccountId'));
            if(selectedAccountId != null){
            
            selectedAcc = [Select Id, Name, Dealer_Category_catcode30__c, Member_Type_catcode1__c, AR_Customer_Group_JDE__c, BusinessBuilderProgramStatus__c,AccountNumber from Account where Id =: selectedAccountId];
            System.debug('selectedAcc--'+selectedAcc);
            
            //Get Active SSPY list
            ssProgYearList = [Select Id, Name, Program_Year_Allocation__c, BusinessBuilderProgramYear__r.EnrollmentStartDate__c, BusinessBuilderProgramYear__r.Name, BusinessBuilderProgramStatus__c from SellingSupportProgramYear__c where Account__c =: selectedAccountId AND BusinessBuilderProgramYear__c=:BBProgYear.Id];
            
            //Get Active BBPY list
            //bbProgYearList = [Select Id, Name, EnrollmentStartDate__c, EnrollmentEndDate__c, StartDate__c, EndDate__c from BusinessBuilderProgramYear__c where 
                 //((StartDate__c <=: Date.Today() and EndDate__c >=: Date.Today()) OR(EnrollmentStartDate__c <=: Date.Today() AND EnrollmentEndDate__c >=: Date.Today()))ORDER BY StartDate__c ASC limit 2]; 
            bbProgYearList = [Select Id, Name, EnrollmentStartDate__c, EnrollmentEndDate__c, StartDate__c, EndDate__c from BusinessBuilderProgramYear__c where ID=:BBProgYear.Id]; 
            getAccVsYearDetails();        
            getSSYear();
            getBalanceAdjustmentExpenses();
            getReimbursementPendingExpenses();
            getReimbursementApprovedExpenses();
            
            createCSVReport();
        }//If null check
       } 
        catch(Exception ex){
            System.debug('Exception---'+ex);
            //LOLUtilities.LogErrMsg('LPDCR_BalanceAndSummaryController',ex, 'Exception occurred');
        }
    }
    
    public void createCSVReport(){
        //String csvContent = 'column1,column2\nvalue1,value2';
        try{
        
            String csvContent = selectedAcc.Name + '\nProgram Year,'+ssProgYearRec.Name+
            '\nProgram Year Allocation ($),'+ssProgYearRec.Program_Year_Allocation__c+
            '\nTotal Approved Requests,'+ ssProgYearRec.Total_Approved_Requests__c+
            '\nTotal Balance Adjustments,'+ssProgYearRec.Total_Balance_Adjustments__c+
            '\nTotal Pending Requests,'+ssProgYearRec.Total_Pending_Requests__c+
            '\nProjected Balance,'+ssProgYearRec.Available_Balance__c+'\n\n'+reimbursementHeader;
            
            //List<AMASellingSupportExpense__c> expenseLst = [SELECT Id, Type__c, SalesOperationsBalanceAdjustment__c, Name, Submitted_for_Approval_Date__c ,Selling_Support_Program_Year__r.Name, CreditMemo__c, Line_Item_Total__c, DealerAccount__r.Name, Description__c, ApprovalStatus__c, CreatedDate, DealerAccount__c, Total__c, Cloned_Expense_From__c, Cloned_Expense_From__r.Name FROM AMASellingSupportExpense__c where Selling_Support_Program_Year__c =: ssProgYearRec.Id AND ApprovalStatus__c!=: 'Saved' AND (UltimateParentAR__c =: selectedAccountId OR DealerAccount__c =: selectedAccountId) ORDER BY CreatedDate DESC];
            List<AMASellingSupportExpenseLineItem__c> allExpenseLineItemLst = [Select Id, Name, Expense__r.SalesOperationsBalanceAdjustment__c, Expense__r.Type__c, Expense__r.Name, Expense__r.Line_Item_Total__c, Expense__r.Description__c, Expense__r.ApprovalStatus__c, Expense__r.Submitted_for_Approval_Date__c, Expense__r.CreditMemo__c, Expense__r.Total__c, Reimbursement_Category__c, Reimbursement_Sub_category__c, ExpenseAmount__c, Description__c, Expense__c from AMASellingSupportExpenseLineItem__c];
            
            Set<AMASellingSupportExpenseLineItem__c> expLineItemLst = new Set<AMASellingSupportExpenseLineItem__c>();
            for(AMASellingSupportExpense__c ex: [SELECT Id, Type__c, SalesOperationsBalanceAdjustment__c, Name, Submitted_for_Approval_Date__c ,Selling_Support_Program_Year__r.Name, CreditMemo__c, Line_Item_Total__c, DealerAccount__r.Name, Description__c, ApprovalStatus__c, CreatedDate, DealerAccount__c, Total__c, Cloned_Expense_From__c, Cloned_Expense_From__r.Name FROM AMASellingSupportExpense__c where Selling_Support_Program_Year__c =: ssProgYearRec.Id AND ApprovalStatus__c!=: 'Saved' AND (UltimateParentAR__c =: selectedAccountId OR DealerAccount__c =: selectedAccountId) ORDER BY CreatedDate DESC]){
                for(AMASellingSupportExpenseLineItem__c li : allExpenseLineItemLst){
                    if(li.Expense__c == ex.Id){
                        expLineItemLst.add(li);
                        System.debug(li.Name);
                    }
                }
            }
           
            
            for(AMASellingSupportExpenseLineItem__c li: expLineItemLst){
                if(li.Expense__r.Type__c != 'Balance Adjustment'){
                    csvContent += '\n'+li.Expense__r.Name+','+li.Expense__r.Line_Item_Total__c+','+li.Expense__r.Description__c+','+li.Expense__r.ApprovalStatus__c+','+li.Expense__r.Submitted_for_Approval_Date__c+','+li.Expense__r.CreditMemo__c+','+li.Expense__r.Total__c+','+li.Reimbursement_Category__c+','+li.Reimbursement_Sub_category__c+','+li.Description__c+','+li.ExpenseAmount__c;
                }
                else{
                    csvContent += '\n'+li.Expense__r.Name+','+li.Expense__r.Line_Item_Total__c+','+li.Expense__r.Description__c+','+li.Expense__r.ApprovalStatus__c+','+li.Expense__r.Submitted_for_Approval_Date__c+','+li.Expense__r.CreditMemo__c+','+li.Expense__r.Total__c+','+li.Reimbursement_Category__c+','+li.Reimbursement_Sub_category__c+','+li.Description__c+','+li.Expense__r.SalesOperationsBalanceAdjustment__c;
                }
            }
            
            //Attachment[] attLst = ssProgYearRec.getSObjects('Attachments');
            Attachment[] attLst = [SELECT Id, Name, Body FROM Attachment where ParentId=:ssProgYearRec.Id];
            System.debug('attLst ---'+attLst);
            if(attLst.size()<=0 || attLst==null){
                System.debug('In if.....');
                expenseRep = new Attachment();
                expenseRep.ParentId = ssProgYearRec.Id;
            }
            else{
                System.debug('In Else.....');
                expenseRep = attLst[0];
                System.debug('1....'+ssProgYearRec.Program_Year_Allocation__c+',,,'+expenseRep.Body);
            }
            expenseRep.Body = Blob.valueOf(csvContent);
            expenseRep.Name = '('+ssProgYearRec.Name+') Reimbursement Request Details.csv';
            
            
            System.debug('expense report---'+expenseRep);
            upsert expenseRep;
            //Attachment att=[Select Id, Name from Attachment where ];
        }        
        catch(Exception ex){
            System.debug('Exception,,,'+ex);
        }
    }
        
    public List<AccountVsYear> getAccVsYearDetails(){
    List<AccountVsYear> accVsYearLst = new List<AccountVsYear>();
    try{
        List<SellingSupportProgramYear__c> sspyLst = [Select Id, Name, Available_Balance__c, BusinessBuilderProgramTier__c, Total_Pending_Requests__c,Account__c,
                 Program_Year_Allocation__c, BusinessBuilderProgramYear__r.EnrollmentStartDate__c,Total_Approved_Requests__c,Total_Balance_Adjustments__c, 
                 BusinessBuilderProgramYear__r.Name, BusinessBuilderProgramStatus__c from 
                 SellingSupportProgramYear__c where Account__c =: selectedAccountId AND BusinessBuilderProgramYear__c=:BBProgYear.Id ];
                 
                 Map<Id,SellingSupportProgramYear__c> sspyVsBbpyMap = new Map<Id,SellingSupportProgramYear__c>();
                System.debug('sspyLst--'+sspyLst);
                for(SellingSupportProgramYear__c s: sspyLst){
                    System.debug('s--=='+s+',,'+s.BusinessBuilderProgramYear__c);
                    sspyVsBbpyMap.put(s.BusinessBuilderProgramYear__c, s);
                }
                  for(BusinessBuilderProgramYear__c bbYear: bbProgYearList){
                    AccountVsYear accVsYr = new AccountVsYear();
                    accVsYr.programYear = bbYear.Name;
                    accVsYr.bbPYRec = bbYear;
                    accVsYr.ssPYRec = sspyVsBbpyMap.get(bbYear.Id);
                    if(accVsYr.ssPYRec!=null){
                        accVsYr.availableBalance = accVsYr.ssPYRec.Available_Balance__c + accVsYr.ssPYRec.Total_Pending_Requests__c;
                    }
                    accVsYr.showAccount = true;
                    accVsYr.showAvailBlnc = false;
                    System.debug('accVsYr-------'+accVsYr);
                    accVsYearLst.add(accVsYr);
                }
                 
    }
    catch(Exception ex){
        System.debug('Exception Genrated'+ ex);
        //LOLUtilities.LogErrMsg('LPDCR_BalanceAndSummaryController',ex, 'Exception occurred');
    }
     return accVsYearLst;
   }
   //By Request part in VF page
   public SellingSupportProgramYear__c getSSYear(){
   
       ssProgYearRec = [Select Id,Account__c, Name, Available_Balance__c, Total_Pending_Requests__c,Program_Year_Allocation__c,Total_Approved_Requests__c, Total_Balance_Adjustments__c,BusinessBuilderProgramYear__c from SellingSupportProgramYear__c where Account__c =: selectedAccountId AND BusinessBuilderProgramYear__c=:BBProgYear.Id];
       System.debug('ssProgYearRec-------'+ssProgYearRec);
       return ssProgYearRec;
       
   }
   
 //Get Expense Record with record type as "Balance Adjusment"
  public List<AMASellingSupportExpense__c> getBalanceAdjustmentExpenses(){
    expBalRecList =[Select Id,Name,RecordType.Name,SalesOperationsBalanceAdjustment__c,Total_Pending__c,DealerAccount__c,Selling_Support_Program_Year__c FROM AMASellingSupportExpense__c WHERE DealerAccount__c=: selectedAccountId AND Selling_Support_Program_Year__c=:ssProgYearRec.ID AND RecordType.Name ='Balance Adjustment'];
     
    return expBalRecList;
   }
 //Get Expense Record with record type as "Reimbursment Request" and internalStatus 'Entered by Sales Admin','Approved Sales Operations','Approved by Sales Specialist','Submitted for Approval','Approved by Area Sales Manager'
 public void getReimbursementPendingExpenses(){
   expPendingList =[Select Id,Name,RecordType.Name,CreditMemo__c,SalesOperationsBalanceAdjustment__c,Total_Pending__c,DealerAccount__c,Selling_Support_Program_Year__c,Internal_Status__c,Type__c FROM AMASellingSupportExpense__c WHERE DealerAccount__c=: selectedAccountId AND Selling_Support_Program_Year__c=:ssProgYearRec.ID AND RecordType.Name ='Reimbursement Request' AND Internal_Status__c IN:pendingStatusSet AND Total_Pending__c > 0 AND Type__c ='Expense'];
    
    // query fetch the line items 
    grpPendCatList = new List<CategoryWrapper>();
    grpPendSubCatList = new List<SubCategoryWrapper> ();
    
    Set<ID> expObjID = new Set<ID>();
   for(AMASellingSupportExpense__c expObj:expPendingList)    
       {    
       expObjID.add(expObj.Id);  
       }
       if(expObjID.size()>0){
           
        List<AggregateResult> expPendLineItemList = [SELECT SUM(ExpenseAmount__c)totalspend, Reimbursement_Category__c,COUNT(Id)totalcount
       FROM AMASellingSupportExpenseLineItem__c
       WHERE Expense__c IN:expObjID  //Approval_Status__c = 'In Progress'
       GROUP BY Reimbursement_Category__c
       HAVING SUM(Total_Spend__c) > 0 ]; 
       
       
       List<AggregateResult> expPendSubCatLineItemList = [SELECT SUM(ExpenseAmount__c)totalspend,Reimbursement_Category__c, Reimbursement_Sub_category__c
       FROM AMASellingSupportExpenseLineItem__c
       WHERE Expense__c IN:expObjID //Approval_Status__c = 'In Progress' AND 
       GROUP BY Reimbursement_Category__c, Reimbursement_Sub_category__c
       HAVING SUM(Total_Spend__c) > 0 ]; 
        //Looping over aggregare result and forming a list of wrapper
       
       for(AggregateResult ag:expPendLineItemList)
         {
             CategoryWrapper categoryObj = new CategoryWrapper();
             categoryObj.category = String.valueOf(ag.get('Reimbursement_Category__c'));
             categoryObj.totalAmount =  (Decimal)(ag.get('totalspend'));
             categoryObj.totalCount = (Decimal)(ag.get('totalcount'));
             grpPendCatList.add(categoryObj);
         }
        for(AggregateResult ag:expPendSubCatLineItemList)
         {
             SubCategoryWrapper subCategoryObj = new SubCategoryWrapper();
             subCategoryObj.categoryName = String.valueOf(ag.get('Reimbursement_Category__c'));
             subCategoryObj.subcategory = String.valueOf(ag.get('Reimbursement_Sub_category__c'));
             subCategoryObj.subCategoryTotalAmount =  (Decimal)(ag.get('totalspend'));
             grpPendSubCatList.add(subCategoryObj);
         }   
         }
             
    system.debug('grpPendCatList'+ grpPendCatList); 
    System.debug('grpPendSubCatList----'+ grpPendSubCatList);
    //return expPendingList;
 }
 //Get Expense Record with record type as "Reimbursment Request" and internalStatus 'Approved Sales Operations','Complete - Partially Paid','Complete - Paid in Full'
  public void getReimbursementApprovedExpenses(){
   expApprovedList =[Select Id,Name,RecordType.Name,CreditMemo__c,SalesOperationsBalanceAdjustment__c,Total__c,DealerAccount__c,Selling_Support_Program_Year__c,Internal_Status__c FROM AMASellingSupportExpense__c WHERE DealerAccount__c=: selectedAccountId AND Selling_Support_Program_Year__c=:ssProgYearRec.ID AND RecordType.Name ='Reimbursement Request' AND Internal_Status__c IN:approvedStatusSet AND Total__c >0];
    // query fetch the line items
    grpApprCatList = new List<CategoryWrapper>();
    grpApprSubCatList = new List<SubCategoryWrapper> ();
    Set<ID> expObjID = new Set<ID>();
   for(AMASellingSupportExpense__c expObj:expApprovedList)    
       {    
       expObjID.add(expObj.Id);  
       }
       if(expObjID.size()>0){
       
       List<AggregateResult> expApprCatLineItemList = [SELECT SUM(ExpenseAmount__c)totalspend,Reimbursement_Category__c,COUNT(Id)totalcount
       FROM AMASellingSupportExpenseLineItem__c
       WHERE Approval_Status__c = 'Approved' AND Expense__c IN:expObjID
       GROUP BY Reimbursement_Category__c
       HAVING SUM(Total_Spend__c) > 0 ]; 
       
       List<AggregateResult> expApprSubCatLineItemList = [SELECT SUM(ExpenseAmount__c)totalspend,Reimbursement_Category__c, Reimbursement_Sub_category__c
       FROM AMASellingSupportExpenseLineItem__c
       WHERE Approval_Status__c = 'Approved' AND Expense__c IN:expObjID
       GROUP BY Reimbursement_Category__c, Reimbursement_Sub_category__c
       HAVING SUM(Total_Spend__c) > 0 ]; 
       
       
        //Looping over aggregare result and forming a list of wrapper
       for(AggregateResult ag:expApprCatLineItemList)
         {
             CategoryWrapper categoryObj = new CategoryWrapper();
             categoryObj.category = String.valueOf(ag.get('Reimbursement_Category__c'));
             categoryObj.totalAmount =  (Decimal)(ag.get('totalspend')); 
             categoryObj.totalCount = (Decimal)(ag.get('totalcount'));
             grpApprCatList.add(categoryObj);
         }
        for(AggregateResult ag:expApprSubCatLineItemList)
         {
             SubCategoryWrapper subCategoryObj = new SubCategoryWrapper();
             subCategoryObj.categoryName = String.valueOf(ag.get('Reimbursement_Category__c'));
             subCategoryObj.subcategory = String.valueOf(ag.get('Reimbursement_Sub_category__c'));
             subCategoryObj.subCategoryTotalAmount =  (Decimal)(ag.get('totalspend'));
             grpApprSubCatList.add(subCategoryObj);
         }   
          
        }
 }
   
    
    public class AccountVsYear{
        public String programYear{get;set;}
        public Decimal availableBalance{get;set;}
        public BusinessBuilderProgramYear__c bbPYRec{get;set;}
        public SellingSupportProgramYear__c ssPYRec{get;set;}
        public Boolean showAccount {get;set;}
        public Boolean showAvailBlnc{get;set;}
    }
    
    //Inner class for pending and approved list
    public class CategoryWrapper{
         public String category{get;set;}         
         public Decimal totalAmount{get;set;}
         public Decimal totalCount{get;set;}
         //public List<SubCategoryWrapper> subCategoryList{get;set;}
         public CategoryWrapper(){}
         
    
    }
    
    public class SubCategoryWrapper
    {
        public String categoryName{get;set;}
        public String subcategory{get;set;}
        public Decimal subCategoryTotalAmount{get;set;}
        public SubCategoryWrapper(){}
        
    }
    
}