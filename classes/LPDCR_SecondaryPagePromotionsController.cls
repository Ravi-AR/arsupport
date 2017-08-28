/******************************************************************************
 * Controller for the LPDCR_SecondaryPagePromotionBody component
 * 
 * @Author: Magnet 360
 * @Date: Mar 30, 2017 
 * @Jira: LPDCR-2230
 */

public with sharing class 
LPDCR_SecondaryPagePromotionsController
    extends LPDCR_ComponentBaseController 
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
    public Boolean internal_only { get; set; }
    public String sort_filter { get
        {
            if(sort_filter == null || sort_filter ==''){
                    sort_filter = 'Date DESC';
            }
            
            return sort_filter;
        } 
        set;}
       
    
    public List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions> promotions { get; set; }
    public List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions> activePromotions { get; set; }
    public Boolean init{
        get{            
            getPromotionList();
            return false;
        }
    } 
    public String search_term { get; set; }
    

/******************************************************************************
 * Constructor
 */
    public
    LPDCR_SecondaryPagePromotionsController()
    {
        System.debug( 'START: LPDCR_SecondaryPagePromotionsController.constructor()' );
        //if(species_filter!=null)species_filter.clear();
        //file_type_filter.clear();
        //sort_filter = '';
        System.debug( 'END: LPDCR_SecondaryPagePromotionsController.constructor()' );
    }
    
    
/**********************************************************************************************************************
 * Method to get Promotion List
 */    
    public 
    List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions> 
    getPromotionList()
    {
                                                     // Get the promotions
                                                     // and Filter by species
        if(internal_only==null){
            internal_only = False;
        }
        System.debug('sort_filter---'+sort_filter);
        
        promotions = LPDCR_BLPromotions.filterPromotions( content_service.getPromotionsData(Label.LPDCR_Promotion_Order_By_Clause).getPromotionsList(), 
                                                          species_filter,
                                                          internal_only,
                                                          sort_filter);
       
        activePromotions = new List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions>();
       
        for(LPDCR_BLPromotions.PurinaBusinessLink_Promotions promo: promotions){
            if( (promo.StartDate > Date.today()) ||  (  promo.StartDate <= Date.today() && promo.ExpirationDate >= Date.today() )){
            //if()
                activePromotions.add(promo);
            }
        }
       
        System.debug('total promotions---'+activePromotions.size());
        
        if( activePromotions!= null){            
                                                     // Sort the promotions list
            LPDCR_BLPromotions.sortBy = sort_filter;
            activePromotions.sort();
        }
        
        
        return null;
    }
    
} // /END Class