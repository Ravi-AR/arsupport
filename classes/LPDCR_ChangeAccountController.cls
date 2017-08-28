/**
*   @Author:    Heena Tanna
*   @Date:      10.03.2017
*   @Jira:      LPDCR-1991
*   @Purpose:   Controller behind LPDCR_ChangeAccount Component
*/

public without sharing class LPDCR_ChangeAccountController {
    
    public Account selectedAcc{get;set;}
    public static User userName{get;set;}
    public static Contact contactObj{get;set;}
    public List<Account> accLst{get;set;}
    public static String selectedAccountId{get;set;}
    
    public Boolean init{
        
        get{
                                                 // Moved getAccountList() method
                                                 // here to prevent DML in constructor
            if(UserInfo.getUserType() != 'Standard'){                                     // when session cache is set
            getAccountList();
            }
            return false;
        }
        set;
    }

/******************************************************************************
 * Constructor
 */
    public LPDCR_ChangeAccountController(){
        System.debug( 'START: LPDCR_ChangeAccountController.constructor()' );
        //getAccountList();
        System.debug( 'END: LPDCR_ChangeAccountController.constructor()' );
    }
    
   //Get list of Accounts for the logged in community user. 
    public void getAccountList()
    {
        System.debug( 'START: LPDCR_ChangeAccountController.getAccountList()' );   
        try{
              
                
	            selectedAccountId = getSelectedAccId();
	            
	            selectedAcc = [Select Id,ParentId, Name, Dealer_Category_catcode30__c, Member_Type_catcode1__c, AR_Customer_Group_JDE__c, BusinessBuilderProgramStatus__c,AccountNumber FROM Account WHERE Id =: selectedAccountId];
	            System.debug('CAselectedAcc--'+selectedAcc);
	            System.debug('selectedAcc ParentId--'+ selectedAcc.ParentId);  
	            List<AccountContactRelation> acrLst = [Select Id, AccountId, Account.Name, Account.ParentId, ContactId,AuthorizedBusinessBuilderParentAR__c, IsDirect FROM AccountContactRelation WHERE ContactId=:contactObj.Id AND (IsDirect =: true OR Account.ParentId =: null OR Account.ParentId != null) ]; //added (or Account.ParentId != null) -LPDCR-2629
	            List<Id> accIdLst = new List<Id>();
	            Id directAccId;            
	            
	            for(AccountContactRelation acr: acrLst){
	                if(acr.IsDirect==True){
	                    directAccId = acr.AccountId;
	                }
	                    accIdLst.add(acr.AccountId); 
	            System.debug('accIdLst----' + accIdLst);
	            } 
	            accLst = [Select Id, Name, Member_Type_catcode1__c, BusinessBuilderProgramStatus__c, Business_Builder_Program_Tier__c, AR_customer_group_JDE__C,  Dealer_Category_catcode30__c,AccountNumber,ParentId FROM Account WHERE Id in: accIdLst];
                System.debug('accLst----' + accLst);
         }//try block
         catch(Exception ex){
            System.debug('Exception in LPDCR_ChangeAccountController.getAccountList() - ' + ex);
            ApexPages.addMessage( new ApexPages.Message( ApexPages.severity.ERROR, 'An error occurred while trying to set your current Account.' ) );
            LOLUtilities.LogErrMsg('LPDCR_ChangeAccountController',ex, 'Exception occurred');
         }
         System.debug( 'END: LPDCR_ChangeAccountController.getAccountList()' );
    }
    
    //Method for Cache Session.
    public static final String CACHE_SEL_ACCT_ID = 'selectedAccountId';
    public static final String PARM_SEL_ACCT_ID = 'selectedAccountId';
    public static String getSelectedAccId()
    {
        System.debug( 'START: LPDCR_ChangeAccountController.getSelectedAccId()' );
        //Get User Detail
        try{
            userName = [Select Name,ContactId from User where Id=:UserInfo.getUserId()];
            if(userName.ContactId!=null){
                contactObj = [Select Id,OwnerId,Name,AccountId,Account.BillTo_flag__c from Contact where Id=:userName.ContactId];
            }
            
            if(ApexPages.currentPage().getParameters().get(PARM_SEL_ACCT_ID)!=null)
            {    
                
                selectedAccountId = ApexPages.currentPage().getParameters().get(PARM_SEL_ACCT_ID);
               
                if(selectedAccountId !=null && selectedAccountId != Cache.Session.get(CACHE_SEL_ACCT_ID))
                {
                    Cache.Session.put(CACHE_SEL_ACCT_ID,selectedAccountId);
   
                }
                
            }                
            else{ 
                
                if(Cache.Session.get(CACHE_SEL_ACCT_ID)!=null)
                {
                    selectedAccountId =(ID)Cache.Session.get(CACHE_SEL_ACCT_ID); 
                    
                }
                else if(contactObj != null)
                {
                    selectedAccountId = contactObj.AccountId;
                    Cache.Session.put(CACHE_SEL_ACCT_ID,selectedAccountId);
                   
                }
                
             }   
            System.debug( 'Return: selectedAccountId = ' + selectedAccountId );
            System.debug( 'END: LPDCR_ChangeAccountController.getSelectedAccId()' );
            return selectedAccountId;
          }//try block
          catch(Exception ex){
            System.debug('Exception-'+ex);
            LOLUtilities.LogErrMsg('LPDCR_ChangeAccountController',ex, 'Exception occurred');
            
            System.debug( 'Return: null' );
            System.debug( 'END: LPDCR_ChangeAccountController.getSelectedAccId()' );
            
            throw ex;
            
            return null;
          }
    }
    
}// /END Class