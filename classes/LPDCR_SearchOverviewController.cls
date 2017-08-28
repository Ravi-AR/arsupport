/******************************************************************************
 * Controller for the LPDCR_SearchOverview page
 * 
 * @Author: Magnet 360
 * @Date: May 8, 2017 
 * @Jira: LPDCR-1992
 */

public without sharing class 
LPDCR_SearchOverviewController 
{
    public String term { get; set; }
    public List<Campaign> events { get; set; } 
    public LPDCR_BLDocuments document_results { get; set; }
    public LPDCR_BLPromotions promotion_results { get; set; }
    
    public String selectedAccountId
    {
        get {
            if( selectedAccountId == null ) {
                selectedAccountId = LPDCR_ChangeAccountController.getSelectedAccId();
            }
            return selectedAccountId;
        }
        set;
    }
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> sales_resources { get; set; }
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> documents { get; set; }
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> images { get; set; }
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> videos { get; set; }
    // public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> feed_manuals { get; set; }
    
    public List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions> promotions { get; set; }
    
    public LPDCR_ContentServiceUtil content_util;
    
    private static String TYPE_NATIONAL_VIP = 'National VIP';//Farm VIP Event
    private static String TYPE_DEALER_TRAINING = 'Dealer/Training VIP';
    private static String STATUS_PLANNED ='Planned';
    private static String STATUS_REGISTRATIONOPEN ='Registration Open';
    private static String STATUS_REGISTRATIONCLOSED ='Registration Closed';
    
                                                 // Define the search types/categories
    public static String EVENTS_SEARCH_CATEGORY = 'Events';
    public static String PROMOTIONS_SEARCH_CATEGORY = 'Promotions';
    public static String VIDEOS_SEARCH_CATEGORY = 'Videos';
    public static String IMAGES_SEARCH_CATEGORY = 'Images';
    public static String DOCUMENTS_SEARCH_CATEGORY = 'Documents';
    public static String SALES_RESOURCES_SEARCH_CATEGORY = 'Sales Resources';
    // public static String FEED_MANUALS_SEARCH_CATEGORY = 'Feed Manuals';
    
    Set<String> camFarmVipType = new Set<String>{TYPE_NATIONAL_VIP,TYPE_DEALER_TRAINING};//Farm VIP Event
    Set<String> camFarmVipStatus = new Set<String>{STATUS_PLANNED,STATUS_REGISTRATIONOPEN,STATUS_REGISTRATIONCLOSED};//Farm VIP Event
    
/******************************************************************************
 * Constructor
 */
	public
	LPDCR_SearchOverviewController()
	{
		System.debug( 'START: LPDCR_SearchOverviewController.constructor()' );
		
		content_util = new LPDCR_ContentServiceUtil();
		
		if( ApexPages.currentPage().getParameters().get( 'term' ) != null )
		{
		    term = ApexPages.currentPage().getParameters().get( 'term' );
		}
		
		if( term != null && term.replace('*','').replace('%','').length() < 2 )
        {
            ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The search term must contain at least two alpha-numeric characters.' );
            ApexPages.addMessage( l_msg );
        }
		
		System.debug( 'term = ' + term );
		System.debug( 'END: LPDCR_SearchOverviewController.constructor()' );
	}

/******************************************************************************
 * Method to take the user to the full search results page for the Events
 * content type
 */
    public
    PageReference
    goToEventSearchResults()
    {
        System.debug( 'START: LPDCR_SearchOverviewController.goToEventSearchResults()' );
        
        PageReference l_search_results = goToSearchResults( EVENTS_SEARCH_CATEGORY );
        
        System.debug( 'l_search_results Events = ' + l_search_results );
        System.debug( 'END: LPDCR_SearchOverviewController.goToEventSearchResults()' );
        
        return l_search_results;
    }

/******************************************************************************
 * Method to take the user to the full search results page for the Events
 * content type
 */
    public
    PageReference
    goToPromotionSearchResults()
    {
        System.debug( 'START: LPDCR_SearchOverviewController.goToPromotionSearchResults()' );
        
        PageReference l_search_results = goToSearchResults( PROMOTIONS_SEARCH_CATEGORY );
        
        System.debug( 'l_search_results Promotion= ' + l_search_results );
        System.debug( 'END: LPDCR_SearchOverviewController.goToPromotionSearchResults()' );
        
        return l_search_results;
    }

/******************************************************************************
 * Method to take the user to the full search results page for the Videos
 * content type
 */
    public
    PageReference
    goToVideosSearchResults()
    {
        System.debug( 'START: LPDCR_SearchOverviewController.goToVideosSearchResults()' );
        
        PageReference l_search_results = goToSearchResults( VIDEOS_SEARCH_CATEGORY );
        
        System.debug( 'l_search_results Video= ' + l_search_results );
        System.debug( 'END: LPDCR_SearchOverviewController.goToVideosSearchResults()' );
        
        return l_search_results;
    }

/******************************************************************************
 * Method to take the user to the full search results page for the Images
 * content type
 */
    public
    PageReference
    goToImageSearchResults()
    {
        System.debug( 'START: LPDCR_SearchOverviewController.goToImageSearchResults()' );
        
        PageReference l_search_results = goToSearchResults( IMAGES_SEARCH_CATEGORY );
        
        System.debug( 'l_search_results Image= ' + l_search_results );
        System.debug( 'END: LPDCR_SearchOverviewController.goToImageSearchResults()' );
        
        return l_search_results;
    }

/******************************************************************************
 * Method to take the user to the full search results page for the Documents
 * content type
 */
    public
    PageReference
    goToDocumentSearchResults()
    {
        System.debug( 'START: LPDCR_SearchOverviewController.goToDocumentSearchResults()' );
        
        PageReference l_search_results = goToSearchResults( DOCUMENTS_SEARCH_CATEGORY );
        
        System.debug( 'l_search_results Document= ' + l_search_results );
        System.debug( 'END: LPDCR_SearchOverviewController.goToDocumentSearchResults()' );
        
        return l_search_results;
    }

/******************************************************************************
 * Method to take the user to the full search results page for the Sales Resources
 * content type
 */
    public
    PageReference
    goToSalesResourceSearchResults()
    {
        System.debug( 'START: LPDCR_SearchOverviewController.goToSalesResourceSearchResults()' );
        
        PageReference l_search_results = goToSearchResults( SALES_RESOURCES_SEARCH_CATEGORY );
        
        System.debug( 'l_search_results SalesResource= ' + l_search_results );
        System.debug( 'END: LPDCR_SearchOverviewController.goToSalesResourceSearchResults()' );
        
        return l_search_results;
    }

/******************************************************************************
 * Method to take the user to the full search results page for the Feed Manuals
 * content type

    public
    PageReference
    goToFeedManualSearchResults()
    {
        System.debug( 'START: LPDCR_SearchOverviewController.goToFeedManualSearchResults()' );
        
        PageReference l_search_results = goToSearchResults( FEED_MANUALS_SEARCH_CATEGORY );
        
        System.debug( 'l_search_results FeedManual= ' + l_search_results );
        System.debug( 'END: LPDCR_SearchOverviewController.goToFeedManualSearchResults()' );
        
        return l_search_results;
    }
 */
 
/******************************************************************************
 * Private helper method to take the user to the full search results page for
 * the content type specified
 */
    private
    PageReference
    goToSearchResults( String a_content_type )
    {
        System.debug( 'START: LPDCR_SearchOverviewController.goToSearchResults()' );
        System.debug('EventTerm'+ term);
        System.debug('Content Type'+ a_content_type);
        PageReference l_search_results = Page.LPDCR_SearchResults;
        l_search_results.getParameters().put( 'term', term );
        l_search_results.getParameters().put( 'type', a_content_type );
        l_search_results.setRedirect( true );
        
        System.debug( 'l_search_results = ' + l_search_results );
        System.debug( 'END: LPDCR_SearchOverviewController.goToSearchResults()' );
        
        return l_search_results;
    }

/******************************************************************************
 * Action Function method to start the Events search
 */
    public
    void
    searchEvents()
    {
        System.debug( 'START: LPDCR_SearchOverviewController.searchEvents()' );
        
        events = new List<Campaign>();
        
        if( term != null && term.replace('*','').replace('%','').length() < 2 )
        {
            ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The search term must contain at least two alpha-numeric characters.' );
            ApexPages.addMessage( l_msg );
        }
        else if( term != null && term.replace('*','').replace('%','').length() > 2 )
        {
            String l_search_string = '*'+ term + '*';
            try
            {
	            events = ( List<Campaign> ) [ FIND :l_search_string IN ALL FIELDS 
	                                          RETURNING Campaign (Id, 
	                                                              Name, 
	                                                              Event_Date_Range__c, 
	                                                              Event_Location__c,
	                                                              Short_Description__c
		                                                     WHERE (Display_in_Dealer_Community__c = true 
		                                                             AND RecordType.DeveloperName =: LPDCR_Constants.CONS_FARMVIPEVENTS 
		                                                             AND Type IN :camFarmVipType 
		                                                             AND Status IN :camFarmVipStatus 
		                                                             AND EndDate >= TODAY ) 
		                                                     LIMIT 5 ) 
	                                         ][ 0 ];
            }
            catch( Exception l_ex )
            {
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.ERROR, l_ex.getMessage() );
                ApexPages.addMessage( l_msg );
            }
        }// /END if( term != null )
        
        System.debug( 'END: LPDCR_SearchOverviewController.searchEvents()' );
    }
    

