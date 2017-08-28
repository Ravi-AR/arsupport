/******************************************************************************
 * Controller for the LPDCR_DealerVIPPointsTonsReportDetail page 
 * 
 * @Author: Heena Tanna
 * @Date: July 03, 2017 
 * @Jira: LPDCR-2029
 */

public without sharing class LPDCR_DealerVIPPointsTonsReportCntrlr {
  
  
  public LPDCR_VIPTonsReport accountReport { get; set; }
  public LPDCR_VIPTonsReport level3Report { get; set; }
  public LPDCR_VIPTonsReport productReport { get; set; }
  
  //public LPDCR_VIPTonsReport.Row l_summary_row { get; set; }
  
  public Account acc{get;set;} 
  private LPDCR_ContentServiceUtil l_content_util;
  private String account_id; 
  public String level3_id{get;set;}
  //public String product_id{get;set;}
  public String fd1_customer_id{get;set;}
  public String active_account_id
  {
    get
    {
        if( active_account_id == null )
        {   
            if( ApexPages.currentPage().getParameters().get( 'dlrAccountId' ) == null )
            {
                active_account_id = [ SELECT AccountNumber FROM Account WHERE Id = :selectedAccountId LIMIT 1 ].AccountNumber;
            }
            else
            {
                active_account_id = ApexPages.currentPage().getParameters().get( 'dlrAccountId' );
                if( UserInfo.getUserType() != 'STANDARD' )
                {
                    String l_contact_id = [ SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1 ].ContactId;
                                                 // Check to make sure the current
                                                 // user has access to the account
                    List<AccountContactRelation> l_acct_access = [ SELECT Id
                                                                   FROM AccountContactRelation
                                                                   WHERE Account.AccountNumber = :active_account_id
                                                                     AND ContactId = :l_contact_id ];
                    if( l_acct_access.size() == 0 )
                    {
                        active_account_id = null;
                        ApexPages.addMessage( new ApexPages.Message( ApexPages.severity.ERROR, 'You are not authorized to view the specified account information' ) );
                    }
                }// /END if( UserInfo.getUserType() != 'STANDARD' )

            }// /END if( dlrAccountId  == null)
        }// /if( active_account_id == null )
        return active_account_id; 
    }
    set;
  }
  
  public String selectedAccountId
    {
        get {
            if( selectedAccountId == null ) {
                selectedAccountId = LPDCR_ChangeAccountController.getSelectedAccId();
            }
            return selectedAccountId;
        }
        set;
    }
   public LPDCR_ContentServiceUtil content_service{
        get{
            if( content_service == null ){
                content_service = new LPDCR_ContentServiceUtil();
            }
            return content_service;
        }
        set;
    }
    
 /******************************************************************************
 * Constructor
 */
  public
  LPDCR_DealerVIPPointsTonsReportCntrlr()
  {
    System.debug( 'START: LPDCR_DealerVIPPointsTonsReportCntrlr.constructor()' );
    l_content_util = new LPDCR_ContentServiceUtil();
    getAccountDetails();
    getDealerAccountList();
   
    System.debug( 'END: LPDCR_DealerVIPPointsTonsReportCntrlr.constructor()' );
  }
  
  public void getAccountDetails()
  {
      
    System.debug( 'active_account_id = ' + active_account_id );
    try
    {
        acc =[Select Id, Name from Account WHERE AccountNumber = :active_account_id];
        System.debug('Account Name--' + acc.Name);
    }
    catch( Exception l_ex )
    {
        System.debug( 'Account Number ' + active_account_id + ' does not exist in salesforce.' );
        /*
        ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Account Number ' + active_account_id + ' does not exist in the system.' );
        ApexPages.addMessage( l_msg );
        */
    }
 
  } 
  public void getDealerAccountList()
  {
        Account l_account;
        User l_user; 

                                                 // Find the account number for the
                                                 // the current users selected account
        try
        {
            accountReport = content_service.getDealerAccountDetailReport( active_account_id );
            level3Report = null;
            productReport = null;
            
            if( accountReport.success == false || (accountReport.success && accountReport.row == null && accountReport.row.size() > 0 ) )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.Invalid_AccountNo_For_VIP );
                ApexPages.addMessage( l_msg );
            }
        }
        catch( Exception l_ex )
        {
            ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.Invalid_AccountNo_For_VIP );
            ApexPages.addMessage( l_msg );
        }

        System.debug('getDealerAccountList summary_report' + accountReport);
  }
  
  public void getDealerLevel3List(){ //String level3_id
 
        
        System.debug ('fd1_customer_id ---'+ fd1_customer_id );
         
        Account l_account;
        User l_user; 

                                                 // Find the account number for the
                                                 // the current users selected account
        try
        {
                
            level3Report = content_service.getDealerAccountLevel3DetailReport( active_account_id, fd1_customer_id );
            productReport = null;
            
            if( level3Report.success == false || (level3Report.success && level3Report.row == null && level3Report.row.size() > 0 ) )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.Invalid_AccountNo_For_VIP );
                ApexPages.addMessage( l_msg );
            }
        }
        catch( Exception l_ex )
        {
            ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.LPDCR_Report_Error_Message );
            ApexPages.addMessage( l_msg );
        }
        System.debug('Dealer level3Report--'+ level3Report);
  }
  
  public void getDealerProductList(){//String product_id
        Account l_account;
        User l_user; 

                                                 // Find the account number for the
                                                 // the current users selected account
        try
        {
            System.debug('productReport fd1_customer_id--'+ fd1_customer_id);
            System.debug('productReport level3_id--'+ level3_id);
            productReport = content_service.getDealerAccountProductDetailReport( fd1_customer_id,active_account_id,level3_id );
           
            if( productReport.success == false || (productReport.success && productReport.row == null && productReport.row.size() > 0 ) )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.Invalid_AccountNo_For_VIP );
                ApexPages.addMessage( l_msg );
            }
        }
        catch( Exception l_ex )
        {
            ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.LPDCR_Report_Error_Message );
            ApexPages.addMessage( l_msg );
        }
        System.debug('Dealer productReport--'+ productReport);    
  } 
  
/******************************************************************************
 * Method to return the Base64 encoded string of the compressed zip file 
 * for the full report. Used to allow the dealer to download the full report

    public
    string
    getFullDealerReport()
    {
        String l_csv_report = content_service.getDealerFullReportAsCSV( active_account_id );
        
        return l_csv_report;
    }
 */  
} // /END Class