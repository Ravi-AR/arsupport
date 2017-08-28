/**
*   @Author:    Heena Tanna
*   @Date:      08.06.2017
*   @Jira:      LPDCR-3052
*   @Purpose:   Test class for LPDCR_SecondaryLearningCenterCntlr.cls
*/
@isTest( SeeAllData=false )
private class LPDCR_SecondaryLearningCenterCntlrTest { 
    
    /******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryLearningCenterCntlrTest.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryLearningCenterCntlr controller = new LPDCR_SecondaryLearningCenterCntlr();
        System.assert( controller != null );
        controller.sort_filter='';
        String sort_filter = controller.sort_filter;
        controller.showDocumentList();
       
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryLearningCenterCntlrTest.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getVFDContent()
 */
    static testMethod void test_getLearningCenterData() 
    {
        System.debug( 'START: LPDCR_SecondaryLearningCenterCntlrTest.test_getvfdContentList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryLearningCenterCntlr controller = new LPDCR_SecondaryLearningCenterCntlr();
        controller.search_term = 'Sales';
        controller.sort_filter = null;
        String sort_filter=Label.LPDCR_Document_Order_By_Clause;
        Boolean init = controller.init;
        Boolean internal = controller.internal_only;
        controller.showDocumentList();
        controller.hideDocumentList();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryLearningCenterCntlrTest.test_getvfdContentList()' );
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
        controller.showDocumentList();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageMerchandisingCtrlrTst.test_hideDocumentList()' );
    }
    
}