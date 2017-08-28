/******************************************************************************
 * Test class for LPDCR_SecondaryPageMediaToolsCtrlr.cls
 *
 *
 * @Author: Magnet 360
 * @Date: Apr 4, 2017
 * @Jira: LPDCR-2230
 */
@isTest( SeeAllData=false)
private class 
LPDCR_SecondaryPageMediaToolsCtrlrTest 
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
    static testMethod 
    void 
    test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryPageMediaToolsCtrlrTest.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageMediaToolsCtrlr l_controller = new LPDCR_SecondaryPageMediaToolsCtrlr();
        System.assert( l_controller!= null );
        l_controller.search_term = 'Search Term';
        l_controller.species_filter = new List<String>();
        l_controller.sort_filter='';
        l_controller.showDocumentList();
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> data = l_controller.documentList;
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageMediaToolsCtrlrTest.test_Constructor()' );
    }
    
    static testMethod void test_DocumentData(){
        Test.startTest();
        //Test.setMock( HttpCalloutMock.class, new LPDCR_DocumentsMockHttpResponseGenerator() );
        LPDCR_SecondaryPageMediaToolsCtrlr controller = new LPDCR_SecondaryPageMediaToolsCtrlr();
        controller.search_term = 'Sales';
        controller.sort_filter = 'Name ASC';
        controller.showDocumentList();
        controller.document_type = Label.LPDCR_Logo_Component_Name;
        controller.retrieveDocuments();
        controller.document_type = Label.LPDCR_Package_Component_Name;
        controller.retrieveDocuments();
        controller.document_type = Label.LPDCR_Social_Media_Component_Name;
        controller.retrieveDocuments();
        controller.document_type = Label.LPDCR_Video_Component_Name;
        controller.retrieveDocuments();
        controller.document_type = Label.LPDCR_Ad_Slicks_Component_Name;
        controller.retrieveDocuments();
        controller.document_type = Label.LPDCR_Radio_Scripts_Component_Name;
        controller.retrieveDocuments();
        controller.showDocumentList();
        
        System.assert( controller != null );
        Test.stopTest();
    }
    
    /*******************************************************************************
 * Method to test hideDocumentList()
 */
    static testMethod void test_hideDocumentList() 
    {
        System.debug( 'START: LPDCR_SecondaryPageMediaToolsCtrlr.test_hideDocumentList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryPageMediaToolsCtrlr controller = new LPDCR_SecondaryPageMediaToolsCtrlr();
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> documentList = controller.documentList;
        controller.hideDocumentList();
        
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageMediaToolsCtrlr.test_hideDocumentList()' );
    }
    
}// /END Test Class