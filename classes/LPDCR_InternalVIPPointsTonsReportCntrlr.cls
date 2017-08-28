/******************************************************************************
 * Controller for the LPDCR_InternalVIPPointsTonsReportDetail page 
 * 
 * @Author: Magnet 360
 * @Date: Jun 29, 2017 
 * @Jira: LPDCR-2029
 */

public with sharing class 
LPDCR_InternalVIPPointsTonsReportCntrlr 
{
    public LPDCR_VIPTonsReport territoryReport { get; set; }
    public LPDCR_VIPTonsReport accountReport { get; set; }
    public LPDCR_VIPTonsReport level3Report { get; set; }
    public LPDCR_VIPTonsReport productReport { get; set; }
    
    //public LPDCR_VIPTonsReport.Row l_summary_row { get; set; }
    
    private LPDCR_ContentServiceUtil l_content_util;
    public String level3_id{get;set;}
    public String customer_number{get;set;}
    public String territory_id{get;set;}
    
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
    LPDCR_InternalVIPPointsTonsReportCntrlr()
    {
        System.debug( 'START: LPDCR_InternalVIPPointsTonsReportCntrlr.constructor()' );
        getInternalTerritoryList();
        
        
        System.debug( 'END: LPDCR_InternalVIPPointsTonsReportCntrlr.constructor()' );
    }
    
    
    
    public void getInternalTerritoryList(){
       
       User l_user;
           
       if( UserInfo.getUserType() == 'STANDARD' )
        { 
            l_user =[Select Id,FederationIdentifier, Employee_Number__c from User where Id = :UserInfo.getUserId() Limit 1];
            territoryReport = content_service.getInternalAccountTerritoryReport( String.valueOf( l_user.Employee_Number__c ) );
            accountReport = null;
            level3Report = null;
            productReport = null;
            System.debug('territoryReport............'+ territoryReport );
            if( territoryReport.success == true && territoryReport.row == null && territoryReport.row.size() > 0 )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.Invalid_AccountNo_For_VIP );
                ApexPages.addMessage( l_msg );
            }
            else if( territoryReport.success == false )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.LPDCR_Invalid_Emploee_Number_For_VIP );
                ApexPages.addMessage( l_msg );
            }
        }
    
    }
    
    public void getInternalAccountList(){
       
       User l_user;
        
       if( UserInfo.getUserType() == 'STANDARD' )
        { 
            l_user =[Select Id,FederationIdentifier, Employee_Number__c from User where Id = :UserInfo.getUserId() Limit 1];
            System.debug('l_user.Employee_Number__c---'+ l_user.Employee_Number__c);  
            System.debug('territory_id---'+ territory_id);  
            accountReport = content_service.getInternalAccountDetailReport( String.valueOf( l_user.Employee_Number__c ),territory_id);
            level3Report = null;
            productReport = null;
            System.debug('accountReport--'+ accountReport);
            if( accountReport.success == true && accountReport.row == null && accountReport.row.size() > 0 )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.Invalid_AccountNo_For_VIP );
                ApexPages.addMessage( l_msg );
            }
            else if( accountReport.success == false )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.LPDCR_Invalid_Emploee_Number_For_VIP );
                ApexPages.addMessage( l_msg );
            }
        }
    
    }
    public void getInternalLevel3List(){
        
         User l_user;
         
           
       if( UserInfo.getUserType() == 'STANDARD' )
        { 
            l_user =[Select Id,FederationIdentifier, Employee_Number__c from User where Id = :UserInfo.getUserId() Limit 1];
            
            level3Report = content_service.getInternalAccountLevel3DetailReport( String.valueOf( l_user.Employee_Number__c ),customer_number );  
            productReport = null;
            
            if( level3Report.success == true && level3Report.row == null && level3Report.row.size() > 0 )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.Invalid_AccountNo_For_VIP );
                ApexPages.addMessage( l_msg );
            }
            else if( level3Report.success == false )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.LPDCR_Report_Error_Message ); //Label.LPDCR_Invalid_Emploee_Number_For_VIP
                ApexPages.addMessage( l_msg );
            }
        }
        
    }
    public void getInternalProductList(){
        
          User l_user;
         
          
       if( UserInfo.getUserType() == 'STANDARD' )
        { 
            l_user =[Select Id,FederationIdentifier, Employee_Number__c from User where Id = :UserInfo.getUserId() Limit 1];
            productReport = content_service.getInternalAccountProductDetailReport( String.valueOf( l_user.Employee_Number__c ),customer_number,level3_id );  

            if( productReport.success == true && productReport.row == null && productReport.row.size() > 0 )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.Invalid_AccountNo_For_VIP );
                ApexPages.addMessage( l_msg );
            }
            else if( productReport.success == false )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO,  Label.LPDCR_Report_Error_Message);//Label.LPDCR_Invalid_Emploee_Number_For_VIP
                ApexPages.addMessage( l_msg );
            }
        }
    
    }
    
    public static void getInternalFullReport(){
        
          
          User l_user;
             
         
       if( UserInfo.getUserType() == 'STANDARD' )
        { 
            l_user =[Select Id,FirstName, LastName, FederationIdentifier, Employee_Number__c,Email from User where Id = :UserInfo.getUserId() Limit 1];
            System.debug('l_user.Email---'+ l_user.Email);
            System.debug('l_user.Employee_Number__c---'+ l_user.Employee_Number__c);
            LPDCR_ContentServiceUtil.requestInternalVIPTonsReport( String.valueOf( l_user.Employee_Number__c ),
                                                                   l_user.Email,
                                                                   l_user.FirstName + '_' + l_user.LastName );  
            
        }
    
    }
    
} // /END Class