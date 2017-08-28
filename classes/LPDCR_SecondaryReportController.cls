/******************************************************************************
 * Controller for the LPDCR_SecondaryReport component
 * 
 * @Author: Magnet 360
 * @Date: May 9, 2017 
 * @Jira: LPDCR-2029
 */

public without sharing class 
LPDCR_SecondaryReportController extends LPDCR_ComponentBaseController
{

    public LPDCR_VIPTonsReport summary_report { get; set; }
    
    private LPDCR_ContentServiceUtil l_content_util;
    
    private String account_id;
    public List<LOLMyLinksCallouts.MyLinkData> resources { get; set; }
    public LOLMyLinksCallouts my_links_callout { get; set; }
    public String reportURL { get; set; }
    public String priceListURL { get; set; }
    public String chcInternalUserURL { get; set; }
    public List<CHC_Summary__c> chcLst{get;set;}
    public String document_type { get; set; }
    public String document_list_where_clause { get; set; }
    public String document_list_cache_key { get; set; }
    public Boolean showReportList { get; set; }
    public Boolean showDocumentList { get; set; }
    public Boolean showMSRPDocumentList { get; set; }
    public Boolean showPointsDetail { get; set; }
    public DateTime chcLastModified {get;set;}
    public DateTime chcSummaryDate {get;set;}
    
    //public List<CHC_Summary__c> chcDetails {get;set;}
       
                                                 // Variables to hold the percentages
                                                 // used to show the size of the
                                                 // VIP Points and Tons bar graphs
    public Decimal pointsPYPercent { get; set; }
    public Decimal pointsCYTDPercent { get; set; }
    public Decimal pointsPYTDPercent { get; set; }
    public Decimal tonsPYPercent { get; set; }
    public Decimal tonsCYTDPercent { get; set; }
    public Decimal tonsPYTDPercent { get; set; }
    
    public Decimal chcBase{get;set;}
    public Decimal chcActivity{get;set;}
    public Decimal chcSpeed{get;set;}
    public String chcLevel{get;set;}
    public Decimal chcBasePercent{get;set;}
    public Decimal chcActivityPercent{get;set;}
    public Decimal chcSpeedPercent{get;set;}
    
    //public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> docLst { get; set; }
    //public Set<LPDCR_BLDocuments.PurinaBusinessLink_Documents> finalDocs { get; set; }
    public Account accountObj { get; set; }
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> documentList
    {
        get
        {
            return retrieveDocuments();
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
     public List<String> species_filter { get; set; }
    public List<String> files_filter { get; set; }
    public String search_term { get; set; }
    public String sort_filter { get
        {
            if(sort_filter == null || sort_filter ==''){
                    sort_filter = 'Date DESC';
            }
            
            return sort_filter;
        } 
        set;}
    
    public Boolean internal_only { get; set; }
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> chcDocument { 
        get{
            if(chcDocument == null){
                chcDocument = content_service.getDocuments( System.label.LPDCR_CHC_Document_Where_Clause,
                                                            System.label.LPDCR_CHC_Service_Cache_Key,
                                                            System.Label.LPDCR_Document_Order_By_Clause ).getDocumentsList();
            }
            System.debug('chcDocument ----'+chcDocument );
            if(chcDocument.size()<=0){
                chcDocument = null;
            }
            return chcDocument;
        }
        set; }
     public Boolean init{
        get{
            getWaffleResourceList();
            /*if(UserInfo.getUserType() != 'Standard'){
                getDocumentList();
            }*/
            getCHCDetails();
            //getCHCDocument();
            return false;
        }
    }
    public LPDCR_VIPTonsReport.Row l_summary_row { get; set; }
/******************************************************************************
 * Constructor
 */
    public
    LPDCR_SecondaryReportController()
    {
        System.debug( 'START: LPDCR_SecondaryReportController.constructor()' );
        
        l_content_util = new LPDCR_ContentServiceUtil();
        //l_summary_row = new LPDCR_AccountPointsSummary.Row();
        my_links_callout = new LOLMyLinksCallouts();
        //getCHCDetails();
        getCHCDocument();
        /*if(UserInfo.getUserType() != 'Standard'){
                retrieveDocuments();
        }*/
        showReportList = true;
        showDocumentList = false;
        showPointsDetail = false;
        //showMSRPDocumentList = false;
        System.debug( 'END: LPDCR_SecondaryReportController.constructor()' );
    }
 /******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void showDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryReportController.showDocumentList()' );
        
        showReportList = false;
        showDocumentList = true;
        showPointsDetail = false;
        //showMSRPDocumentList = false;
        
        System.debug( 'END: LPDCR_SecondaryReportController.showDocumentList()' );
    }
    /******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void hideDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryReportController.hideDocumentList()' );
        
        //showMSRPDocumentList = false;
        showReportList = true;
        showDocumentList = false;
        showPointsDetail = false;
        System.debug( 'END: LPDCR_SecondaryReportController.hideDocumentList()' );
    }

/******************************************************************************
 * Method called from the VF action function to render the VIP Points & Tons Details
 */
    public void showPointsDetailReport()
    {
        System.debug( 'START: LPDCR_SecondaryReportController.showPointsDetailReport()' );
        
        showDocumentList = false;
        showReportList = false;
        showPointsDetail = true;
        
        System.debug( 'END: LPDCR_SecondaryReportController.showPointsDetailReport()' );
    }
    
    
/******************************************************************************
 * Method called from an action function to make the callout to retrieve the
 * the Account Summary Report
 */
    public
    void
    getAccountPointsSummary()
    {
        System.debug( 'START: LPDCR_SecondaryReportController.getAccountPointsSummary()' );
        
        summary_report = callVIPPointsService();
        System.debug('summary_report---'+ summary_report);
        if( summary_report != null 
            && summary_report.success == true 
            && summary_report.row != null 
            && summary_report.row.size() > 0 )
        {
            //LPDCR_AccountPointsSummary.Row l_summary_row = l_summary_report.report_rows[ 0 ];
            l_summary_row =summary_report.row[0];
                                                 // Calculate the graph bar sizes
            if( l_summary_row.shipped_tons_py >= l_summary_row.shipped_tons_ytd && l_summary_row.shipped_tons_py >= l_summary_row.shipped_tons_pytd )
            {
                                                 // shipped_tons_py is the largest value
                tonsPYPercent = 100;
                if( l_summary_row.shipped_tons_py == 0 )
                {
                    tonsCYTDPercent = 0;
                    tonsPYTDPercent = 0;
                }
                else
                {
                    tonsCYTDPercent = ((l_summary_row.shipped_tons_ytd / l_summary_row.shipped_tons_py ) * 100).setScale( 2 );
                    tonsPYTDPercent = ((l_summary_row.shipped_tons_pytd / l_summary_row.shipped_tons_py ) * 100).setScale( 2 );
                }
            }
            else if( l_summary_row.shipped_tons_ytd >= l_summary_row.shipped_tons_py && l_summary_row.shipped_tons_ytd >= l_summary_row.shipped_tons_pytd )
            {
                                                 // shipped_tons_ytd is the largest value
                tonsCYTDPercent = 100;
                if( l_summary_row.shipped_tons_ytd == 0 )
                {
                    tonsPYPercent = 0;
                    tonsPYTDPercent = 0;
                }
                else
                {
                    tonsPYPercent = (( l_summary_row.shipped_tons_py / l_summary_row.shipped_tons_ytd ) * 100 ).setScale( 2 );
                    tonsPYTDPercent = (( l_summary_row.shipped_tons_pytd / l_summary_row.shipped_tons_ytd ) * 100 ).setScale( 2 ); 
                }
            }
            else
            {
                                                 // shipped_tons_pytd is the largest value   
                tonsPYTDPercent = 100;
                if( l_summary_row.shipped_tons_pytd == 0 )
                {
                    tonsPYPercent = 0;
                    tonsCYTDPercent = 0;
                }
                else
                {
                    tonsPYPercent = (( l_summary_row.shipped_tons_py / l_summary_row.shipped_tons_pytd ) * 100 ).setScale( 2 );
                    tonsCYTDPercent = (( l_summary_row.shipped_tons_ytd / l_summary_row.shipped_tons_pytd ) * 100 ).setScale( 2 );
                }
            }
            
            if( l_summary_row.vip_points_py >= l_summary_row.vip_points_ytd && l_summary_row.vip_points_py >= l_summary_row.vip_points_pytd )
            {
                                                 // vip_points_py is the largest value
                pointsPYPercent = 100;
                if( l_summary_row.vip_points_py == 0 )
                {
                    pointsCYTDPercent = 0;
                    pointsPYTDPercent = 0;
                }
                else
                {
                    pointsCYTDPercent = ((l_summary_row.vip_points_ytd / l_summary_row.vip_points_py ) * 100).setScale( 2 );
                    pointsPYTDPercent = ((l_summary_row.vip_points_pytd / l_summary_row.vip_points_py ) * 100).setScale( 2 );
                }
            }
            else if( l_summary_row.vip_points_ytd >= l_summary_row.vip_points_py && l_summary_row.vip_points_ytd >= l_summary_row.vip_points_pytd )
            {
                                                 // vip_points_ytd is the largest value
                pointsCYTDPercent = 100;
                if( l_summary_row.vip_points_ytd == 0 )
                {
                    pointsPYPercent = 0;
                    pointsPYTDPercent = 0;
                }
                else
                {
                    pointsPYPercent = (( l_summary_row.vip_points_py / l_summary_row.vip_points_ytd ) * 100 ).setScale( 2 );
                    pointsPYTDPercent = (( l_summary_row.vip_points_pytd / l_summary_row.vip_points_ytd ) * 100 ).setScale( 2 ); 
                }
            }
            else
            {
                                                 // vip_points_pytd is the largest value   
                pointsPYTDPercent = 100;
                if( l_summary_row.vip_points_pytd == 0 )
                {
                    pointsPYPercent = 0;
                    pointsCYTDPercent = 0;
                }
                else
                {
                    pointsPYPercent = (( l_summary_row.vip_points_py / l_summary_row.vip_points_pytd ) * 100 ).setScale( 2 );
                    pointsCYTDPercent = (( l_summary_row.vip_points_ytd / l_summary_row.vip_points_pytd ) * 100 ).setScale( 2 );
                }
            }
        }// /END if( summary_report.success )

        System.debug( 'END: LPDCR_SecondaryReportController.getAccountPointsSummary()' );
    }

/******************************************************************************
 * Private helper method to call the VIP Points and Tons report service
 */
    private 
    LPDCR_VIPTonsReport
    callVIPPointsService()
    {
        System.debug( 'START: LPDCR_SecondaryReportController.callVIPPointsService()' );
        
        Account l_account;
        User l_user;  
        
                                               // If the user is a standard user
        if( UserInfo.getUserType() == 'STANDARD' )
        { 
            l_user =[Select Id,FederationIdentifier, Employee_Number__c from User where Id = :UserInfo.getUserId() Limit 1];
            summary_report = content_service.getInternalSummaryReport( String.valueOf( l_user.Employee_Number__c ) );  
            System.debug('............'+summary_report );
            if( summary_report.success == true && summary_report.row == null && summary_report.row.size() > 0 )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.Invalid_AccountNo_For_VIP );
                ApexPages.addMessage( l_msg );
            }
            else if( summary_report.success == false )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.INFO, Label.LPDCR_Invalid_Emploee_Number_For_VIP );
                ApexPages.addMessage( l_msg );
            }
        }
        else
        {
                                                 // Find the account number for the
                                                 // the current users selected account
            //account_id = LPDCR_ChangeAccountController.getSelectedAccId();
            account_id = selectedAccountId;
            System.debug('account_id1---'+ account_id);
            if( account_id != null && account_id != '' )
            {
                try
                {
                    l_account = [ SELECT Id,
                                         AccountNumber
                                  FROM Account
                                  WHERE Id = :account_id
                                  LIMIT 1 ];
                    System.debug('l_account.AccountNumber ---'+ l_account.AccountNumber );    
                    summary_report = content_service.getDealerAccountSummaryReport( l_account.AccountNumber );
                    if( summary_report.success == false || (summary_report.success && summary_report.row == null && summary_report.row.size() > 0 ) )
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
            }
            
        }// /END if( USERTYPE == Standard )
        System.debug('summary_report--'+summary_report);
        System.debug( 'END: LPDCR_SecondaryReportController.callVIPPointsService()' );
        return summary_report;
    }

