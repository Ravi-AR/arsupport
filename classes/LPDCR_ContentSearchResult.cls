/******************************************************************************
 * Custom class used to hold and parse the data returned from the Kentico
 * search API results.
 * 
 * @Author: Magnet 360
 * @Date: May 16, 2017 
 * @Jira: LPDCR-1992
 */

public with sharing class 
LPDCR_ContentSearchResult
    extends LPDCR_ContentCalloutResponse 
{
    @TestVisible private static String DOCUMENTS_SEARCH_TYPE = 'Documents';
    @TestVisible private static String PROMOTIONS_SEARCH_TYPE = 'Promotions';
    
    @TestVisible private List<DocumentSearchResult> document_search_results { get; set; }
    @TestVisible private List<PromotionSearchResult> promotion_search_results { get; set; }
    
    public LPDCR_BLDocuments documents { get; set; }
    public LPDCR_BLPromotions promotions { get; set; }    
    
/******************************************************************************
 * Basic constructor. Should only be called during exception handling
 */
    public
    LPDCR_ContentSearchResult()
    {
        System.debug( 'START: LPDCR_ContentSearchResult.constructor()' );
        System.debug( 'END: LPDCR_ContentSearchResult.constructor()' );
    }

/******************************************************************************
 * Constructor. Parses through the XML structure returned to find the JSON
 * result string. Creates either the list of Promotion results or the list
 * of Document results, based on the a_object_type parameter
 * 
 * @Param String a_object_type : Either 'Documents' or 'Promotions'. Determines
 *                  how the JSON result string will be parsed
 * @Param String a_xml : The XML string returned from the search API that contains
 *                         the JSON result string to be parsed
 */
    public
    LPDCR_ContentSearchResult( String a_object_type, String a_xml )
    {
        System.debug( 'START: LPDCR_ContentSearchResult.constructor()' );
        System.debug( 'Param: a_object_type = ' + a_object_type );
        System.debug( 'Param: a_xml = ' + a_xml );
        
        this.documents = new LPDCR_BLDocuments();
        this.promotions = new LPDCR_BLPromotions();
        
        try
        {
            parse( a_object_type, a_xml );
            this.success = true;
        }
        catch( Exception l_ex )
        {
            LPDCR_ParsingException exceptionDocuments = new LPDCR_ParsingException( 'LPDCR_ContentSearchResult', a_xml, l_ex );
            this.success = false;
            this.ex = exceptionDocuments;
            
            LOLUtilities.LogErrMsg( 'LPDCR_ContentSearchResult.parse()',l_ex,': Message = ' + l_ex.getMessage()+' : Param XML = ' + a_xml );

            throw exceptionDocuments;
        }
        
        System.debug( 'END: LPDCR_ContentSearchResult.constructor()' );
    }

/******************************************************************************
 * Private method to first parse the XML string to find the JSON results, then
 * parse the JSON string to build either the List<DocumentSearchResult> or 
 * List<PromotionSearchResult>
 */
    private
    void
    parse( String a_object_type, String a_xml )
    {
        System.debug( 'START: LPDCR_ContentSearchResult.parse()' );
        System.debug( 'Param: a_object_type = ' + a_object_type );
        System.debug( 'Param: a_xml = ' + a_xml );
        
        Boolean l_allow_add;
        
        DOM.Document l_document = new DOM.Document();      
        l_document.load( a_xml );    
        DOM.XMLNode l_root = l_document.getRootElement();
        
        System.JSONParser l_json_parser; 
        System.JSONToken l_token;
        System.debug( 'Root Text = ' + l_root.getText().trim() );
        
        if( l_root.getName() == 'string' 
            && l_root.getText() != null
            && l_root.getText() != 'null' )
        {
            l_json_parser = System.JSON.createParser( l_root.getText().trim() );
            
            Map<String, Boolean> l_user_permissions = LPDCR_ContentServiceUtil.getcurrentUserPerSet();
            
            while( l_json_parser.nextToken() != JSONToken.END_OBJECT )
            {
                if( l_json_parser.getCurrentToken() == JSONToken.FIELD_NAME )
                {
                    String text = l_json_parser.getText();
                    if( l_json_parser.nextToken() != JSONToken.VALUE_NULL ) 
                    {
                        if( text == 'results' || text == 'Table' ) // Documents == 'results', Promotions == 'Table'
                        {
                            if( a_object_type == DOCUMENTS_SEARCH_TYPE )
                            {
                                document_search_results = new List<DocumentSearchResult>();
                                while( l_json_parser.nextToken() != JSONToken.END_ARRAY){
                                    DocumentSearchResult l_doc = new DocumentSearchResult( l_json_parser );
                                    document_search_results.add( l_doc );
                                }// /END while()

                                this.documents = new LPDCR_BLDocuments( document_search_results );
                            }
                            else
                            {
                                promotion_search_results = new List<PromotionSearchResult>();
                                while( l_json_parser.nextToken() != JSONToken.END_ARRAY) {
                                    PromotionSearchResult l_promo = new PromotionSearchResult( l_json_parser );
                                    promotion_search_results.add( l_promo );
                                }// /END while()
                                
                                this.promotions = new LPDCR_BLPromotions( promotion_search_results );
                            }
                        }
                        else
                        {
                            System.debug(LoggingLevel.WARN, 'LPDCR_ContentSearchResult consuming unrecognized property: '+text);
                            consumeObject(l_json_parser);
                        }
                    }// /END if( l_json_parser.nextToken() != JSONToken.VALUE_NULL )
                }// /END if( parser.getCurrentToken() == JSONToken.FIELD_NAME )
            }// /END while( l_json_parser.nextToken() != JSONToken.END_OBJECT )
        }// /END if( l_root.getName() == 'string' )
        
        System.debug( 'END: LPDCR_ContentSearchResult.parse()' );
    }

/******************************************************************************
 * Custom inner class to hold the Document search result records
 */
    public class
    DocumentSearchResult
    {
        public String id { get; set; }
        public String type { get; set; }
        public String score { get; set; }
        public String position { get; set; }
        public String title { get; set; }
        public String content { get; set; }
        public String created { get; set; }
        public String image { get; set; }
        public String imageclass { get; set; }
        public String absscore { get; set; }
        public String maxscore { get; set; }
        public String index { get; set; }
        public Boolean IsActive { get; set; }
        public Boolean InternalOnly { get; set; }
        public String FileOrLink { get; set; }
        public String DocumentName { get; set; }
        public String VideoUrl { get; set; }
        public String DocumentFilePath { get; set; }
        public Boolean DocumentHasLandingPage { get; set; }
        public Boolean ShowInPromoImageCarousel { get; set; }
        public String DocumentSpecies { get; set; }
        public String DocumentLocation { get; set; }
        public String DocumentType { get; set; }
        public String DocumentProduct { get; set; }
        public String DocumentBrand { get; set; }
        public String DocumentSubBrand { get; set; }
        public String DocumentShortDescription { get; set; }
        public String DocumentKeywords { get; set; }
        public String DocumentWYSIWYG { get; set; }
        public String CarouselHeadline { get; set; }
        public String CarouselTextArea { get; set; }
        public String CarouselImage { get; set; }
        public Boolean ShowOnHomePage { get; set; }
        public String DocumentOrLink { get; set; }
        public String LinkPath { get; set; }
        public Boolean LinkOpenInNewWindow { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime ExpirationDate { get; set; }
        public DateTime DocumentsLastModified  { get; set; }
        public String Plants  { get; set; }

        public
        DocumentSearchResult( JSONParser parser )
        {
            while( parser.nextToken() != JSONToken.END_OBJECT ) {
                if( parser.getCurrentToken() == JSONToken.FIELD_NAME ) {
                    String text = parser.getText();
                    if( parser.nextToken() != JSONToken.VALUE_NULL ) {
                        if(text == 'id') {
                            id = parser.getText();
                        }else if( text == 'type' ) {
                            type = parser.getText();
                        }else if( text == 'score' ) {
                            score = parser.getText();
                        }else if( text == 'position' ) {
                            position = parser.getText();
                        }else if( text == 'title' ) {
                            title = parser.getText();
                        }else if( text == 'content' ) {
                            content = parser.getText();
                        }else if( text == 'created' ) {
                            created = parser.getText();
                        }else if( text == 'image' ) {
                            image = parser.getText();
                        }else if( text == 'imageclass' ) {
                            imageclass = parser.getText();
                        }else if( text == 'absscore' ) {
                            absscore = parser.getText();
                        }else if( text == 'maxscore' ) {
                            maxscore = parser.getText();
                        }else if( text == 'index' ) {
                            index = parser.getText();
                        }else if( text == 'IsActive' ) {
                            IsActive = Boolean.valueOf( parser.getText() );
                        }else if( text == 'InternalOnly' ) {
                            InternalOnly = Boolean.valueOf( parser.getText() );
                        }else if( text == 'FileOrLink' ) {
                            FileOrLink = parser.getText() ;
                        }else if( text == 'DocumentName' ) {
                            DocumentName = parser.getText() ;
                        }else if( text == 'VideoUrl' ) {
                            VideoUrl = parser.getText() ;
                        }else if( text == 'DocumentHasLandingPage' ) {
                            DocumentHasLandingPage = Boolean.valueOf( parser.getText() );
                        }else if( text == 'ShowInPromoImageCarousel' ) {
                            ShowInPromoImageCarousel = Boolean.valueOf( parser.getText() );
                        }else if( text == 'DocumentSpecies' ) {
                            DocumentSpecies = parser.getText() ;
                        }else if( text == 'DocumentLocation' ) {
                            DocumentLocation = parser.getText() ;
                        }else if( text == 'DocumentType' ) {
                            DocumentType = parser.getText() ;
                        }else if( text == 'DocumentProduct' ) {
                            DocumentProduct = parser.getText() ;
                        }else if( text == 'DocumentBrand' ) {
                            DocumentBrand = parser.getText() ;
                        }else if( text == 'DocumentSubBrand' ) {
                            DocumentSubBrand = parser.getText() ;
                        }else if( text == 'DocumentShortDescription' ) {
                            DocumentShortDescription = parser.getText() ;
                        }else if( text == 'DocumentKeywords' ) {
                            DocumentKeywords = parser.getText() ;
                        }else if( text == 'DocumentWYSIWYG' ) {
                            DocumentWYSIWYG = parser.getText() ;
                        }else if( text == 'DocumentKeywords' ) {
                            DocumentKeywords = parser.getText() ;
                        }else if( text == 'CarouselHeadline' ) {
                            CarouselHeadline = parser.getText() ;
                        }else if( text == 'CarouselTextArea' ) {
                            CarouselTextArea = parser.getText() ;
                        }else if( text == 'ShowOnHomePage' ) {
                            ShowOnHomePage = Boolean.valueOf( parser.getText() );
                        }else if( text == 'DocumentOrLink' ) {
                            DocumentOrLink = parser.getText() ;
                        }else if( text == 'LinkPath' ) {
                            LinkPath = parser.getText() ;
                        }else if( text == 'LinkOpenInNewWindow' ) {
                            LinkOpenInNewWindow = Boolean.valueOf( parser.getText() );
                        }else if( text == 'StartDate' ) {
                            StartDate = DateTime.valueOf( parser.getText().replace( 'T', ' ' ) ) ;
                        }else if( text == 'ExpirationDate' ) {
                            ExpirationDate = DateTime.valueOf( parser.getText().replace( 'T', ' ' ) ) ;
                        }else if( text == 'DocumentsLastModified' ) {
                            DocumentsLastModified = DateTime.valueOf( parser.getText().replace( 'T', ' ' ) ) ;
                        }else if( text == 'DocumentFilePath' ) {
                            DocumentFilePath = parser.getText() ;
                        }else if( text == 'Plants' ) {
                            Plants = parser.getText() ;
                        }else {
                                                 // Handle any values that are
                                                 // not accounted for, by simply
                                                 // looping through them 
                            System.debug( LoggingLevel.WARN, 'DocumentSearchResult consuming unrecognized property: '+text );
                            consumeObject( parser );
                        }
                    }// /END if( parser.nextToken() != JSONToken.VALUE_NULL )
                }// /END if( parser.getCurrentToken() == JSONToken.FIELD_NAME )
            }// /END while()
        }// /END DocumentSearchResult constructor
        /* 
          "id": "1883_PurinaBusinessLink.Documents",
          "type": "PurinaBusinessLink.Documents",
          "score": "1",
          "position": "0",
          "title": "The Farmer Video",
          "content": "Backyard Poultry|Cattle|Dairy - Young Animal|Horse|Swine - Commercial|Deer &amp; Elk|Goat|Fish &amp; Aqua|Rabbit|Show|Dairy - Transition &amp; Lactating Cow|Swine - Retail",
          "created": null,
          "image": null,
          "imageclass": null,
          "absscore": "0.6806158",
          "maxscore": "0.6806158",
          "index": "BusinessLinkDocuments",
          "IsActive": true,
          "InternalOnly": false,
          "FileOrLink": "Link To URL",
          "DocumentName": null,
          "VideoUrl": "https:\/\/youtu.be\/p0OfsM6MchA",
          "DocumentHasLandingPage": false,
          "ShowInPromoImageCarousel": false,
          "DocumentSpecies": "Backyard Poultry|Cattle|Dairy - Young Animal|Horse|Swine - Commercial|Deer &amp; Elk|Goat|Fish &amp; Aqua|Rabbit|Show|Dairy - Transition &amp; Lactating Cow|Swine - Retail",
          "DocumentLocation": "Marketing",
          "DocumentType": "Video",
          "DocumentProduct": null,
          "DocumentBrand": null,
          "DocumentSubBrand": null,
          "DocumentShortDescription": null,
          "DocumentKeywords": null,
          "DocumentWYSIWYG": null,
          "CarouselHeadline": null,
          "CarouselTextArea": null,
          "ShowOnHomePage": false,
          "DocumentOrLink": null,
          "LinkPath": null,
          "LinkOpenInNewWindow": false,
          "StartDate": null,
          "ExpirationDate": null,
          "Plants": null
        */
        
    }// /END inner class
        
/******************************************************************************
 * Custom inner class to hold the Document search result records
 */
    public class
    PromotionSearchResult
    {
        public Integer PromotionsID { get; set; }
        public String PromotionsGuid { get; set; }
        public DateTime PromotionsLastModified { get; set; }
        public String Headline { get; set; }
        public String Species { get; set; }
        public String WYSIWYG { get; set; }
        public Boolean ShowInPromoImageCarousel { get; set; }
        public Boolean ShowOnHomePage { get; set; }
        public String CarouselImage { get; set; }
        public String CarouselHeadline { get; set; }
        public String CarouselTextArea { get; set; }
        public String CarouselButtonText { get; set; }
        public String CarouselButtonLink { get; set; }
        public String CarouselDocumentLink { get; set; }
        public String CarouselURLLink { get; set; }
        public String RelatedDocuments { get; set; }
        public Boolean IsActive { get; set; }
        public Integer ItemOrder { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime ExpirationDate { get; set; }
        public String DocumentType { get; set; }
        public Boolean InternalOnly { get; set; }
        public String DocumentLocation { get; set; }
        /*
          "PromotionsID": 14,
	      "PromotionsGuid": "9ef547ec-e29e-4ed3-8eab-2cfcad483706",
	      "PromotionsLastModified": "2017-05-17T12:22:10",
	      "Headline": "Nature's Match - Targeting Overall Nutrient Utilization to Optimize Sow and Pig Performance",
	      "Species": "Cattle|Swine - Retail",
	      "WYSIWYG": "&lt;ul&gt;\r\n\t&lt;li&gt;Essential nuition to optimize sow and pig performance&lt;\/li&gt;\r\n\t&lt;li&gt;Proactive in environmental preservation&lt;\/li&gt;\r\n\t&lt;li&gt;Flexible feeding options&lt;\/li&gt;\r\n&lt;\/ul&gt;\r\n",
	      "ShowInPromoImageCarousel": true,
	      "ShowOnHomePage": false,
	      "CarouselImage": "~\/BusinessLink\/media\/Business-Link\/Images\/Promo\/Promo-Retail-Swine-Grass-by-Round-Bale.jpg?ext=.jpg",
	      "CarouselHeadline": "Nutrient Utilization to Optimize Performance",
	      "CarouselTextArea": "&lt;ul&gt;\r\n\t&lt;li&gt;Essential nutrition for sow and pig&lt;\/li&gt;\r\n\t&lt;li&gt;Proactive environnmental preservation&lt;\/li&gt;\r\n\t&lt;li&gt;Flexible feeding options&lt;\/li&gt;\r\n&lt;\/ul&gt;\r\n",
	      "CarouselButtonText": "Read More",
	      "CarouselButtonLink": "Link to current promotion",
	      "CarouselDocumentLink": null,
	      "CarouselURLLink": null,
	      "RelatedDocuments": null,
	      "IsActive": true,
	      "ItemOrder": 3,
	      "StartDate": "2017-04-26T00:00:00",
	      "ExpirationDate": "2017-06-28T00:00:00",
	      "DocumentType": "Promotions",
	      "InternalOnly": false,
	      "DocumentLocation": null
        */
        public
        PromotionSearchResult( JSONParser parser )
        {
            while( parser.nextToken() != JSONToken.END_OBJECT ) {
                if( parser.getCurrentToken() == JSONToken.FIELD_NAME ) {
                    String text = parser.getText();
                    if( parser.nextToken() != JSONToken.VALUE_NULL ) {
                        if(text == 'PromotionsID') {
                            PromotionsID = Integer.valueOf( parser.getText() );
                        }else if( text == 'PromotionsGuid' ) {
                            PromotionsGuid = parser.getText();
                        }else if( text == 'PromotionsLastModified' ) {
                            PromotionsLastModified = DateTime.valueOf( parser.getText().replace( 'T', ' ' ) );
                        }else if( text == 'Headline' ) {
                            Headline = parser.getText();
                        }else if( text == 'Species' ) {
                            Species = parser.getText();
                        }else if( text == 'WYSIWYG' ) {
                            WYSIWYG = parser.getText();
                        }else if( text == 'ShowInPromoImageCarousel' ) {
                            ShowInPromoImageCarousel = Boolean.valueOf( parser.getText() );
                        }else if( text == 'ShowOnHomePage' ) {
                            ShowOnHomePage = Boolean.valueOf( parser.getText() );
                        }else if( text == 'CarouselImage' ) {
                            CarouselImage = parser.getText();
                        }else if( text == 'CarouselHeadline' ) {
                            CarouselHeadline = parser.getText();
                        }else if( text == 'CarouselTextArea' ) {
                            CarouselTextArea = parser.getText();
                        }else if( text == 'CarouselButtonText' ) {
                            CarouselButtonText = parser.getText();
                        }else if( text == 'CarouselButtonLink' ) {
                            CarouselButtonLink = parser.getText();
                        }else if( text == 'CarouselURLLink' ) {
                            CarouselURLLink = parser.getText();
                        }else if( text == 'RelatedDocuments' ) {
                            RelatedDocuments = parser.getText();
                        }else if( text == 'IsActive' ) {
                            IsActive = Boolean.valueOf( parser.getText() ) ;
                        }else if( text == 'ItemOrder' ) {
                            ItemOrder = Integer.valueOf( parser.getText() );
                        }else if( text == 'StartDate' ) {
                            StartDate = DateTime.valueOf( parser.getText().replace( 'T', ' ' ) );
                        }else if( text == 'ExpirationDate' ) {
                            ExpirationDate = DateTime.valueOf( parser.getText().replace( 'T', ' ' ) );
                        }else if( text == 'DocumentType' ) {
                            DocumentType = parser.getText();
                        }else if( text == 'InternalOnly' ) {
                            InternalOnly = Boolean.valueOf( parser.getText() );
                        }else if( text == 'DocumentLocation' ) {
                            DocumentLocation = parser.getText();
                        }else {
                                                 // Handle any values that are
                                                 // not accounted for, by simply
                                                 // looping through them 
                            System.debug( LoggingLevel.WARN, 'PromotionSearchResult consuming unrecognized property: '+text );
                            consumeObject( parser );
                        }
                    }// /END if( parser.nextToken() != JSONToken.VALUE_NULL )
                }// /END if( parser.getCurrentToken() == JSONToken.FIELD_NAME )
            }// /END while()
        }// /END PromotionSearchResult constructor
        
        
        
    }// /END inner class

/******************************************************************************
 * Helper method to loop through any JSON element that is not recognized
 */
    public static 
    void 
    consumeObject( JSONParser parser ) 
    {
        Integer depth = 0;
        do {
            JSONToken curr = parser.getCurrentToken();
            if (curr == JSONToken.START_OBJECT || 
                curr == JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == JSONToken.END_OBJECT ||
                curr == JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    
} // /END Class