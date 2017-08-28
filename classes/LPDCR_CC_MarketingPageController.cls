/******************************************************************************
 * Controller for the LPDCR_CC_MarketingPage VF page. Uses the design patter
 * described here - https://developer.salesforce.com/page/Controller_Component_Communication - 
 * in order to allow multiple components on the VF page to interact with each
 * 
 * @Author: Magnet 360
 * @Date: Mar 28, 2017 
 * @Jira: LPDCR-2230
 */

public with sharing class 
LPDCR_CC_MarketingPageController
    extends LPDCR_SecondaryPageBaseController
{

                                                 // Create a variable for the
                                                 // controller for each component
                                                 // on the page
    public LPDCR_SecondaryPageFiltersController filterController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPageFiltersController l_controller;
                l_controller = ( LPDCR_SecondaryPageFiltersController ) getComponentControllerMap().get( 'filtersComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryPageFiltersController(); 
        }
    }
    
    public LPDCR_SecondaryPagePromotionsController promotionsController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPagePromotionsController l_controller;
                l_controller = ( LPDCR_SecondaryPagePromotionsController ) getComponentControllerMap().get( 'promotionsComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryPagePromotionsController(); 
        }
    }

    public LPDCR_SecondaryPageMerchandisingCtrlr merchandisingController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPageMerchandisingCtrlr l_controller;
                l_controller = ( LPDCR_SecondaryPageMerchandisingCtrlr ) getComponentControllerMap().get( 'merchandisingComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryPageMerchandisingCtrlr(); 
        }
    }
    
    public LPDCR_SecondaryPageMediaToolsCtrlr mediaToolsController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPageMediaToolsCtrlr l_controller;
                l_controller = ( LPDCR_SecondaryPageMediaToolsCtrlr ) getComponentControllerMap().get( 'mediaToolsComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryPageMediaToolsCtrlr(); 
        }
    }
    
    private Set<String> pageSpecieList;
    private Set<String> pageFileFilterList;
    private String sortFilter;
    private Boolean internalUserOnly;
    public String search_term { get; set; }
    public String page_title { get; set; }
    public String selected_title { get; set; }
    
/******************************************************************************
 * Constructor
 */
    public
    LPDCR_CC_MarketingPageController()
    {
        System.debug( 'START: LPDCR_CC_MarketingPageController.constructor()' );
        
                                                 // Check to see if a subtab
                                                 // URLParam is passed in. If not,
                                                 // default the page title, otherwise
                                                 // set it to the proper value for the
                                                 // the subtab
        String l_subtab = ApexPages.currentPage().getParameters().get( 'subtab' );
        if( l_subtab == null )
        {
            page_title = Label.LPDCR_Promotions_Subtab_Name;
        }
        else
        {
            selected_title = l_subtab;
        }
        setPageTitle();
        //getSortByValue();
        
        System.debug( 'END: LPDCR_CC_MarketingPageController.constructor()' );
    }


/******************************************************************************
 * Method to pass the search term into the component to filter the results
 * returned 
 */
    public
    void
    doSearch()
    {
        System.debug( 'search_term = ' + search_term );
    }
    
/******************************************************************************
 * Getter method to return the sort_filter from the filterComponent variable
 */
    public String getSortBy()
    {
        sortFilter = filterController.sort_filter;
        return sortFilter;
    }        
    

/******************************************************************************
 * Getter method to return the species_filter from the filterComponent 
 * variable
 */
    public
    List<String>
    getSpecieList()
    {
        pageSpecieList = filterController.species_filter;
        return new List<String>( pageSpecieList );
    }

/******************************************************************************
 * Getter method to return the file_type_filter from the filterComponent 
 * variable
 */
    public
    List<String>
    getFileTypeFilter()
    {
        pageFileFilterList = filterController.file_type_filter;
        return new List<String>( pageFileFilterList );
    }
    
    // To check salesContent files
    public Boolean getInternalUserCheck(){
        internalUserOnly = filterController.internalOnly;
        return internalUserOnly;
    }

/******************************************************************************
 * Setter method to update the page_title when a subtab is selected. The page
 * title is set using a whitelist rather than directly from the URL parameter
 * for security, since the page_title is displayed directly on the page
 */
    public
    void
    setPageTitle()
    {
        System.debug( 'START: LPDCR_CC_MarketingPageController.setPageTitle()' );
        System.debug( 'Param: selected_title = ' + selected_title );
        
        if( selected_title == 'Promotions' || selected_title == null )
        {
            page_title = Label.LPDCR_Promotions_Subtab_Name;
        }
        else if( selected_title == 'MediaTools' )
        {
            page_title = Label.LPDCR_Media_Tools_Subtab_Name;
        }
        else if( selected_title == 'Merchandising' )
        {
            page_title = Label.LPDCR_Merchandising_Subtab_Name;
        }
        else
        {
            page_title = Label.LPDCR_Marketing_Component_Name;
        }
        
        System.debug( 'END: LPDCR_CC_MarketingPageController.setPageTitle()' );
    }

} // /END Class