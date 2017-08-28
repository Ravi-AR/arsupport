/******************************************************************************
 * Controller for the LPDCR_SecFeedLicenceManufacturer component
 * @Author: Shruti
 * @Date: May 23, 2017 
 * @Jira: 
 */

public with sharing class LPDCR_SecFLMContentController extends LPDCR_ComponentBaseController 
{

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
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> flmLst { get; set; }
    public Boolean init{
        get{
            getflmContentList();
            return false;
        }
        set;
    }

/******************************************************************************
 * Constructor
 */
    public LPDCR_SecFLMContentController()
    {
        System.debug( 'START: LPDCR_SecFLMContentController.constructor()' );
        getflmContentList();
        System.debug( 'END: LPDCR_SecFLMContentController.constructor()' );
    }
    
    
/**********************************************************************************************************************
 * Method to get FLM Content List
 */    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getflmContentList(){        
        
        flmLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_FLM_Service_Where_Clause,System.label.LPDCR_FLM_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          files_filter,
                                                          null,
                                                          sort_filter);        
        
        if( flmLst != null){
            // Sort the salesSheets list
            LPDCR_BLDocuments.sortBy = sort_filter;
            flmLst.sort();            
        }
        System.debug('flmLst----'+flmLst);
        return flmLst;
    }
    
    
} // /END Class