/******************************************************************************
 * Test class for the LPDCR_SearchOverviewController class
 *
 * @Author: Magnet 360
 * @Date: May 31, 2017
 * @Jira: LPDCR-1992
 */
@isTest( SeeAllData=false )
private class 
LPDCR_SearchResultsControllerTest 
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
 * Method to test 
 */
    static testMethod 
    void 
    test_SearchResults() 
    {
        System.debug( 'START: LPDCR_SearchResultsControllerTest.test_SearchResults()' );

        LPDCR_SearchResultsController l_controller;
        
        Test.setCurrentPage( Page.LPDCR_SearchResults );
        Test.startTest();
        Test.setMock( HttpCalloutMock.class, new LPDCR_DocumentSearchMockHTTPResponse() );
        l_controller = new LPDCR_SearchResultsController();
        System.assert( l_controller.validate() != null, 'User was not redirected to global search' );
        
        ApexPages.currentPage().getParameters().put( 'term', 'horse' );
        System.assert( l_controller.validate() == null, 'LPDCR_SearchResultsController page parameters were not validated correctly' );
        
        l_controller.setComponentControllerMap( 'filtersComponent', new LPDCR_SecondaryPageFiltersController() );
        l_controller.setComponentControllerMap( 'resultsListComponent', new LPDCR_SearchResultsListController() );
        
        System.assert( l_controller.resultsListController != null, 'resultsListController component controller was not set or referenced correctly');
        
        Set<String> l_species_filter = l_controller.species_filter;
        Set<String> l_file_filter = l_controller.file_type_filter;

        Test.stopTest();

        System.debug( 'END: LPDCR_SearchResultsControllerTest.test_SearchResults()' );
    }
    
}// /END Test Class