/******************************************************************************
 * Test class for LPDCR_SecondaryPageMerchandisingCtrlr.cls
 *
 *
 * @Author: Magnet 360
 * @Date: Apr 4, 2017
 * @Jira: LPDCR-2230
 */
@isTest( SeeAllData=false)
private class 
LPDCR_SecondaryPageMerchandisingCtrlrTst 
{
/******************************************************************************
 * Setup any data and custom settings needed for the test class
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
        System.debug( 'START: LPDCR_SecondaryPageMerchandisingCtrlrTst.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageMerchandisingCtrlr l_controller = new LPDCR_SecondaryPageMerchandisingCtrlr();
        System.assert( l_controller != null );
        
        l_controller.species_filter = new List<String>();
        l_controller.search_term = 'Search Term Test';
        l_controller.sort_filter='';
        String sort_filter = l_controller.sort_filter;
        l_controller.showDocumentList();
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> data = l_controller.documentList;
        //l_controller.files_filter=
        
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageMerchandisingCtrlrTst.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test showDocumentList()
 */
    static testMethod void test_showDocumentList() 
    {
        System.debug( 'START: LPDCR_SecondaryPageMerchandisingCtrlrTst.test_showDocumentList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageMerchandisingCtrlr controller = new LPDCR_SecondaryPageMerchandisingCtrlr();
        controller.document_type = Label.LPDCR_POS_Sign_Templates_Component_Name;
        controller.search_term = 'Sales';
        controller.sort_filter = 'Name DESC';
        controller.showDocument();
        
        controller.document_type = Label.LPDCR_Planograms_Component_Name;
        controller.showDocument();
        controller.document_type = Label.LPDCR_Signs_Component_Name;
        controller.showDocument();
        controller.document_type = Label.LPDCR_Display_Library_Component_Name;
        controller.showDocument();
        controller.document_type = Label.LPDCR_Planograms_Component_Name;
        controller.showDocument();
        controller.document_type = Label.LPDCR_POS_Sign_Templates_Component_Name;
        controller.showDocument();
        controller.document_type = Label.LPDCR_Print_eStore_Component_Name;
        controller.showDocument();
        controller.document_type = Label.LPDCR_Promotions_eStore_Component_Name;
        controller.showDocument();
                
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageMerchandisingCtrlrTst.test_showDocumentList()' );
    }
    
/*******************************************************************************
 * Method to test hideDocumentList()
 */
    static testMethod void test_hideDocumentList() 
    {
        System.debug( 'START: LPDCR_SecondaryPageMerchandisingCtrlrTst.test_hideDocumentList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageMerchandisingCtrlr controller = new LPDCR_SecondaryPageMerchandisingCtrlr();
        
        controller.hideDocumentList();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageMerchandisingCtrlrTst.test_hideDocumentList()' );
    }
    
}// /END Test Class