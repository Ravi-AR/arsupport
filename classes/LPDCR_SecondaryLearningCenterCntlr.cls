/**
*   @Author:    Heena Tanna
*   @Date:      07.06.2017
*   @Jira:      LPDCR-3052
*   @Purpose:   Controller behind Learning Center component
*/
public with sharing class LPDCR_SecondaryLearningCenterCntlr extends LPDCR_ComponentBaseController  {
    
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
    public String search_term { get; set; }
    public List<String> species_filter { get; set; }
    public List<String> files_filter { get; set; } 
    public Boolean internal_only{get;set;}
    public Boolean showLearningList { get; set; }
    public Boolean showDocumentList { get; set; }
    public String sort_filter { 
        get
        {
            if(sort_filter == null || sort_filter ==''){
                    sort_filter = 'Date DESC';
            }
            
            return sort_filter;
        } 
        set;}
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> learningDocList {get;set;}
    public Boolean init{
    get{
        getLearningCenterData();
        return false;
       }
    }
    
/**********************************************************************************************
 * Constructor
 */
    public LPDCR_SecondaryLearningCenterCntlr()
    {
        System.debug( 'START: LPDCR_SecondaryLearningCenterCntlr.constructor()' );
        showLearningList = true;
        showDocumentList = false;
        System.debug( 'END: LPDCR_SecondaryLearningCenterCntlr.constructor()' );
    }
    /******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void showDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryLearningCenterCntlr.showDocumentList()' );
       

        showLearningList = false;
        showDocumentList = true;

        System.debug( 'END: LPDCR_SecondaryLearningCenterCntlr.showDocumentList()' );
    }
    /******************************************************************************
 * Method called from the VF action function to render the document list
 */
    public void hideDocumentList()
    {
        System.debug( 'START: LPDCR_SecondaryLearningCenterCntlr.hideDocumentList()' );
        

        showLearningList = true;
        showDocumentList = false;

        System.debug( 'END: LPDCR_SecondaryLearningCenterCntlr.hideDocumentList()' );
    }
/**********************************************************************************************
 * Getter method for Training videos
 */
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getLearningCenterData(){
         
        learningDocList = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_Learning_Center_Service_Where_Clause, System.label.LPDCR_Learning_Center_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          files_filter,
                                                          internal_only,
                                                          sort_filter);
        for(LPDCR_BLDocuments.PurinaBusinessLink_Documents item: learningDocList){
            System.debug('item -------'+ item.DocumentsLastModified );
        }
        if( learningDocList != null )    
        {
            if(sort_filter == null || sort_filter == ''){
                sort_filter = Label.LPDCR_Document_Order_By_Clause;
            }
            //sorting...
            LPDCR_BLDocuments.sortBy = sort_filter;
            learningDocList.sort();
        }
        
        return learningDocList;
    }
    
}