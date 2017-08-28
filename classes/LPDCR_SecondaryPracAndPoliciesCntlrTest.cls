/**
*   @Author:    Heena Tanna
*   @Date:      24.05.2017
*   @Jira:      LPDCR-2399
*   @Purpose:   Test class for LPDCR_SecondaryPracAndPoliciesCntlr.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecondaryPracAndPoliciesCntlrTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryPracAndPoliciesCntlr.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPracAndPoliciesCntlr controller = new LPDCR_SecondaryPracAndPoliciesCntlr();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPracAndPoliciesCntlr.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getPracandpolicyContent()
 */
    static testMethod void test_getPracAndPoliciesList() 
    {
        System.debug( 'START: LPDCR_SecondaryPracAndPoliciesCntlr.test_getPracAndPoliciesList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPracAndPoliciesCntlr controller = new LPDCR_SecondaryPracAndPoliciesCntlr();
        controller.search_term = 'Sales';
        controller.sort_filter = 'Name DESC';
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPracAndPoliciesCntlr.test_getPracAndPoliciesList()' );
    }

    
}// /END Test Class