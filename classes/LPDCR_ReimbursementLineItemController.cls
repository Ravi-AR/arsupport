/**
*   @Author:    Heena Tanna
*   @Date:      15.02.2017
*   @Jira:      LPDCR-1771
*   @Purpose:   Controller behind LPDCR_ReimbursementLineItem page
*/

public with sharing class LPDCR_ReimbursementLineItemController{

    public String category { get; set; }
    public String subcategory {get; set;} 
    
    public AMASellingSupportExpenseLineItem__c lineItemObj{get;set;}
    private Id expenseId;
    public String ssprgyear; 
    
    /*public Boolean editCategory
    {
        get
        {
            if( editCategory == null )
            {
                editCategory = canEditCategory();
            }
            return editCategory;
        }
        set;
    }*/
    
 public LPDCR_ReimbursementLineItemController(ApexPages.StandardController controller)
 {
     List<String> fieldList = new List<String>();
     fieldList.add('Reimbursement_Category__c');
     fieldList.add('Reimbursement_Sub_category__c');
     
     if(!test.isRunningTest())
     {     
     controller.addFields(fieldList);
     }
    lineItemObj=(AMASellingSupportExpenseLineItem__c)controller.getRecord();
        system.debug('**'+lineItemObj.Expense__c);
        expenseId =  lineItemObj.Expense__c;
       
       
     if(lineItemObj.Id != null)
     {
         category = lineItemObj.Reimbursement_Category__c;
         subcategory = lineItemObj.Reimbursement_Sub_category__c;
     }
     
     if(expenseId != null)
     {
     List<AMASellingSupportExpense__c> expObj=[Select Id,Name,Selling_Support_Program_Year__r.Name FROM AMASellingSupportExpense__c WHERE ID=:expenseId];
     ssprgyear = expObj[0].Selling_Support_Program_Year__r.Name;
     
     }  
     getCategorySelectList();  
 }


 //Generate Dropdown
    public List<SelectOption> getCategorySelectList(){
     List<SelectOption> options = new List<SelectOption>();
     set<String>  setUniqueCategory = new set<String>();      
     
     //Find all categories from Custom Settings
      for( BusinessBuilderRules__c bbRules :BusinessBuilderRules__c.getAll().values())
      {
      if(bbRules.ApplicableYears__c != null && bbRules.ApplicableYears__c.contains(ssprgyear) && bbRules.Active__c == True){ 
        if(!setUniqueCategory.contains(bbRules.Category__c))
        {
           options.add(new SelectOption(bbRules.Category__c, bbRules.Category__c));
           setUniqueCategory.add(bbRules.Category__c);       
        }
      }
     
     } 
        if(category == null){
            category = options[0].getValue();
         }
         getSubCategorySelectList();
    return options;
    }
    
    public List<SelectOption> getSubCategorySelectList(){
       List<SelectOption> options = new List<SelectOption>();
        
       for( BusinessBuilderRules__c bbRules :BusinessBuilderRules__c.getAll().values())
       {
           if(bbRules.ApplicableYears__c != null && bbRules.ApplicableYears__c.contains(ssprgyear) && bbRules.Active__c == True){
           if(bbRules.Category__c == this.category) {
               
               options.add(new SelectOption(bbRules.Reimbursement_Subcategory__c, bbRules.Reimbursement_Subcategory__c));
           }
          }
       }
    options.sort();
    return options;
    }
 //Method to save line Item
 public PageReference saveLineItem()
 {
    try{
     /*
     lineItemObj.Reimbursement_Category__c = category;
     lineItemObj.Reimbursement_Sub_category__c = subcategory;*/
     Profile userProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
     
     
     //Replaced this logic by using the canEditCategory() method and updating the VF page only render editable
     if ((lineItemObj.Reimbursement_Category__c != category && !Schema.sObjectType.AMASellingSupportExpenseLineItem__c.fields.Reimbursement_Category__c.isUpdateable()) || 
        (lineItemObj.Reimbursement_Sub_category__c != subcategory &&!Schema.sObjectType.AMASellingSupportExpenseLineItem__c.fields.Reimbursement_Sub_category__c.isUpdateable()) ){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Insufficient access to update category/subcategory'));
         System.debug('In if------------');
         return null;
     }
     
     else if ((lineItemObj.Approval_Status__c == 'Submitted for Approval') &&
     (userProfile.Name!='System Administrator' && userProfile.Name!='Sales Operations' && UserInfo.getUserId()!=lineItemObj.Expense__r.Area_Sales_Manager__c && UserInfo.getUserId()!=lineItemObj.Expense__r.Sales_Representative__c && UserInfo.getUserId()!=lineItemObj.Expense__r.CurrentApprover__c)){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Record Submitted for Approval can not be modified'));
         System.debug('else if------------');
         return null;
     }
     
    else {
           lineItemObj.Reimbursement_Category__c = category;
           lineItemObj.Reimbursement_Sub_category__c = subcategory;
           //Profile userProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
           System.debug('Else------------');
           
          }
          
          
     
     /*else 
     if( lineItemObj.Id != null
         && Approval.isLocked( lineItemObj.Id ) 
         && userProfile.Name != 'System Administrator' 
         && userProfile.Name != 'Sales Operations' 
         && UserInfo.getUserId() != lineItemObj.Expense__r.Area_Sales_Manager__c 
         && UserInfo.getUserId() != lineItemObj.Expense__r.Sales_Representative__c 
         && UserInfo.getUserId() != lineItemObj.Expense__r.CurrentApprover__c )
     {
         ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.FATAL,'Record Submitted for Approval can not be modified' ) );
         return null;
     }*/
     // Old way of checking if the record should not be updateable by the user
     
     
     
     
     upsert lineItemObj;
     
     PageReference pageRef = new PageReference('/'+lineItemObj.Id);
     pageRef.setRedirect(true);
     return pageRef;
     }
     
     
     catch(Exception ex)
     {
         System.debug('Exception Occured'+ ex);
     }
     return null;
 }
 //Method for back button
 public PageReference backMethod()
    {
        PageReference pg = new PageReference('/'+expenseId);
        pg.setRedirect(true);
        return pg;
    } 

    /******************************************************************************
     * Method to check if the user has edit access to the Category and Subcategory
     * fields
     */
   /*public Boolean canEditCategory()
    {
        Boolean l_access = true;
        if( ( !Schema.sObjectType.AMASellingSupportExpenseLineItem__c.fields.Reimbursement_Category__c.isUpdateable() ) 
            || 
            ( !Schema.sObjectType.AMASellingSupportExpenseLineItem__c.fields.Reimbursement_Sub_category__c.isUpdateable() ) 
          )
        {
             l_access = false;
        }
        return l_access;
    }*/
    
 }// /END Class