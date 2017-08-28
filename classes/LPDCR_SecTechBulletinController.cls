/******************************************************************************
 * Controller for the LPDCR_SecTechBulletinBody component
 * @Author: Shruti
 * @Date: Apr 18, 2017 
 * @Jira: 
 */

public with sharing class LPDCR_SecTechBulletinController extends LPDCR_ComponentBaseController 
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
    public Boolean internal_only{get;set;}
    public List<String> species_filter { get; set; }
    
    public String search_term { get; set; }
    public String sort_filter { get; set; }
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> techBulletinLst { get; set; }
    public Boolean init{
        get{
            getTechBulletinList();
            return false;
        }
        set;
    }

/******************************************************************************
 * Constructor
 */
    public LPDCR_SecTechBulletinController()
    {
        System.debug( 'START: LPDCR_SecTechBulletinController.constructor()' );
        
        System.debug( 'END: LPDCR_SecTechBulletinController.constructor()' );
    }
    
    
/**********************************************************************************************************************
 * Method to get product List
 */    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getTechBulletinList(){
        System.debug('In tech bulletin list');
        //if(techBulletinLst == null){
            //techBulletinLst = content_service.getDocuments(System.label.LPDCR_TechBulletin_Service_Where_Clause,System.label.LPDCR_TechBulletin_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList();
            techBulletinLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_TechBulletin_Service_Where_Clause,System.label.LPDCR_TechBulletin_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          null,
                                                          internal_only,
                                                          sort_filter);
        //}
        if( techBulletinLst != null && sort_filter != null ) {
            System.debug('Tech bulletin sort_filter--'+ sort_filter);
            LPDCR_BLDocuments.sortBy = sort_filter;
            techBulletinLst.sort(); 
            System.debug('Sorting...');
        }
        return null;
    }
    
} // /END Class