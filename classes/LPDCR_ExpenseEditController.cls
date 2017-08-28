/**
*   @Author:    Usman Ali ( Magnet 360 )
*   @Date:      09.09.2016
*   @Jira:      LPDCR-267
*   @Purpose:   Controller behind LPDCR_ExpenseEdit page
*/

public without sharing class LPDCR_ExpenseEditController
{
    public static User userName{get;set;}
    public static Contact contactObj{get;set;}
    public static Account dealerAccount{get;set;}
    public static Account account{get;set;}
    //Private
    public static Id selectedAccountId;
    public static List<Id> accIdLst=new List<Id>();
    public static Id directAccId;
    public static Account selectedAcc{get;set;}
    public static Attachment attachment{
      get {
          if (attachment == null)
            attachment = new Attachment();
          return attachment;
        }
      set;
    }

  // Expense Types from AMASellingExpense object
  @TestVisible
  public List<SelectOption> expenseTypes
    {
      get
      {
        if( expenseTypes == null )
        {
          expenseTypes = new List<SelectOption>();
          /* Get Picklist values dynamically */
         Schema.DescribeFieldResult fieldResult = AMASellingSupportExpense__c.Type__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

         for( Schema.PicklistEntry f : ple)
         {
            expenseTypes.add(new SelectOption(f.getLabel(), f.getValue()));
         }
        }
        return expenseTypes;
      }
      private set;
    }

    // Constructor
    public LPDCR_ExpenseEditController(ApexPages.StandardController sc ) {
        //retrieve contact of logged in user
        userName = [Select Name,ContactId from User where Id=:UserInfo.getUserId()];
        contactObj = [Select OwnerId,Name,AccountId from Contact where Id=:userName.ContactId];
        account = [Select Id, Name, Dealer_Category_catcode30__c, Member_Type_catcode1__c, 
        AR_Customer_Group_JDE__c, BusinessBuilderProgramStatus__c,AccountNumber from 
        Account where Id =: ApexPages.currentPage().getParameters().get('Accountid')];
        //accIdLst = new List<Id>();    
        if(account!=null)       
            accIdLst.add(account.Id);
        if(contactObj.AccountId!=null)
            dealerAccount = [Select Id, Name from Account where Id =: contactObj.AccountId];
        System.debug('in constructor--'+accIdLst);
    }

    //Method to retrieve parent accounts that the user has access to
    @RemoteAction
    //public static List<Account> getParentAccount(Id selectedAccId, SellingSupportProgramYear__c year)
    public static List<Account> getParentAccount(Id selectedAccId)
    {
        List<Account> accLst = new List<Account>();
        List<Account> allAccounts = new List<Account>();
        Set<Id> uniqueAccountIdSet = new Set<Id>();
        try{            
            //userName = [Select Name,ContactId,contact.AccountId from User where Id=:UserInfo.getUserId()];
            //contactObj = [Select OwnerId,Name,AccountId from Contact where Id=:userName.ContactId];
            
            //System.debug('year--'+year);
            //List<SellingSupportProgramYear__c> prgmYearList = [Select Id, Account__c from SellingSupportProgramYear__c where Name=: year.Name];
                        
            //System.debug('prgmYearList---'+prgmYearList);
            
            //List<Account> accList = [Select id,Name,ParentID,Parent.Name,Parent_Account_And_Number__c,Ultimate_Parent__c,AccountNumber, Ultimate_Parent__r.Name,(Select Id, Name, Account__c,Total_Pending_Requests__c, Available_Balance__c from Selling_Support_Program_Years__r) FROM Account WHERE ID=:userName.Contact.AccountId AND Billing_Address_Type_JDE__c = 'X - Active Parent/Child Customer'];
            //System.debug('Account iddddd....'+ApexPages.currentPage().getParameters().get('Accountid'));
            
            System.debug('selectedAccId----'+selectedAccId);
            List<Account> accList = [Select id, Name, ParentID, Parent.Name, Parent_Account_And_Number__c, Ultimate_Parent__c, AccountNumber, Ultimate_Parent__r.Name, (Select Id, Name, Account__c,Total_Pending_Requests__c, Available_Balance__c from Selling_Support_Program_Years__r) FROM Account WHERE ID =: selectedAccId AND Billing_Address_Type_JDE__c = 'X - Active Parent/Child Customer' ];
            
            /*Map<Account,List<SellingSupportProgramYear__c>> accVsSSpy = new Map<Account,List<SellingSupportProgramYear__c>>();
            for(Account ac: accList){
                List<SellingSupportProgramYear__c> sspyLst = new List<SellingSupportProgramYear__c>();
                for(SellingSupportProgramYear__c yr: prgmYearList){                                    
                    if(yr.Account__c == ac.Id){
                        System.debug('yr.Account__c---'+yr.Account__c+',,ac.Id---'+ac.Id);
                        sspyLst.add(yr);                        
                    }
                }
                System.debug('ac--'+ac+',,sspyLst--'+sspyLst);
                accVsSSpy.put(ac,sspyLst);
            }*/
            
            if(accList != null && accList.size()>0)
            {
                 //if(accVsSSpy.get(accList[0])!=null){
                     allAccounts.add(accList[0]);
                 //}
                
                for(Account acc :[SELECT Id, ParentID, Name, AccountNumber, Ultimate_Parent__r.Name, (Select Id, Name, Account__c,Total_Pending_Requests__c, Available_Balance__c from Selling_Support_Program_Years__r) FROM Account WHERE ParentId =:accList[0].Id AND Account.BillTo_Flag__c = true AND Billing_Address_Type_JDE__c = 'X - Active Parent/Child Customer'])
                {
                    //if(accVsSSpy.get(acc)!=null){
                        allAccounts.add(acc);
                    //}
                }
                System.debug('allAccounts--'+allAccounts);
            }
            /*if(ApexPages.currentPage().getParameters().get('AccountId')!=null){
                Id accId = ApexPages.currentPage().getParameters().get('AccountId');
                System.debug('accId----'+accId);
                if(accId!=null){
                    List<Account> accList = [Select id,Name,ParentID,Parent.Name,Parent_Account_And_Number__c,Ultimate_Parent__c,AccountNumber, Ultimate_Parent__r.Name,(Select Id, Name, Account__c,Total_Pending_Requests__c, Available_Balance__c from Selling_Support_Program_Years__r) FROM Account WHERE ID=: accId AND Billing_Address_Type_JDE__c = 'X - Active Parent/Child Customer'];
                     
                }      
            }*/
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
        return allAccounts;
    }

    //Method to get all categories
    /*@RemoteAction
    public static String getAllCategories()
    {
        Set<String> categoryLst= new Set<String>();
        String categoryJson = null;
        try{
            //get user profile
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            //String bbRuleSOQL = 'Select Name,Category__c,Description__c,Max_Reimbursement__c,Checkpoint_Multiplier__c,Reimbursement_Percentage__c,Reimbursement_Subcategory__c, Active__c from BusinessBuilderRules__c where Active__c=true and ApplicableYears__c LIKE \'%'+selectedYear+'%\'';
            //List<BusinessBuilderRules__c> bbRules = Database.query(bbRuleSOQL);
            List<BusinessBuilderRules__c> bbRules = [Select Name,Category__c,Description__c,Max_Reimbursement__c,Checkpoint_Multiplier__c,Reimbursement_Percentage__c,Reimbursement_Subcategory__c, Active__c from BusinessBuilderRules__c where Active__c=true];
            //System.debug('bbRuleSOQL ---'+bbRuleSOQL );
            System.debug('bbRules.size()---'+bbRules.size());
            
            //for Dealer profile
            if(profileName==LPDCR_Constants.CONS_CommunityUser){
                for(BusinessBuilderRules__c item: bbRules) {
                    if(item.Category__c != null && item.Category__c != LPDCR_Constants.CONS_BalanceAdjustment && item.Active__c == True)
                    categoryLst.add(item.Category__c);
                }
            }
            //for other profiles
            else{
               for(BusinessBuilderRules__c item: bbRules) {
                    if(item.Category__c != null && item.Active__c == True)
                    categoryLst.add(item.Category__c);
                }
            }
            
            categoryJson = LPDCR_ExpenseEditHelper.createJsonObjects(categoryLst,null,null,null,null,null,null,null,null,null,null);
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
        if(categoryJson != null){
            return categoryJson;
        }
        else{
            return 'Categories don\'t exist.';
        }
    }*/
    
    @RemoteAction
    public static String getAllCategories(String selectedYear)
    {
        Set<String> categoryLst= new Set<String>();
        String categoryJson = null;
        try{
            //get user profile
            Id profileId=userinfo.getProfileId();
            String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            //String bbRuleSOQL = 'Select Name,Category__c,Description__c,Max_Reimbursement__c,Checkpoint_Multiplier__c,Reimbursement_Percentage__c,Reimbursement_Subcategory__c, Active__c from BusinessBuilderRules__c where Active__c=true and ApplicableYears__c LIKE \'%'+selectedYear+'%\'';
            //List<BusinessBuilderRules__c> bbRules = Database.query(bbRuleSOQL);
            
            List<BusinessBuilderRules__c> allBBRules = BusinessBuilderRules__c.getall().values();
            List<BusinessBuilderRules__c> bbRules = new List<BusinessBuilderRules__c>();
            for(BusinessBuilderRules__c rule: allBBRules){
                if(rule.Active__c==true && rule.ApplicableYears__c.contains(selectedYear)){
                    bbRules.add(rule);
                }
            }
            
            //System.debug('bbRuleSOQL ---'+bbRuleSOQL );
            System.debug('bbRules.size()---'+bbRules.size());
            
            //for Dealer profile
            if(profileName==LPDCR_Constants.CONS_CommunityUser){
                for(BusinessBuilderRules__c item: bbRules) {
                    if(item.Category__c != null && item.Category__c != LPDCR_Constants.CONS_BalanceAdjustment && item.Active__c == True)
                    categoryLst.add(item.Category__c);
                }
            }
            //for other profiles
            else{
                for(BusinessBuilderRules__c item: bbRules) {
                    if(item.Category__c != null && item.Active__c == True)
                    categoryLst.add(item.Category__c);
                }
            }
            //### To Do: Return at the end of the method - what happens if null is returned and is it tested for?
            categoryJson = LPDCR_ExpenseEditHelper.createJsonObjects(categoryLst,null,null,null,null,null,null,null,null,null,null);
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
        if(categoryJson != null){
            return categoryJson;
        }
        else{
            return 'Categories don\'t exist.';
        }
    }

    //Method to get all related subCategories for selected category
    @RemoteAction
    public static String getSubCategories(String selectedCat,String selectedYear)
    {
        List<String> subcategories = new List<string>();
        String subCategoryJson = null;
        //String bbRuleSOQL = 'Select Name,Category__c,Description__c,Max_Reimbursement__c,Checkpoint_Multiplier__c,Reimbursement_Percentage__c,Reimbursement_Subcategory__c, Active__c from BusinessBuilderRules__c where Active__c=true and ApplicableYears__c LIKE \'%'+selectedYear+'%\'';
        //List<BusinessBuilderRules__c> bbRules = Database.query(bbRuleSOQL);
        
        List<BusinessBuilderRules__c> allBBRules = BusinessBuilderRules__c.getall().values();
            List<BusinessBuilderRules__c> bbRules = new List<BusinessBuilderRules__c>();
            for(BusinessBuilderRules__c rule: allBBRules){
                if(rule.Active__c==true && rule.ApplicableYears__c.contains(selectedYear)){
                    bbRules.add(rule);
                }
            }
        
        try{
            for(BusinessBuilderRules__c item: bbRules) {
                if (item.Category__c == selectedCat) {
                    subcategories.add(item.Name);
                }
            }
            subCategoryJson = LPDCR_ExpenseEditHelper.createJsonObjects(null,selectedCat,subcategories,null,null,null,null,null,null,null,null);
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
        if(subCategoryJson != null){
            return subCategoryJson;
        }
        else{
            return 'Subcategories don\'t exist for selected category.';
        }
    }

    //Method to get all the information including description required for selected subcategory
    @RemoteAction
    public static String getAmountBySubCategories(String selectedSubCat)
    {
        Id subCatId;
        Decimal checkPt;
        Decimal maxReimbursement;
        string subCatName;
        string categoryName;
        string description;
        Decimal reimbursePerc;
        String subCatDetails = null;
        //String bbRuleSOQL = 'Select Name,Category__c,Description__c,Max_Reimbursement__c,Checkpoint_Multiplier__c,Reimbursement_Percentage__c,Reimbursement_Subcategory__c, Active__c from BusinessBuilderRules__c where Active__c=true';
        //List<BusinessBuilderRules__c> bbRules = [Select Name,Category__c,Description__c,Max_Reimbursement__c,Checkpoint_Multiplier__c,Reimbursement_Percentage__c,Reimbursement_Subcategory__c, Active__c from BusinessBuilderRules__c where Active__c=true];
        
        List<BusinessBuilderRules__c> allBBRules = BusinessBuilderRules__c.getall().values();
            List<BusinessBuilderRules__c> bbRules = new List<BusinessBuilderRules__c>();
            for(BusinessBuilderRules__c rule: allBBRules){
                if(rule.Active__c==true){
                    bbRules.add(rule);
                }
            }
        
        try{
           for(BusinessBuilderRules__c bbRule: bbRules) {
              if (bbRule.Name == selectedSubCat) {
                if(bbRule.Id!=null)
                  subCatId = bbRule.Id;
                if(bbRule.Checkpoint_Multiplier__c!=null)
                  checkPt = bbRule.Checkpoint_Multiplier__c;
                if(bbRule.Description__c!=null)
                  description = bbRule.Description__c;
                if(bbRule.Max_Reimbursement__c!=null)
                  maxReimbursement = bbRule.Max_Reimbursement__c;
                if(bbRule.Name!=null)
                  subCatName = bbRule.Name;
                if(bbRule.Reimbursement_Percentage__c!=null)
                  reimbursePerc = bbRule.Reimbursement_Percentage__c;
                if(bbRule.Category__c!=null)
                  categoryName = bbRule.Category__c;
              }
            }
            subCatDetails = LPDCR_ExpenseEditHelper.createJsonObjects(null,null,null,selectedSubCat,subCatId,checkPt,description,maxReimbursement,subCatName,reimbursePerc,categoryName);
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
        if(subCatDetails!=null){
            System.debug('return subCatDetails-----------'+subCatDetails);
            return subCatDetails;
        }
        else{
            return 'Subcategory details don\'t exist.';
        }
    }

    //Method to get an expense based on id including all line items
    @RemoteAction
    public static ExpenseLineItemClass getExpenseDetail(Id expenseId)
    {
        ExpenseLineItemClass expLineItems = null;
        try{
            AMASellingSupportExpense__c expense = [Select Id, Name, Bill_To_Sold_To_Account__r.Name, Bill_To_Sold_To_Account__r.AccountNumber, Description__c, Line_Item_Total__c, Selling_Support_Program_Year__r.Program_Year_Allocation__c, Selling_Support_Program_Year__r.Total_Pending_Requests__c, Selling_Support_Program_Year__r.Total_Approved_Requests__c, Selling_Support_Program_Year__r.Available_Balance__c, DealerAccount__c, DealerAccount__r.Name, DealerAccount__r.AccountNumber, ApprovalStatus__c, Total_Pending__c, AMABalanceFF__c from AMASellingSupportExpense__c where Id=: expenseId];
            List<AMASellingSupportExpenseLineItem__c> lineItems = [ Select Id, Name, Expense__c, Total_Spend__c, Description__c, Reimbursement_Category__c, Date__c, Reimbursement_Sub_category__c, ExpenseAmount__c,CreatedDate, (SELECT Id, Name FROM Attachments) from AMASellingSupportExpenseLineItem__c where Expense__c =: expense.Id ORDER BY CreatedDate ];//1840 replaced ORDER BY Name with CreatedDate 
            expLineItems = new ExpenseLineItemClass();
            expLineItems.expenseObj = expense;
            expLineItems.lineItemLst = lineItems;                        
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
        return expLineItems;
    }
    
    //To get the List of Program years based on parent account
    @RemoteAction
    public static List<SellingSupportProgramYear__c> getProgramYears(Id selectedAccId, Id selectedBBProgramYearId)
    //public static List<SellingSupportProgramYear__c> getProgramYears(Id selectedAccId)// 1682
    {
        //userName = [Select Name,ContactId from User where Id=:UserInfo.getUserId()];
        //contactObj = [Select OwnerId,Name,AccountId from Contact where Id=:userName.ContactId];
        //List<SellingSupportProgramYear__c> programYears = [Select Id, Name, Available_Balance__c,Total_Pending_Requests__c, Total_Balance_Adjustments__c, Total_Approved_Requests__c from SellingSupportProgramYear__c where Account__c=: contactObj.AccountId AND (BusinessBuilderProgramStartDate__c <=: Date.Today() AND BusinessBuilderProgramEndDate__c >: Date.Today()) ORDER BY BusinessBuilderProgramStartDate__c DESC];
        
        System.debug('selectedBBProgramYearId--'+selectedBBProgramYearId);
        List<SellingSupportProgramYear__c> programYears = [Select Id, Name, Available_Balance__c,Total_Pending_Requests__c, Total_Balance_Adjustments__c, Total_Approved_Requests__c,BusinessBuilderProgramYear__c from SellingSupportProgramYear__c where Account__c=: selectedAccId AND BusinessBuilderProgramYear__c=:selectedBBProgramYearId AND (BusinessBuilderProgramStartDate__c <=: Date.Today() AND BusinessBuilderProgramEndDate__c >: Date.Today()) ORDER BY BusinessBuilderProgramStartDate__c DESC];
        System.debug('programYears2--'+programYears); //added BusinessBuilderProgramYear__c and condition BusinessBuilderProgramYear__c=:Name 1682
        return programYears;
    }
    
    //Heena Tanna : 30-Sept-2016 Changes done as per LPDCR-616.Parameters of saveExpense and saveLineItem changed.
    //Shruti: 30/08/2016; LPDCR-290. Updated parameters and field value assignment.
    // Method to save Expense record
    @RemoteAction
    public static String saveExpense(String accountId, String description, String year)
    {
        AMASellingSupportExpense__c expense = null;
        try{
            Account acc = [Select Id, ParentId from Account where Id =: accountId];
            //userName = [Select Name,ContactId,contact.AccountId from User where Id=:UserInfo.getUserId()];
            //contactObj = [Select OwnerId,Name,AccountId from Contact where Id=:userName.ContactId];
            SellingSupportProgramYear__c prgmYear;
            //retrieve current year
            if(acc.ParentId != null)
                prgmYear = [Select Id, Account__c from SellingSupportProgramYear__c where Name=: year and Account__c=: acc.ParentId limit 1];
            else
                prgmYear = [Select Id, Account__c from SellingSupportProgramYear__c where Name=: year and Account__c=: accountId limit 1];                
            
            //retrieve contact of logged in user
            //userName = [Select Name,ContactId from User where Id=:UserInfo.getUserId()];
            //contactObj = [Select OwnerId,Name,AccountId from Contact where Id=:userName.ContactId]; 
                        
            //insert expense record
            //expense = new AMASellingSupportExpense__c(Bill_To_Sold_To_Account__c = accountId, DealerAccount__c = prgmYear.Account__c, Type__c = LPDCR_Constants.CONS_EXPENSE, Description__c = description, Selling_Support_Program_Year__c = year);
            //System.debug('year----'+year || acc.Id==contactObj.AccountId);
            if(prgmYear !=null){
                if(acc.ParentId == null)
                    expense = new AMASellingSupportExpense__c(Bill_To_Sold_To_Account__c = accountId, DealerAccount__c = accountId, Type__c = LPDCR_Constants.CONS_EXPENSE, Description__c = description, Selling_Support_Program_Year__c = prgmYear.Id);
                else{
                    expense = new AMASellingSupportExpense__c(Bill_To_Sold_To_Account__c = accountId, DealerAccount__c = acc.ParentId, Type__c = LPDCR_Constants.CONS_EXPENSE, Description__c = description, Selling_Support_Program_Year__c = prgmYear.Id);
                }
                //set record type; LPDCR-751
                expense.RecordTypeId = [Select Id, SobjectType, Name From RecordType WHERE DeveloperName ='Reimbursement_Request' and SobjectType ='AMASellingSupportExpense__c' limit 1].Id;
                
                upsert expense ;
            }
            else{
                return 'Program year not found.';
            }
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
        if(expense != null){
            return expense.Id;
        }
        else{
            return 'Expense not created.';
        }
    }


    // Method to create or update expenseLineItems
    @RemoteAction
    public static String upsertLineItem(String lineItemId, String expenseId, String totalAmount, String reimbursableAmount, String expensedesc, String expenseLineItemCategory, String expenseDate, String expenseLineItemSubCategory )
    {
        AMASellingSupportExpense__c expense = [Select Id, Selling_Support_Program_Year__r.Available_Balance__c, Selling_Support_Program_Year__r.Total_Pending_Requests__c from AMASellingSupportExpense__c where Id=:expenseId];
        AMASellingSupportExpenseLineItem__c line;
        try{
            if(String.isBlank(lineItemId)){
                //Inserting Line Item
              line = new AMASellingSupportExpenseLineItem__c( Expense__c = expenseId, Total_Spend__c = Decimal.valueOf(totalAmount),
                                                        Max_Reimbursement__c = Decimal.valueOf(reimbursableAmount), Date__c = Date.valueOf(expenseDate),
                                                        Description__c = expensedesc, Reimbursement_Category__c = expenseLineItemCategory ,
                                                        Reimbursement_Sub_category__c = expenseLineItemSubCategory );
              System.debug('line created--'+line);
              insert line ;
            }
            else{
                //Updating Line Item
                AMASellingSupportExpenseLineItem__c oldline = [Select ExpenseAmount__c,Reimbursement_Percentage__c,Max_Reimbursement__c, Expense__c, Total_Spend__c, Date__c, Description__c, Reimbursement_Category__c, Reimbursement_Sub_category__c
                                                           from AMASellingSupportExpenseLineItem__c where Id=: lineItemId and Expense__c=: expenseId];
                line = new AMASellingSupportExpenseLineItem__c();
                line = oldline;
                line.Total_Spend__c = Decimal.valueOf(totalAmount);
                line.Date__c = Date.valueOf(expenseDate);
                line.Description__c = expensedesc;
                line.Reimbursement_Category__c = expenseLineItemCategory;
                line.Reimbursement_Sub_category__c = expenseLineItemSubCategory;
                AMASellingSupportExpense__c expObj = [Select Id,Line_Item_Total__c,AMABalanceFF__c,Selling_Support_Program_Year__r.Available_Balance__c,Selling_Support_Program_Year__r.Total_Pending_Requests__c from AMASellingSupportExpense__c where Id=:expenseId];
                
                List<BusinessBuilderRules__c> allBBRules = BusinessBuilderRules__c.getall().values();
                List<BusinessBuilderRules__c> bbRules = new List<BusinessBuilderRules__c>();
                for(BusinessBuilderRules__c rule: allBBRules){
                    if(rule.Active__c==true){
                        bbRules.add(rule);
                    }
                }
                
                for(BusinessBuilderRules__c rule:bbRules){
                
                    if(rule.Category__c == expenseLineItemCategory && rule.Reimbursement_Subcategory__c == expenseLineItemSubCategory){
                        line.Reimbursement_Percentage__c = rule.Reimbursement_Percentage__c;
                    }
                    if (((line.Total_Spend__c*line.Reimbursement_Percentage__c/100) > (expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c))
                     &&((rule.Max_Reimbursement__c==null && ((expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c) < expObj.Selling_Support_Program_Year__r.Available_Balance__c) )
                     ||(rule.Max_Reimbursement__c!=null && ((expObj.Selling_Support_Program_Year__r.Available_Balance__c-expObj.Line_Item_Total__c) < rule.Max_Reimbursement__c))
                     )){
                                Decimal amountToCompair = expObj.Line_Item_Total__c - line.ExpenseAmount__c;
                                amountToCompair  = expObj.Selling_Support_Program_Year__r.Available_Balance__c - amountToCompair;
                                if((line.Total_Spend__c*line.Reimbursement_Percentage__c/100)> amountToCompair){
                                    line.ExpenseAmount__c = amountToCompair;
                                }
                                else{
                                    line.ExpenseAmount__c = (line.Total_Spend__c*line.Reimbursement_Percentage__c/100);
                                }
                     }
                     
                 }
                     
                upsert line;
            }
            return line.Id ;
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
        return null;
    }

    //Method to delete line item of the provided id
    @RemoteAction
    public static void deleteLineItem(Id lineItemId)
    {
        try{
            AMASellingSupportExpenseLineItem__c liObj = [Select Id from AMASellingSupportExpenseLineItem__c where Id=: lineItemId];
            delete liObj;
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
    }
    //Method to delete expense of the provided id //1893
    @RemoteAction
    public static void deleteExpense(Id deleteexpId)
    {
     try{
            AMASellingSupportExpense__c expObj = [Select Id from AMASellingSupportExpense__c where Id=: deleteexpId];
            delete expObj;
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
    
    }
    //Method to delete line item of the provided id
    @RemoteAction
    public static void deleteAttachment(Id attId)
    {
        try{
            Attachment att = [Select Id from Attachment where Id=: attId];
            delete att;
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
    }

    //Method to submit expense for approval based on expense Id
    @RemoteAction
    public static void submitForApproval(Id expenseId){
    try{
        Approval.ProcessSubmitRequest approvalReq= new Approval.ProcessSubmitRequest();
        approvalReq.setComments('Submitted for Approval');
        approvalReq.setObjectId(expenseId);
        Approval.ProcessResult result = Approval.process(approvalReq);
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_ExpenseEditController',ex, 'Exception occurred');
        }
    }

    //upload attachment
    @RemoteAction
    public static String uploadAttachment(String lineItemId, String attachmentBody, String attachmentName, String attachmentId){
        if(lineItemId != null) {
                if(attachmentBody != null) {
                    String newBody = '';
                    if(attachmentId!=null){
                        attachment = getAttachment(attachmentId);
                        if(attachment.Body != null) {
                            newBody = EncodingUtil.base64Encode(attachment.Body);
                        }
                    }
                    else{
                        attachment = new Attachment();
                    }
                    
                    newBody += attachmentBody;
                    attachment.Body = EncodingUtil.base64Decode(newBody);
                    if(attachmentId == null) {
                        attachment.Name = attachmentName;
                        attachment.parentId = lineItemId;
                    }
                    upsert attachment;
                    return attachment.Id;
                } else {
                    return 'Attachment Body was null';
                }
            } else {
                return 'Line Item could not be found';
            }         
    }
    
    //Method to get existing attachments to update
    private static Attachment getAttachment(String attId) {
        list<Attachment> attachments = [SELECT Id, Body FROM Attachment WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }
    
        
    //Inner Class gets ExpenseObject and related LineItems Record
    public class ExpenseLineItemClass{
        public AMASellingSupportExpense__c expenseObj{get;set;}
        public List<AMASellingSupportExpenseLineItem__c> lineItemLst{get;set;}
        //public List<SellingSupportProgramYear__c> associatedYears{get;set;}
    }

}