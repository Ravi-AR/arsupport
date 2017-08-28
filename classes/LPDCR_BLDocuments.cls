/**
*   @Author:    Heena Tanna
*   @Date:      31.03.2017
*   @Jira:      LPDCR-2011
*   @Purpose:   Controller behind Logos and Package Imaging Data for Marketing component
*/

public without sharing class LPDCR_BLDocuments 
    extends LPDCR_ContentCalloutResponse
{
    public static String sortBy { get; set; }
    
                                                 // Account record for the current
                                                 // user. Used to determine access
                                                 // to documents
    private Account current_user_account
    {
        get
        {
            if( current_user_account == null )
            {
                if( UserInfo.getUserType() == 'STANDARD' )
                {
                    current_user_account = new Account();
                }
                else
                {
                    current_user_account = [ SELECT Id,Name,Feed_License_Manufacturer__c
                                             FROM Account
                                             WHERE Id = :LPDCR_ChangeAccountController.getSelectedAccId()
                                             LIMIT 1 ] ;
                   System.debug('current_user_account--'+ current_user_account);                          
                }
            }
            return current_user_account;
        }
        set;
    }
    
    public class PurinaBusinessLink_Documents_Z{
        public List<PurinaBusinessLink_Documents> PurinaBusinessLink_Documents{get;set;}
        public List<TotalRecords> TotalRecords;
  
    }
  
    public List<PurinaBusinessLink_Documents_Z> PurinaBusinessLink_Documents{get;set;}

    public class TotalRecords{
        public String TotalRecords;  
    }

/******************************************************************************
 * Base empty constructor for the class
 */
    public
    LPDCR_BLDocuments()
    { }

/******************************************************************************
 * Constructor to build the class from the list of Document search results
 */
    public
    LPDCR_BLDocuments( List<LPDCR_ContentSearchResult.DocumentSearchResult> a_document_search_results )
    { 
        System.debug( 'START: LPDCR_BLDocuments.constructor()' );
        
        this.PurinaBusinessLink_Documents = new List<PurinaBusinessLink_Documents_Z>();
        List<PurinaBusinessLink_Documents> l_docs = new List<PurinaBusinessLink_Documents>();
                                                 // For each search result, create a
                                                 // a PurinaBusinessLink_Documents record
                                                 // and add it to the list
        for( LPDCR_ContentSearchResult.DocumentSearchResult l_dsr : a_document_search_results )
        {
            PurinaBusinessLink_Documents l_doc = new PurinaBusinessLink_Documents();
                                                 // Set search result fields
            l_doc.id = l_dsr.Id;
            l_doc.type = l_dsr.type;
            l_doc.score = l_dsr.score;
            l_doc.position = l_dsr.position;
            l_doc.title = l_dsr.title;
            l_doc.content = l_dsr.content;
            l_doc.created = l_dsr.created;
            l_doc.image = l_dsr.image;
            l_doc.imageclass = l_dsr.imageclass;
            l_doc.absscore = l_dsr.absscore;
            l_doc.maxscore = l_dsr.maxscore;
            l_doc.index = l_dsr.index;
                                                 // Set document info fields
            l_doc.DocumentFilePath = l_dsr.DocumentFilePath;
            l_doc.DocumentHasLandingPage = l_dsr.DocumentHasLandingPage;
            l_doc.DocumentsLastModified = l_dsr.DocumentsLastModified;
            l_doc.DocumentSubBrand = l_dsr.DocumentSubBrand;
            l_doc.ShowOnHomePage = l_dsr.ShowOnHomePage;
            l_doc.LinkPath = l_dsr.LinkPath;
            l_doc.ShowInPromoImageCarousel = l_dsr.ShowInPromoImageCarousel;
            l_doc.DocumentShortDescription = l_dsr.DocumentShortDescription;
            l_doc.DocumentLocation = l_dsr.DocumentLocation;
            l_doc.ReviewRemoveDate = null;
            l_doc.CarouselTextArea = l_dsr.CarouselTextArea;
            l_doc.DocumentsID = null;
            l_doc.FileOrLink = l_dsr.FileOrLink;
            l_doc.DocumentKeywords = l_dsr.DocumentKeywords;
            l_doc.DocumentType = l_dsr.DocumentType;
            l_doc.DocumentProduct = l_dsr.DocumentProduct;
            l_doc.LinkOpenInNewWindow = l_dsr.LinkOpenInNewWindow;
            l_doc.DocumentsGuid = null;
            l_doc.CarouselImage = l_dsr.CarouselImage;
            l_doc.DocumentBrand = l_dsr.DocumentBrand;
            l_doc.DocumentOrLink = l_dsr.DocumentOrLink;
            l_doc.DocumentWYSIWYG = l_dsr.DocumentWYSIWYG;
            l_doc.CarouselHeadline = l_dsr.CarouselHeadline;
            l_doc.DocumentSpecies = l_dsr.DocumentSpecies;
            l_doc.IsActive = l_dsr.IsActive;
            l_doc.DocumentName = l_dsr.DocumentName;
            if( l_dsr.InternalOnly == null )
            {
                l_dsr.InternalOnly = false;
            }
            l_doc.InternalOnly = l_dsr.InternalOnly;
            l_doc.VideoUrl = l_dsr.VideoUrl;
            l_doc.StartDate = l_dsr.StartDate;
            l_doc.ExpirationDate = l_dsr.ExpirationDate;
            l_doc.ItemOrder = l_dsr.position;
            l_doc.Plants = l_dsr.Plants;
            
            l_docs.add( l_doc );
        }// /END for( a_document_search_results )
        
        PurinaBusinessLink_Documents_Z l_doc_z = new PurinaBusinessLink_Documents_Z();
        l_doc_z.PurinaBusinessLink_Documents = l_docs;
        l_doc_z.TotalRecords = new List<TotalRecords>();
        TotalRecords l_records = new TotalRecords();
        l_records.TotalRecords = String.valueOf( l_docs.size() );
        l_doc_z.TotalRecords.add( l_records );
        
        this.PurinaBusinessLink_Documents.add( l_doc_z );  
        
        System.debug( 'END: LPDCR_BLDocuments.constructor()' );
    }// /END LPDCR_BLDocuments constructor


/******************************************************************************
 * Wrapper class to hold the document details
 */  
    public class PurinaBusinessLink_Documents
        implements Comparable
    {
                                                 // Search result fields. Only
                                                 // returned from the search API
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
                                                 // Document Info fields. Returned
                                                 // from both the search api and
                                                 // the direct document web service
        public String DocumentFilePath {get;set;}
        public Boolean DocumentHasLandingPage {get;set;}
        public DateTime DocumentsLastModified  {get;set;}
        public String DocumentSubBrand {get;set;}
        public Boolean ShowOnHomePage {get;set;}
        public String LinkPath {get;set;}
        public Boolean ShowInPromoImageCarousel {get;set;}
        public String DocumentShortDescription {get;set;}
        public String DocumentLocation {get;set;}
        public String ReviewRemoveDate {get;set;}
        public String CarouselTextArea {get;set;}
        public Integer DocumentsID {get;set;}
        public String FileOrLink {get;set;}
        public String DocumentKeywords {get;set;}
        public String DocumentType {get;set;}
        public String DocumentProduct {get;set;}
        public Boolean LinkOpenInNewWindow {get;set;}
        public String DocumentsGuid {get;set;}
        public String CarouselImage {get;set;}
        public String DocumentBrand {get;set;}
        public String DocumentOrLink {get;set;}
        public String DocumentWYSIWYG {get;set;}
        public String CarouselHeadline {get;set;}
        public String DocumentSpecies {get;set;}
        public Boolean IsActive {get;set;}
        public String DocumentName {get;set;}
        public Boolean InternalOnly {get;set;}
        public String VideoUrl {get;set;}
        public DateTime StartDate {get;set;}
        public DateTime ExpirationDate {get;set;}
        public String ItemOrder {get;set;}
        public String Plants {get;set;}

        
                                                 // Custom variable for the object
                                                 // that is set when the in the list
                                                 // of PurinaBusinessLink_Documents
                                                 // objects is returned from the
                                                 // getDocumentsList() method
        public String FileType {get;set;}
                                                 // Custom variable used to indicate
                                                 // that the file type is web friendly
        public Boolean IsWebVisibleFile {get;set;}
                                                 // Custom variable to help return the
                                                 // proper URL Link to the file/website/video
        public String URLLink
        {
            get
            {
                if( URLLink == null || URLLink == '' )
                {
                    if( VideoUrl != null )
                    {
                        URLLink = VideoUrl;
                    }
                    else if( LinkPath != null )
                    {
                        URLLink = LinkPath;
                    }
                    else
                    {
                        URLLink = DocumentFilePath;
                    }
                }
                return URLLink;
            }
            set;
        }
        
        
        /**********************************************************************
         * Dynamic compareTo method to sort the documents based on the parent
         * sortBy static variable value
         */
        public
        Integer
        compareTo( Object a_compare_to )
        {
            PurinaBusinessLink_Documents l_document = ( PurinaBusinessLink_Documents ) a_compare_to;
            
            if( LPDCR_BLDocuments.sortBy.equals( 'Date DESC' ) )
            {
                if( DocumentsLastModified < l_document.DocumentsLastModified )
                {
                    return 1;
                }
                else
                {
                    return 0;
                }
            }
            else if( LPDCR_BLDocuments.sortBy.equals( 'Date ASC' ) )
            {
                if( DocumentsLastModified > l_document.DocumentsLastModified )
                {
                    return 1;
                }
                else
                {
                    return 0;
                }       
            }
            else if( LPDCR_BLDocuments.sortBy.equals( 'Name DESC' ) )
            {
                if( DocumentName < l_document.DocumentName )
                {
                    //System.debug(DocumentName +'......'+l_document.DocumentName );
                    return 1;
                }
                else
                {
                    return 0;
                }       
            }
            else
            {
                                                 // This is the default sorting
                                                 // ( LPDCR_BLDocuments.sortBy.equals( 'Name ASC' ) )
                if( DocumentName > l_document.DocumentName )
                {
                    return 1;
                }
                else
                {
                    return 0;
                }
            }
        }// / END compareTo() method
        
    }// /END Inner Class PurinaBusinessLink_Documents
  
/*******************************************************************************
  * Method to Parse the JSON Response from Kentico WS
  */
    public static LPDCR_BLDocuments parse( String json ) {
        
        LPDCR_BLDocuments response = new LPDCR_BLDocuments();
        
        // System.debug('Document JSON generated--'+json);
        try{
            response = (LPDCR_BLDocuments) System.JSON.deserialize(json, LPDCR_BLDocuments.class);
            response.success = true;
        }
        catch( Exception ex ){
            response.success = false;
            LPDCR_ParsingException exceptionDocuments = new LPDCR_ParsingException( 'LPDCR_BLDocuments',json,ex );
            
            LOLUtilities.LogErrMsg( 'LPDCR_BLDocuments.parse()',ex,': Message = ' + ex.getMessage()+' : Param JSON = ' + json );

            response.ex = exceptionDocuments; 
            throw exceptionDocuments;
        }
        
        return response;
    }

/******************************************************************************
 * Method to return the list of Documents records as PurinaBusinessLink_Documents 
 */
    public 
    List<PurinaBusinessLink_Documents> 
    getDocumentsList()
    {
        System.debug( 'START: LPDCR_BLDocuments.getDocumentsList()' );
        
        List<PurinaBusinessLink_Documents> l_document_list = new List<PurinaBusinessLink_Documents>();
                                                 // Permission set security is not
                                                 // ready to be implemented
        Map<String, Boolean> l_user_permissions = LPDCR_ContentServiceUtil.getcurrentUserPerSet();
        Boolean l_allow_add;
        
        if( PurinaBusinessLink_Documents != null ) 
        {
            for( PurinaBusinessLink_Documents_Z l_documents_z : PurinaBusinessLink_Documents )
            {
                if( l_documents_z != null && l_documents_z.PurinaBusinessLink_Documents != null )
                {
                    for( PurinaBusinessLink_Documents l_doc : l_documents_z.PurinaBusinessLink_Documents )
                    {
                        if( canUserAccessDocument( l_doc, l_user_permissions ) )
                        {
                                                 // Default the IsWebVisibleFile flag
                            l_doc.IsWebVisibleFile = false;
                        
                                                 // Set the FileType variable for
                                                 // the record before the full URL
                                                 // path is added to the DocumentFilePath
                            if( l_doc.DocumentFilePath != null 
                                && l_doc.DocumentFilePath.split( 'ext=' ).size() > 1)
                            {
                                l_doc.FileType = l_doc.DocumentFilePath.split( 'ext=' )[ 1 ];
                                System.debug('---condition 1....'+l_doc.FileType);
                            }
                            else if( l_doc.DocumentFilePath != null )
                            {
                                                 // If "ext=" is not added to the Path,
                                                 // attempt to determine it
                                List<String> l_parts = l_doc.DocumentFilePath.split( '\\.' );
                                if( l_parts.size() > 0 
                                    && l_parts[ l_parts.size() - 1 ].length() <= 4 )
                                {
                                    l_doc.FileType = '.' + l_parts[ l_parts.size() - 1 ];
                                }
                                System.debug('---condition 2....'+l_doc.FileType);
                            }
                            else if( l_doc.DocumentFilePath == null && l_doc.VideoUrl != null )
                            {
                                l_doc.FileType = 'YouTube Video';
                                System.debug('---condition 3....'+l_doc.FileType);
                            }
                            else
                            {
                                l_doc.FileType = 'Other';
                                System.debug('---condition 4....'+l_doc.FileType);
                            }
                                                 // Check to see if the found file type
                                                 // is web visible
                            if( l_doc.FileType != null && Label.LPDCR_Web_Visible_File_Types.contains( l_doc.FileType ) )
                            {
                                l_doc.IsWebVisibleFile = true;
                            }
                            
                            if( l_doc.LinkPath != null && l_doc.LinkPath.startsWith( '~/' )){
                                l_doc.LinkPath = l_doc.LinkPath.replace( '~', LPDCR_Org_Settings__c.getInstance().Kentico_Resource_URL_Prefix__c );
                            }
                            if(l_doc.FileOrLink != null && l_doc.FileOrLink.startsWith('~/')){
                                l_doc.FileOrLink = l_doc.FileOrLink.replace( '~', LPDCR_Org_Settings__c.getInstance().Kentico_Resource_URL_Prefix__c );
                            }
                            if(l_doc.DocumentWYSIWYG != null && l_doc.DocumentWYSIWYG.contains('~/')){
                                l_doc.DocumentWYSIWYG = l_doc.DocumentWYSIWYG.replace( '~', LPDCR_Org_Settings__c.getInstance().Kentico_Resource_URL_Prefix__c );
                            }
                            if( l_doc.DocumentFilePath != null && l_doc.DocumentFilePath.startsWith( '~/' )){
                                l_doc.DocumentFilePath = l_doc.DocumentFilePath.replace( '~', LPDCR_Org_Settings__c.getInstance().Kentico_Resource_URL_Prefix__c );
                            }
                            if( l_doc.CarouselImage != null && l_doc.CarouselImage.startsWith( '~/' )){
                                l_doc.CarouselImage = l_doc.CarouselImage.replace( '~', LPDCR_Org_Settings__c.getInstance().Kentico_Resource_URL_Prefix__c );
                            }
                            if( l_doc.VideoUrl != null && l_doc.VideoUrl.startsWith( '~/' )){
                                l_doc.VideoUrl = l_doc.VideoUrl.replace( '~', LPDCR_Org_Settings__c.getInstance().Kentico_Resource_URL_Prefix__c );
                            }
                               
                            l_document_list.add( l_doc );
                        }// /END if( canUserAccessDocument() )
                    }// /END for( l_documents_z.PurinaBusinessLink_Documents )
                }// /END if( l_documents_z != null )
            }// /END for( PurinaBusinessLink_Documents )
        }// /END if( PurinaBusinessLink_Documents != null )
        
        // System.debug( 'Return: l_document_list = ' + l_document_list );        
        System.debug( 'END: LPDCR_BLDocuments.getDocumentsList()' );
        
        return l_document_list;
    }

/******************************************************************************
 * Static method to return a Set of file types from a list of PurinaBusinessLink_Documents
 * objects passed in
 */
    public static
    Set<String> 
    getFileTypes( List<PurinaBusinessLink_Documents> a_docs )
    {
        System.debug( 'START: LPDCR_BLDocuments.getFileTypes()' );
        
        List<String> l_file_types = new List<String>();
        
        if( a_docs != null )
        {
            for( PurinaBusinessLink_Documents l_doc : a_docs )
            {
                if( l_doc.FileType != null )
                {
                    l_file_types.add( l_doc.FileType );
                }
            }// /END for( a_docs )
            
            l_file_types.sort();
        }
        
        System.debug( 'Return: l_file_types' );
        System.debug( 'END: LPDCR_BLDocuments.getFileTypes()' );
        
        return new Set<String>( l_file_types );
    }

/******************************************************************************
 * Static method to filter the list of PurinaBusinessLink_Documents passed in
 * by the specified species and Internal Only parameters
 */
    public static
    List<PurinaBusinessLink_Documents> 
    filterDocuments( List<PurinaBusinessLink_Documents> a_docs,
                     List<String> a_species,
                     List<String> a_file_types,
                     Boolean a_internal_only,
                     String sort_filter )
    {
        System.debug( 'START: LPDCR_BLDocuments.filterDocuments()' );

        Set<PurinaBusinessLink_Documents> l_filtered_docs = new Set<PurinaBusinessLink_Documents>();
        
        Boolean l_proceed;
        Boolean l_species_match;
        Boolean l_file_type_match;
        Boolean l_internal_only_match;

        if( a_internal_only == null )
        {
            a_internal_only = false;
        }
        System.debug('a_species---'+a_species);
        if( ( a_species == null 
              || a_species.size() == 0 )
            && ( a_file_types == null 
                 || a_file_types.size() == 0 )
            && a_internal_only == false )
        {
                                                 // Return all the original documents
            return a_docs;
        }
        
        Map<String, Boolean> l_user_permissions = LPDCR_ContentServiceUtil.getcurrentUserPerSet();
        LPDCR_BLDocuments l_doc_controller = new LPDCR_BLDocuments();
                                                 // Loop over all the documents
                                                 
        for( PurinaBusinessLink_Documents l_doc : a_docs )
        {
            l_proceed = true;
            l_species_match = false;
            l_file_type_match = false;
            l_internal_only_match = false;
                                                 
                                                 // Check if the user has access to 
                                                 // the document
            l_proceed = l_doc_controller.canUserAccessDocument( l_doc, l_user_permissions );
            
                                                 // No need to proceed if this is not
                                                 // an internal only document and the
                                                 // user only wants to see internal documents
            if( l_proceed )
            {
                                                 // If any species are selected,
                                                 // loop over them and add only
                                                 // those that match
                if( a_species !=null && a_species.size() > 0 )
                {
                    for( String l_specie : a_species )
                    {
                        if( l_doc.DocumentSpecies != null && l_doc.DocumentSpecies.contains( l_specie ) )
                        {
                            l_species_match = true;
                                                 // Only 1 specie needs to be matched
                                                 // Break out of the specie loop
                            break;
                        }
                    }// /END for( a_species )
                }
                else
                {                                                 
                                                 // If no species are selected,
                                                 // match this document
                    l_species_match = true;
                }
                
                                                 // If any file types are selected
                                                 // loop over the file types and add
                                                 // only those documents that match 
                                                 // a file type to the final doc list
                if(a_file_types !=null && a_file_types.size() > 0)
                {
                    for( String l_file_type : a_file_types )
                    {
                        if( l_doc.FileType != null && l_doc.FileType.contains( l_file_type ) )
                        {
                            l_file_type_match = true;
                            break;
                        }        
                    }// /END for( l_filtered_docs )
                }
                else
                {
                                                 // if no file types are selected,
                                                 // match this document
                    l_file_type_match = true;
                    
                }// /END if( a_file_types.size() >= 0 )
                
                                                 // If a_internal_only is true, and the
                                                 // user is an internal user, loop over
                                                 // the filtered doc list
                if( a_internal_only != true )
                {
                    l_internal_only_match = true;
                }
                else if( a_internal_only && UserInfo.getUserType() != 'Standard' )
                {
                                                 // Prevent internal only documents
                                                 // from being returned to external users
                    l_internal_only_match = false;
                }
                else if( a_internal_only 
                         && UserInfo.getUserType() == 'Standard'
                         && l_doc.InternalOnly )
                {
                    l_internal_only_match = true;
                }// /END if( Internal Only )
                
                                                 // If all the filter criteria is matched,
                                                 // add the record to the list of
                                                 // returned results
                if( l_species_match && l_file_type_match && l_internal_only_match )
                {
                    l_filtered_docs.add( l_doc );
                }
                     
            }// /END if( l_proceed )
        }// /END loop over all the documents
        List<PurinaBusinessLink_Documents> finalDocList = new List<PurinaBusinessLink_Documents>();
        for(PurinaBusinessLink_Documents doc:l_filtered_docs){
            finalDocList.add(doc);
        }

        System.debug( 'START: LPDCR_BLDocuments.filterDocuments()' );
        
        return finalDocList;
    }
    

/******************************************************************************
 * Method to check to see if the current user has access to a document record
 * based on internal/external user, permission sets, or account settings
 *
 * @Param PurinaBusinessLink_Documents a_doc : The document record to check access to
 * @Param Map<String, Boolean> a_user_permissions : A map of the users permission sets
 */
    public
    Boolean
    canUserAccessDocument( PurinaBusinessLink_Documents a_doc, Map<String, Boolean> a_user_permissions )
    {
        Boolean l_has_access = true;
                                                 // Internal users have access to
                                                 // everything
        if( UserInfo.getUserType() != 'STANDARD' )
        {                                     // Do not add InActive documents
            if( a_doc.IsActive != true )
            {
                l_has_access = false;
            }
                        
                                                 // Make Sure Internal Only documents
                                                 // are not returned to External users
            if( l_has_access && a_doc.InternalOnly )
            {
                l_has_access = false;
            }
                                                 // Check an external users permissions
                                                 // to make sure they have access to 
                                                 // the document record 
            if( l_has_access
                && ( a_doc.DocumentLocation == null || a_doc.DocumentLocation == '' ) )
            {
                                                 // If no security is set, no external
                                                 // user can see it
                l_has_access = false;
            }  
            else if( l_has_access
                     && a_doc.DocumentLocation != null )
            {
                                                 // Loop over the security field values
                                                 // and compare them against
                for( String l_security : a_doc.DocumentLocation.split( '\\|' ) )
                {
                    if( a_user_permissions.get( l_security ) == true )
                    {
                        l_has_access = true;
                        break;
                    }
                    else
                    {
                        l_has_access = false;
                    }
                }
            }// /END if l_allow_add
            
                                                 // If this is a Feed License Manufacture
                                                 // document type, make sure the users
                                                 // account is marked for FLM in order
                                                 // before granting access to it
            if( l_has_access && a_doc != null 
                && current_user_account != null
                && a_doc.DocumentType != null
                && a_doc.DocumentType.contains( 'Feed License Manufacturer' )
                && ! current_user_account.Feed_License_Manufacturer__c )
            {
                l_has_access = false;
            }
            
            
        }// /END if( UserInfo.getUserType() == 'STANDARD' )
        
        return l_has_access;
    }
     
}// /END Class