/******************************************************************************
 * Test class for the LPDCR_ContentServiceUtil class and its supporting classes 
 *
 * @Author: Magnet 360
 * @Date: Mar 28, 2017
 * @Jira: LPDCR-2230
 */
@isTest( SeeAllData=false )
private class 
LPDCR_ContentServiceUtilTest 
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
 * Test the constructor and Static private variables
 */
    static testMethod 
    void 
    test_Constructor() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_Constructor()' );

        LPDCR_ContentServiceUtil l_controller = new LPDCR_ContentServiceUtil();
        System.assert( LPDCR_ContentServiceUtil.CREDENTIALS_NAME != null );
        System.assert( LPDCR_ContentServiceUtil.SESSION_CACHE_TYPE != null );
        System.assert( LPDCR_ContentServiceUtil.ORG_CACHE_TYPE != null );

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_Constructor()' );
    }

/******************************************************************************
 * Test the getSpecies() Method for a successfull response
 */
    static testMethod 
    void 
    test_getSpecies_Success() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getSpecies_Success()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_BLSpecies l_species;
        
        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_SpeciesMockHttpResponseGenerator() );
        
                                                 // Call the web service to 
                                                 // return the species information
        l_controller = new LPDCR_ContentServiceUtil();
        l_species = l_controller.getSpecies();
        
        Test.stopTest();
        
        System.assert( l_species.getSpeciesList().size() > 0 );
        System.assert( l_species.success == true );
        System.assert( l_species.ex == null );

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getSpecies_Success()' );
    }

/******************************************************************************
 * Test the getSpecies() Method for a Parsing Exception response
 */
    static testMethod 
    void 
    test_getSpecies_ParsingException() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getSpecies_ParsingException()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_BLSpecies l_species;
        
        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_MockParsingExceptionHttpResponse() );
        
                                                 // Call the web service to 
                                                 // return the species information
        l_controller = new LPDCR_ContentServiceUtil();
        l_species = l_controller.getSpecies();
        
        Test.stopTest();
        
        System.assert( l_species.success == false );
        System.assert( l_species.ex != null );
        LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_parsing_ex
            = ( LPDCR_ContentCalloutResponse.LPDCR_ParsingException ) l_species.ex;
        System.assert( l_parsing_ex.ex != null );
        System.assert( l_parsing_ex.obj_name != null );
        System.assert( l_parsing_ex.json != null );

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getSpecies_ParsingException()' );
    }

/******************************************************************************
 * Test the getSpecies() Method for a Callout Exception response
 */
    static testMethod 
    void 
    test_getSpecies_CalloutException() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getSpecies_CalloutException()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_BLSpecies l_species;
        
        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_MockCalloutExceptionHttpResponse() );
        
                                                 // Call the web service to 
                                                 // return the species information
        l_controller = new LPDCR_ContentServiceUtil();
        l_species = l_controller.getSpecies();
        
        Test.stopTest();
        
        System.assert( l_species.success == false );
        System.assert( l_species.ex != null );
        LPDCR_ContentServiceUtil.LPDCR_CalloutException l_callout_ex
            = ( LPDCR_ContentServiceUtil.LPDCR_CalloutException) l_species.ex;
        System.assert( l_callout_ex.ex != null );
        System.assert( l_callout_ex.table_name != null );
        System.assert( l_callout_ex.columns != null );

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getSpecies_CalloutException()' );
    }
    
/******************************************************************************
 * Test the getPromotionsData() Method for a successfull response
 */
    static testMethod void test_getPromotions_Success() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getPromotions_Success()' );
        
        LPDCR_ContentServiceUtil controller;
        LPDCR_BLPromotions promoController;
        
        Test.startTest();
               
        Test.setMock( HttpCalloutMock.class, new LPDCR_PromotionsMockHttpResGenerator() );
        
        controller = new LPDCR_ContentServiceUtil();
        promoController = controller.getPromotionsData('Test Date');
        
        Test.stopTest();
        
        System.assertEquals(promoController!=null, true);
        
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getPromotions_Success()' );
    }

