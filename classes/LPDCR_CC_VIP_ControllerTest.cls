/******************************************************************************
 * Test class for LPDCR_CC_VIP_Controller.cls
 *
 * @Author: Magnet 360
 * @Date: Apr 24, 2017
 * @Jira: LPDCR-2397
 */
@isTest( SeeAllData=false )
private class 
LPDCR_CC_VIP_ControllerTest 
{

/******************************************************************************
 * Method to test the constructor 
 */
    static testMethod 
    void 
    test_Constructor() 
    {
        System.debug( 'START: LPDCR_CC_VIP_ControllerTest.test_Constructor()' );

        Test.startTest();
        PageReference l_test_page = Page.LPDCR_CC_VIP;
        Test.setCurrentPage( l_test_page );
        LPDCR_CC_VIP_Controller l_controller = new LPDCR_CC_VIP_Controller();
        LPDCR_SecondaryPageFiltersController l_filters_controller;
        l_filters_controller = l_controller.filterController; 
        l_controller.setComponentControllerMap( 'filtersComponent', new LPDCR_SecondaryPageFiltersController() );
        l_filters_controller = l_controller.filterController;
        l_controller.setComponentControllerMap( 'vipEventsComponent', new LPDCR_SecondaryVIPFarmController () );
        l_controller.setComponentControllerMap( 'nationalEventsComponent', new  LPDCR_SecondaryNationalEventsController() );
        l_controller.setComponentControllerMap( 'localEventsComponent', new LPDCR_CC_VIPEventsController() );
        l_controller.setComponentControllerMap('eventPlanningController', new LPDCR_SecondaryEventPlanningController());
        System.assert( l_controller.page_title == Label.LPDCR_Farm_VIP_Subtab_Name, 'Default page title not set correctly' );
        
        System.assert( l_controller.filterController != null, 'Filter component controller not set correctly' );
        System.assert( l_controller.vipEventsController != null, 'Farm VIP component controller not set correctly' );
        System.assert( l_controller.nationalEventsController != null, 'National Events component controller not set correctly' );
        System.assert( l_controller.localEventsController != null, 'Local Events component controller not set correctly' );
        
        System.assert( l_controller.getSpecieList() != null, 'Species were not retrieved correctly');
        
        l_controller.selected_title = 'LocalEvents';
        l_controller.setPageTitle();
        System.assert( l_controller.page_title == Label.LPDCR_Local_Events_Subtab_Name, 'Local Events page title not set correctly' );
        
        l_controller.selected_title = 'PlanningResources';
        l_controller.setPageTitle();
        System.assert( l_controller.page_title == Label.LPDCR_Planning_Resources_Subtab_Name, 'Planning Resources page title not set correctly' );
        
        l_controller.selected_title = 'FarmVIP';
        l_controller.setPageTitle();
        System.assert( l_controller.page_title == Label.LPDCR_Farm_VIP_Subtab_Name, 'Farm VIP page title not set correctly' );
        
        l_controller.selected_title = 'Test';
        l_controller.setPageTitle();
        System.assert( l_controller.page_title == Label.LPDCR_Farm_VIP_Subtab_Name, 'Default page title not set correctly' );
        
        l_controller.search_term = 'Search Term';
        l_controller.doSearch();
        
        l_controller.getSortBy();
        l_controller.getFileTypeFilter();
        
        
        
        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_VIP_ControllerTest.test_Constructor()' );
    }
/******************************************************************************
 * Test setting and getting the Species Component controller, and calling the
 * getSpecieList() method
 */
    static testMethod 
    void 
    test_getSpecieList() 
    {
        System.debug( 'START: LPDCR_CC_VIP_ControllerTest.test_getSpecieList()' );
        
        List<String> l_specie_list;
        LPDCR_SecondaryPageFiltersController l_filters_controller;
        Test.startTest();
        PageReference l_test_page = Page.LPDCR_CC_VIP;
        Test.setCurrentPage( l_test_page );
        LPDCR_CC_VIP_Controller l_controller = new LPDCR_CC_VIP_Controller();
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
        
        System.debug( 'END: LPDCR_CC_VIP_ControllerTest.test_getSpecieList()' );
    }
/******************************************************************************
 * Method to test the constructor with a subtab URL parameter passed in
 */
    static testMethod 
    void 
    test_ConstructorWithQueryParam() 
    {
        System.debug( 'START: LPDCR_CC_VIP_ControllerTest.test_ConstructorWithQueryParam()' );
        
        PageReference l_test_page = Page.LPDCR_CC_VIP;
        Test.setCurrentPage( l_test_page );
        ApexPages.currentPage().getParameters().put( 'subtab', 'NationalEvents' );
        
        Test.startTest();

        LPDCR_CC_VIP_Controller l_controller = new LPDCR_CC_VIP_Controller();
        System.assert( l_controller.page_title == Label.LPDCR_National_Events_Subtab_Name, 'National Events page title was not set correctly' );
        
        System.assert( l_controller.filterController != null, 'Filter component controller not set correctly' );
        System.assert( l_controller.vipEventsController != null, 'Farm VIP component controller not set correctly' );
        System.assert( l_controller.nationalEventsController != null, 'National Events component controller not set correctly' );
        System.assert( l_controller.localEventsController != null, 'Local Events component controller not set correctly' );
        System.assert( l_controller.eventPlanningController!= null, ' Event Plans component controller not set correctly' );
        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_VIP_ControllerTest.test_ConstructorWithQueryParam()' );
    }
    
}// /END Test Class