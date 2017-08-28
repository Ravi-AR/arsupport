/******************************************************************************
 * Controller for the LPDCR_SecondaryFeedSafety component
 * @Author: Heena Tanna
 * @Date: May 23, 2017 
 * @Jira: LPDCR-2806
 */

public with sharing class LPDCR_SecondaryFeedSafetyCntlr extends LPDCR_ComponentBaseController 
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
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> feedSafetyLst { get; set; }
    public Boolean init{
        get{
            getFeedSafetyList();
            return false;
        }
        set;
    }

/******************************************************************************
 * Constructor
 */
    public LPDCR_SecondaryFeedSafetyCntlr()
    {
        System.debug( 'START: LPDCR_SecondaryFeedSafetyCntlr.constructor()' );
        getFeedSafetyList();
        System.debug( 'END: LPDCR_SecondaryFeedSafetyCntlr.constructor()' );
    }
    
    
/**********************************************************************************************************************
 * Method to get VFD Content List
 */    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getFeedSafetyList(){
        
        feedSafetyLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_Feed_Safety_Service_Where_Clause,System.label.LPDCR_Feed_Safety_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          files_filter,
                                                          null,
                                                          sort_filter);        
        
        if( feedSafetyLst != null){
            // Sort the Feed Safety list
            LPDCR_BLDocuments.sortBy = sort_filter;
            feedSafetyLst.sort();            
        }
        System.debug('feedSafetyLst----'+feedSafetyLst);
        return null;
    }
    
    
} // /END Class