/******************************************************************************
 * Test the getPromotionsData() Method for a Parsing Exception response
 */
    static testMethod void test_getPromotions_ParsingException() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getPromotions_ParsingException()' );
        
        LPDCR_ContentServiceUtil controller;
        LPDCR_BLPromotions promoController;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_MockParsingExceptionHttpResponse() );
        
        controller = new LPDCR_ContentServiceUtil();
        promoController = controller.getPromotionsData('Test Date');
        
        Test.stopTest();
        
        System.assert( promoController.success == false );
        System.assert( promoController.ex != null );
        LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_parsing_ex
            = ( LPDCR_ContentCalloutResponse.LPDCR_ParsingException ) promoController.ex;
        System.assert( l_parsing_ex.ex != null );
        System.assert( l_parsing_ex.obj_name != null );
        System.assert( l_parsing_ex.json != null );

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getPromotions_ParsingException()' );
    }

/******************************************************************************
 * Test the getPromotionsData() Method for a Callout Exception response
 */
    static testMethod void test_getPromotions_CalloutException() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getPromotions_CalloutException()' );
        
        LPDCR_ContentServiceUtil controller;
        LPDCR_BLPromotions promoController;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_MockCalloutExceptionHttpResponse() );
        
        controller = new LPDCR_ContentServiceUtil();
        promoController = controller.getPromotionsData('Test Date');
        
        Test.stopTest();
        
        System.assert( promoController.success == false );
        System.assert( promoController.ex != null );
        LPDCR_ContentServiceUtil.LPDCR_CalloutException l_callout_ex
            = ( LPDCR_ContentServiceUtil.LPDCR_CalloutException) promoController.ex;
        System.assert( l_callout_ex.ex != null );
        System.assert( l_callout_ex.table_name != null );
        System.assert( l_callout_ex.columns != null );

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getPromotions_CalloutException()' );
    }
     
 /******************************************************************************
 * Test the getDocuments() Method for a successfull response
 */
    static testMethod void test_getDocuments_Success() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getDocuments_Success()' );
        
        LPDCR_ContentServiceUtil bl_controller;
        LPDCR_BLDocuments bl_documents;
        
        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_DocumentsMockHttpResponseGenerator() );
        
                                                 // Call the web service to 
                                                 // return the document information
        bl_controller = new LPDCR_ContentServiceUtil();
        //bl_documents = bl_controller.getMSRPDocuments( 'Documents', 'All', 'DocumentType = \'MSRP/MAP\'', null );
        //bl_documents = bl_controller.getDocuments('Logo');
        bl_documents = bl_controller.getDocuments('Logo','LPDCR Active Logos','Test Date');
        
        Test.stopTest();
        bl_documents = bl_controller.getDocuments('Logo');
        System.assert( bl_documents.getDocumentsList().size() > 0 );
        System.assert( bl_documents.success == true );
        System.assert( bl_documents.ex == null );

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getDocuments_Success()' );
    }


/******************************************************************************
 * Test the getDocuments() Method for a Callout Exception response
 */
    static testMethod void test_getDocuments_CalloutException() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getDocuments_CalloutException()' );
        
        LPDCR_ContentServiceUtil bl_controller;
        LPDCR_BLDocuments bl_documents;
        
        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_MockCalloutExceptionHttpResponse() );
        
                                                 // Call the web service to 
                                                 // return the document information
        bl_controller = new LPDCR_ContentServiceUtil();
        //bl_documents = bl_controller.getDocuments();
        //bl_documents = bl_controller.getDocuments('Logo');
        bl_documents = bl_controller.getDocuments('Logo','LPDCR Active Logos','Test Date');
        
        Test.stopTest();
        bl_documents = bl_controller.getDocuments('Logo');
        System.assert( bl_documents.success == false );
        System.assert( bl_documents.ex != null );
        LPDCR_ContentServiceUtil.LPDCR_CalloutException l_callout_ex
            = ( LPDCR_ContentServiceUtil.LPDCR_CalloutException) bl_documents.ex;
        System.assert( l_callout_ex.ex != null );
        System.assert( l_callout_ex.table_name != null );
        System.assert( l_callout_ex.columns != null );

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getDocuments_CalloutException()' );
    }    

