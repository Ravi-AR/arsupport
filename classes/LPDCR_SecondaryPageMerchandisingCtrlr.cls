/******************************************************************************
 * Controller for the LPDCR_SecondaryPageMerchandisingBody component
 * 
 * @Author: Magnet 360
 * @Date: Mar 30, 2017 
 * @Jira: LPDCR-2230
 */

public with sharing class 
LPDCR_SecondaryPageMerchandisingCtrlr
    extends LPDCR_ComponentBaseController 
{

    public List<String> species_filter { get; set; }
    public String search_term { get; set; }
    public String sort_filter { get
        {
            if(sort_filter == null || sort_filter ==''){
                    sort_filter = 'Date DESC';
            }
            
            return sort_filter;
        } 
        set;}
    public Boolean showMerchandiseList{ get; set; }
    public Boolean showDocumentList { get; set; }
    public List<String> files_filter { get; set; }
    public String document_type { get; set; }
    public Boolean internal_only{get;set;}
    public String document_list_where_clause { get; set; }
    public String document_list_cache_key { get; set; }
    //public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> documentList {get;set;}
     public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> documentList
    {
        get
        {
            return showDocument();
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
    LPDCR_SecondaryPageMerchandisingCtrlr()
    {
        System.debug( 'START: LPDCR_SecondaryPageMerchandisingCtrlr.constructor()' );
         
         showMerchandiseList= true;
         showDocumentList = false;
        
        System.debug( 'END: LPDCR_SecondaryPageMerchandisingCtrlr.constructor()' );
    }
    /******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void showDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryPageMerchandisingCtrlr.showDocumentList()' );
        System.debug( 'Param: document_type = ' + document_type );

        showMerchandiseList = false;
        showDocumentList = true;

        System.debug( 'END: LPDCR_SecondaryPageMerchandisingCtrlr.showDocumentList()' );
    }
    /******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public  List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> showDocument()
    {
        System.debug( 'START: LPDCR_SecondaryPageMerchandisingCtrlr.showDocument()' );
        System.debug( 'Param: document_type = ' + document_type );

        
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> l_documents
            = new List<LPDCR_BLDocuments.PurinaBusinessLink_Documents>();
            
        if( document_type == Label.LPDCR_Signs_Component_Name)
        {
            document_list_where_clause = Label.LPDCR_Signs_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Signs_Service_Cache_Key;
          
        }
        else if( document_type == Label.LPDCR_Display_Library_Component_Name )
        {         
            document_list_where_clause = Label.LPDCR_Display_Library_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Display_Library_Service_Cache_Key;
        }
        else if( document_type == Label.LPDCR_Planograms_Component_Name)
        {
            document_list_where_clause = Label.LPDCR_Planograms_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Planograms_Service_Cache_Key;
        }
        else if( document_type == Label.LPDCR_POS_Sign_Templates_Component_Name)
        {           
            document_list_where_clause = Label.LPDCR_POS_Sign_Templates_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_POS_Sign_Templates_Service_Cache_Key;
        }
        else if( document_type == Label.LPDCR_Print_eStore_Component_Name)
        {           
            document_list_where_clause = Label.LPDCR_Print_eStore_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Print_eStore_Service_Cache_Key;
        }
        else if( document_type == Label.LPDCR_Promotions_eStore_Component_Name)
        {           
            document_list_where_clause = Label.LPDCR_Promotions_eStore_Service_Where_Clause;
            document_list_cache_key = Label.LPDCR_Promotions_eStore_Service_Cache_Key;
        }
        //documentList = content_service.getDocuments(document_list_where_clause,document_list_cache_key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList();
        
        if( document_list_cache_key == null && Test.isRunningTest() )
        {
            document_list_cache_key = 'TestCacheKey';
        }
        
        l_documents= LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(document_list_where_clause,document_list_cache_key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(),
                                                              species_filter,
                                                              files_filter,
                                                              internal_only,
                                                              sort_filter );
        if( l_documents != null && sort_filter != null )    
        {
                                                     // Sort the documents list
            System.debug( 'Sort Documents = ' + sort_filter );
            LPDCR_BLDocuments.sortBy = sort_filter;
            l_documents.sort();
            //System.debug('Sorted list--------'+l_documents);
        }
        System.debug( 'END: LPDCR_SecondaryPageMerchandisingCtrlr.showDocument()' );
        System.debug('data-----'+ l_documents);
        return l_documents;
    }
   
/******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void hideDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryPageMerchandisingCtrlr.hideDocumentList()' );
        System.debug( 'Param: document_type = ' + document_type );

        showMerchandiseList = true;
        showDocumentList = false;
        
        System.debug( 'END: LPDCR_SecondaryPageMerchandisingCtrlr.hideDocumentList()' );
    }
} // /END Class