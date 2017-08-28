/******************************************************************************
 * Controller for the LPDCR_AccountPointsDetailExport.page. Needs to run 
 * Without sharing so that the access check for dealer users works correctly
 * 
 * @Author: Magnet 360
 * @Date: Jul 6, 2017 
 * @Jira: LPDCR-2029
 *
 * @Update: 07/17/2017 : Magnet 360 : Change to run WITHOUT SHARING
 */

public without sharing class 
LPDCR_DealerVIPPointsTonsExportCntrlr 
{

    public LPDCR_VIPTonsReport report { get; set; }

                                                 // Used by Internal users who
                                                 // are viewing a Dealers report
                                                 // Value is set from a URL Parameter
    private String accountIdParam
    {
        get {
            if( accountIdParam == null ) {
                accountIdParam = ApexPages.currentPage().getParameters().get( 'dlrAccountId' );
            }
            return accountIdParam;
        }
        set;
    }
    
    private String selectedAccountId
    {
        get {
            if( selectedAccountId == null ) {
                selectedAccountId = LPDCR_ChangeAccountController.getSelectedAccId();
            }
            return selectedAccountId;
        }
        set;
    }
    
    public String active_account_id
    {
        get
        {
          if( active_account_id == null )
          {
              if( accountIdParam == null )
              {
                  active_account_id = [ SELECT AccountNumber FROM Account WHERE Id = :selectedAccountId LIMIT 1 ].AccountNumber;
              }
              else
              {
                  active_account_id = accountIdParam;
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
    
    public LPDCR_ContentServiceUtil content_service
    {
        get
        {
            if( content_service == null )
            {
                content_service = new LPDCR_ContentServiceUtil();
            }
            return content_service;
        }
        set;
    }
    
    public String csv_string { get; set; }
    
/******************************************************************************
 * Constructor
 */
  public
  LPDCR_DealerVIPPointsTonsExportCntrlr()
  {
    System.debug( 'START: LPDCR_DealerVIPPointsTonsExportCntrlr.constructor()' );

                                   // Check to see if an account id was
                                   // passed in through the URL. If so, use
                                   // that id to generate the report
                                   // (Internal users can download dealer reports this way)
                                   // Otherwise, use the Selected Account
                                   // If the Id is passed in through the URL, and
                                   // the user is a dealer
                                   // make sure the current user has access to it
                                   // in their related accounts, otherwise deny
                                   // them access.
    
    if( active_account_id != null )
    {
        report = content_service.getDealerFullReport( active_account_id );

        csv_string = 'Parent FD1 Customer Number,Parent FD1 Customer,Parent AR Customer Number,Parent AR Customer,Level3 ID,Level3,Product Name,Product Number,'
                    + 'Sales Tons CYM,Sales Tons PYM,Sales Tons YTD,Sales Tons PYTD,Sales Tons PY,VIP Points CYM,VIP Points PYM,VIP Points YTD,VIP Points PYTD,VIP Points PY'
                    + '\n';
                        
        for( LPDCR_VIPTonsReport.Row l_row : report.row )
        {
            
            csv_string += '"' + l_row.fd1_customer_number + '",'
                       + '"' + l_row.fd1_customer_name + '",'
                       + '"' + l_row.ar_customer_number + '",'
                       + '"' + l_row.ar_customer_name + '",'
                       + '"' + l_row.level_3_id + '",'
                       + '"' + l_row.level_3_name + '",'
                       + '"' + l_row.product_name + '",'
                       + '"' + l_row.product_id + '",'
                       + '"' + l_row.shipped_tons_cm + '",'
                       + '"' + l_row.shipped_tons_pym + '",'
                       + '"' + l_row.shipped_tons_ytd + '",'
                       + '"' + l_row.shipped_tons_pytd + '",'
                       + '"' + l_row.shipped_tons_py + '",'
                       + '"' + l_row.vip_points_cm + '",'
                       + '"' + l_row.vip_points_pym + '",'
                       + '"' + l_row.vip_points_ytd + '",'
                       + '"' + l_row.vip_points_pytd + '",'
                       + '"' + l_row.vip_points_py + '"'
                       + '\n';
                       
                       /*
                       + '"' + l_row.shipped_tons_py + '",'
                       + '"' + l_row.vip_points_ytd + '",'
                       + '"' + l_row.vip_points_pytd + '",'
                       + '"' + l_row.vip_points_py + '",'
                       + '"' + l_row.vip_points_cm + '",'
                       + '"' + l_row.vip_points_pym + '",'
                       + '"' + l_row.shipped_tons_ytd + '",'
                       + '"' + l_row.shipped_tons_cm + '",'
                       + '"' + l_row.shipped_tons_pytd + '",'
                       + '"' + l_row.shipped_tons_pym + '"'
                       + '\n';
                       */
        }// /END for( report )
    }// /END if( active_account_id != null )
    
    if( active_account_id == null || ApexPages.getMessages().size() > 0 )
    {
        csv_string = ApexPages.getMessages()[ 0 ].getSummary();
    }
    
    System.debug( 'END: LPDCR_DealerVIPPointsTonsExportCntrlr.constructor()' );
  }
} // /END Class