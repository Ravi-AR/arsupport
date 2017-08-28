/******************************************************************************
 * Controller for the LPDCR_SecondaryPageMedialToolsBody component
 * 
 * @Author: Magnet 360
 * @Date: Mar 30, 2017 
 * @Jira: LPDCR-2230
 */

public with sharing class 
LPDCR_SecondaryPageMediaToolsCtrlr 
    extends LPDCR_ComponentBaseController
{

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
    public Boolean showMediaToolsList { get; set; }
    public Boolean showDocumentList { get; set; }
    
    public String document_type { get; set; }
    public String document_list_where_clause { get; set; }
    public String document_list_cache_key { get; set; }
    
    public LOLMyLinksCallouts my_links_callout { get; set; }
    public String fadBuilderURL { get; set; }
    
    //public String tempTest { get { return 'Testing'; } set; }
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> documentList
    {
        get
        {
            //document_type = Label.LPDCR_Logo_Component_Name ;
            return retrieveDocuments();
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
    
/******************************************************************************
 * Constructor
 */
    public
    LPDCR_SecondaryPageMediaToolsCtrlr()
    {
        System.debug( 'START: LPDCR_SecondaryPageMediaToolsCtrlr.constructor()' );
        
                                                 // Hide the document list by default
        showMediaToolsList = true;
        showDocumentList = false;
        my_links_callout = new LOLMyLinksCallouts();
        if(my_links_callout.GetSpecificMyLink(Label.LPDCR_FadBuilder_AppCode) != null){
            fadBuilderURL = my_links_callout.GetSpecificMyLink(Label.LPDCR_FadBuilder_AppCode).myAppUrl;
        }
                                                 
        System.debug( 'LPDCR_SecondaryPageMediaToolsCtrlr.search_term = ' + search_term );
        
        System.debug( 'END: LPDCR_SecondaryPageMediaToolsCtrlr.constructor()' );
    }

/******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void showDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryPageMediaToolsCtrlr.showDocumentList()' );
        System.debug( 'Param: document_type = ' + document_type );

        showMediaToolsList = false;
        showDocumentList = true;

        System.debug( 'END: LPDCR_SecondaryPageMediaToolsCtrlr.showDocumentList()' );
    }

/******************************************************************************
 * Method to retreive the documents from the web service and sort them
 */    
    public
    List<LPDCR_BLDocuments.PurinaBusinessLink_Documents>
    retrieveDocuments()
    {
        System.debug( 'START: LPDCR_SecondaryPageMediaToolsCtrlr.retrieveDocuments()' );
        System.debug( 'Param: document_type = ' + document_type );
        System.debug( 'Param: internal User= '+internal_only);
        //document_type = Label.LPDCR_Logo_Component_Name ;
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> l_documents
            = new List<LPDCR_BLDocuments.PurinaBusinessLink_Documents>();
        
        if( document_type == Label.LPDCR_Logo_Component_Name )
        {
            document_list_where_clause = Label.LPDCR_Logos_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Logos_Service_Cache_Key;
          
        }
        else if( document_type == Label.LPDCR_Package_Component_Name )
        {         
            document_list_where_clause = Label.LPDCR_Package_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Package_Service_Cache_Key;
        }
        else if( document_type == Label.LPDCR_Social_Media_Component_Name)
        {
            document_list_where_clause = Label.LPDCR_Social_Media_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Social_Media_Service_Cache_Key;
        }
        else if( document_type == Label.LPDCR_Video_Component_Name)
        {           
            document_list_where_clause = Label.LPDCR_Video_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Video_Service_Cache_Key;
        }
        else if( document_type == Label.LPDCR_Ad_Slicks_Component_Name)
        {
            document_list_where_clause = Label.LPDCR_Ad_Slicks_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Ad_Slicks_Service_Cache_Key;
        }
        else if( document_type == Label.LPDCR_Radio_Scripts_Component_Name)
        {
            document_list_where_clause = Label.LPDCR_Radio_Scripts_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Radio_Scripts_Service_Cache_Key;
        }
        
        if( document_list_where_clause != null )
        {
        
            l_documents = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(document_list_where_clause,document_list_cache_key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(),
                                                              species_filter,
                                                              files_filter,
                                                              internal_only,
                                                              sort_filter );
        }
        
        if( l_documents != null && sort_filter != null )    
        {
                                                     // Sort the documents list
            System.debug( 'Sort Documents = ' + sort_filter );
            LPDCR_BLDocuments.sortBy = sort_filter;
            l_documents.sort();
            System.debug('Sorted list--------'+l_documents);
        }
        
        System.debug( 'END: LPDCR_SecondaryPageMediaToolsCtrlr.retrieveDocuments()' );
        
        return l_documents;
    }
   
/******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void hideDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryPageMediaToolsCtrlr.hideDocumentList()' );
        System.debug( 'Param: document_type = ' + document_type );

        showMediaToolsList = true;
        showDocumentList = false;

        System.debug( 'END: LPDCR_SecondaryPageMediaToolsCtrlr.hideDocumentList()' );
    }
    

} // /END Class