/******************************************************************************
 * 
 */    
    public List<LOLMyLinksCallouts.MyLinkData> getWaffleResourceList()
    {
        LOLMyLinksCallouts.MyLinkData l_report_my_link = my_links_callout.GetSpecificMyLink(Label.LPDCR_Report_AppCode);
        LOLMyLinksCallouts.MyLinkData l_price_list_my_link = my_links_callout.GetSpecificMyLink(Label.LPDCR_PriceList_AppCode); 
        LOLMyLinksCallouts.MyLinkData l_sf_my_link;
        
        if( UserInfo.getUserType() == 'STANDARD' )
        {
            l_sf_my_link = my_links_callout.GetSpecificMyLink(Label.LPDCR_Purina_AppCode);
        }
        
        if( l_report_my_link != null){
            reportURL = l_report_my_link.myAppUrl;
        }
        if( l_price_list_my_link != null ){
            priceListURL = l_price_list_my_link.myAppUrl;
        }
        if( l_sf_my_link != null ){
            chcInternalUserURL = l_sf_my_link.myAppUrl;
        }
        
        System.debug('reportURL ----'+reportURL + 'priceListURL ----' +priceListURL );
        return null;
    } 
    
/******************************************************************************
 * 
 */    
    public void getCHCDetails(){
        
        chcLst = [ Select Average_Per_Month__c, Summary_Date__c, Current_Growth__c, LastModifiedDate, Points_for_Bronze__c, Points_for_Gold__c, Points_for_Silver__c, Total_Base_Points__c, 
                          Total_Performance_Points__c, Trip_Win_Level__c,Parent_FD_1_Account__c, Double_or_95_000_Pts_Gold__c,
                          X47_500_Pts_with_Growth_Gold__c,Ultimate_FD_1_Parent_Account__c,CHC_Level__c
                    FROM CHC_Summary__c 
                    WHERE Parent_FD_1_Account__c =:selectedAccountId
                    ORDER BY LastModifiedDate DESC
                    LIMIT 1];
         
         
         System.debug('chcLst----'+ chcLst);
         
         if(chcLst.size()>0){
             
             chcLastModified = chcLst[ 0 ].LastModifiedDate;
             chcSummaryDate = chcLst[ 0 ].Summary_Date__c;
             chcBase =chcLst[ 0 ].Total_Base_Points__c;
             chcActivity =chcLst[ 0 ].Total_Performance_Points__c;
             chcSpeed =chcLst[0].Average_Per_Month__c;
             chcLevel =chcLst[0].CHC_Level__c;
             
             //Percentage Calculation part
             if( chcLst[ 0 ].Total_Base_Points__c >= chcLst[ 0 ].Total_Performance_Points__c && chcLst[ 0 ].Total_Base_Points__c >= chcLst[0].Average_Per_Month__c )
            {
                                                 
                                                 //chcLst[ 0 ].Total_Base_Points__c is the largest value
                chcBasePercent = 100;
                if( chcLst[ 0 ].Total_Base_Points__c == 0 )
                {
                    chcActivityPercent = 0;
                    chcSpeedPercent = 0;
                }
                else
                {
                    chcActivityPercent = ((chcLst[ 0 ].Total_Performance_Points__c / chcLst[ 0 ].Total_Base_Points__c) * 100).setScale(2);
                    chcSpeedPercent= ((chcLst[0].Average_Per_Month__c/ chcLst[ 0 ].Total_Base_Points__c) * 100).setScale( 2 );
                }
            }
            else if( chcLst[ 0 ].Total_Performance_Points__c >= chcLst[ 0 ].Total_Base_Points__c && chcLst[ 0 ].Total_Performance_Points__c >= chcLst[0].Average_Per_Month__c )
            {
                                                 
                                                 //chcLst[ 0 ].Total_Performance_Points__c is the largest value
                chcActivityPercent = 100;
                if( chcLst[ 0 ].Total_Performance_Points__c == 0 )
                {
                    chcBasePercent = 0;
                    chcSpeedPercent = 0;
                }
                else
                {
                    chcBasePercent = (( chcLst[ 0 ].Total_Base_Points__c / chcLst[ 0 ].Total_Performance_Points__c) * 100 ).setScale(2);
                    chcSpeedPercent = (( chcLst[0].Average_Per_Month__c / chcLst[ 0 ].Total_Performance_Points__c ) * 100 ).setScale( 2 ); 
                }
            }
            else
            {
                                               
                                                 // chcLst[0].Average_Per_Month__c is the largest value
                chcSpeedPercent = 100;
                if( chcLst[0].Average_Per_Month__c == 0 )
                {
                    chcBasePercent= 0;
                    chcActivityPercent = 0;
                }
                else
                {
                    chcBasePercent = (( chcLst[ 0 ].Total_Base_Points__c / chcLst[0].Average_Per_Month__c) * 100 ).setScale(2);
                    chcActivityPercent = (( chcLst[ 0 ].Total_Performance_Points__c / chcLst[0].Average_Per_Month__c ) * 100 ).setScale(2);
                }
            }
             
         } // chcLst.size() condition ends
        
    }
    
 /**********************************************************************************************************************
 * Method to get CHC Document
 */    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getCHCDocument(){
        System.debug('Entered CHC');
        if( chcDocument == null )
        {
            chcDocument = content_service.getDocuments( System.label.LPDCR_CHC_Document_Where_Clause,
                                                        System.label.LPDCR_CHC_Service_Cache_Key,
                                                        System.Label.LPDCR_Document_Order_By_Clause ).getDocumentsList();
        }
        System.debug('chcDocument ----'+chcDocument);
        return null;
    }
    
