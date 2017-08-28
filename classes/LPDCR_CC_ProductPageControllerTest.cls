/**
*   @Author:    Shruti Mishra
*   @Date:      05.05.2017
*   @Jira:      LPDCR-2482
*   @Purpose:   Test class for LPDCR_CC_ProductPageController.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_CC_ProductPageControllerTest {
    
/******************************************************************************
 * Method to test the constructor and doSearch() methods
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_CC_ProductPageControllerTest.test_Constructor()' );

        Test.startTest();
        PageReference pageRef = Page.LPDCR_CC_ProductPage;
        Test.setCurrentPage(pageRef);
        LPDCR_CC_ProductPageController l_controller = new LPDCR_CC_ProductPageController();
        System.assert( l_controller != null );
        
        l_controller.search_term = 'Search Term';
        l_controller.doSearch();

        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_ProductPageControllerTest.test_Constructor()' );
    }

/******************************************************************************
 * Test setting and getting the Species Component controller, and calling the
 * getSpecieList() method
 */
    static testMethod void test_getSpecieList() 
    {
        System.debug( 'START: LPDCR_CC_ProductPageControllerTest.test_getSpecieList()' );
        
        List<String> l_specie_list;
        LPDCR_SecondaryPageFiltersController l_filters_controller;
        Test.startTest();
        PageReference pageRef = Page.LPDCR_CC_ProductPage;
        Test.setCurrentPage(pageRef);
        LPDCR_CC_ProductPageController l_controller = new LPDCR_CC_ProductPageController();
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
        
        System.debug( 'END: LPDCR_CC_ProductPageControllerTest.test_getSpecieList()' );
    }

/******************************************************************************
 * Test setting and getting each of the component controllers
 */
    static testMethod void test_ComponentControllerMethods() 
    {
        System.debug( 'START: LPDCR_CC_ProductPageControllerTest.test_ComponentControllerMethods()' );
        
        List<String> l_specie_list;
        LPDCR_SecondaryPageProductsController l_products_controller;
        //LPDCR_SecondaryPageFeedManualsController l_feedManual_controller;
        LPDCR_SecondaryPageSalesSheetsController l_salesSheets_controller;
        LPDCR_SecTechBulletinController l_techBulletin_controller;
        LPDCR_SecondaryPagePromotionsController l_promotions_controller;
        LPDCR_SecondarySalesToolController l_salesTools_controller;
        
        Test.startTest();
        PageReference pageRef = Page.LPDCR_CC_ProductPage;
        Test.setCurrentPage(pageRef);
        LPDCR_CC_ProductPageController l_controller = new LPDCR_CC_ProductPageController();
        System.assert( l_controller != null );
        
        l_products_controller = l_controller.productController;
        //l_feedManual_controller = l_controller.feedManualController;
        l_salesSheets_controller = l_controller.salesSheetsController;
        l_techBulletin_controller = l_controller.techBulletinController;
        l_promotions_controller = l_controller.promotionsController;
        l_salesTools_controller = l_controller.salesToolsController;
        
        l_controller.setComponentControllerMap( 'productComponent',  new LPDCR_SecondaryPageProductsController() );
        //l_controller.setComponentControllerMap( 'feedManualComponent',  new LPDCR_SecondaryPageFeedManualsController() );
        l_controller.setComponentControllerMap( 'sellSheetComponent',  new LPDCR_SecondaryPageSalesSheetsController() );
        l_controller.setComponentControllerMap( 'techBulletinComponent',  new LPDCR_SecTechBulletinController() );
        l_controller.setComponentControllerMap( 'promotionsComponent',  new LPDCR_SecondaryPagePromotionsController() );
        l_controller.setComponentControllerMap( 'salesToolsComponent',  new LPDCR_SecondarySalesToolController() );
        
        //ApexPages.currentPage().getParameters().put( 'subtab' );
        
        l_products_controller = l_controller.productController;
        System.assert( l_products_controller != null );
        //l_feedManual_controller = l_controller.feedManualController;
        //System.assert( l_feedManual_controller != null );
        l_salesSheets_controller = l_controller.salesSheetsController;
        System.assert( l_salesSheets_controller != null );
        l_techBulletin_controller = l_controller.techBulletinController;
        System.assert( l_techBulletin_controller != null );
        l_promotions_controller = l_controller.promotionsController;
        System.assert( l_promotions_controller != null );
        l_salesTools_controller = l_controller.salesToolsController;
        System.assert( l_salesTools_controller != null );
        
        l_controller.selected_title = 'FeedManual' ;
        l_controller.setPageTitle();
        l_controller.selected_title = 'SalesSheets';
        l_controller.setPageTitle();
        l_controller.selected_title = 'TechBulletins'; 
        l_controller.setPageTitle();
        l_controller.selected_title = 'Promotions';
        l_controller.setPageTitle();
        l_controller.selected_title = 'ProductSales';
        l_controller.setPageTitle();
        l_controller.selected_title = 'ProductP';
        l_controller.setPageTitle();
        
        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_ProductPageControllerTest.test_ComponentControllerMethods()' );
    }
    
}// /END Test Class