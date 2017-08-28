/**
*   @Author:    Shruti Mishra
*   @Date:      05.05.2017
*   @Jira:      LPDCR-2482
*   @Purpose:   Test class for LPDCR_SecondaryPageSalesSheetsController.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecondaryPageSalesSheetsCntrlrTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryPageSalesSheetsCntrlrTest.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageSalesSheetsController controller = new LPDCR_SecondaryPageSalesSheetsController();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageSalesSheetsCntrlrTest.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getSalesSheetsList()
 */
    static testMethod void test_getSalesSheetsList() 
    {
        System.debug( 'START: LPDCR_SecondaryPageSalesSheetsCntrlrTest.test_getSalesSheetsList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageSalesSheetsController controller = new LPDCR_SecondaryPageSalesSheetsController();
        controller.search_term = 'Sales';
        controller.sort_filter = 'Name DESC';
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageSalesSheetsCntrlrTest.test_getSalesSheetsList()' );
    }

    
}// /END Test Class