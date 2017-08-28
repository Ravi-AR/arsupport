/****************************************************************************
 * @Author:  Heena Tanna
 * @Date:    31.03.2017
 * @Jira:    LPDCR-2011
 * @Purpose: Test class for the LPDCR_BLDocuments class
 */
@isTest( SeeAllData=false )
private class LPDCR_BLDocumentsTest {
    
    static testMethod void testParse() 
    {

        LPDCR_TestUtil.setCustomSettings();
        
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> l_documents; 
        
        String json = LPDCR_TestUtil.LPDCR_BLDocumentsTest_JSON;
        LPDCR_BLDocuments obj2 = LPDCR_BLDocuments.parse( json );
        
        LPDCR_BLDocuments controller = new LPDCR_BLDocuments();
       
        controller.PurinaBusinessLink_Documents = obj2.PurinaBusinessLink_Documents;
        l_documents = controller.getDocumentsList();
        System.assert( l_documents.size() > 0, 'LPDCR_BLDocuments.getDocumentsList() did not complete correctly' );
        
        Set<String> l_file_types = LPDCR_BLDocuments.getFileTypes( l_documents );
        System.assert( l_file_types.size() > 0, 'LPDCR_BLDocuments.getFileTypes() did not return any file types for the document list' );
        
        LPDCR_BLDocuments.PurinaBusinessLink_Documents temp = new LPDCR_BLDocuments.PurinaBusinessLink_Documents();
        temp.DocumentFilePath = null;
        temp.DocumentHasLandingPage = null;
        temp.DocumentsLastModified = null;
        temp.DocumentSubBrand = null;
        temp.ShowOnHomePage = null;
        temp.LinkPath = null;
        temp.ShowInPromoImageCarousel = null;
        temp.DocumentShortDescription = null;
        temp.DocumentLocation = null;
        temp.ReviewRemoveDate = null;
        temp.CarouselTextArea = null;
        temp.DocumentsID = null;
        temp.FileOrLink = null;
        temp.DocumentKeywords = null;
        temp.DocumentType = null;
        temp.DocumentProduct = null;
        temp.LinkOpenInNewWindow = null;
        temp.DocumentsGuid = null;
        temp.CarouselImage = null;
        temp.DocumentBrand = null;
        temp.DocumentOrLink = null;
        temp.DocumentWYSIWYG = null;
        temp.CarouselHeadline = null;
        temp.DocumentSpecies = null;
        temp.IsActive = null;
        temp.DocumentName = null;
        temp.InternalOnly = false;
        temp.VideoUrl = null;
        temp.StartDate = null;
        temp.ExpirationDate = null;
        temp.ItemOrder = null;
    }
    
    
    
}