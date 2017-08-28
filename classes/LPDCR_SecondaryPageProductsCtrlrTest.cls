/**
*   @Author:    Shruti Mishra
*   @Date:      12.05.2017
*   @Jira:      LPDCR-2482
*   @Purpose:   Test Class behind LPDCR_SecondaryPageProductsController
*
*/
@isTest( SeeAllData=false )
private class LPDCR_SecondaryPageProductsCtrlrTest {

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
 * Method to test the class constructor
 */

 static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryPageProductsCtrlrTest.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageProductsController controller = new LPDCR_SecondaryPageProductsController();
        System.assert( controller != null );
        controller.search_term = 'Search Term';
        controller.sort_filter = 'Name ASC';
        
        //Boolean init = controller.init;
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageProductsCtrlrTest.test_Constructor()' );
    }
    
  /*******************************************************************************
 * Method to test getTrainingData()
 */
    static testMethod void test_getProductList() 
    {
        System.debug( 'START: LPDCR_SecondaryPageProductsCtrlrTest.test_getProductList()' );
        
        Test.startTest();
		// Create Data
		ccrz__E_Product__c productObj = new ccrz__E_Product__c(Name = 'TestProd1', ccrz__SKU__c='111', ccrz__ProductId__c = '1234', ccrz__ShortDesc__c='Short Desc', ccrz__LongDesc__c='Long Desciption', ccrz__StartDate__c = Date.Today()-2,
                                                ccrz__EndDate__c = Date.Today()+2, ccrz__Storefront__c = 'PurinaMills');
        insert productObj;
        ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
        insert spec;
        ccrz__E_ProductSpec__c productSpec = new ccrz__E_ProductSpec__c(ccrz__Spec__c = spec.Id, ccrz__Product__c=productObj.Id, ccrz__SpecValue__c='Cattle');
        insert productSpec;
        
        LPDCR_SecondaryPageProductsController controller = new LPDCR_SecondaryPageProductsController();
        //Assigning selected ProductId to Page variable 'more'
        Apexpages.currentPage().getParameters().put('more',productObj.Id);
        
        //Adding demo species
        List<String> speciesLst = new List<String>();
        speciesLst.add('Cattle');
        speciesLst.add('Dairy - Young Animal');
        controller.species_filter = speciesLst;
        //controller.selectedProductId = productObj.Id;
        
        // Getting Product List
        //Set<ccrz__E_Product__c> productLst = controller.getProductList();
        
        //Getting Product
        controller.getProducts();
        //controller.hasNext();
        //controller.hasPrevious();
        controller.first();
        controller.last();
        controller.previous();
        controller.next();
        controller.searchReset();
        
        controller.products_per_page = null;
        Integer products_per_page = controller.products_per_page;
        controller.products_per_page = 101;
        Integer productsCount = controller.products_per_page;
        
        controller.total_products = 10;
        controller.end_product_number = 12;
        Boolean next = controller.hasNext;
        
        controller.current_page_number = 10;
        Boolean previous = controller.hasPrevious;
        Integer pageNum = controller.pageNumber;
        //Checking null filter
        //LPDCR_SecondaryPageProductsController.filterProducts( null );
        
        controller.search_term = 'Cattle';
        speciesLst.add('Dairy - Young Animal');
        controller.getProducts();
        controller.sort_filter = 'Date ASC';
        controller.getProducts();
        controller.sort_filter = 'Name DESC';
        controller.getProducts();
        controller.sort_filter = '' ;
        controller.getProducts();
        
        System.assert( controller != null );

        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageProductsCtrlrTest.test_getProductList()' );
    }
}