/******************************************************************************
 * Test the getCarouselPromotions() Method for a successfull response
 */
    static testMethod 
    void 
    test_getCarouselPromotions_Success() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getCarouselPromotions_Success()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_BLPromotions l_carousel_promotions;
        
        Test.startTest();
               
        Test.setMock( HttpCalloutMock.class, new LPDCR_CarouselMockHttpResGenerator() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_carousel_promotions = l_controller.getCarouselPromotions();
        
        Test.stopTest();
        
        System.assertEquals(l_carousel_promotions!=null, true);
        
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getCarouselPromotions_Success()' );
    }

/******************************************************************************
 * Test the getCarouselPromotions() Method for a Parsing Exception response
 */
    static testMethod void test_getCarouselPromotions_ParsingException() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getCarouselPromotions_ParsingException()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_BLPromotions l_carousel_promotions;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_MockParsingExceptionHttpResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_carousel_promotions = l_controller.getCarouselPromotions();
        
        Test.stopTest();
        
        System.assert( l_carousel_promotions.success == false );
        System.assert( l_carousel_promotions.ex != null );
        LPDCR_ContentCalloutResponse.LPDCR_ParsingException l_parsing_ex
            = ( LPDCR_ContentCalloutResponse.LPDCR_ParsingException ) l_carousel_promotions.ex;
        System.assert( l_parsing_ex.ex != null );
        System.assert( l_parsing_ex.obj_name != null );
        System.assert( l_parsing_ex.json != null );

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getCarouselPromotions_ParsingException()' );
    }

/******************************************************************************
 * Test the getCarouselPromotions() Method for a Callout Exception response
 */
    static testMethod void test_getCarouselPromotions_CalloutException() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getCarouselPromotions_CalloutException()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_BLPromotions l_carousel_promotions;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_MockCalloutExceptionHttpResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_carousel_promotions = l_controller.getCarouselPromotions();
        
        Test.stopTest();
        
        System.assert( l_carousel_promotions.success == false );
        System.assert( l_carousel_promotions.ex != null );
        LPDCR_ContentServiceUtil.LPDCR_CalloutException l_callout_ex
            = ( LPDCR_ContentServiceUtil.LPDCR_CalloutException) l_carousel_promotions.ex;
        System.assert( l_callout_ex.ex != null );
        System.assert( l_callout_ex.table_name != null );
        System.assert( l_callout_ex.columns != null );

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getCarouselPromotions_CalloutException()' );
    }
    

    
  /******************************************************************************
 * Test the getMSRPDocuments() Method for a successfull response
 */
    static testMethod void test_getMSRPDocuments_Success() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getMSRPDocuments_Success()' );
        
        LPDCR_ContentServiceUtil bl_controller;
        LPDCR_BLDocuments bl_documents;
        
        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_DocumentsMockHttpResponseGenerator() );
        
                                                 // Call the web service to 
                                                 // return the document information
        bl_controller = new LPDCR_ContentServiceUtil();
        //bl_documents = bl_controller.getMSRPDocuments( 'Documents', 'All', 'MSRP/MAP', 'test' );
      
        
        Test.stopTest();
        if(bl_documents != null){       
        System.assertEquals(bl_documents !=null, false);
        }

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getMSRPDocuments_Success()' );
    }


