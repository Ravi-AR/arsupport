/******************************************************************************
 * Test class for LPDCR_CC_MarketingPageController.cls 
 *
 * @Author: Magnet 360
 * @Date: Apr 4, 2017
 * @Jira: LPDCR-2230
 */
@isTest( SeeAllData=false )
private class 
LPDCR_CC_MarketingPageControllerTest 
{

/******************************************************************************
 * Method to test the constructor and doSearch() methods
 */
    static testMethod 
    void 
    test_Constructor() 
    {
		System.debug( 'START: LPDCR_CC_MarketingPageControllerTest.test_Constructor()' );

        Test.startTest();
        
        LPDCR_CC_MarketingPageController l_controller = new LPDCR_CC_MarketingPageController();
        System.assert( l_controller != null );
        
                                                 // Test the doSearch() method
        l_controller.search_term = 'Search Term';
        l_controller.doSearch();

        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_MarketingPageControllerTest.test_Constructor()' );
    }

/******************************************************************************
 * Test setting and getting the Species Component controller, and calling the
 * getSpecieList() method
 */
    static testMethod 
    void 
    test_getSpecieList() 
    {
        System.debug( 'START: LPDCR_CC_MarketingPageControllerTest.test_getSpecieList()' );
        
        List<String> l_specie_list;
        LPDCR_SecondaryPageFiltersController l_filters_controller;
        Test.startTest();
        
        LPDCR_CC_MarketingPageController l_controller = new LPDCR_CC_MarketingPageController();
        System.assert( l_controller != null );
            
                                                 // Test returning a value when
                                                 // none is found
        l_filters_controller = l_controller.filterController;                                         
                                                 // Test setting & getting the
                                                 // filter component controller
        l_controller.setComponentControllerMap( 'filtersComponent',  new LPDCR_SecondaryPageFiltersController() );
        l_filters_controller = l_controller.filterController;
        System.assert( l_filters_controller != null );
        
        l_specie_list = l_controller.getSpecieList();
        System.assert( l_specie_list != null );
        
        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_MarketingPageControllerTest.test_getSpecieList()' );
    }

/******************************************************************************
 * Test setting and getting each of the component controllers
 */
    static testMethod 
    void 
    test_ComponentControllerMethods() 
    {
        System.debug( 'START: LPDCR_CC_MarketingPageControllerTest.test_ComponentControllerMethods()' );
        
        List<String> l_specie_list;
        LPDCR_SecondaryPagePromotionsController l_promotions_controller;
        LPDCR_SecondaryPageMerchandisingCtrlr   l_merchandising_controller;
        LPDCR_SecondaryPageMediaToolsCtrlr      l_media_tools_controller;
        
        Test.startTest();
        
        LPDCR_CC_MarketingPageController l_controller = new LPDCR_CC_MarketingPageController();
        System.assert( l_controller != null );
        
                                                 // Test returning a value when
                                                 // none is found
        l_promotions_controller = l_controller.promotionsController;
        l_merchandising_controller = l_controller.merchandisingController;
        l_media_tools_controller = l_controller.mediaToolsController;
                                                 // Test setting & getting the
                                                 // filter component controller
        l_controller.setComponentControllerMap( 'promotionsComponent',  new LPDCR_SecondaryPagePromotionsController() );
        l_controller.setComponentControllerMap( 'merchandisingComponent',  new LPDCR_SecondaryPageMerchandisingCtrlr() );
        l_controller.setComponentControllerMap( 'mediaToolsComponent',  new LPDCR_SecondaryPageMediaToolsCtrlr() );
        
        l_promotions_controller = l_controller.promotionsController;
        System.assert( l_promotions_controller != null );
    
        l_merchandising_controller = l_controller.merchandisingController;
        System.assert( l_merchandising_controller != null );
        
        l_media_tools_controller = l_controller.mediaToolsController;
        System.assert( l_media_tools_controller != null );
        
        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_MarketingPageControllerTest.test_ComponentControllerMethods()' );
    }

}// /END Test Class