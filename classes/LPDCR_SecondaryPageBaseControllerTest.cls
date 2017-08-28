/******************************************************************************
 * Test class for LPDCR_SecondaryPageBaseController.cls
 *
 *
 * @Author: Magnet 360
 * @Date: Apr 4, 2017
 * @Jira: LPDCR-2230
 */
@isTest( SeeAllData=false )
private class 
LPDCR_SecondaryPageBaseControllerTest 
{

/******************************************************************************
 * Method to test the controllers getter & setter methods that are not tested
 * from the other page controllers that extend those classes.
 */
    static testMethod 
    void 
    test_GettersAndSetters() 
    {
		System.debug( 'START: LPDCR_SecondaryPageBaseControllerTest.test_GettersAndSetters()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageBaseController l_controller = new LPDCR_SecondaryPageBaseController();
        
        l_controller.setComponentController( new LPDCR_ComponentBaseController() );
        System.assert( l_controller.getMyComponentController() != null );
        
        l_controller.setComponentControllerMap( 'ComponentControllerTest', new LPDCR_ComponentBaseController() );
        System.assert( l_controller.getComponentControllerMap() != null );
        
        System.assert( l_controller.getThis() != null );
        
        l_controller.initCachedData();
        
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageBaseControllerTest.test_GettersAndSetters()' );
    }
    
}// /END Test Class