/******************************************************************************
 * Test class for LPDCR_SearchResultsListController 
 *
 *
 * @Author: Magnet 360
 * @Date: May 31, 2017
 * @Jira: LPDCR-1992
 */
@isTest( SeeAllData=false )
private class 
LPDCR_SearchResultsListControllerTest 
{
/******************************************************************************
 * Setup any data and custom settings needed for the test class
 */    
    @testSetup
    public static 
    void 
    testSetup()
    {
        LPDCR_TestUtil.setCustomSettings();
    }


/******************************************************************************
 * Method to test searching the Documents Search service
 */
    static testMethod 
    void 
    test_DocumentSearchResultsList() 
    {
		System.debug( 'START: LPDCR_SearchResultsListControllerTest.test_DocumentSearchResultsList()' );
        
        Test.setCurrentPage( Page.LPDCR_SearchResults );
        Test.setMock( HttpCalloutMock.class, new LPDCR_DocumentSearchMockHTTPResponse() );
        Test.startTest();
        
        LPDCR_SearchResultsController l_search_resuls_controller = new LPDCR_SearchResultsController();
        LPDCR_SecondaryPageFiltersController l_filters_controllers = new LPDCR_SecondaryPageFiltersController();
        l_search_resuls_controller.setComponentControllerMap( 'filtersComponent', l_filters_controllers );
        
        LPDCR_SearchResultsListController l_controller = new LPDCR_SearchResultsListController();
        l_controller.pageController = l_search_resuls_controller;
        l_controller.search_term = 'horse';
        l_controller.species_filter.add( 'Horse' );
        l_controller.file_type_filter.add( '.pdf' );
        l_controller.internalOnly = false;

        l_controller.doSearch();
        System.assert( l_controller.results != null );
        System.assert( l_controller.filtered_results != null );
        
        l_controller.search_category = LPDCR_SearchOverviewController.VIDEOS_SEARCH_CATEGORY;
        l_controller.doSearch();
        System.assert( l_controller.results != null );
        System.assert( l_controller.filtered_results != null );
        
        l_controller.search_category = LPDCR_SearchOverviewController.IMAGES_SEARCH_CATEGORY;
        l_controller.doSearch();
        System.assert( l_controller.results != null );
        System.assert( l_controller.filtered_results != null );
        
        l_controller.search_category = LPDCR_SearchOverviewController.SALES_RESOURCES_SEARCH_CATEGORY;
        l_controller.doSearch();
        System.assert( l_controller.results != null );
        System.assert( l_controller.filtered_results != null );
        
        l_controller.search_category = LPDCR_SearchOverviewController.EVENTS_SEARCH_CATEGORY;
        l_controller.doSearch();
        System.assert( l_controller.results != null );
        System.assert( l_controller.filtered_results != null );
        
        Test.stopTest();

        System.debug( 'END: LPDCR_SearchResultsListControllerTest.test_DocumentSearchResultsList()' );
    }

/******************************************************************************
 * Method to test searching the Promotions Search service
 */
    static testMethod 
    void 
    test_PromotionSearchResultsList() 
    {
        System.debug( 'START: LPDCR_SearchResultsListControllerTest.test_PromotionSearchResultsList()' );
        
        Test.setCurrentPage( Page.LPDCR_SearchResults );
        Test.setMock( HttpCalloutMock.class, new LPDCR_PromotionSearchMockHTTResponse() );
        Test.startTest();
        
        
        LPDCR_SearchResultsController l_search_resuls_controller = new LPDCR_SearchResultsController();
        LPDCR_SecondaryPageFiltersController l_filters_controllers = new LPDCR_SecondaryPageFiltersController();
        l_search_resuls_controller.setComponentControllerMap( 'filtersComponent', l_filters_controllers );
        
        LPDCR_SearchResultsListController l_controller = new LPDCR_SearchResultsListController();
        l_controller.pageController = l_search_resuls_controller;
        l_controller.search_term = 'horse';
        l_controller.species_filter.add( 'Horse' );
        l_controller.internalOnly = false;
        
        l_controller.search_category = LPDCR_SearchOverviewController.PROMOTIONS_SEARCH_CATEGORY;
        l_controller.doSearch();
        System.assert( l_controller.promotions != null );
        System.assert( l_controller.filtered_promotions != null );
        
        Test.stopTest();

        System.debug( 'END: LPDCR_SearchResultsListControllerTest.test_PromotionSearchResultsList()' );
    }

/******************************************************************************
 * Method to test searching the Events
 */
    static testMethod 
    void 
    test_EventsSearchResultsList() 
    {
        System.debug( 'START: LPDCR_SearchResultsListControllerTest.test_EventsSearchResultsList()' );
        
        Test.setCurrentPage( Page.LPDCR_SearchResults );
        Test.startTest();
        
        LPDCR_SearchResultsController l_search_resuls_controller = new LPDCR_SearchResultsController();
        LPDCR_SecondaryPageFiltersController l_filters_controllers = new LPDCR_SecondaryPageFiltersController();
        l_search_resuls_controller.setComponentControllerMap( 'filtersComponent', l_filters_controllers );
        
        LPDCR_SearchResultsListController l_controller = new LPDCR_SearchResultsListController();
        l_controller.pageController = l_search_resuls_controller;
        l_controller.search_term = 'horse';
        l_controller.species_filter.add( 'Horse' );
        
        l_controller.search_category = LPDCR_SearchOverviewController.EVENTS_SEARCH_CATEGORY;
        l_controller.doSearch();
        System.assert( l_controller.events != null );
        System.assert( l_controller.filtered_events != null );
        
        Test.stopTest();

        System.debug( 'END: LPDCR_SearchResultsListControllerTest.test_EventsSearchResultsList()' );
    }
    
}// /END Test Class