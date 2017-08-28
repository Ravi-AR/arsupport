/******************************************************************************
 * Controller for the LPDCR_SecondaryPageSalesSheetsBody component
 * @Author: Shruti
 * @Date: Apr 18, 2017 
 * @Jira: 
 */

public with sharing class LPDCR_SecondaryPageSalesSheetsController extends LPDCR_ComponentBaseController 
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
    public Boolean internal_only{get;set;}
    public String search_term { get; set; }
    public String sort_filter { get; set; }
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> salesSheetsLst { get; set; }
    public Boolean init{
        get{
            getSalesSheetsList();
            return false;
        }
        set;
    }

/******************************************************************************
 * Constructor
 */
    public LPDCR_SecondaryPageSalesSheetsController()
    {
        System.debug( 'START: LPDCR_SecondaryPageSalesSheetsController.constructor()' );
        
        System.debug( 'END: LPDCR_SecondaryPageSalesSheetsController.constructor()' );
    }
    
    
/**********************************************************************************************************************
 * Method to get product List
 */    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getSalesSheetsList(){
        
        //if(salesSheetsLst == null){
           //salesSheetsLst = content_service.getDocuments(System.label.LPDCR_SalesSheets_Service_Where_Clause,System.label.LPDCR_SalesSheets_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList();
           salesSheetsLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_SalesSheets_Service_Where_Clause,System.label.LPDCR_SalesSheets_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          null,
                                                          internal_only,
                                                          sort_filter);
        //}
        if( salesSheetsLst != null && sort_filter != null )    
        {
            // Sort the salesSheets list
            LPDCR_BLDocuments.sortBy = sort_filter;
            salesSheetsLst.sort();
            System.debug('sorting...');
        }
        System.debug('salesSheetsLst----'+salesSheetsLst);
        return null;
    }
    
    
} // /END Class