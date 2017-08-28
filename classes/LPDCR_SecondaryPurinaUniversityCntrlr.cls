/**
*   @Author:    Shruti Mishra
*   @Date:      17.04.2017
*   @Jira:      LPDCR-2345
*   @Purpose:   Controller behind Purina University component
*/
public with sharing class LPDCR_SecondaryPurinaUniversityCntrlr extends LPDCR_ComponentBaseController  {
    
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
    public String sort_filter { get
        {
            if(sort_filter == null || sort_filter ==''){
                    sort_filter = 'Date DESC';
            }
            
            return sort_filter;
        } 
        set;}
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> purinaUniversityDocList{get;set;}
    public Boolean init{
    get{
        getPurinaUniversityContent();
        return false;
       }
    }
    
/**********************************************************************************************
 * Constructor
 */
    public LPDCR_SecondaryPurinaUniversityCntrlr()
    {
        System.debug( 'START: LPDCR_SecondaryPurinaUniversityCntrlr.constructor()' );
        
        System.debug( 'END: LPDCR_SecondaryPurinaUniversityCntrlr.constructor()' );
    }
    
/**********************************************************************************************
 * Getter method for PurinaUniversity Content
 */
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getPurinaUniversityContent(){
        //if( purinaUniversityDocList == null ){
            //purinaUniversityDocList = content_service.getDocuments(System.label.LPDCR_PurinaUniversity_Service_Where_Clause,System.label.LPDCR_PurinaUniversity_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList();
            purinaUniversityDocList = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_PurinaUniversity_Service_Where_Clause,System.label.LPDCR_PurinaUniversity_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          null,
                                                          internal_only,
                                                          sort_filter);
        //}
         if( purinaUniversityDocList != null && sort_filter != null )    
        {
            //Sorting..
            LPDCR_BLDocuments.sortBy = sort_filter;
            purinaUniversityDocList.sort();
        }
        System.debug('purinaUniversityDocList -------'+ purinaUniversityDocList );
        return purinaUniversityDocList;
    }
    
}