/**
*   @Author:    Heena Tanna
*   @Date:      19.04.2017
*   @Jira:      
*   @Purpose:   Test class for LPDCR_SecTechBulletinController.cls
*/

@isTest( SeeAllData=false )
private class LPDCR_SecTechBulletinControllerTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecTechBulletinController.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecTechBulletinController controller = new LPDCR_SecTechBulletinController();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecTechBulletinController.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getPurinaUniversityContent()
 */
    static testMethod void test_getTechBulletinList() 
    {
        System.debug( 'START: LPDCR_SecTechBulletinController.test_getTechBulletinList()' );
        
        Test.startTest();
        
        LPDCR_SecTechBulletinController controller = new LPDCR_SecTechBulletinController();
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecTechBulletinController.test_getTechBulletinList()' );
    }

    
}// /END Test Class