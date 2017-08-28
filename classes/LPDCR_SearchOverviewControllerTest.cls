/******************************************************************************
 * Test class for the LPDCR_SearchOverviewController class
 *
 * @Author: Magnet 360
 * @Date: May 23, 2017
 * @Jira: LPDCR-1992
 */
@isTest( SeeAllData=false )
private class 
LPDCR_SearchOverviewControllerTest 
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
 * Method to test the page constructor and page direct methods
 */
    static testMethod 
    void 
    test_SearchOverview() 
    {
		System.debug( 'START: LPDCR_SearchOverviewControllerTest.test_SearchOverview()' );

        LPDCR_SearchOverviewController l_controller;
        PageReference l_event_page;
        PageReference l_promotion_page;
        PageReference l_video_page;
        PageReference l_image_page;
        PageReference l_document_page;
        PageReference l_sales_resource_page;
        // PageReference l_feed_manuals_page;
        
        Test.setCurrentPage( Page.LPDCR_SearchOverview );
        Test.startTest();
        Test.setMock( HttpCalloutMock.class, new LPDCR_DocumentSearchMockHTTPResponse() );
        ApexPages.currentPage().getParameters().put( 'term', 'horse' );
        
        l_controller = new LPDCR_SearchOverviewController();
        System.assert( l_controller.term == 'horse', 'Search term was not set correctly for the LPDCR_SearchOverview page.' );
        System.assert( l_controller.events == null );
        l_controller.searchEvents();
        System.assert( l_controller.events != null );
        
        l_controller.searchContent();
        System.assert( l_controller.document_results != null );
        System.assert( l_controller.promotion_results != null );
        System.assert( l_controller.sales_resources != null );
        System.assert( l_controller.documents != null );
        System.assert( l_controller.images != null );
        System.assert( l_controller.videos != null );
        System.assert( l_controller.promotions != null );
        // System.assert( l_controller.feed_manuals != null );
        
        l_event_page = l_controller.goToEventSearchResults();
        l_promotion_page = l_controller.goToPromotionSearchResults();
        l_video_page = l_controller.goToVideosSearchResults();
        l_image_page = l_controller.goToImageSearchResults();
        l_document_page = l_controller.goToDocumentSearchResults();
        l_sales_resource_page = l_controller.goToSalesResourceSearchResults();
        // l_feed_manuals_page = l_controller.goToFeedManualSearchResults();
        
        System.assert( l_event_page != null, 'goToEventSearchResults() did not direct the user properly.' );
        System.assert( l_promotion_page != null, 'goToPromotionSearchResults() did not direct the user properly.' );
        System.assert( l_video_page != null, 'goToVideosSearchResults() did not direct the user properly.' );
        System.assert( l_image_page != null, 'goToImageSearchResults() did not direct the user properly.' );
        System.assert( l_document_page != null, 'goToDocumentSearchResults() did not direct the user properly.' );
        System.assert( l_sales_resource_page != null, 'goToSalesResourceSearchResults() did not direct the user properly.' );
        // System.assert( l_feed_manuals_page != null, 'goToFeedManualSearchResults() did not direct the user properly.' );

        Test.stopTest();
        
        System.debug( 'END: LPDCR_SearchOverviewControllerTest.test_SearchOverview()' );
    }
    
}// /END Test Class