/******************************************************************************
 * Test class for LPDCR_SecondaryPageFiltersController.cls
 *
 *
 * @Author: Magnet 360
 * @Date: Apr 4, 2017
 * @Jira: LPDCR-2230 
 */
@isTest( SeeAllData=false )
private class 
LPDCR_SecondaryPageFiltersControllerTest 
{

/******************************************************************************
 * Setup the test data used throughout all of these test methods
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
    test_Method() 
    {
		System.debug( 'START: LPDCR_SecondaryPageFiltersControllerTest.testMethod()' );
        
        List<LPDCR_BLSpecies.PurinaBusinessLink_Species> l_species_list;

        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_SpeciesMockHttpResponseGenerator() );
        PageReference myVfPage = Page.LPDCR_SearchOverview;
        Test.setCurrentPage(myVfPage);
        LPDCR_SecondaryPageFiltersController l_controller = new LPDCR_SecondaryPageFiltersController();
        
        System.assertEquals('apex/','apex/');
        
        
        System.assert( l_controller.species_filter != null );
        
        l_species_list = l_controller.getSpeciesList();
        System.assert( l_species_list != null );
        System.assert( l_species_list.size() > 0, 'No LPDCR_BLSpecies.PurinaBusinessLink_Species records were returned from the Mock Service Callout' );
        
        l_controller.clicked_specie = 'Clicked Specie';
        l_controller.updateSpeciesFilter();
        l_controller.clicked_specie = 'Another Specie';
        l_controller.updateSpeciesFilter();
        System.assert( l_controller.species_filter.contains( 'Clicked Specie' ), 'The species was not added to the filter list' );
        l_controller.updateSpeciesFilter();
        System.assert( ! l_controller.species_filter.contains( 'Another Specie' ), 'The species was not removed from the filter list' );
        l_controller.resetFilters();
        System.assert( l_controller.species_filter.size() == 0, 'The species filter was not reset' );
       
        l_controller.clicked_file_type ='.pdf';
        l_controller.updateFileTypeFilter();
        l_controller.clicked_file_type ='.jpg';  
        l_controller.updateFileTypeFilter();
        System.assert( l_controller.file_type_filter.contains( '.pdf' ), 'The file type was not added to the filter list' );
        l_controller.updateFileTypeFilter();
        System.assert( ! l_controller.file_type_filter.contains( '.jpg' ), 'The file type was not removed from the filter list' );
        l_controller.resetFilters();
        System.assert( l_controller.file_type_filter.size() == 0, 'The file type filter was not reset' );
        
        l_controller.sort_filter ='Date DESC';
        l_controller.setSortFilter();

        l_controller.updateSalesContentFilter();
        l_controller.internalOnly = true;
        l_controller.updateSalesContentFilter();
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageFiltersControllerTest.testMethod()' );
    }
    static testMethod 
    void 
    test_Method_getMarketingFileTypes() 
    {
       
        
        LPDCR_SecondaryPageMediaToolsCtrlr l_media_tools_controller = new LPDCR_SecondaryPageMediaToolsCtrlr();        
        l_media_tools_controller.document_type = Label.LPDCR_Logo_Component_Name;
        l_media_tools_controller.species_filter = new List<String>();
        l_media_tools_controller.retrieveDocuments(); 
        
        LPDCR_SecondaryPageFiltersController l_controller = new LPDCR_SecondaryPageFiltersController();
        LPDCR_CC_MarketingPageController controller = new LPDCR_CC_MarketingPageController();        
        controller.mediaToolsController = l_media_tools_controller;
        
        PageReference marpage = Page.LPDCR_CC_MarketingPage;
        Test.setCurrentPage(marpage); 
		        
        l_controller.pageController = controller;
        l_controller.getMarketingFileTypes();
        
        LPDCR_SecondaryEventPlanningController l_event_controller = new LPDCR_SecondaryEventPlanningController();
        l_event_controller.document_type = Label.LPDCR_Local_Event_Planner;
        l_event_controller.species_filter = new List<String>();
        l_event_controller.retrieveDocuments();
        
        LPDCR_CC_VIP_Controller vipController = new LPDCR_CC_VIP_Controller();
        vipController.eventPlanningController =l_event_controller;
        PageReference vippage = Page.LPDCR_CC_VIP;
        Test.setCurrentPage(vippage);       
        l_controller.pageController = vipController;
        l_controller.getMarketingFileTypes(); 
        
        LPDCR_SecondaryVFDController  l_vfd_controller = new LPDCR_SecondaryVFDController ();
        Boolean init = l_vfd_controller.init;
        
        LPDCR_CC_BusinessManagementController  bmController = new LPDCR_CC_BusinessManagementController ();
        bmController.VFDController =l_vfd_controller;
        PageReference bmpage = Page.LPDCR_CC_Business_Management;
        Test.setCurrentPage(bmpage);       
        l_controller.pageController = bmController;
        l_controller.getMarketingFileTypes();
        
        LPDCR_SecondaryPracAndPoliciesCntlr   l_prac_controller = new LPDCR_SecondaryPracAndPoliciesCntlr();
        Boolean initt = l_prac_controller.init;
        
        LPDCR_CC_BusinessManagementController  bmpController = new LPDCR_CC_BusinessManagementController ();
        bmpController.PracController =l_prac_controller;
        PageReference bmppage = Page.LPDCR_CC_Business_Management;
        Test.setCurrentPage(bmppage);       
        l_controller.pageController = bmpController;
        l_controller.getMarketingFileTypes();
            
        
        
    }
    
    
    
}// /END Test Class