/******************************************************************************
 * Test the getMSRPDocuments() Method for a Callout Exception response
 */
    static testMethod void test_getMSRPDocuments_CalloutException() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getMSRPDocuments_CalloutException()' );
        
        LPDCR_ContentServiceUtil bl_controller;
        LPDCR_BLDocuments bl_documents;
        
        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_MockCalloutExceptionHttpResponse() );
        
                                                 // Call the web service to 
                                                 // return the document information
        bl_controller = new LPDCR_ContentServiceUtil();
        bl_documents = bl_controller.getMSRPDocuments( 'Documents', 'All', 'DocumentType = \'MSRP/MAP\'', null );
        
        Test.stopTest();
        
        System.assert( bl_documents.success == false );
        System.assert( bl_documents.ex != null );
        LPDCR_ContentServiceUtil.LPDCR_CalloutException l_callout_ex
            = ( LPDCR_ContentServiceUtil.LPDCR_CalloutException) bl_documents.ex;
        System.assert( l_callout_ex.ex != null );
        System.assert( l_callout_ex.table_name != null );
        System.assert( l_callout_ex.columns != null );

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getMSRPDocuments_CalloutException()' );
    }
   /******************************************************************************
 * Test the searchDocuments() Method for a successfull response
 */
    static testMethod void test_searchDocuments_Success() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_searchDocuments_Success()' );
        
        LPDCR_ContentServiceUtil bl_controller;
        LPDCR_BLDocuments bl_documents;
        
        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_DocumentSearchMockHTTPResponse() );
        
                                                 // Call the web service to 
                                                 // return the document information
        bl_controller = new LPDCR_ContentServiceUtil();
        bl_documents = bl_controller.searchDocuments('test');
       
        
        
        Test.stopTest();
        
        System.assertEquals(bl_documents!=null, true);
       

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_searchDocuments_Success()' );
    }


/******************************************************************************
 * Test the searchDocuments() Method for a Callout Exception response
 */
    static testMethod void test_searchDocuments_CalloutException() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_searchDocuments_CalloutException()' );
        
        LPDCR_ContentServiceUtil bl_controller;
        LPDCR_BLDocuments bl_documents;
        
        
        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_MockCalloutExceptionHttpResponse() );
        
                                                 // Call the web service to 
                                                 // return the document information
        bl_controller = new LPDCR_ContentServiceUtil();
        bl_documents = bl_controller.searchDocuments('test');
        
        Test.stopTest();
         if(bl_documents != null){
        System.assert( bl_documents.success == false );
       
        System.assert( bl_documents.ex != null );
        LPDCR_ContentServiceUtil.LPDCR_CalloutException l_callout_ex
            = ( LPDCR_ContentServiceUtil.LPDCR_CalloutException) bl_documents.ex;
        System.assert( l_callout_ex.ex != null );
        System.assert( l_callout_ex.table_name != null );
        System.assert( l_callout_ex.columns != null );
         }
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_searchDocuments_CalloutException()' );
    } 
    
    /******************************************************************************
 * Test the searchPromotions() Method for a successfull response
 */
    static testMethod void test_searchPromotions_Success() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_searchPromotions_Success()' );
        
        LPDCR_ContentServiceUtil bl_controller;
       
        LPDCR_BLPromotions l_carousel_promotions;
        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_PromotionSearchMockHTTResponse() );
        
                                                 // Call the web service to 
                                                 // return the document information
        bl_controller = new LPDCR_ContentServiceUtil();
       
        l_carousel_promotions = bl_controller.searchPromotions('test');
        
        
        Test.stopTest();
        System.assertEquals(l_carousel_promotions!=null, true);
       

        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_searchPromotions_Success()' );
    }


