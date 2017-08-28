/**
*   @Author:    Heena Tanna
*   @Date:      19.04.2017
*   @Jira:      LPDCR-2345
*   @Purpose:   Test class for LPDCR_SecondaryPurinaUniversityCntrlr.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecondaryPurinaUniversityCtrlTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryPurinaUniversityCntrlr.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPurinaUniversityCntrlr controller = new LPDCR_SecondaryPurinaUniversityCntrlr();
        System.assert( controller != null );
        
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPurinaUniversityCntrlr.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getPurinaUniversityContent()
 */
    static testMethod void test_getPurinaUniversityContent() 
    {
        System.debug( 'START: LPDCR_SecondaryPurinaUniversityCntrlr.test_getPurinaUniversityContent()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPurinaUniversityCntrlr controller = new LPDCR_SecondaryPurinaUniversityCntrlr();
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPurinaUniversityCntrlr.test_getPurinaUniversityContent()' );
    }

    
}// /END Test Class