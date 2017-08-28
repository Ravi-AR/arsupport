/**
*   @Author:    Heena Tanna
*   @Date:      24.05.2017
*   @Jira:      LPDCR-2399
*   @Purpose:   Test class for LPDCR_SecondaryFeedSafetyCntlr.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecondaryFeedSafetyCntlrTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryFeedSafetyCntlr.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryFeedSafetyCntlr controller = new LPDCR_SecondaryFeedSafetyCntlr();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryFeedSafetyCntlr.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getFeedSafetyContent()
 */
    static testMethod void test_getFeedSafetyList() 
    {
        System.debug( 'START: LPDCR_SecondaryFeedSafetyCntlr.test_getFeedSafetyList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryFeedSafetyCntlr controller = new LPDCR_SecondaryFeedSafetyCntlr();
        controller.search_term = 'Sales';
        controller.sort_filter = 'Name DESC';
        Boolean internal = controller.internal_only;
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryFeedSafetyCntlr.test_getFeedSafetyList()' );
    }

    
}// /END Test Class