/******************************************************************************
 * Action Function method to start the Kentico search of documents and promotions
 */
    public
    void
    searchContent()
    {
        System.debug( 'START: LPDCR_SearchOverviewController.searchContent()' );

        document_results = new LPDCR_BLDocuments();
        promotion_results = new LPDCR_BLPromotions();
        
        sales_resources = new List<LPDCR_BLDocuments.PurinaBusinessLink_Documents>();
        documents = new List<LPDCR_BLDocuments.PurinaBusinessLink_Documents>();
        images = new List<LPDCR_BLDocuments.PurinaBusinessLink_Documents>();
        videos = new List<LPDCR_BLDocuments.PurinaBusinessLink_Documents>();
        // feed_manuals = new List<LPDCR_BLDocuments.PurinaBusinessLink_Documents>();
        
        promotions = new List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions>();
        if( term != null && term.replace('*','').replace('%','').length() < 2 )
        {
            ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The search term must contain at least two alpha-numeric characters.' );
            ApexPages.addMessage( l_msg );
        }
        else if( term != null && term.replace('*','').replace('%','').length() > 2 )
        {
            try
            {
                document_results = content_util.searchDocuments( term );
                document_results.success = true;
            }
            catch( Exception l_ex )
            {
                document_results = new LPDCR_BLDocuments();
                document_results.success = false;
                document_results.ex = l_ex;
                
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while searching for matching documents.' );
                ApexPages.addMessage( l_msg );
            }
            
            try
            {
                promotion_results = content_util.searchPromotions( term );
                promotion_results.success = true;
            }
            catch( Exception l_ex )
            {
                promotion_results = new LPDCR_BLPromotions();
                promotion_results.success = false;
                promotion_results.ex = l_ex;
                
                ApexPages.Message l_msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while searching for matching promotions.' );
                ApexPages.addMessage( l_msg );
            }
                                                 // Loop over the document search
                                                 // results and parse them out into
                                                 // the individual types
            if( document_results != null && document_results.success )
            {
                                                 // Compare the records document types
                                                 // against the document type categories
                                                 // stored in the custom labels
	            Set<String> l_document_doc_types = new Set<String>( Label.LPDCR_Search_Category_Document_Doc_Types.split( ',' ) );
	            // Set<String> l_feed_manual_doc_types = new Set<String>( Label.LPDCR_Search_Category_Feed_Manuals_Doc_Types.split( ',' ) );
	            Set<String> l_image_file_doc_types = new Set<String>( Label.LPDCR_Search_Category_Image_Files_Doc_Types.split( ',' ) );
	            Set<String> l_video_doc_types = new Set<String>( Label.LPDCR_Search_Category_Videos_Doc_Types.split( ',' ) );
	            Set<String> l_sales_resource_doc_types = new Set<String>( Label.LPDCR_Search_Category_Sales_Resource_Doc_Types.split( ',' ) );
	            
	            System.debug( 'l_video_doc_types = ' + l_video_doc_types );
	            
	                                             // Set flags to prevent the record
	                                             // from being added to the same
	                                             // category multiple times
                Boolean l_added_to_documents;
                Boolean l_added_to_images;
                Boolean l_added_to_sales_resources;
                Boolean l_added_to_videos;
                // Boolean l_added_to_feed_manuals;
	            
	            for( LPDCR_BLDocuments.PurinaBusinessLink_Documents l_result : document_results.getDocumentsList() )
	            {
	                if( l_result.DocumentType == null )
	                {
	                    documents.add( l_result );
	                }
	                else
	                {
	                    l_added_to_documents = false;
	                    l_added_to_images = false;
	                    l_added_to_sales_resources = false;
	                    l_added_to_videos = false;
	                    // l_added_to_feed_manuals = false;
                        
	                    for( String l_doc_type : l_result.DocumentType.split( '\\|' ) )
	                    {
	                        if( ! l_added_to_documents && l_document_doc_types.contains( l_doc_type ) ) {
		                        documents.add( l_result );
		                        l_added_to_documents = true;
		                    }
		                    
		                    if( ! l_added_to_images && l_image_file_doc_types.contains( l_doc_type ) ) {
		                        images.add( l_result );
		                        l_added_to_images = true;
		                    }
		                    
		                    if( ! l_added_to_sales_resources && l_sales_resource_doc_types.contains( l_doc_type ) ) {
		                        sales_resources.add( l_result );
		                        l_added_to_sales_resources = true;
		                    }
		                    
		                    if( ! l_added_to_videos && l_video_doc_types.contains( l_doc_type ) ) {
		                        videos.add( l_result );
		                        l_added_to_videos = true;
		                    }
		                    /*
		                    if( ! l_added_to_feed_manuals && l_feed_manual_doc_types.contains( l_doc_type ) ) {
		                        feed_manuals.add( l_result );
		                        l_added_to_feed_manuals = true;
		                    }
		                    */

	                    }// /END for( l_result.DocumentType.split( '|' ) )
	                    
                                                 // If the record wasn't added to
                                                 // any of the categories, add
                                                 // it to Documents
                        if( !( l_added_to_documents || l_added_to_images || l_added_to_sales_resources || l_added_to_videos /* || l_added_to_feed_manuals */ ) )
                        {
                            documents.add( l_result );
                        }
	                    
	                }// if( l_result.DocumentType == null )
	            }// /END for( documents )
            }// if( document_results != null && document_results.success )
            
            if( promotion_results != null && promotion_results.success )
            {
                promotions = promotion_results.getPromotionsList();    
            }
            
            
        }// /END if( term != null )
        
        System.debug( 'END: LPDCR_SearchOverviewController.searchContent()' );
    }

} // /END Class