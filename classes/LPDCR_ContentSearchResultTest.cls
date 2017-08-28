/******************************************************************************
 * Test class for the LPDCR_ContentSearchResult class
 *
 *
 * @Author: Magnet 360
 * @Date: May 23, 2017
 * @Jira: LPDCR-1992
 */
@isTest( SeeAllData=false )
private class 
LPDCR_ContentSearchResultTest 
{

/******************************************************************************
 * Setup any data needed by the test methods
 */
    @testSetup
    static 
    void 
    dataSetup() 
    {
        LPDCR_TestUtil.setCustomSettings();
    }
    
/******************************************************************************
 * Method to test the constructors and parsing method
 */
    static testMethod 
    void 
    test_Constructors() 
    {
		System.debug( 'START: LPDCR_ContentSearchResultTest.testMethod()' );
        
        Test.startTest();
                                                 // Test the empty constructor
        LPDCR_ContentSearchResult l_base_constructor = new LPDCR_ContentSearchResult();
        System.assert( l_base_constructor != null );
                                                 // Test the constructor for 
                                                 // Document search results
        LPDCR_ContentSearchResult l_document_constructor
            = new LPDCR_ContentSearchResult( 'Documents', LPDCR_TestUtil.LPDCR_Document_Search_Response_XML );

                                                 // Test the constructor for 
                                                 // Promotion search results
        LPDCR_ContentSearchResult l_promotion_constructor
            = new LPDCR_ContentSearchResult( 'Promotions', LPDCR_TestUtil.LPDCR_Promotion_Search_Response_XML );

        System.assert( l_document_constructor.documents != null );
        System.assert( l_promotion_constructor.promotions != null );
        
                                                 // Test the sorting, filtering, and
                                                 // supporting methods for the documents
                                                 // list
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> l_document_list
            = l_document_constructor.documents.getDocumentsList();
        System.assert( l_document_list.size() > 0, 'Document Search Results were not loaded and parsed correctlyl' );
        System.assert( LPDCR_BLDocuments.getFileTypes( l_document_list ).size() > 0, 'Document Search Result File Types were not loaded correctly' );
        
        LPDCR_BLDocuments.sortBy = 'Date DESC';
        l_document_list.sort();
        LPDCR_BLDocuments.sortBy = 'Date ASC';
        l_document_list.sort();
        LPDCR_BLDocuments.sortBy = 'Name DESC';
        l_document_list.sort();
        LPDCR_BLDocuments.sortBy = 'Name ASC';
        l_document_list.sort();
        LPDCR_BLDocuments.sortBy = 'Other DESC';
        l_document_list.sort();
        
        List<String> l_species = new List<String>();
        l_species.add( 'Cattle' );
        List<String> l_file_type = new List<String>();
        l_file_type.add( '.pdf' );
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> l_filtered_docs 
            = LPDCR_BLDocuments.filterDocuments( l_document_list, l_species, l_file_type, false, 'Name ASC' );
        
        Test.stopTest();    
        System.debug( 'END: LPDCR_ContentSearchResultTest.testMethod()' );
    }
    
}// /END Test Class