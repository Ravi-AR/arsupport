/******************************************************************************
 * Controller for the LPDCR_SecondaryPlanningResources component
 * 
 * @Author: Heena Tanna
 * @Date: May 12, 2017 
 * @Jira: LPDCR-2795 
 */

public with sharing class LPDCR_SecondaryEventPlanningController extends LPDCR_ComponentBaseController {
    
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
    public Boolean showEventsList { get; set; }
    public Boolean showDocumentList { get; set; }
    
    public String document_type { get; set; }
    public String document_list_where_clause { get; set; }
    public String document_list_cache_key { get; set; }
    
    
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> documentList
    {
        get
        {
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
    LPDCR_SecondaryEventPlanningController()
    {
        System.debug( 'START: LPDCR_SecondaryEventPlanningController.constructor()' );
        
                                                 // Hide the document list by default
        showEventsList = true;
        showDocumentList = false;
                                                 
        System.debug( 'LPDCR_SecondaryEventPlanningController.search_term = ' + search_term );
        
        System.debug( 'END: LPDCR_SecondaryEventPlanningController.constructor()' );
    }

/******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void showDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryEventPlanningController.showDocumentList()' );
        System.debug( 'Param: document_type = ' + document_type );

        showEventsList = false;
        showDocumentList = true;

        System.debug( 'END: LPDCR_SecondaryEventPlanningController.showDocumentList()' );
    }

/******************************************************************************
 * Method to retreive the documents from the web service and sort them
 */    
    public
    List<LPDCR_BLDocuments.PurinaBusinessLink_Documents>
    retrieveDocuments()
    {
        System.debug( 'START: LPDCR_SecondaryEventPlanningController.retrieveDocuments()' );
        System.debug( 'Param: document_type = ' + document_type );
        System.debug( 'Param: internal User= '+internal_only);
        
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> l_documents
            = new List<LPDCR_BLDocuments.PurinaBusinessLink_Documents>();
        
        if( document_type == Label.LPDCR_Local_Event_Planner )
        {
            document_list_where_clause = Label.LPDCR_Local_Event_Planner_Where_Clause;
            document_list_cache_key = Label.LPDCR_Local_Event_Planner_Cache_Key;
          
        }
        else if( document_type == Label.LPDCR_Local_Event_Checklists )
        {         
            document_list_where_clause = Label.LPDCR_Local_Event_Checklists_Where_Clause;
            document_list_cache_key = Label.LPDCR_Local_Event_Checklists_Cache_Key;
        }
        else if( document_type == Label.LPDCR_Event_Resources) {   // LPDCR-3064; Shruti
            document_list_where_clause = Label.LPDCR_Event_Resources_Where_Clause;
            document_list_cache_key = Label.LPDCR_Event_Resources_Cache_Key;
        }
        else if( document_type == Label.LPDCR_Local_Event_Idea_Library)
        {
            document_list_where_clause = Label.LPDCR_Local_Event_Idea_Library_Where_Clause;
            document_list_cache_key = Label.LPDCR_Local_Event_Idea_Library_Cache_Key;
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
        
        System.debug( 'END: LPDCR_SecondaryEventPlanningController.retrieveDocuments()' );
        
        return l_documents;
    }
   
/******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void hideDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryEventPlanningController.hideDocumentList()' );
        System.debug( 'Param: document_type = ' + document_type );

        showEventsList = true;
        showDocumentList = false;

        System.debug( 'END: LPDCR_SecondaryEventPlanningController.hideDocumentList()' );
    }
    
    
    
}