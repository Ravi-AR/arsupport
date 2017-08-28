/******************************************************************************
 * Controller for the LPDCR_SecondaryVFD component
 * @Author: Heena Tanna
 * @Date: May 23, 2017 
 * @Jira: LPDCR-2806
 */

public with sharing class LPDCR_SecondaryVFDController extends LPDCR_ComponentBaseController 
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
    public Boolean internal_only{get;set;}
    public String search_term { get; set; }
    public String sort_filter { get
        {
            if(sort_filter == null || sort_filter ==''){
                    sort_filter = 'Date DESC';
            }
            
            return sort_filter;
        } 
        set;}
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> vfdLst { get; set; }
    public Boolean init{
        get{
            getvfdContentList();
            return false;
        }
        set;
    }

/******************************************************************************
 * Constructor
 */
    public LPDCR_SecondaryVFDController()
    {
        System.debug( 'START: LPDCR_SecondaryVFDController.constructor()' );
        getvfdContentList();
        System.debug( 'END: LPDCR_SecondaryVFDController.constructor()' );
    }
    
    
/**********************************************************************************************************************
 * Method to get VFD Content List
 */    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getvfdContentList(){
        
        vfdLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_VFD_Service_Where_Clause,System.label.LPDCR_VFD_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          files_filter,
                                                          null,
                                                          sort_filter);        
        
        if( vfdLst != null){
            // Sort the VFD list
            LPDCR_BLDocuments.sortBy = sort_filter;
            vfdLst.sort();            
        }
        System.debug('vfdLst----'+vfdLst);
        return vfdLst;
    }
    
    
} // /END Class