/******************************************************************************
 * Test the searchPromotions() Method for a Callout Exception response
 */
    static testMethod void test_searchPromotions_CalloutException() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_searchPromotions_CalloutException()' );
        
        LPDCR_ContentServiceUtil bl_controller;
        
        LPDCR_BLPromotions l_carousel_promotions;
        
        Test.startTest();
                                                 // Set mock callout class
        Test.setMock( HttpCalloutMock.class, new LPDCR_MockCalloutExceptionHttpResponse() );
        
                                                 // Call the web service to 
                                                 // return the document information
        bl_controller = new LPDCR_ContentServiceUtil();
        
        l_carousel_promotions = bl_controller.searchPromotions('test');
        Test.stopTest();
        
        if(l_carousel_promotions != null){
        System.assert( l_carousel_promotions.success == false );
        
        LPDCR_ContentServiceUtil.LPDCR_CalloutException l_callout_ex
            = ( LPDCR_ContentServiceUtil.LPDCR_CalloutException) l_carousel_promotions.ex;
        System.assert( l_callout_ex.ex != null );
        System.assert( l_callout_ex.table_name != null );
        System.assert( l_callout_ex.columns != null );
        }
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_searchPromotions_CalloutException()' );
    }
    /*********************
    Test handling a parsing exception for the  getDealerAccountSummaryReport()
    *********************/
    
    static testmethod void test_getDealerAccountSummaryReport_success(){
        
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getDealerAccountSummaryReport()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_VIPTonsReport l_dealer_account_summary;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_DealerReportDetailMockResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_dealer_account_summary = l_controller.getDealerAccountSummaryReport( '298312' );
        
        Test.stopTest();
        
        System.assert( l_dealer_account_summary.success == true );
        System.assert( l_dealer_account_summary.ex == null );
        System.assert( l_dealer_account_summary.row [0].ar_customer_number != null );
        System.assert( l_dealer_account_summary.row [0].ar_customer_name  != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_pytd != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_ytd != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_py != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_pytd != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_ytd != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_py != null );

        l_dealer_account_summary = l_controller.getDealerAccountSummaryReport( '' );
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getDealerAccountSummaryReport()' );
    
    }
    /******************************************************************************
 * Test handling a callout exception for the getDealerAccountSummaryReport() method
 */
    static testMethod 
    void 
    test_getDealerAccountSummaryReport_CalloutException() 
    {
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getDealerAccountSummaryReport_CalloutException()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_VIPTonsReport l_dealer_account_summary;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_MockCalloutExceptionHttpResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_dealer_account_summary = l_controller.getDealerAccountSummaryReport( '298312' );
        
        Test.stopTest();
        
        System.assert( l_dealer_account_summary.success != true );
        System.assert( l_dealer_account_summary.ex != null );
        LPDCR_ContentServiceUtil.LPDCR_CalloutException l_callout_ex
            = ( LPDCR_ContentServiceUtil.LPDCR_CalloutException) l_dealer_account_summary.ex;
        System.assert( l_callout_ex.ex != null );
        System.assert( l_callout_ex.table_name != null );
        System.assert( l_callout_ex.columns != null );
        
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getDealerAccountSummaryReport_CalloutException()' );
    }
    /*********************
     Test method for getDealerAccountDetailReport() & getDealerFullReport()
    *********************/
    
    static testmethod void test_getDealerAccountDetailReport_success(){
        
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getDealerAccountDetailReport()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_VIPTonsReport l_dealer_account_summary;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_DealerReportDetailMockResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_dealer_account_summary = l_controller.getDealerAccountDetailReport('298312');
        l_dealer_account_summary =l_controller.getDealerFullReport('298312');
        l_controller.getDealerFullReportAsCSV('298312');
        Test.stopTest();
        
        System.assert( l_dealer_account_summary.success == true );
        System.assert( l_dealer_account_summary.ex == null );
        System.assert( l_dealer_account_summary.row [0].ar_customer_number != null );
        System.assert( l_dealer_account_summary.row [0].ar_customer_name  != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_pytd != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_ytd != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_py != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_pytd != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_ytd != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_py != null );
        
        
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getDealerAccountDetailReport()' );
    
    }
    
    /*********************
     Test method for getDealerAccountLevel3DetailReport()
    *********************/
    
    static testmethod void test_getDealerAccountLevel3DetailReport_success(){
        
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getDealerAccountLevel3DetailReport()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_VIPTonsReport l_dealer_account_summary;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_DealerReportDetailMockResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_dealer_account_summary = l_controller.getDealerAccountLevel3DetailReport('298312','298312');
       
        Test.stopTest();
        
        System.assert( l_dealer_account_summary.success == true );
        System.assert( l_dealer_account_summary.ex == null );
        System.assert( l_dealer_account_summary.row [0].ar_customer_number != null );
        System.assert( l_dealer_account_summary.row [0].ar_customer_name  != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_pytd != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_ytd != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_py != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_pytd != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_ytd != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_py != null );
        
       
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getDealerAccountLevel3DetailReport()' );
    
    }    
    
    /*********************
    Test method for  getDealerAccountProductDetailReport()
    *********************/
    
    static testmethod void test_getDealerAccountProductDetailReport_success(){
        
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_ggetDealerAccountProductDetailReport()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_VIPTonsReport l_dealer_account_summary;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_DealerReportDetailMockResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_dealer_account_summary = l_controller.getDealerAccountProductDetailReport('298312','298312','123');
       
        Test.stopTest();
        
        System.assert( l_dealer_account_summary.success == true );
        System.assert( l_dealer_account_summary.ex == null );
        System.assert( l_dealer_account_summary.row [0].ar_customer_number != null );
        System.assert( l_dealer_account_summary.row [0].ar_customer_name  != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_pytd != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_ytd != null );
        System.assert( l_dealer_account_summary.row [0].shipped_tons_py != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_pytd != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_ytd != null );
        System.assert( l_dealer_account_summary.row [0].vip_points_py != null );
        
        
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getDealerAccountProductDetailReport()' );
    
    }
