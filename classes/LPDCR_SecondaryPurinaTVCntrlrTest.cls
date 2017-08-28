/**
*   @Author:    Shruti Mishra
*   @Date:      04.05.2017
*   @Jira:      LPDCR-2349
*   @Purpose:   Test class for LPDCR_SecondaryPurinaTVCntrlr.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecondaryPurinaTVCntrlrTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryPurinaTVCntrlr.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPurinaTVCntrlr controller = new LPDCR_SecondaryPurinaTVCntrlr();
        System.assert( controller != null );
        
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPurinaTVCntrlr.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getPurinaTVContent()
 */
    static testMethod void test_getPurinaTVContent() 
    {
        System.debug( 'START: LPDCR_SecondaryPurinaTVCntrlr.test_getPurinaTVContent()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPurinaTVCntrlr controller = new LPDCR_SecondaryPurinaTVCntrlr();
        controller.sort_filter = 'Name DESC';
        Boolean init = controller.init;
        
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPurinaTVCntrlr.test_getPurinaTVContent()' );
    }

    
}// /END Test Class