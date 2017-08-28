/**
*   @Author:    Shruti Mishra
*   @Date:      12.04.2017
*   @Jira:      LPDCR-2345
*   @Purpose:   Controller behind Training component
*/
public with sharing class LPDCR_SecondaryPageTrainingController extends LPDCR_ComponentBaseController  {
    
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
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> trainingVdoList {get;set;}
    public Boolean init{
    get{
        getTrainingData();
        return false;
       }
    }
    
/**********************************************************************************************
 * Constructor
 */
    public LPDCR_SecondaryPageTrainingController()
    {
        System.debug( 'START: LPDCR_SecondaryPageTrainingController.constructor()' );

        System.debug( 'END: LPDCR_SecondaryPageTrainingController.constructor()' );
    }
    
/**********************************************************************************************
 * Getter method for Training videos
 */
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getTrainingData(){
         
        trainingVdoList = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_Training_Service_Where_Clause, System.label.LPDCR_Training_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          null,
                                                          internal_only,
                                                          sort_filter);
        for(LPDCR_BLDocuments.PurinaBusinessLink_Documents item: trainingVdoList){
            System.debug('item -------'+ item.DocumentsLastModified );
        }
        if( trainingVdoList != null )    
        {
            if(sort_filter == null || sort_filter == ''){
                sort_filter = Label.LPDCR_Document_Order_By_Clause;
            }
            //sorting...
            LPDCR_BLDocuments.sortBy = sort_filter;
            trainingVdoList.sort();
        }
        
        return trainingVdoList;
    }
    
}