/**** Negative Case ***/    
    static testmethod void test_getDealerAccountDetailReport_exception(){
        
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getDealerAccountDetailReport()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_VIPTonsReport l_dealer_account_summary;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_DealerReportDetailMockResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_dealer_account_summary = l_controller.getDealerAccountDetailReport(null);
        l_dealer_account_summary =l_controller.getDealerFullReport(null);
        l_dealer_account_summary = l_controller.getDealerAccountLevel3DetailReport(null,null);
        l_dealer_account_summary = l_controller.getDealerAccountProductDetailReport(null,null,null);
        l_controller.getDealerFullReportAsCSV(null);
        Test.stopTest();
        
       
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getDealerAccountDetailReport()' );
    
    } 
    
    /*********************
    Test method getInternalSummaryReport() &  getInternalAccountTerritoryReport()
    *********************/
    
    static testmethod void test_getInternalSummaryReport_success(){
        
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getInternalSummaryReport()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_VIPTonsReport l_internal_account_summary;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new    LPDCR_InternalReportDetailMockResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_internal_account_summary = l_controller.getInternalSummaryReport('24730');
        
        Test.stopTest(); 
        l_internal_account_summary = l_controller.getInternalAccountTerritoryReport('24730');
        System.assert( l_internal_account_summary.success == true );
        System.assert( l_internal_account_summary.ex == null );
        System.assert( l_internal_account_summary.row [0].ar_customer_number != null );
        System.assert( l_internal_account_summary.row [0].ar_customer_name  != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_pytd != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_ytd != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_py != null );
        System.assert( l_internal_account_summary.row [0].vip_points_pytd != null );
        System.assert( l_internal_account_summary.row [0].vip_points_ytd != null );
        System.assert( l_internal_account_summary.row [0].vip_points_py != null );
        
       
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getInternalSummaryReport()' );
    
    }    
    
    /*********************
    Test method for getInternalAccountDetailReport()
    *********************/
    
    static testmethod void test_getInternalAccountDetailReport_success(){
        
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getInternalAccountDetailReport()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_VIPTonsReport l_internal_account_summary;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_InternalReportDetailMockResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_internal_account_summary = l_controller.getInternalAccountDetailReport('24730','1513900');
        LPDCR_ContentServiceUtil.requestInternalVIPTonsReport('24730','test@test.com', 'TestUser' );
        Test.stopTest();
        
        System.assert( l_internal_account_summary.success == true );
        System.assert( l_internal_account_summary.ex == null );
        System.assert( l_internal_account_summary.row [0].ar_customer_number != null );
        System.assert( l_internal_account_summary.row [0].ar_customer_name  != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_pytd != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_ytd != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_py != null );
        System.assert( l_internal_account_summary.row [0].vip_points_pytd != null );
        System.assert( l_internal_account_summary.row [0].vip_points_ytd != null );
        System.assert( l_internal_account_summary.row [0].vip_points_py != null );
        
        
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getInternalAccountDetailReport()' );
    
    }   
    
    /*********************
    Test method for getInternalAccountLevel3DetailReport()
    *********************/
    
    static testmethod void test_getInternalAccountLevel3DetailReport_success(){
        
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getInternalAccountLevel3DetailReport()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_VIPTonsReport l_internal_account_summary;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_InternalReportDetailMockResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_internal_account_summary = l_controller.getInternalAccountLevel3DetailReport('24730','111176');
        
        Test.stopTest();
        
        System.assert( l_internal_account_summary.success == true );
        System.assert( l_internal_account_summary.ex == null );
        System.assert( l_internal_account_summary.row [0].ar_customer_number != null );
        System.assert( l_internal_account_summary.row [0].ar_customer_name  != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_pytd != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_ytd != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_py != null );
        System.assert( l_internal_account_summary.row [0].vip_points_pytd != null );
        System.assert( l_internal_account_summary.row [0].vip_points_ytd != null );
        System.assert( l_internal_account_summary.row [0].vip_points_py != null );
        
       
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getInternalAccountLevel3DetailReport()' );
    
    }   
    
    /*********************
    Test method for  getInternalAccountProductDetailReport()
    *********************/
    
    static testmethod void test_getInternalAccountProductDetailReport_success(){
        
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getInternalAccountProductDetailReport()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_VIPTonsReport l_internal_account_summary;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_InternalReportDetailMockResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_internal_account_summary = l_controller.getInternalAccountProductDetailReport('24730','111176','171');
       
        Test.stopTest();
        
        System.assert( l_internal_account_summary.success == true );
        System.assert( l_internal_account_summary.ex == null );
        System.assert( l_internal_account_summary.row [0].ar_customer_number != null );
        System.assert( l_internal_account_summary.row [0].ar_customer_name  != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_pytd != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_ytd != null );
        System.assert( l_internal_account_summary.row [0].shipped_tons_py != null );
        System.assert( l_internal_account_summary.row [0].vip_points_pytd != null );
        System.assert( l_internal_account_summary.row [0].vip_points_ytd != null );
        System.assert( l_internal_account_summary.row [0].vip_points_py != null );
        
       
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getInternalAccountProductDetailReport()' );
    
    }  
    
    /**** Negative Case ***/    
    static testmethod void test_getInternalDetailReport_exception(){
        
        System.debug( 'START: LPDCR_ContentServiceUtilTest.test_getDealerAccountDetailReport()' );
        
        LPDCR_ContentServiceUtil l_controller;
        LPDCR_VIPTonsReport l_internal_account_summary;
        
        Test.startTest();
        
        Test.setMock( HttpCalloutMock.class, new LPDCR_InternalReportDetailMockResponse() );
        
        l_controller = new LPDCR_ContentServiceUtil();
        l_internal_account_summary = l_controller.getInternalSummaryReport(null);
        l_internal_account_summary = l_controller.getInternalAccountTerritoryReport(null);
        l_internal_account_summary =l_controller.getInternalAccountDetailReport(null,null);
        l_internal_account_summary = l_controller.getInternalAccountLevel3DetailReport(null,null);
        l_internal_account_summary = l_controller.getInternalAccountProductDetailReport(null,null,null);
        LPDCR_ContentServiceUtil.requestInternalVIPTonsReport (null,null,null);
        Test.stopTest();
        
       
        System.debug( 'END: LPDCR_ContentServiceUtilTest.test_getDealerAccountDetailReport()' );
    
    }   
    
  
    
}// /END Test Class