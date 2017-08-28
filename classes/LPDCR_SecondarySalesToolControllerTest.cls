/**
*   @Author:    Shruti Mishra
*   @Date:      05.05.2017
*   @Jira:      LPDCR-2482
*   @Purpose:   Test class for LPDCR_SecondarySalesToolController.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecondarySalesToolControllerTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondarySalesToolController.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondarySalesToolController controller = new LPDCR_SecondarySalesToolController();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondarySalesToolController.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getSalesToolList()
 */
    static testMethod void test_getSalesToolList() 
    {
        System.debug( 'START: LPDCR_SecondarySalesToolController.test_getSalesToolList()' );
        
        Test.startTest();
        
        LPDCR_SecondarySalesToolController controller = new LPDCR_SecondarySalesToolController();
        controller.search_term = 'Sales';
        controller.sort_filter = 'Name DESC';
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondarySalesToolController.test_getSalesToolList()' );
    }

    
}// /END Test Class