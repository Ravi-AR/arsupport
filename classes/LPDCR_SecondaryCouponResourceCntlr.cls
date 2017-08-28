/******************************************************************************
 * Controller for the LPDCR_SecondaryCouponResource component
 * @Author: Heena Tanna
 * @Date: May 24, 2017 
 * @Jira: LPDCR-2951
 */

public with sharing class LPDCR_SecondaryCouponResourceCntlr extends LPDCR_ComponentBaseController
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
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> couponResourceLst { get; set; }
    public Boolean init{
        get{
            getCouponResourceList();
            return false;
        }
        set;
    }
    
    public Boolean showAllItems{get;set;}
    public Boolean showCouponResourceFlag {get;set;}

/******************************************************************************
 * Constructor
 */
    public LPDCR_SecondaryCouponResourceCntlr()
    {
        System.debug( 'START: LPDCR_SecondaryCouponResourceCntlr.constructor()' );
            showAllItems = true;
            showCouponResourceFlag = false;
        System.debug( 'END: LPDCR_SecondaryCouponResourceCntlr.constructor()' );
    }
    
    
/**********************************************************************************************************************
 * Method to get VFD Content List
 */    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> getCouponResourceList(){
        
        couponResourceLst = LPDCR_BLDocuments.filterDocuments( content_service.getDocuments(System.label.LPDCR_Coupon_Resource_Service_Where_Clause,System.label.LPDCR_Coupon_Resource_Service_Cache_Key,System.Label.LPDCR_Document_Order_By_Clause).getDocumentsList(), 
                                                          species_filter,
                                                          null,
                                                          internal_only,
                                                          sort_filter);        
        
        if( couponResourceLst != null){
            // Sort the list
            LPDCR_BLDocuments.sortBy = sort_filter;
            couponResourceLst.sort();            
        }
        System.debug('couponResourceLst----'+couponResourceLst);
        return null;
    }
    

    public void showCouponResource()
        {
            showCouponResourceFlag = true;
            showAllItems = false;
        } 
    
    
} // /END Class