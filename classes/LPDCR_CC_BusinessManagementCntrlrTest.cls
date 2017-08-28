/**
*   @Author:    Shruti Mishra
*   @Date:      24.05.2017
*   @Jira:      LPDCR-2885
*   @Purpose:   Test class for LPDCR_CC_BusinessManagementController.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_CC_BusinessManagementCntrlrTest {
    
/******************************************************************************
 * Method to test the constructor and doSearch() methods
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_CC_BusinessManagementCntrlrTest.test_Constructor()' );

        Test.startTest();
        
        LPDCR_CC_BusinessManagementController l_controller = new LPDCR_CC_BusinessManagementController();
        System.assert( l_controller != null );
        
        l_controller.search_term = 'Search Term';
        l_controller.doSearch();

        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_BusinessManagementCntrlrTest.test_Constructor()' );
    }

/******************************************************************************
 * Test setting and getting the Species Component controller, and calling the
 * getSpecieList() method
 */
    static testMethod void test_getSpecieList() 
    {
        System.debug( 'START: LPDCR_CC_BusinessManagementCntrlrTest.test_getSpecieList()' );
        
        List<String> l_specie_list;
        LPDCR_SecondaryPageFiltersController l_filters_controller;
        Test.startTest();        
        
        PageReference pageRef = Page.LPDCR_CC_Business_Management;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put( 'subtab', 'BusinessManagement' );
        
        LPDCR_CC_BusinessManagementController l_controller = new LPDCR_CC_BusinessManagementController();
        System.assert( l_controller != null );
            
        l_filters_controller = l_controller.filterController;                                         
        l_controller.setComponentControllerMap( 'filtersComponent',  new LPDCR_SecondaryPageFiltersController() );
        l_filters_controller = l_controller.filterController;
        System.assert( l_filters_controller != null );
        
        l_specie_list = l_controller.getSpecieList();
        String l_sortBy = l_controller.getSortBy();
        Boolean internalUserOnly = l_controller.getInternalUserCheck();
        System.assert( l_specie_list != null );
        
        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_BusinessManagementCntrlrTest.test_getSpecieList()' );
    }

/******************************************************************************
 * Test setting and getting each of the component controllers
 */
    static testMethod void test_ComponentControllerMethods() 
    {
        System.debug( 'START: LPDCR_CC_BusinessManagementCntrlrTest.test_ComponentControllerMethods()' );
        
        List<String> l_specie_list;
        LPDCR_SecFLMContentController l_flm_controller;
        LPDCR_SecondaryBusinessManagementCntlr l_businessMgt_controller;
        LPDCR_SecondaryReportController l_report_controller;
        LPDCR_SecondaryVFDController l_VFD_controller;
        LPDCR_SecondaryCouponResourceCntlr l_couponResource_controller;
        LPDCR_SecondaryFeedSafetyCntlr l_feedSafety_controller;
        LPDCR_SecondaryPracAndPoliciesCntlr l_prac_controller;
        LPDCR_SecondarySalesResourcesCntlr l_sales_controller;
        
        Test.startTest();        
        
        LPDCR_CC_BusinessManagementController l_controller = new LPDCR_CC_BusinessManagementController();
        System.assert( l_controller != null );
        
        LPDCR_SecondaryPageBaseController baseController = new LPDCR_SecondaryPageBaseController();
        baseController.isFLMAccount = True;
        
        l_flm_controller = l_controller.flmContentController;
        l_businessMgt_controller = l_controller.businessMgtController;
        l_report_controller = l_controller.reportController;
        l_VFD_controller= l_controller.VFDController;
        l_couponResource_controller = l_controller.couponResourceController;
        l_feedSafety_controller = l_controller.FeedSafetyController;
        l_prac_controller = l_controller.PracController;
        l_sales_controller = l_controller.SalesController;
        
        l_controller.setComponentControllerMap( 'flmComponent',  new LPDCR_SecFLMContentController() );
        l_controller.setComponentControllerMap( 'businessMgtComponent',  new LPDCR_SecondaryBusinessManagementCntlr() );
        l_controller.setComponentControllerMap( 'reportComponent',  new LPDCR_SecondaryReportController() );
        l_controller.setComponentControllerMap( 'vfdComponent',  new LPDCR_SecondaryVFDController() );
        l_controller.setComponentControllerMap( 'couponResourceComponent',  new LPDCR_SecondaryCouponResourceCntlr() );
        l_controller.setComponentControllerMap( 'feedComponent',  new LPDCR_SecondaryFeedSafetyCntlr() );
        l_controller.setComponentControllerMap( 'pracComponent',  new LPDCR_SecondaryPracAndPoliciesCntlr() );
        l_controller.setComponentControllerMap( 'salesComponent',  new LPDCR_SecondarySalesResourcesCntlr() );
        
        //ApexPages.currentPage().getParameters().put( 'subtab' );
        
        l_flm_controller = l_controller.flmContentController;
        System.assert( l_flm_controller != null );
        l_businessMgt_controller = l_controller.businessMgtController;
        System.assert( l_businessMgt_controller != null );
        l_report_controller = l_controller.reportController;
        System.assert( l_report_controller != null );
        l_VFD_controller = l_controller.VFDController;
        System.assert( l_VFD_controller!= null );
        l_couponResource_controller = l_controller.couponResourceController;
        System.assert( l_couponResource_controller != null );
        l_feedSafety_controller = l_controller.FeedSafetyController;
        System.assert( l_feedSafety_controller != null );
        l_prac_controller = l_controller.PracController;
        System.assert( l_prac_controller != null );
        l_sales_controller = l_controller.SalesController;
        System.assert( l_sales_controller != null );
        
        
        l_controller.selected_title = 'BusinessManagement' ;
        l_controller.setPageTitle();
        l_controller.selected_title = 'Reports';
        l_controller.setPageTitle();
        l_controller.selected_title = 'FeedLicenseManufacturer'; 
        l_controller.setPageTitle();
        l_controller.selected_title = '';
        l_controller.setPageTitle();
        l_controller.selected_title = 'Practices And Policies';
        l_controller.setPageTitle();
        l_controller.selected_title = 'Veterinary Feed Directive';
        l_controller.setPageTitle();
        l_controller.selected_title = 'Feed Safety';
        l_controller.setPageTitle();
        l_controller.selected_title = 'Sales Resources';
        l_controller.setPageTitle();
        //l_controller.getFileTypeFilter();
        
        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_BusinessManagementCntrlrTest.test_ComponentControllerMethods()' );
    }
    
}// /END Test Class