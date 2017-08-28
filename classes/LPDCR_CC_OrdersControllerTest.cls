/******************************************************************************
 * Test class for LPDCR_CC_OrdersController.cls 
 *
 * @Author: Shruti Mishra
 * @Date: June 5, 2017
 * @Jira: LPDCR-2924
 */
@isTest( SeeAllData=false )
private class LPDCR_CC_OrdersControllerTest 
{

/******************************************************************************
 * Method to test the constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_CC_OrdersControllerTest.test_Constructor()' );

        Test.startTest();
        
        LPDCR_CC_OrdersController controller = new LPDCR_CC_OrdersController();
        System.assert( controller != null );
        
        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_OrdersControllerTest.test_Constructor()' );
    }

}// /END Test Class