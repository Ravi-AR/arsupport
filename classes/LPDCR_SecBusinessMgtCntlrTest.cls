/**
*   @Author:    Shruti Mishra
*   @Date:      01.06.2017
*   @Jira:      LPDCR-
*   @Purpose:   Test class for LPDCR_SecondaryBusinessManagementCntlr.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecBusinessMgtCntlrTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecBusinessMgtCntlrTest.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryBusinessManagementCntlr controller = new LPDCR_SecondaryBusinessManagementCntlr();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecBusinessMgtCntlrTest.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getWaffleResourceList()
 */
    static testMethod void test_getWaffleResourceList() 
    {
        System.debug( 'START: LPDCR_SecBusinessMgtCntlrTest.test_getWaffleResourceList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryBusinessManagementCntlr controller = new LPDCR_SecondaryBusinessManagementCntlr();
        //controller.search_term = 'Sales';
        //controller.sort_filter = 'Name DESC';
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecBusinessMgtCntlrTest.test_getWaffleResourceList()' );
    }

    
}// /END Test Class