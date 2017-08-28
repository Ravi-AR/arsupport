/**
*   @Author:    Heena Tanna
*   @Date:      20.04.2017
*   @Jira:      LPDCR-2230
*   @Purpose:   Test Class behind LPDCR_CC_Training_Controller
*
* Updated with a comment for Demo Purposes
*/

@isTest( SeeAllData=false )
private class LPDCR_CC_Training_ControllerTest {
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_CC_Training_Controller.test_Constructor()' );

        Test.startTest();
        
        LPDCR_CC_Training_Controller l_controller = new LPDCR_CC_Training_Controller();
        Boolean init = l_controller.init;
        System.assert( l_controller != null );
        
        System.debug( 'END: LPDCR_CC_Training_Controller.test_Constructor()' );
    }
   
    
    
}