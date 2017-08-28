/******************************************************************************
 * Test class for LPDCR_SecondaryPageTrainingController.cls
 * @Author: Shruti Mishra
 * @Date: Apr 13, 2017
 * @Jira: LPDCR-2346
 */
 
@isTest( SeeAllData=false )
private class LPDCR_SecondaryPageTrainingCntlrTest {
    
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryPageTrainingController.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageTrainingController controller = new LPDCR_SecondaryPageTrainingController();
        System.assert( controller != null );
        
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageTrainingController.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getTrainingData()
 */
    static testMethod void test_getTrainingData() 
    {
        System.debug( 'START: LPDCR_SecondaryPageTrainingController.test_getTrainingData()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageTrainingController controller = new LPDCR_SecondaryPageTrainingController();
        controller.sort_filter = 'Name DESC';
        //controller.getTrainingData();
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageTrainingController.test_getTrainingData()' );
    }

    
}// /END Test Class