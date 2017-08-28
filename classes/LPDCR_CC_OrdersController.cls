/******************************************************************************
 * Controller for the LPDCR_CC_Orders.component 
 * 
 * @Author: Magnet 360
 * @Date: May 3, 2017 
 * @Jira: LPDCR-2466
 */

public with sharing class 
LPDCR_CC_OrdersController 
{
    public Boolean is_price_list_available { get; set;}
    public Boolean is_order_accessible { get; set; }
    public LOLMyLinksCallouts.MyLinkData price_list_data {get; set;}
    public LOLMyLinksCallouts.MyLinkData order_data {get; set;}
    public LOLMyLinksCallouts.MyLinkData purina_data {get; set;}
    public LOLMyLinksCallouts.MyLinkData purinaOO_data {get; set;}

/******************************************************************************
 * Constructor
 */
    public
    LPDCR_CC_OrdersController()
    {
        System.debug( 'START: LPDCR_CC_OrdersController.constructor()' );
        
        is_order_accessible = false;
        is_price_list_available = false;
        
        LOLMyLinksCallouts my_links_callout = new LOLMyLinksCallouts();
        String currentFedId = my_links_callout.getFedId();
        
        if(UserInfo.getUserType() == 'STANDARD'){
            purina_data = my_links_callout.GetSpecificMyLink(Label.LPDCR_Purina_AppCode, currentFedId);
        }
        System.debug('condition...purina_data --'+purina_data );
        
        purinaOO_data = my_links_callout.GetSpecificMyLink(Label.LPDCR_PurinaOO_AppCode, currentFedId);        
        System.debug('condition...purinaOO_data --'+purinaOO_data );
        
        order_data = my_links_callout.GetSpecificMyLink(Label.LPDCR_OnlineOrder_AppCode, currentFedId);
        System.debug('condition...order_data --'+order_data );        
        /*if(order_data != null && order_data.myAppUrl != null){
            is_order_accessible = true;
        }*/
        
        price_list_data = my_links_callout.GetSpecificMyLink(Label.LPDCR_PriceList_AppCode, currentFedId);
        System.debug('condition...price_list_data --'+price_list_data );
        if(price_list_data != null
            && price_list_data.myAppUrl != null            
            && price_list_data.myAppUrl.Length() > 0 ) {
            is_price_list_available = true;
        }
        
        System.debug( 'END: LPDCR_CC_OrdersController.constructor()' );
    }
} // /END Class