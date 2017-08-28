/******************************************************************************
 * Test class for LPDCR_ComponentBaseController.cls
 *
 *
 * @Author: Magnet 360
 * @Date: Apr 4, 2017
 * @Jira: LPDCR-2230
 */
@isTest( SeeAllData=false )
private class 
LPDCR_ComponentBaseControllerTest 
{

/******************************************************************************
 * Method to test the getters and setters in the base class
 */
    static testMethod 
    void 
    test_GettersAndSetters() 
    {
		System.debug( 'START: LPDCR_ComponentBaseControllerTest.test_GettersAndSetters()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageBaseController l_base_controller = new LPDCR_SecondaryPageBaseController();
        
        LPDCR_ComponentBaseController l_controller = new LPDCR_ComponentBaseController();
        l_controller.pageController = l_base_controller;
        l_controller.key = 'KeyValue';
        
        System.assert( l_controller.pageController.getComponentControllerMap().get( 'KeyValue' ) != null );
        
        Test.stopTest();
        
        System.debug( 'END: LPDCR_ComponentBaseControllerTest.test_GettersAndSetters()' );
    }
    
}// /END Test Class