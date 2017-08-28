/******************************************************************************
 * Controller for the LPDCR_SecondaryPracAndPolicies component
 * @Author: Heena Tanna
 * @Date: May 24, 2017 
 * @Jira: LPDCR-2399
 */

public with sharing class LPDCR_SecondaryPracAndPoliciesCntlr extends LPDCR_ComponentBaseController 
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
    public String sort_filter { get
        {
            if(sort_filter == null || sort_filter ==''){
                    sort_filter = 'Date DESC';
            }
            
            return sort_filter;
        } 
        set;}
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> pracPoliciesLst { get; set; }
    public Boolean init{
        get{
            getPracAndPoliciesList();
            return false;
        }
        set;
    }

/******************************************************************************
 * Constructor
 */
    public LPDCR_SecondaryPracAndPoliciesCntlr()
    {
        System.debug( 'START: LPDCR_SecondaryPracAndPoliciesCntlr.constructor()' );
        
        System.debug( 'END: LPDCR_SecondaryPracAndPoliciesCntlr.constructor()' );
    }
    
    
/**********************************************************************************************************************
 * Method to get VFD Content List
 */    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getPracAndPoliciesList(){
        
        pracPoliciesLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_Prac_and_Policies_Service_Where_Clause,System.label.LPDCR_Prac_and_Policies_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          null,
                                                          null,
                                                          internal_only,
                                                          sort_filter);        
        
        if( pracPoliciesLst != null){
            // Sort the list
            LPDCR_BLDocuments.sortBy = sort_filter;
            pracPoliciesLst.sort();            
        }
        System.debug('pracPoliciesLst----'+pracPoliciesLst);
        return null;
    }
    
    
} // /END Class