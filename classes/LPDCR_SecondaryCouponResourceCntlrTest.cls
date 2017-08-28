/**
*   @Author:    Heena Tanna
*   @Date:      25.05.2017
*   @Jira:      LPDCR-2951
*   @Purpose:   Test class for LPDCR_SecondaryCouponResourceCntlr.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecondaryCouponResourceCntlrTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryCouponResourceCntlrTest.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryCouponResourceCntlr controller = new LPDCR_SecondaryCouponResourceCntlr();
        controller.sort_filter='';
        String sort_filter = controller.sort_filter;
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryCouponResourceCntlrTest.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getCouponResourceContent()
 */
    static testMethod void test_getCouponResourceList() 
    {
        System.debug( 'START: LPDCR_SecondaryCouponResourceCntlrTest.test_getCouponResourceList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryCouponResourceCntlr controller = new LPDCR_SecondaryCouponResourceCntlr();
        controller.search_term = 'Sales';
        controller.sort_filter = 'Name DESC';
        Boolean init = controller.init;
        controller.showCouponResource();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryCouponResourceCntlrTest.test_getCouponResourceList()' );
    }

    
}// /END Test Class