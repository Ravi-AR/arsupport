/**
*   @Author:    Heena Tanna
*   @Date:      
*   @Jira:      
*   @Purpose:   Controller for LPDCR_SecondaryBusinessManagement Component
*/

public with sharing class LPDCR_SecondaryBusinessManagementCntlr extends LPDCR_ComponentBaseController {

    
    
    public LPDCR_ContentServiceUtil content_service {
        get {
            if( content_service == null ){
                content_service = new LPDCR_ContentServiceUtil();
            }
            return content_service;
        }
        set;
    }
    public String search_term { get; set; }
    public List<LOLMyLinksCallouts.MyLinkData> resources { get; set; }
    public LOLMyLinksCallouts my_links_callout { get; set; }
    public String voiceMgtLinkURL { get; set; }
    public List<String> species_filter { get; set; }
    public String sort_filter { get
        {
            if(sort_filter == null || sort_filter ==''){
                    sort_filter = 'Date DESC';
            }
            
            return sort_filter;
        } 
        set;}
    public Boolean showBusinessList{ get; set; }
    public Boolean showDocumentList { get; set; }
    public List<String> files_filter { get; set; }
    public String document_type { get; set; }
    public Boolean internal_only{get;set;}
    public String document_list_where_clause { get; set; }
    public String document_list_cache_key { get; set; }
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> documentList
    {
        get
        {
            return showBusinessDocumentList();
        }
        set;
        
    }
  
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> couponResourceLst { get; set; }
    public LPDCR_BLDocuments.PurinaBusinessLink_Documents annualPlanningDoc { get; set; }

    // Constructor
    public LPDCR_SecondaryBusinessManagementCntlr() { 
         my_links_callout = new LOLMyLinksCallouts();
         showbusinessList = true;
         showDocumentList = false;
    }
 
    public Boolean init{
        get{
            getWaffleResourceList();
            //showBusinessDocumentList();
            return false;
        }
    }
  
    public List<LOLMyLinksCallouts.MyLinkData> getWaffleResourceList(){
        if(my_links_callout.GetSpecificMyLink(Label.LPDCR_Invoice_AppCode) != null){
            voiceMgtLinkURL = my_links_callout.GetSpecificMyLink(Label.LPDCR_Invoice_AppCode).myAppUrl;
        }
        
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> annualPlanningDocLst = (LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(Label.LPDCR_Annual_Planning_Where_Clause).getDocumentsList(), 
                                                          null,
                                                          null,
                                                          null,
                                                          null));  
        if(annualPlanningDocLst != null && annualPlanningDocLst.size()>0){
            annualPlanningDoc = annualPlanningDocLst[0];
        }
        
        System.debug('annualPlanningDoc--- '+annualPlanningDoc);
        System.debug('app_code----'+my_links_callout.GetSpecificMyLink(Label.LPDCR_Invoice_AppCode));
        
        return null;
    }
    
     public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> showBusinessDocumentList(){
         showBusinessList = false;
         showDocumentList = true;
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> docLst;
        if( document_type == Label.LPDCR_Invoice_Component_Name)
        {
            document_list_where_clause = Label.LPDCR_Invoice_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Invoice_Service_Cache_Key;
          
        }
        if( document_list_where_clause != null ){
         docLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(document_list_where_clause,document_list_cache_key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(),
                                                              species_filter,
                                                              files_filter,
                                                              null,
                                                              sort_filter );
        }                                                     
        if( docLst != null && sort_filter != null )    
        {
                                                     // Sort the documents list
            System.debug( 'Sort Documents = ' + sort_filter );
            LPDCR_BLDocuments.sortBy = sort_filter;
            docLst.sort();
            
        }
        return docLst;
     
     } 
     /******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void showDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryPageMerchandisingCtrlr.hideDocumentList()' );
        System.debug( 'Param: document_type = ' + document_type );

        showBusinessList = false;
        showDocumentList = true;
        
        System.debug( 'END: LPDCR_SecondaryPageMerchandisingCtrlr.hideDocumentList()' );
    }
     
 /******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void hideDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryPageMerchandisingCtrlr.hideDocumentList()' );
        System.debug( 'Param: document_type = ' + document_type );

        showBusinessList = true;
        showDocumentList = false;
        
        System.debug( 'END: LPDCR_SecondaryPageMerchandisingCtrlr.hideDocumentList()' );
    }
}