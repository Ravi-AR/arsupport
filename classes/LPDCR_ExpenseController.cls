/**
*   @Author:    Shruti Mishra
*   @Date:      12.10.2016
*   @Jira:      LPDCR-546
*   @Purpose:   Controller behind LPDCR_Expense and LPDCR_ExpenseDetail pages
*/

public without sharing class LPDCR_ExpenseController 
{
    public static List<AMASellingSupportExpense__c> expenseLst{get;set;}
    public static transient ExpenseLineItemClass expObj{get;set;}
    public User userName{get;set;}
    public Contact contactObj{get;set;}
    public Account accObj{get;set;}
    public Account account{get;set;}
    public SellingSupportProgramYear__c accDetails;
    public Id expenseId{get;set;}
    public transient List<AccountContactRelation> acConObj{get;set;}       
    public static Set<SelectOption> programYears{get;set;}
    public transient Set<Id> uniqueAccountIdSet{get;set;}
    public BusinessBuilderProgramYear__c BBProgYear{get;set;}//1682
    public String selectedYear{get 
      {if(selectedYear== null){
          userName = [Select Name,ContactId from User where Id=:UserInfo.getUserId()];
          contactObj = [Select OwnerId,Name,AccountId,Account.Name,Account.BillTo_flag__c from Contact where Id=:userName.ContactId];
          List<SellingSupportProgramYear__c> ssProgramYrLst = [Select Id,Name,BusinessBuilderProgramYear__c from SellingSupportProgramYear__c where Account__c =: contactObj.AccountId AND BusinessBuilderProgramYear__c=:BBProgYear.Id AND (BusinessBuilderProgramStartDate__c <=: Date.Today() AND BusinessBuilderProgramEndDate__c >: Date.Today()) ORDER BY BusinessBuilderProgramStartDate__c DESC];
          selectedYear=ssProgramYrLst[0].Name;
          //1682 added BusinessBuilderProgramYear__c=:BBProgYear.Id
      }
      return selectedYear;}
      set;}
    
    //Sorting variables
    public List<LPDCR_ExpenseSort__c> sortParameters {get;set;}
    public string accountName {get;set;}
    public String sortItem
      {get {if(sortItem==null){sortItem='CreatedDate';}return sortItem;}
      set;}
    public String sortSubItem
      {get {if(sortSubItem == null){sortSubItem='DESC';}return sortSubItem;}
      set;}
    public static List<SelectOption> sortItemLst{get;set;}
    public Set<String> sortItems{get;set;}
    public static List<SelectOption> sortSubItemLst{get;set;}
    public static Set<String> sortSubItems{get;set;}
    public List<String> item{get;set;}
    public List<String> subItem{get;set;}
    
    
    //Pagination variables
    @TestVisible
    private integer counter;
    @TestVisible
    private integer list_size;
    public integer total_size;
    public static String getExpenseQuery{get;set;}
    
    
    //Constructor
    public LPDCR_ExpenseController() {
        userName = [Select Name,ContactId from User where Id=:UserInfo.getUserId()];
        if(userName.ContactId!=null)
        contactObj = [Select OwnerId, Name, AccountId, Account.Name, Account.BillTo_flag__c from Contact where Id =: userName.ContactId];
        //accountName = contactObj.Account.Name;
        //1682
        BBProgYear =[Select Id,Name from BusinessBuilderProgramYear__c where Id=: ApexPages.currentPage().getParameters().get('BBYear')];
        account = [Select Id, Name from Account where Id =:ApexPages.currentPage().getParameters().get('Accountid')];
        accountName = account.Name;
        try{
            getProgramYears();
            getAccDetails();
            getSortListData();
            counter = 0;
            list_size = 6;
            runQuery();
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseController',ex, 'Exception occurred');
        }
        //getSortSubItemLst();
    }
        
    //Method to get all Expense Records for an Account
    public void getSortListData()
    {  
        sortItemLst = new List<SelectOption>();
        sortSubItemLst = new List<SelectOption>();        
        sortParameters = LPDCR_ExpenseSort__c.getall().values();
        sortItems = new Set<String>();
        for(LPDCR_ExpenseSort__c param:sortParameters){
            sortItems.add(param.Sort_By_Field__c);
        }  
        for(String s:sortItems){
            item = new List<String>();
            for(LPDCR_ExpenseSort__c param: sortParameters){
                if(param.Sort_By_Field__c==s){
                    item.add(param.SortByField_API__c);
                }
            }
            sortItemLst.add(new SelectOption(item[0],s));
        }
        System.debug('sortItemLst----' + sortItemLst);
        getSortSubItemList();
    }
    
    //get sort sublist
    public void getSortSubItemList(){
        try{
            sortSubItems = new Set<String>();
            for(LPDCR_ExpenseSort__c param:sortParameters){        
                if(param!=null && param.SortByField_API__c==sortItem)
                sortSubItems.add(param.Sort_By_SubField__c);
            } 
            System.debug('sortSubItems-----'+sortSubItems);
            if(sortSubItems.size()>0){
                sortSubItemLst = new List<SelectOption>();
                for(String s:sortSubItems){
                   subItem= new List<String>();
                    
                    for(LPDCR_ExpenseSort__c param: sortParameters){
                        if(param.Sort_By_SubField__c==s){
                            subItem.add(param.SortBySubField_API__c);                              
                        }
                    } 
                    System.debug('subItem---'+subItem);
                    sortSubItemLst.add(new SelectOption(subItem[0],s));  
                    System.debug('sortSubItemLst---'+sortSubItemLst);
                    sortSubItemLst.sort();
                    //sortSubItem = sortSubItemLst[0].getValue();//temprary comment
                    
                    System.debug('subItem[0]--'+sortSubItem );
                }
                
                if(sortItem== LPDCR_Constants.CONS_STATUS)
                {
                    sortSubItem = LPDCR_Constants.CONS_STATUS_SAVED;
                }
                else if (sortItem== LPDCR_Constants.CONS_SUBMITDATE)
                {
                    sortSubItem = LPDCR_Constants.CONS_DESC;
                }    
                
                sortSubItemLst = arrangeList(sortSubItemLst,sortSubItem);//rearrange list
            }
            //runQuery(); //Exception mail
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseController',ex, 'Exception occurred');
        }        
    }    
  
    //Method to rearrange list for UI
    public List<SelectOption> arrangeList(List<SelectOption> optionList, String selectedValue)
    {
      List<SelectOption> tempList = new List<SelectOption>();
      try{
        
        SelectOption selectedOption;
        
        for(Integer i=0;i<optionList.size();i++)
        {
            if(optionList[i].getValue()==selectedValue)
            {
                selectedOption = optionList[i];
                optionList.remove(i);
            }
        }
        
        if(selectedOption != null)
        tempList.add(selectedOption);
        tempList.addAll(optionList);

        }
        
       catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseController',ex, 'Exception occurred');
        }   
       return tempList;
    }
    
    //Method to get program years
    public set<SelectOption> getProgramYears(){
        try{
            List<SellingSupportProgramYear__c> ssProgramYrLst = [Select Id,Name,BusinessBuilderProgramYear__c from SellingSupportProgramYear__c where Account__c =: contactObj.AccountId AND BusinessBuilderProgramYear__c=:BBProgYear.Id AND (BusinessBuilderProgramStartDate__c <=: Date.Today() and BusinessBuilderProgramEndDate__c >: Date.Today()) ORDER BY BusinessBuilderProgramStartDate__c DESC];
            //System.debug('ssProgramYrLst--'+ssProgramYrLst);//1682 added BusinessBuilderProgramYear__c=:BBProgYear.Id
            programYears= new set<SelectOption>();
            for(SellingSupportProgramYear__c year:ssProgramYrLst){
                programYears.add(new SelectOption(year.Name,year.Name));
            }
            //System.debug('programYears--'+programYears);
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseController',ex, 'Exception occurred');
        }
        
        return programYears;
    }
    
    //Method to get Available Balance, Pending Requests, Projected Balance of Parent Account
    public SellingSupportProgramYear__c getAccDetails(){
        try{
            accDetails = [Select Id, Name, Available_Balance__c, Total_Pending_Requests__c,Program_Year_Allocation__c, Total_Balance_Adjustments__c,BusinessBuilderProgramYear__c from SellingSupportProgramYear__c where Name=:selectedYear AND Account__c =: account.Id limit 1];
            return accDetails;
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseController',ex, 'Exception occurred');
        }
        return null;
    }    
    
    //Get Expense Details
    public void getExpDetail(){
    try{
            AMASellingSupportExpense__c exp = [SELECT Id, Type__c, SalesOperationsBalanceAdjustment__c, Submitted_for_Approval_Date__c, Selling_Support_Program_Year__r.Name, RecordType.Name, CreditMemo__c, Name, DealerAccount__r.Name, Description__c , Line_Item_Total__c,ApprovalStatus__c, CreatedDate, DealerAccount__c, Total__c, Cloned_Expense_From__c, Cloned_Expense_From__r.Name FROM AMASellingSupportExpense__c WHERE Id=: ApexPages.currentpage().getparameters().get('expenseId')];
            List<AMASellingSupportExpenseLineItem__c> lineItems = [SELECT Id, Name, BB_Description__c, Approval_Status__c, Expense__c, Total_Spend__c, Description__c, Reimbursement_Category__c, Date__c, Reimbursement_Sub_category__c, ExpenseAmount__c,ReasonforRework__c,DealerFacingReasonforReworkMessage__c,CreatedDate, (SELECT Id, Name, ContentType FROM Attachments) FROM AMASellingSupportExpenseLineItem__c WHERE Expense__c =: exp.Id ORDER BY CreatedDate];//1840 replaced ORDER BY Name with CreatedDate
            //System.debug('Record type-- '+exp.RecordType.Name);
            expObj= new ExpenseLineItemClass();
            expObj.expenseObj = exp;
            expObj.lineItemLst = lineItems;
            //System.debug('SalesOperationsBalanceAdjustment__c--'+expObj.expenseObj.SalesOperationsBalanceAdjustment__c);
            
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseController',ex, 'Exception occurred');
        }        
    } 
    
    //Delete Expense Record LPDCR-1011
    public void deleteExpense(){
        try{
            AMASellingSupportExpense__c exp = [Select Id from AMASellingSupportExpense__c where Id =: ApexPages.currentpage().getparameters().get('expenseId')];
            delete exp;
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseController',ex, 'Exception occurred');
        }
    }
        
    //Pagination Code Starts   
   public void runQuery(){
       uniqueAccountIdSet = new Set<Id>();
       if(userName.ContactId!=null){
            if(contactObj!=null){ 
                acConObj =[SELECT AccountId,ContactId FROM AccountContactRelation WHERE ContactId =:userName.ContactId AND (IsDirect = true OR Account.BillTo_Flag__c = true)];
                for(AccountContactRelation acr:acConObj){
                    if(acr!=null && acr.AccountId!=null)
                        uniqueAccountIdSet.add(acr.AccountId);
                }
                if(uniqueAccountIdSet.size()>0){
                    //List<SellingSupportProgramYear__c> ssProgramYrLst = [Select Id,Name from SellingSupportProgramYear__c where Account__c =: contactObj.AccountId AND (BusinessBuilderProgramStartDate__c <=: Date.Today() AND BusinessBuilderProgramEndDate__c >=: Date.Today()) ORDER BY BusinessBuilderProgramStartDate__c DESC];
                    //System.debug('Account Id-----'+account);
                    Id BBId = ApexPages.currentPage().getParameters().get('BBYear'); //1682 
                    List<SellingSupportProgramYear__c> ssProgramYrLst = [Select Id,Name,BusinessBuilderProgramYear__c from SellingSupportProgramYear__c where Account__c =: account.Id AND BusinessBuilderProgramYear__c =: BBId AND (BusinessBuilderProgramStartDate__c <=: Date.Today() AND BusinessBuilderProgramEndDate__c >=: Date.Today()) ORDER BY BusinessBuilderProgramStartDate__c DESC];
                    Set<String> previous2Years = new Set<String>();
                    if(ssProgramYrLst.size()>=1)
                        previous2Years.add(ssProgramYrLst.get(0).Name);
                   /* if(ssProgramYrLst.size()>=2)//1682
                        previous2Years.add(ssProgramYrLst.get(1).Name);*/
                    //System.debug('previous2Years--'+previous2Years);
                    
                    
                    System.debug('sortItem---'+sortItem+', sortSubItem---'+sortSubItem);
                    
                      Id accId= ApexPages.currentPage().getParameters().get('Accountid'); 
                                     
                    if(sortItem != LPDCR_Constants.CONS_STATUS && sortItem != LPDCR_Constants.CONS_ProgramYear){
                        //getExpenseQuery = 'SELECT Id, Name, Submitted_for_Approval_Date__c , Selling_Support_Program_Year__r.Name, CreditMemo__c, Line_Item_Total__c, DealerAccount__r.Name, Description__c, ApprovalStatus__c, CreatedDate, DealerAccount__c, Total__c, Cloned_Expense_From__c, Cloned_Expense_From__r.Name FROM AMASellingSupportExpense__c where Selling_Support_Program_Year__r.Name IN: previous2Years AND (UltimateParentAR__c IN: uniqueAccountIdSet OR DealerAccount__c IN: uniqueAccountIdSet) ORDER BY '+ sortItem+' '+sortSubItem;
                       
                        getExpenseQuery = 'SELECT Id, Type__c, SalesOperationsBalanceAdjustment__c, Name, Submitted_for_Approval_Date__c ,Selling_Support_Program_Year__r.Name, CreditMemo__c, Line_Item_Total__c, DealerAccount__r.Name, Description__c, ApprovalStatus__c, CreatedDate, DealerAccount__c, Total__c, Cloned_Expense_From__c, Cloned_Expense_From__r.Name FROM AMASellingSupportExpense__c where Selling_Support_Program_Year__r.Name IN: previous2Years AND (UltimateParentAR__c =: accId OR DealerAccount__c =: accId) ORDER BY '+ sortItem+' '+sortSubItem;
                    }
                    else if(sortItem == LPDCR_Constants.CONS_STATUS || sortItem == LPDCR_Constants.CONS_ProgramYear){
                        //getExpenseQuery = 'SELECT Id, Name, Submitted_for_Approval_Date__c , Selling_Support_Program_Year__r.Name, CreditMemo__c, Line_Item_Total__c, DealerAccount__r.Name, Description__c, ApprovalStatus__c, CreatedDate, DealerAccount__c, Total__c, Cloned_Expense_From__c, Cloned_Expense_From__r.Name FROM AMASellingSupportExpense__c where Selling_Support_Program_Year__r.Name IN: previous2Years AND (UltimateParentAR__c IN: uniqueAccountIdSet OR DealerAccount__c IN: uniqueAccountIdSet) AND ('+sortItem+' = \''+sortSubItem+'\') ORDER BY CreatedDate DESC';
                        getExpenseQuery = 'SELECT Id, Type__c, SalesOperationsBalanceAdjustment__c, Name, Submitted_for_Approval_Date__c ,Selling_Support_Program_Year__r.Name , CreditMemo__c, Line_Item_Total__c, DealerAccount__r.Name, Description__c, ApprovalStatus__c, CreatedDate, DealerAccount__c, Total__c, Cloned_Expense_From__c, Cloned_Expense_From__r.Name FROM AMASellingSupportExpense__c where Selling_Support_Program_Year__r.Name IN: previous2Years AND (UltimateParentAR__c =: accId OR DealerAccount__c =: accId) AND ('+sortItem+' = \''+sortSubItem+'\') ORDER BY CreatedDate DESC';
                    }
                    expenseLst = Database.query(getExpenseQuery);   
                    System.debug('expenseLst--'+expenseLst.size());                 
                }                      
            }
        }
       total_Size = expenseLst.size();
       getExpenseQuery+= ' limit :list_size  offset :counter';
       expenseLst = Database.query(getExpenseQuery);     
   } 
   
    public PageReference Beginning() { //user clicked beginning
      counter = 0;
      runQuery();
      return null;
   }

   public PageReference Previous() { //user clicked previous button
   
   if(counter == 0){
       counter = 0;
     return null;
   }
   else{
       
      counter -= list_size;
      runQuery();
      return null;
      }
   }

   public PageReference Next() { //user clicked next button //1529
      if(counter + list_size < total_size )
      counter += list_size;
      runQuery();
      return null;
   }

   public PageReference End() { //user clicked end //1529
      if(math.mod(total_size, list_size)==0)
      counter = total_size-list_size;      
      else
      counter = total_size - math.mod(total_size, list_size);
      
      runQuery();
      return null;
   }

   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter>0) return false; else return true;
   }

   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter + list_size >= total_size) return true; else return false;
   }

   public Integer getTotal_size() {
      return total_size;
   }

   public Integer getPageNumber() {   
      return counter/list_size + 1;
   }

   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }

   public String getRecordNumber() {
      Integer pageNumber = counter/list_size;
      Integer firstRecord = (pageNumber * list_size) + 1;
      Integer lastRecord = (pageNumber * list_size) + list_size;
      lastRecord = (lastRecord <= total_size) ? lastRecord : total_size;
      return String.valueOf(firstRecord + ' to ' + lastRecord);
   }
    //Pagination Code Ends
    
    
    public void doNothing(){
        //To replace doNothing method in VF page to getAccDetails and delete this.
        getAccDetails();
    }
    
    //Inner Class gets ExpenseObject and related LineItems Record
    public class ExpenseLineItemClass{
        public AMASellingSupportExpense__c expenseObj{get;set;}
        public List<AMASellingSupportExpenseLineItem__c> lineItemLst{get;set;}
    }
    
}