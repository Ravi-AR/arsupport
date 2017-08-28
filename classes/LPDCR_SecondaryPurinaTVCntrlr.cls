/**
*   @Author:    Shruti Mishra
*   @Date:      17.04.2017
*   @Jira:      LPDCR-2345
*   @Purpose:   Controller behind Purina TV component
*/
public with sharing class LPDCR_SecondaryPurinaTVCntrlr extends LPDCR_ComponentBaseController  {
    
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
    public List<String> species_filter { get; set; }
    public Boolean internal_only{get;set;}
    public String sort_filter { 
        get
        {
            if(sort_filter == null || sort_filter ==''){
                    sort_filter = 'Date DESC';
            }
            
            return sort_filter;
        } 
        set;}
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> purinaTVList{get;set;}
    public Boolean init{
    get{
        getPurinaTVContent();
        return false;
       }
    }
    
/**********************************************************************************************
 * Constructor
 */
    public LPDCR_SecondaryPurinaTVCntrlr()
    {
        System.debug( 'START: LPDCR_SecondaryPurinaTVCntrlr.constructor()' );
        
        System.debug( 'END: LPDCR_SecondaryPurinaTVCntrlr.constructor()' );
    }
    
/**********************************************************************************************
 * Getter method for Purina TV Content
 */
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getPurinaTVContent(){
        //if( purinaTVList == null ){
            //purinaTVList = content_service.getDocuments(System.label.LPDCR_PurinaTV_Service_Where_Clause, System.label.LPDCR_PurinaTV_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList();
            purinaTVList = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_PurinaTV_Service_Where_Clause, System.label.LPDCR_PurinaTV_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          null,
                                                          internal_only,
                                                          sort_filter);
        //}
        if( purinaTVList != null && sort_filter != null )    
        {
            //Sorting..
            LPDCR_BLDocuments.sortBy = sort_filter;
            purinaTVList.sort();
        }
        System.debug('purinaTVList -------'+ purinaTVList );
        return purinaTVList;
    }
    
}