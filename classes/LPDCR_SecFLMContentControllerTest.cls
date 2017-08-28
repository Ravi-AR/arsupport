/**
*   @Author:    Shruti Mishra
*   @Date:      24.05.2017
*   @Jira:      LPDCR-2885
*   @Purpose:   Test class for LPDCR_SecFLMContentController.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecFLMContentControllerTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecFLMContentControllerTest.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecFLMContentController controller = new LPDCR_SecFLMContentController();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecFLMContentControllerTest.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getflmContentList()
 */
    static testMethod void test_getflmContentList() 
    {
        System.debug( 'START: LPDCR_SecFLMContentControllerTest.test_getflmContentList()' );
        
        Test.startTest();
        
        LPDCR_SecFLMContentController controller = new LPDCR_SecFLMContentController();
        controller.search_term = 'Sales';
        controller.sort_filter = 'Name DESC';
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecFLMContentControllerTest.test_getflmContentList()' );
    }

    
}// /END Test Class