/**********************************************************************************************************************
 * Method to get MSRP/MAP Document List
 */    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> retrieveDocuments()
    {
        String plantNames;
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> docLst;
        
        System.debug('selectedAccountId ---'+selectedAccountId );
        if( selectedAccountId != null && selectedAccountId != '' ){
            accountObj = [SELECT Id, AccountNumber, ShippingState FROM Account WHERE Id=: selectedAccountId ];
        }
        System.debug('accountObj ---'+accountObj );
        if( document_type == Label.LPDCR_MSRP_Component_Name )
        {
            System.debug('document type--- MSRP/MAP');
            if(accountObj != null && accountObj.ShippingState != 'Arizona' && accountObj.ShippingState != 'New Mexico' && accountObj.AccountNumber!= null){
                List<CC_OO_Customer_Freight__c> customerFreightList = [SELECT Id, Name, Plant_Name__r.Name, Plant_Name__r.ccrz__SellerId__c, ShipTo_Account_Number__c FROM CC_OO_Customer_Freight__c WHERE ShipTo_Account_Number__c =: Decimal.ValueOf(accountObj.AccountNumber)];
                
                System.debug('customerFreightList ----'+customerFreightList );            
                
                for( CC_OO_Customer_Freight__c c: customerFreightList ){
                    
                    if(c != null && c.Plant_Name__r!=null && c.Plant_Name__r.ccrz__SellerId__c!=null){
                        plantNames += ' OR Plants LIKE \'%' + c.Plant_Name__r.ccrz__SellerId__c +'%\'';
                    }
                }
            }
            else{
                plantNames = Label.LPDCR_SouthWest_Plants;
            }
            
            if(plantNames != null){
                plantNames = plantNames.replaceAll('null OR ','');
            }
            
            System.debug('plantNames---'+ plantNames);
            
            //System.debug('plantList----'+plantList);
            if(UserInfo.getUserType() != 'STANDARD' && plantNames != null){
                docLst = LPDCR_BLDocuments.filterDocuments( content_service.getMSRPDocuments( System.Label.LPDCR_Kentico_Documents_Table, null, System.label.LPDCR_MSRP_Service_Where_Clause, plantNames ).getDocumentsList(), 
                                                              species_filter,
                                                              null,
                                                              internal_only,
                                                              sort_filter);
                                                              
            }
            else if(UserInfo.getUserType() == 'STANDARD'){
                docLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_MSRP_Service_Where_Clause).getDocumentsList(), 
                                                              species_filter,
                                                              null,
                                                              internal_only,
                                                              sort_filter);
            }
            else{
                System.debug('Plants null');
            }
        } // END MSRP Document type 
        else{
            if( document_type == Label.LPDCR_Tons_and_VIP_Points_Component_Name){
            document_list_where_clause = Label.LPDCR_Tons_and_VIP_Points_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Tons_and_VIP_Points_Service_Cache_Key;
            
            }
            else if( document_type == Label.LPDCR_Price_Lists_Component_Name){
                document_list_where_clause = Label.LPDCR_Price_Lists_Service_Where_Clause;
                document_list_cache_key = Label.LPDCR_Price_Lists_Service_Cache_Key;
                
            }
            else if( document_type == Label.LPDCR_Performance_Profile_Component_Name){
                document_list_where_clause = Label.LPDCR_Performance_Profile_Service_Where_Clause;
                document_list_cache_key = Label.LPDCR_Performance_Profile_Service_Cache_Key;
                
            }
            
            if( document_list_cache_key == null && Test.isRunningTest() )
            {
                document_list_cache_key = 'TestCachKey';
            }
            
            docLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(document_list_where_clause,document_list_cache_key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(),
                                                              species_filter,
                                                              files_filter,
                                                              null,
                                                         sort_filter);
        }
        
         if( docLst!= null && sort_filter != null )    
        {
            // Sort the MSRP list
            System.debug( 'Sort Documents = ' + sort_filter );
            LPDCR_BLDocuments.sortBy = sort_filter;
            docLst.sort();
            System.debug('Sorted list--------'+docLst);
        }
        
        //System.debug('msrpDocLst ----'+msrpDocLst );
        return docLst;
    }
    
} // /END Class