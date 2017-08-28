/**
*   @Author:    Heena Tanna
*   @Date:      08.06.2017
*   @Jira:      LPDCR-3052
*   @Purpose:   Test class for LPDCR_SecondaryBusinessManagementCntlr.cls
*/
@isTest( SeeAllData=false )
private class LPDCR_SecondaryBusinessMngntCntlrTest {
    
    /******************************************************************************
 * Method to test the class constructor
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_SecondaryBusinessMngntCntlrTest.test_Constructor()' );
        
        Test.startTest();
        
        LPDCR_SecondaryBusinessManagementCntlr controller = new LPDCR_SecondaryBusinessManagementCntlr();
        controller.species_filter = new List<String>();
        controller.files_filter = new List<String>();
        controller.search_term = 'Search Term Test';
        controller.sort_filter='';
        String sort_filter = controller.sort_filter;
        controller.showDocumentList();
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> data = controller.documentList;
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> resourcedata = controller.couponResourceLst;
        List<LOLMyLinksCallouts.MyLinkData> resource = controller.resources;
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryBusinessMngntCntlrTest.test_Constructor()' );
    }
    
/*******************************************************************************
 * Method to test getVFDContent()
 */
    static testMethod void test_getLearningCenterData() 
    {
        System.debug( 'START: LPDCR_SecondaryBusinessMngntCntlrTest.test_getvfdContentList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryBusinessManagementCntlr controller = new LPDCR_SecondaryBusinessManagementCntlr();
        controller.search_term = 'Sales';
        controller.sort_filter = 'Name DESC';
        controller.species_filter = new List<String>();
        Boolean internal = controller.internal_only;
        controller.showDocumentList();
        Boolean init = controller.init;
        controller.document_type = Label.LPDCR_Invoice_Component_Name;
        controller.document_list_where_clause = Label.LPDCR_Invoice_Service_Where_Clause;
        controller.document_list_cache_key = Label.LPDCR_Invoice_Service_Cache_Key;
        controller.showBusinessDocumentList();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryBusinessMngntCntlrTest.test_getvfdContentList()' );
    }
    /*******************************************************************************
 * Method to test hideDocumentList()
 */
    static testMethod void test_hideDocumentList() 
    {
        System.debug( 'START: LPDCR_SecondaryPageMerchandisingCtrlrTst.test_hideDocumentList()' );
        
        Test.startTest();
        
        LPDCR_SecondaryBusinessManagementCntlr controller = new LPDCR_SecondaryBusinessManagementCntlr();
        
        controller.hideDocumentList();
        controller.showBusinessDocumentList();
        System.assert( controller != null );
        Test.stopTest();

        System.debug( 'END: LPDCR_SecondaryPageMerchandisingCtrlrTst.test_hideDocumentList()' );
    }
    
}