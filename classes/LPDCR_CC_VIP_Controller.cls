/******************************************************************************
 * Controller for the LPDCR_CC_VIP VF page. Uses the design pattern
 * described here - https://developer.salesforce.com/page/Controller_Component_Communication - 
 * in order to allow multiple components on the VF page to interact with each
 * 
 * @Author: Magnet 360
 * @Date: Apr 24, 2017 
 * @Jira: LPDCR-2397
 */

public with sharing class 
LPDCR_CC_VIP_Controller 
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
    
    public  LPDCR_SecondaryVIPFarmController vipEventsController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryVIPFarmController l_controller;
                l_controller = ( LPDCR_SecondaryVIPFarmController ) getComponentControllerMap().get( 'vipEventsComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryVIPFarmController(); 
        }
    }
    
    public LPDCR_SecondaryNationalEventsController nationalEventsController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryNationalEventsController l_controller;
                l_controller = ( LPDCR_SecondaryNationalEventsController ) getComponentControllerMap().get( 'nationalEventsComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryNationalEventsController(); 
        }
    }
    
    public LPDCR_CC_VIPEventsController localEventsController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_CC_VIPEventsController l_controller;
                l_controller = ( LPDCR_CC_VIPEventsController ) getComponentControllerMap().get( 'localEventsComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_CC_VIPEventsController(); 
        }
    }
     public LPDCR_SecondaryEventPlanningController eventPlanningController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryEventPlanningController l_controller;
                l_controller = ( LPDCR_SecondaryEventPlanningController ) getComponentControllerMap().get( 'eventPlansComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryEventPlanningController(); 
        }
    }

    private Set<String> pageSpecieList;
    private Set<String> pageFileFilterList;
    public String search_term { get; set; }
    public String page_title { get; set; }
    public String selected_title { get; set; }
    private String sortFilter;
    private Boolean internalUserOnly;
    
/******************************************************************************
 * Constructor
 */
    public
    LPDCR_CC_VIP_Controller()
    {
        System.debug( 'START: LPDCR_CC_VIP_Controller.constructor()' );
        
                                                 // Check to see if a subtab
                                                 // URLParam is passed in. If not,
                                                 // default the page title, otherwise
                                                 // set it to the proper value for the
                                                 // the subtab
        String l_subtab = ApexPages.currentPage().getParameters().get( 'subtab' );
        if( l_subtab == null )
        {
            page_title = Label.LPDCR_Farm_VIP_Subtab_Name;
        }
        else
        {
            selected_title = l_subtab;
        }
        setPageTitle();
        
        System.debug( 'END: LPDCR_CC_VIP_Controller.constructor()' );
    }

   // To check salesContent files
    public Boolean getInternalUserCheck(){
        internalUserOnly = filterController.internalOnly;
        return internalUserOnly;
    }

/******************************************************************************
 * Getter method to return the species_filter from the filterComponent variable
 */
    public
    List<String>
    getSpecieList()
    {
        pageSpecieList = filterController.species_filter;
        return new List<String>( pageSpecieList );
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
/******************************************************************************
 * Setter method to update the page_title when a subtab is selected. The page
 * title is set using a whitelist rather than directly from the URL parameter
 * for security, since the page_title is displayed directly on the page
 */
    public
    void
    setPageTitle()
    {
        System.debug( 'START: LPDCR_CC_VIP_Controller.setPageTitle()' );
        System.debug( 'Param: selected_title = ' + selected_title );
        
        if( selected_title == 'FarmVIP' || selected_title == null )
        {
            page_title = Label.LPDCR_Farm_VIP_Subtab_Name;
        }
        else if( selected_title == 'NationalEvents' )
        {
            page_title = Label.LPDCR_National_Events_Subtab_Name;
        }
        else if( selected_title == 'LocalEvents' )
        {
            page_title = Label.LPDCR_Local_Events_Subtab_Name;
        }
        else if( selected_title == 'PlanningResources' )
        {
            page_title = Label.LPDCR_Planning_Resources_Subtab_Name;
        }
        else
        {
            page_title = Label.LPDCR_Farm_VIP_Subtab_Name;
        }
        
        System.debug( 'END: LPDCR_CC_VIP_Controller.setPageTitle()' );
    }

} // /END Class