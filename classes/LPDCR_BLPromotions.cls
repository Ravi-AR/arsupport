/**
*   @Author:    Shruti Mishra
*   @Date:      29.03.2017
*   @Jira:      LPDCR-2329
*   @Purpose:   Controller behind Promotion Data
*/

public with sharing class LPDCR_BLPromotions
extends LPDCR_ContentCalloutResponse
{
    public static String sortBy { get; set; }
    
    public class PurinaBusinessLink_Promotions_Z{
        public List<PurinaBusinessLink_Promotions> PurinaBusinessLink_Promotions{get;set;}
        public List<TotalRecords> TotalRecords{get;set;}
    }
  
    public List<PurinaBusinessLink_Promotions_Z> PurinaBusinessLink_Promotions{get;set;}

    public class TotalRecords{
        public String TotalRecords{get;set;} 
    }

/******************************************************************************
 * Base empty constructor for the class
 */
    public
    LPDCR_BLPromotions()
    { }

/******************************************************************************
 * Constructor to build the class from the list of Promotion search results
 */
    public
    LPDCR_BLPromotions( List<LPDCR_ContentSearchResult.PromotionSearchResult> a_promotion_search_results )
    { 
        System.debug( 'START: LPDCR_BLPromotions.constructor()' );
        
        this.PurinaBusinessLink_Promotions = new List<PurinaBusinessLink_Promotions_Z>();
        List<PurinaBusinessLink_Promotions> l_promotions = new List<PurinaBusinessLink_Promotions>();
                                                 // For each search result, create a
                                                 // a PurinaBusinessLink_Promotions record
                                                 // and add it to the list
        for( LPDCR_ContentSearchResult.PromotionSearchResult l_psr : a_promotion_search_results )
        {
            PurinaBusinessLink_Promotions l_promo = new PurinaBusinessLink_Promotions();

            l_promo.Species = l_psr.Species;
	        l_promo.ItemOrder = l_psr.ItemOrder;
	        l_promo.PromotionsGuid = l_psr.PromotionsGuid;
	        l_promo.CarouselImage = l_psr.CarouselImage;
	        l_promo.ShowOnHomePage = l_psr.ShowOnHomePage;
	        l_promo.Headline = l_psr.Headline;
	        l_promo.ShowInPromoImageCarousel = l_psr.ShowInPromoImageCarousel;
	        l_promo.PromotionsLastModified = l_psr.PromotionsLastModified;
	        l_promo.CarouselDocumentLink = l_psr.CarouselDocumentLink;
	        l_promo.CarouselURLLink = l_psr.CarouselURLLink;
	        l_promo.CarouselTextArea = l_psr.CarouselTextArea;
	        l_promo.WYSIWYG = l_psr.WYSIWYG;
	        l_promo.CarouselButtonLink = l_psr.CarouselButtonLink;
	        l_promo.PromotionsID = l_psr.PromotionsID;
	        l_promo.CarouselButtonText = l_psr.CarouselButtonText;
	        l_promo.CarouselHeadline = l_psr.CarouselHeadline;
	        l_promo.RelatedDocuments = l_psr.RelatedDocuments;
	        l_promo.IsActive = l_psr.IsActive;
	        l_promo.StartDate = l_psr.StartDate;
	        l_promo.ExpirationDate = l_psr.ExpirationDate;
	        l_promo.DocumentType = l_psr.DocumentType;
	        if( l_psr.InternalOnly == null )
            {
                l_psr.InternalOnly = false;
            }
            l_promo.InternalOnly = l_psr.InternalOnly;
	        l_promo.DocumentLocation = l_psr.DocumentLocation;
                                                 
            l_promotions.add( l_promo );
        }// /END for( a_promotion_search_results )
        
        PurinaBusinessLink_Promotions_Z l_promotions_z = new PurinaBusinessLink_Promotions_Z();
        l_promotions_z.PurinaBusinessLink_Promotions = l_promotions;
        l_promotions_z.TotalRecords = new List<TotalRecords>();
        TotalRecords l_records = new TotalRecords();
        l_records.TotalRecords = String.valueOf( l_promotions.size() );
        l_promotions_z.TotalRecords.add( l_records );
        
        this.PurinaBusinessLink_Promotions.add( l_promotions_z ); 
        
        System.debug( 'END: LPDCR_BLPromotions.constructor()' );
    }

/******************************************************************************
 * Wrapper class to hold the promotion details
 */      
    public class PurinaBusinessLink_Promotions
        implements Comparable
    {
        public String Species{get;set;}
        public Integer ItemOrder{get;set;}
        public String PromotionsGuid{get;set;}
        public String CarouselImage{get;set;}
        public Boolean ShowOnHomePage{get;set;}
        public String Headline{get;set;}
        public Boolean ShowInPromoImageCarousel{get;set;}
        public DateTime PromotionsLastModified{get;set;}
        public String CarouselDocumentLink{get;set;}
        public String CarouselURLLink{get;set;}
        public String CarouselTextArea{get;set;}
        public String WYSIWYG{get;set;}
        public String CarouselButtonLink{get;set;}
        public Integer PromotionsID{get;set;}
        public String CarouselButtonText{get;set;}
        public String CarouselHeadline{get;set;}
        public String RelatedDocuments{get;set;}
        public Boolean IsActive{get;set;}
        public DateTime StartDate { get; set; }
        public DateTime ExpirationDate { get; set; }
        public String DocumentType { get; set; }
        public Boolean InternalOnly { get; set; }
        public String DocumentLocation { get; set; }

        /**********************************************************************
         * Dynamic compareTo method to sort the documents based on the parent
         * sortBy static variable value
         */
        public
        Integer
        compareTo( Object a_compare_to )
        {
            PurinaBusinessLink_Promotions l_promo = ( PurinaBusinessLink_Promotions ) a_compare_to;
            
            if( LPDCR_BLPromotions.sortBy == null )
            {
                LPDCR_BLPromotions.sortBy = '';
            }
            
            if( LPDCR_BLPromotions.sortBy.equals( 'Date DESC' ) )
            {
                if( StartDate < l_promo.StartDate )
                {
                    return 1;
                }
                else
                {
                    return 0;
                }
            }
            else if( LPDCR_BLPromotions.sortBy.equals( 'Date ASC' ) )
            {
                if( StartDate > l_promo.StartDate )
                {
                    return 1;
                }
                else
                {
                    return 0;
                }       
            }
            else if( LPDCR_BLPromotions.sortBy.equals( 'Name DESC' ) )
            {
                if( Headline < l_promo.Headline )
                {
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
                                                 // ( LPDCR_BLPromotions.sortBy.equals( 'Name ASC' ) )
                if( Headline > l_promo.Headline )
                {
                    return 1;
                }
                else
                {
                    return 0;
                }
            }
        }// / END compareTo() method
        
    }
  
/*******************************************************************************
  * Method to Parse the JSON Response from Kentico WS
  */
    public static LPDCR_BLPromotions parse( String json ) {
        
        LPDCR_BLPromotions response = new LPDCR_BLPromotions();

        try{
            response = (LPDCR_BLPromotions) System.JSON.deserialize(json, LPDCR_BLPromotions.class);
            if(response != null){
                response.success = true;
            }
            else{
                response = new LPDCR_BLPromotions();
            }
        }
        catch( Exception ex ){
            response.success = false;            
            LPDCR_ParsingException exceptionCampaigns = new LPDCR_ParsingException( 'LPDCR_BLPromotions',json,ex );
            LOLUtilities.LogErrMsg( 'LPDCR_BLPromotions.parse()',ex,': Message = ' + ex.getMessage()+' : Param JSON = ' + json );
            
            response.ex = exceptionCampaigns;                
            throw exceptionCampaigns;            
        }
        
        return response;
    }
    
/******************************************************************************
 * Method to return the list of Promotion records as PurinaBusinessLink_Promotions 
 */
    public 
    List<PurinaBusinessLink_Promotions> 
    getPromotionsList()
    {
        System.debug( 'START: LPDCR_BLPromotions.getPromotionsList()' );
        
        List<PurinaBusinessLink_Promotions> l_promotions_list = new List<PurinaBusinessLink_Promotions>();
        Map<String, Boolean> l_user_permissions = LPDCR_ContentServiceUtil.getcurrentUserPerSet();
        Boolean l_allow_add;
        
        if( PurinaBusinessLink_Promotions != null ) 
        {
            for( PurinaBusinessLink_Promotions_Z l_promos_z : PurinaBusinessLink_Promotions )
            {
                
                if( l_promos_z != null && l_promos_z.PurinaBusinessLink_Promotions != null)
                {
                    
                    for( PurinaBusinessLink_Promotions l_promo : l_promos_z.PurinaBusinessLink_Promotions )
                    {
                        l_allow_add = true;
                        
                                                 // Do not add InActive documents
                        if( l_promo.IsActive != true )
                        {
                            l_allow_add = false;
                        }
                        
                        l_allow_add = canUserViewPromotion( l_promo, l_user_permissions );
                        
                        if( l_allow_add )
                        {
	                        if( l_promo.CarouselDocumentLink != null && l_promo.CarouselDocumentLink.startsWith( '~/' ) ){
	                            l_promo.CarouselDocumentLink = l_promo.CarouselDocumentLink.replace( '~', LPDCR_Org_Settings__c.getInstance().Kentico_Resource_URL_Prefix__c );
	                        }
	                        if(l_promo.CarouselURLLink != null && l_promo.CarouselURLLink.startsWith('~/')){
	                            l_promo.CarouselURLLink = l_promo.CarouselURLLink.replace( '~', LPDCR_Org_Settings__c.getInstance().Kentico_Resource_URL_Prefix__c );
	                        }
	                        else if( l_promo.CarouselURLLink != null && ! l_promo.CarouselURLLink.startsWith( 'http' ) )
                            {
                                l_promo.CarouselURLLink = 'http://' + l_promo.CarouselURLLink;                                
                            }
	                        if(l_promo.WYSIWYG != null && l_promo.WYSIWYG.contains('~/')){
	                            l_promo.WYSIWYG = l_promo.WYSIWYG.replace( '~', LPDCR_Org_Settings__c.getInstance().Kentico_Resource_URL_Prefix__c );
	                        }
	                        if( l_promo.CarouselButtonLink != null && l_promo.CarouselButtonLink.startsWith( '~/' ) ){
	                            l_promo.CarouselButtonLink = l_promo.CarouselButtonLink.replace( '~', LPDCR_Org_Settings__c.getInstance().Kentico_Resource_URL_Prefix__c );
	                        }
	                        else if( l_promo.CarouselButtonLink != null && ! l_promo.CarouselButtonLink.startsWith( 'http' ) )
                            {
                                l_promo.CarouselButtonLink = 'http://' + l_promo.CarouselButtonLink;
                            }
	                        if( l_promo.CarouselImage != null && l_promo.CarouselImage.startsWith( '~/' ) ){
	                            l_promo.CarouselImage = l_promo.CarouselImage.replace( '~', LPDCR_Org_Settings__c.getInstance().Kentico_Resource_URL_Prefix__c );
	                        }
	                        l_promotions_list.add( l_promo );
                        }// /END if( l_allow_add )
                    }// /END for( l_promos_z.PurinaBusinessLink_Promotions )
                }// /END if( l_documents_z != null )
            }// /END for( PurinaBusinessLink_Promotions )
        }// /END if( PurinaBusinessLink_Promotions != null )
        
        System.debug( 'Return: l_promotions_list = ' + l_promotions_list );        
        System.debug( 'END: LPDCR_BLPromotions.getPromotionsList()' );
        
        return l_promotions_list;
    }
    
/******************************************************************************
 * Static method to filter the list of PurinaBusinessLink_Promotions passed in
 * by the specified species and Internal Only parameters
 */
    public static 
    List<PurinaBusinessLink_Promotions> 
    filterPromotions(  List<PurinaBusinessLink_Promotions> a_promotions,
                       List<String> a_species,
                       Boolean a_internal_only,
                       String sort_filter )
    {
        System.debug( 'START: LPDCR_BLPromotions.filterPromotions()' );
        
        Map<String, Boolean> l_user_permissions = LPDCR_ContentServiceUtil.getcurrentUserPerSet();
        
        List<PurinaBusinessLink_Promotions> l_filtered_promos = new List<PurinaBusinessLink_Promotions>();

        Boolean l_proceed;
        Boolean l_species_match;
        Boolean l_internal_only_match;
        
        if( a_internal_only == null ){
            a_internal_only = false;
        }
        
        if(( a_species == null || a_species.size() == 0 ) && a_internal_only == false ){
            return a_promotions;
        }
        
        LPDCR_BLPromotions l_promo_controller = new LPDCR_BLPromotions();
                                                         
        for( PurinaBusinessLink_Promotions l_promo : a_promotions)
        {
            l_proceed = true;
            l_species_match = false;
            l_internal_only_match = false;
            
            System.debug('-->'+a_internal_only +',,'+ UserInfo.getUserType() +',,'+ l_promo.InternalOnly);
            
            l_proceed = l_promo_controller.canUserViewPromotion( l_promo, l_user_permissions);

            if( l_proceed ){
                if( a_species !=null && a_species.size() > 0 )
                {
                    for( String l_specie : a_species )
                    {
                        if( l_promo.Species != null && l_promo.Species.contains( l_specie ) )
                        {
                            l_species_match = true;
                            break;
                        }
                    }// /END for( a_species )
                }
                else
                {                                                 
                    l_species_match = true;
                }
              
                if( a_internal_only != true ){
                    l_internal_only_match = true;
                }
                else if( a_internal_only && UserInfo.getUserType() != 'Standard' ){
                    l_internal_only_match = false;
                }
                else if( l_promo.InternalOnly !=null && a_internal_only && UserInfo.getUserType() == 'Standard' && l_promo.InternalOnly ){
                    l_internal_only_match = true;
                    
                }// /END if( Internal Only )
                
                
                if( l_species_match && l_internal_only_match )
                {                    
                    l_filtered_promos.add( l_promo );
                }
                     
            }// /END if( l_proceed )
        }// /END loop over all the promotions
        
        List<PurinaBusinessLink_Promotions> finalPromotionList = new List<PurinaBusinessLink_Promotions >();
        for(PurinaBusinessLink_Promotions promotion:l_filtered_promos){
            finalPromotionList.add(promotion);
        }

        System.debug( 'START: LPDCR_BLPromotions.filterPromotions()' );
        
        return finalPromotionList;
        
    }

/******************************************************************************
 * Method to check to see if the current user has access to view the promotion
 * based on internal/external user, permission sets, or account settings
 *
 * @Param PurinaBusinessLink_Promotions a_promo : The promotion record to check access to
 * @Param Map<String, Boolean> a_user_permissions : A map of the users permission sets
 */
    public
    Boolean
    canUserViewPromotion( PurinaBusinessLink_Promotions a_promo, 
                          Map<String, Boolean> a_user_permissions )
    {
        System.debug( 'START: LPDCR_BLPromotions.canUserViewPromotion()' );
        
        Boolean l_has_access = true;
        
                                                 // Internal users have access to
                                                 // everything
        if( UserInfo.getUserType() != 'STANDARD' )
        {                                     // Do not add InActive documents
            if( a_promo.IsActive != true )
            {
                l_has_access = false;
            }
                                                 // Make Sure Internal Only Promotions
                                                 // are not returned to External users
		    if( l_has_access 
		        && a_promo.InternalOnly )
		    {
		        l_has_access = false;
		    }
	    
	                             // Check an external users permissions
	                             // to make sure they have access to 
	                             // the document record 
		    if( l_has_access
		        && ( a_promo.DocumentLocation == null || a_promo.DocumentLocation == '' ) )
		    {
	                             // If no security is set, no external
	                             // user can see it
	            l_has_access = false;
		    }  
		    else if( l_has_access
		             && a_promo.DocumentLocation != null )
		    {
	                             // Loop over the DocumentLocation field values
	                             // and compare them against
		        for( String l_security : a_promo.DocumentLocation.split( '\\|' ) )
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
		        }// /END for( a_promo.DocumentLocation.split( '|' ) )
		    }// /END if l_allow_add
        }// /END if(  UserInfo.getUserType() != 'STANDARD' )

        System.debug( 'Return: l_has_access = ' + l_has_access );
        System.debug( 'END: LPDCR_BLPromotions.canUserViewPromotion()' );
        
        return l_has_access;
    }
    
}// /END Class