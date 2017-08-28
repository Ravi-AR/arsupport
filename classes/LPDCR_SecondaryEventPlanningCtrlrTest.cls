/******************************************************************************
 * Test Class for controller LPDCR_SecondaryEventPlanningController.cls 
 * 
 * @Author: Heena Tanna
 * @Date: May 15, 2017 
 * @Jira: LPDCR-2795 
 */
 @isTest( SeeAllData=false)
private class LPDCR_SecondaryEventPlanningCtrlrTest {

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
        System.debug( 'START: LPDCR_SecondaryEventPlanningCtrlrTest.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryEventPlanningController l_controller = new LPDCR_SecondaryEventPlanningController();
        l_controller.search_term = 'Search Term';
        l_controller.sort_filter = '';
        l_controller.species_filter = new List<String>();
        System.assert( l_controller!= null );
        
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryEventPlanningCtrlrTest.test_Constructor()' );
    }
    
    static testMethod void test_DocumentData(){
        Test.startTest();
        Test.setMock( HttpCalloutMock.class, new LPDCR_DocumentsMockHttpResponseGenerator() );
        LPDCR_SecondaryEventPlanningController controller = new LPDCR_SecondaryEventPlanningController();
        controller.sort_filter = 'Name ASC';
        controller.document_type = Label.LPDCR_Local_Event_Planner;
        controller.retrieveDocuments();
        controller.document_type = Label.LPDCR_Local_Event_Checklists;
        controller.retrieveDocuments();
        controller.document_type = Label.LPDCR_Local_Event_Idea_Library;
        controller.retrieveDocuments();
        controller.document_type = Label.LPDCR_Event_Resources;
        controller.retrieveDocuments();
        controller.showDocumentList();
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> documentList = controller.documentList;
        controller.hideDocumentList();
        System.assert( controller != null );
        Test.stopTest();
    }
    
    
}