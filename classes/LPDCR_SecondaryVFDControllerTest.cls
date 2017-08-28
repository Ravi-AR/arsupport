/**
*   @Author:    Heena Tanna
*   @Date:      24.05.2017
*   @Jira:      LPDCR-2806
*   @Purpose:   Test class for LPDCR_SecondaryVFDController.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecondaryVFDControllerTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryVFDController.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryVFDController controller = new LPDCR_SecondaryVFDController();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryVFDController.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getVFDContent()
 */
    static testMethod void test_getvfdContentList() 
    {
        System.debug( 'START: LPDCR_SecondaryVFDController.test_getvfdContentList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryVFDController controller = new LPDCR_SecondaryVFDController();
        controller.search_term = 'Sales';
        controller.sort_filter = 'Name DESC';
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryVFDController.test_getvfdContentList()' );
    }

    
}// /END Test Class