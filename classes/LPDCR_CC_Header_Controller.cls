/******************************************************************************
 * Controller for the LPDCR_CC_Header.component
 * 
 * @Author: Magnet 360
 * @Date: Mar 14, 2017 
 * @Jira: LPDCR-2141
 */

public with sharing class 
LPDCR_CC_Header_Controller 
{
    
    private LOLMyLinksCallouts my_links_callout { get; set; }
    public Map<String,Boolean> permissionSetUserMap{get;set;}
    public Boolean bbm{get;set;}
    public Boolean oo{get;set;}
    public Boolean bb{get;set;}
    public Boolean pi{get;set;}
    public Boolean mm{get;set;}
    public Boolean ep{get;set;}
    public Boolean tt{get;set;}
    public Account selectedAcc{get;set;}
    public Boolean is_price_list_available { get; set;}
    public Boolean is_order_accessible { get; set; }
    public LOLMyLinksCallouts.MyLinkData price_list_data {get; set;}
    public LOLMyLinksCallouts.MyLinkData order_data {get; set;}
    public LOLMyLinksCallouts.MyLinkData purina_data {get; set;}
    public LOLMyLinksCallouts.MyLinkData purinaOO_data {get; set;}
    public String selectedAccountId
    {
        get {
            if( selectedAccountId == null) {
                selectedAccountId = LPDCR_ChangeAccountController.getSelectedAccId();
            }
            return selectedAccountId;
        }
        set;
    }
    public String search_term { get; set; }
    
    public User current_user {
        get {
            if( current_user == null ) {
                if( Cache.Session.isAvailable() && Cache.Session.get( UserInfo.getUserId() ) != null ) {
                    current_user = (User) Cache.Session.get( UserInfo.getUserId() );
                } else {
                    current_user = [ SELECT Id, 
                                            Name, 
                                            Username, 
                                            FederationIdentifier
                                     FROM User
                                     WHERE Id = :UserInfo.getUserId()
                                     LIMIT 1 ];
                    if( Cache.Session.isAvailable() ) {
                        Cache.Session.put( current_user.Id, current_user );   
                    }    
                }// /END if( Cache.Session.isAvailable() )
            }// /END if( current_user == null )
            
            return current_user;
        }
        set;
    }
    
    public String logout_url {
        get {
            if( logout_url == null ) {
                logout_url = '/mypurinamills/secur/logout.jsp';
            }
            System.debug('logout_url----'+logout_url);
            return logout_url;
        }
        set;
    }

    public String my_profile_url {
        get {
            if( my_profile_url == null ) {
                my_profile_url = my_links_callout.GetUserProfileURL();
            }
            return my_profile_url;
        }
        set;
    }

    /*
     * Property that returns the My Link data with the Home Pages
     * listed first, followed by the applications.
     */
    public List<LOLMyLinksCallouts.MyLinkData> resources {
        get {
            if( resources == null ) {
                resources = my_links_callout.GetMyLinkHomeSites();
                for (LOLMyLinksCallouts.MyLinkData A :my_links_callout.GetMyLinkApplications()) {
                   resources.add(A);
                }
            }
            return resources;
            
        }
        set;
    }
    public Boolean init
    {
        get
        {
            if( my_links_callout == null )
            { 
	            my_links_callout = new LOLMyLinksCallouts();
		        is_order_accessible = false;
		        is_price_list_available = false;
		        
		        String currentFedId = my_links_callout.getFedId();
		        
		                                                 // Internal users are granted access
		                                                 // to see all of the tiles
		        if( UserInfo.getUserType() == 'STANDARD' )
		        {
		            bbm = true;
		            oo = true;
		            bb = true;
		            pi = true;
		            mm = true;
		            ep = true;
		            tt = true;
		            purina_data = my_links_callout.GetSpecificMyLink(Label.LPDCR_Purina_AppCode, currentFedId);
		        }
		        else
		        {
		            permissionSetUserMap = LPDCR_ContentServiceUtil.getcurrentUserPerSet();
		            bbm= permissionSetUserMap.get(System.Label.LPDCR_Business_Management_Permission_Set);
		            oo= permissionSetUserMap.get(System.Label.LPDCR_Online_Order_Permission_Set);
		            bb= permissionSetUserMap.get(System.Label.LPDCR_Business_Builder_Permission_Set);
		            pi= permissionSetUserMap.get(System.Label.LPDCR_Product_Information_Permission_Set);
		            mm= permissionSetUserMap.get(System.Label.LPDCR_Marketing_Permission_Set);
		            ep= permissionSetUserMap.get(System.Label.LPDCR_Events_and_Planning_Permission_Set);
		            tt= permissionSetUserMap.get(System.Label.LPDCR_Training_Permission_Set);
		            purinaOO_data = my_links_callout.GetSpecificMyLink(Label.LPDCR_PurinaOO_AppCode, currentFedId); 
		            order_data = my_links_callout.GetSpecificMyLink(Label.LPDCR_OnlineOrder_AppCode, currentFedId);
		            price_list_data = my_links_callout.GetSpecificMyLink(Label.LPDCR_PriceList_AppCode, currentFedId);
		            if(order_data != null && order_data.myAppUrl != null){
		                is_order_accessible = true;
		            }
		            if(price_list_data != null
		                && price_list_data.myAppUrl != null            
		                && price_list_data.myAppUrl.Length() > 0 ) {
		                is_price_list_available = true;
		            }
		        }
		        System.debug('condition...purina_data --'+purina_data );
		        System.debug('condition...purinaOO_data --'+purinaOO_data );
		        System.debug('condition...order_data --'+order_data );        
		        System.debug('condition...price_list_data --'+price_list_data );
            }
            return false;
        }
        set;
    }
       
    
/******************************************************************************
 * Constructor
 */
    public
    LPDCR_CC_Header_Controller()
    {
        System.debug( 'START: LPDCR_CC_Header_Controller.constructor()' );
        System.debug( 'END: LPDCR_CC_Header_Controller.constructor()' );
    }

} // /END Class