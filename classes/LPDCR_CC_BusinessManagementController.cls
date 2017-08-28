/******************************************************************************
 * Controller for the LPDCR_CC_Business_Management VF page.
 * @Author: Shruti Mishra
 * @Date: May 23, 2017 
 * @Jira: 
 */

public with sharing class 
LPDCR_CC_BusinessManagementController
    extends LPDCR_SecondaryPageBaseController
{

    // Create a variable for the controller for each component on the page
    public LPDCR_SecondaryPageFiltersController filterController
    {
        set;
        get
        {
            // get the map, then the component controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPageFiltersController l_controller;
                l_controller = ( LPDCR_SecondaryPageFiltersController ) getComponentControllerMap().get( 'filtersComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
            // just in case something goes wrong, return something
            return new LPDCR_SecondaryPageFiltersController(); 
        }
    }    
    
    public LPDCR_SecondaryBusinessManagementCntlr businessMgtController
    {
        set;
        get
        {
            // get the map, then the component controller using the appropriate key
            if( getComponentControllerMap() != null) {
                LPDCR_SecondaryBusinessManagementCntlr l_controller;
                l_controller = ( LPDCR_SecondaryBusinessManagementCntlr ) getComponentControllerMap().get( 'businessMgtComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
            // just in case something goes wrong, return something
            return new LPDCR_SecondaryBusinessManagementCntlr(); 
        }
    }
    
    public LPDCR_SecondaryReportController reportController
    {
        set;
        get
        {
            // get the map, then the component controller using the appropriate key
            if( getComponentControllerMap() != null) {
                LPDCR_SecondaryReportController l_controller;
                l_controller = ( LPDCR_SecondaryReportController ) getComponentControllerMap().get( 'reportComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
            // just in case something goes wrong, return something
            return new LPDCR_SecondaryReportController(); 
        }
    }
    
    public LPDCR_SecFLMContentController flmContentController
    {
        set;
        get
        {
            // get the map, then the component controller using the appropriate key
            if( getComponentControllerMap() != null && isFLMAccount ) {
                LPDCR_SecFLMContentController l_controller;
                l_controller = ( LPDCR_SecFLMContentController ) getComponentControllerMap().get( 'flmComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
            // just in case something goes wrong, return something
            return new LPDCR_SecFLMContentController(); 
        }
    }
    public LPDCR_SecondaryVFDController VFDController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryVFDController l_controller;
                l_controller = ( LPDCR_SecondaryVFDController ) getComponentControllerMap().get( 'vfdComponent' );
                if( l_controller != null ) {
                    
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryVFDController(); 
        }
    }
    
    public LPDCR_SecondaryCouponResourceCntlr couponResourceController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryCouponResourceCntlr l_controller;
                l_controller = ( LPDCR_SecondaryCouponResourceCntlr ) getComponentControllerMap().get( 'couponResourceComponent' );
                if( l_controller != null ) {
                    
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryCouponResourceCntlr(); 
        }
    }
    public LPDCR_SecondaryFeedSafetyCntlr FeedSafetyController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryFeedSafetyCntlr l_controller;
                l_controller = ( LPDCR_SecondaryFeedSafetyCntlr ) getComponentControllerMap().get( 'feedComponent' );
                if( l_controller != null ) {
                    
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryFeedSafetyCntlr(); 
        }
    }
    public LPDCR_SecondaryPracAndPoliciesCntlr PracController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPracAndPoliciesCntlr l_controller;
                l_controller = ( LPDCR_SecondaryPracAndPoliciesCntlr ) getComponentControllerMap().get( 'pracComponent' );
                if( l_controller != null ) {
                    
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryPracAndPoliciesCntlr(); 
        }
    }
    public LPDCR_SecondarySalesResourcesCntlr SalesController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondarySalesResourcesCntlr l_controller;
                l_controller = ( LPDCR_SecondarySalesResourcesCntlr ) getComponentControllerMap().get( 'salesComponent' );
                if( l_controller != null ) {
                    
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondarySalesResourcesCntlr(); 
        }
    }

    
    private Set<String> pageSpecieList;
    private Set<String> pageFileFilterList;
    private String sortFilter;
    private Boolean internalUserOnly;
    //public Boolean isFlmAccount { get; set; }
    public String search_term { get; set; }
    public String page_title { get; set; }
    public String selected_title { get; set; }

    
/****************************************************************************************
 * Constructor
 */
    public LPDCR_CC_BusinessManagementController()
    {
        System.debug( 'START: LPDCR_CC_BusinessManagementController.constructor()' );
        
        // Check to see if a subtab URLParam is passed in. If not, default the page title, 
        // otherwise set it to the proper value for subtab
        String l_subtab = ApexPages.currentPage().getParameters().get( 'subtab' );
        
        if( l_subtab == null ){
            page_title = Label.LPDCR_Promotions_Subtab_Name;
        }
        else{
            selected_title = l_subtab;
        }
        
        /*if(){
        
        }*/
        //isFlmAccount = False;
        
        System.debug('isFLM? ---'+isFLMAccount );
        setPageTitle();
                
        System.debug( 'END: LPDCR_CC_BusinessManagementController.constructor()' );
    }


/******************************************************************************
 * Method to pass the search term into the component to filter the results returned 
 */
    public void doSearch()
    {
        System.debug( 'search_term = ' + search_term );
    }
    
/******************************************************************************
 * Getter method to return the sort_filter from the filterComponent variable
 */
    public String getSortBy()
    {
        sortFilter = filterController.sort_filter;
        System.debug('sortFilter ==='+sortFilter );
        return sortFilter;
    }    

/******************************************************************************
 * Getter method to return the species_filter from the filterComponent 
 * variable
 */
    public List<String> getSpecieList()
    {
        pageSpecieList = filterController.species_filter;
        return new List<String>( pageSpecieList );
    }

/******************************************************************************
 * Getter method to return the file_type_filter from the filterComponent variable
 */
    public List<String> getFileTypeFilter()
    {
        pageFileFilterList = filterController.file_type_filter;
        return new List<String>( pageFileFilterList );
    }
    
/******************************************************************************
 * Getter method to check salesContent files
 */
    public Boolean getInternalUserCheck()
    {
        internalUserOnly = filterController.internalOnly;
        return internalUserOnly;
    }

/******************************************************************************
 * Setter method to update the page_title when a subtab is selected.
 */
    public void setPageTitle()
    {
        System.debug( 'START: LPDCR_CC_BusinessManagementController.setPageTitle()' );
        System.debug( 'Param: selected_title = ' + selected_title );
        
        //Set page titles
        if( selected_title == 'BusinessManagement' || selected_title == null ){
            page_title = Label.LPDCR_Business_Management_Component_Name;
        }
        else if( selected_title == 'Reports' ){
            page_title = Label.LPDCR_Reports_Subtab_Name;
        }
        else if( selected_title == 'Practices And Policies' ){
            page_title = Label.LPDCR_Prac_and_Policies_Subtab_Name;
        }
        else if( selected_title == 'Veterinary Feed Directive' ){
            page_title = Label.LPDCR_VFD_Subtab_Name;
        }
        else if( selected_title == 'Feed Safety' ){
            page_title = Label.LPDCR_Feed_Safety_Subtab_Name;
        }
        else if( selected_title == 'Sales Resources' ){
            page_title = Label.LPDCR_Sales_Resources_Subtab_Name;
        }
        else if( selected_title == 'FeedLicenseManufacturer' ){
            page_title = Label.LPDCR_FLM_Subtab_Name;
        }
        else{
            page_title = Label.LPDCR_Business_Management_Component_Name;
        }
        
        System.debug( 'END: LPDCR_CC_BusinessManagementController.setPageTitle()' );
    }

} // /END Class