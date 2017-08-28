/******************************************************************************
 * Controller for the LPDCR_SecondarySalesToolController component
 * @Author: Shruti
 * @Date: Apr 18, 2017 
 * @Jira: 
 */

public with sharing class LPDCR_SecondarySalesToolController extends LPDCR_ComponentBaseController 
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
    public Boolean internal_only{get;set;}
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> salesToolLst { get; set; }
    public Boolean init{
        get{
            getSalesToolList();
            return false;
        }
        set;
    }

/******************************************************************************
 * Constructor
 */
    public LPDCR_SecondarySalesToolController()
    {
        System.debug( 'START: LPDCR_SecondarySalesToolController.constructor()' );
        getSalesToolList();
        System.debug( 'END: LPDCR_SecondarySalesToolController.constructor()' );
    }
    
    
/**********************************************************************************************************************
 * Method to get sales tool List
 */    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getSalesToolList(){
        
        //if(salesToolLst == null){
        System.debug('In if---'+internal_only);
            //salesToolLst = content_service.getDocuments(System.label.LPDCR_SalesTools_Service_Where_Clause,System.label.LPDCR_SalesTools_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList();
            
             salesToolLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_SalesTools_Service_Where_Clause,System.label.LPDCR_SalesTools_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          files_filter,
                                                          internal_only,
                                                          sort_filter);
                                                              
        //}
            
        if( salesToolLst != null && sort_filter != null )    
        {
            // Sort the SalesTools list
            LPDCR_BLDocuments.sortBy = sort_filter;
            salesToolLst.sort();
            System.debug('sorting salestool...');
        }
        System.debug('salesToolLst ----'+salesToolLst.size() );
        return salesToolLst;
    }
    
} // /END Class