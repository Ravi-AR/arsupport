/******************************************************************************
 * Controller for the LPDCR_SecondarySalesResource component
 * @Author: Heena Tanna
 * @Date: May 24, 2017 
 * @Jira: LPDCR-2399
 */

public with sharing class LPDCR_SecondarySalesResourcesCntlr extends LPDCR_ComponentBaseController 
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
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> salesResourceLst { get; set; }
    public Boolean init{
        get{
            getSalesResourceList();
            return false;
        }
        set;
    }

/******************************************************************************
 * Constructor
 */
    public LPDCR_SecondarySalesResourcesCntlr()
    {
        System.debug( 'START: LPDCR_SecondarySalesResourcesCntlr.constructor()' );
        
        System.debug( 'END: LPDCR_SecondarySalesResourcesCntlr.constructor()' );
    }
    
    
/**********************************************************************************************************************
 * Method to get VFD Content List
 */    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getSalesResourceList(){
        
        salesResourceLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_Sales_Resources_Service_Where_Clause,System.label.LPDCR_Sales_Resources_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          files_filter,
                                                          null,
                                                          sort_filter);        
        
        if( salesResourceLst != null){
            // Sort the list
            LPDCR_BLDocuments.sortBy = sort_filter;
            salesResourceLst.sort();            
        }
        System.debug('salesResourceLst----'+salesResourceLst);
        return null;
    }
    
    
} // /END Class