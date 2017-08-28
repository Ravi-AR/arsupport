/******************************************************************************
 * Test class for LPDCR_SecondaryPageMerchandisingCtrlr.cls
 *
 *
 * @Author: Shruti Mishra
 * @Date: Apr 7, 2017
 * @Jira: LPDCR-2330
 */
@isTest( SeeAllData=false )
private class LPDCR_SecondaryPagePromotionsCtrlTest 
{

/******************************************************************************
 * Setup the test data used throughout all of these test methods
 */
    @testSetup
    public static 
    void 
    testSetup()
    {
        LPDCR_TestUtil.setCustomSettings();
    }
/******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryPagePromotionsController.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPagePromotionsController controller = new LPDCR_SecondaryPagePromotionsController();
        System.assert( controller != null );
        
        controller.species_filter = new List<String>();
        controller.search_term = 'Search Term Test';
        
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPagePromotionsController.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getPromotionList()
 */
    static testMethod void test_getPromotionList() 
    {
        System.debug( 'START: LPDCR_SecondaryPagePromotionsController.test_getPromotionList()' );
        List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions>  promoLst;
        Test.startTest();
         
        Test.setMock( HttpCalloutMock.class, new LPDCR_PromotionsMockHttpResGenerator());
        LPDCR_SecondaryPagePromotionsController controller = new LPDCR_SecondaryPagePromotionsController();
        controller.sort_filter = 'Name DESC';
        Boolean init = controller.init;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPagePromotionsController.test_getPromotionList()' );
    }

    
    
}// /END Test Class