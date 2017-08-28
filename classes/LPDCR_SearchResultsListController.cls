/******************************************************************************
 * Controller for the LPDCR_SearchResultsList component. Displays the 
 * results of the global search
 * 
 * @Author: Magnet 360
 * @Date: May 25, 2017 
 * @Jira: LPDCR-1992
 */

public with sharing class 
LPDCR_SearchResultsListController
    extends LPDCR_ComponentBaseController  
{

    public String search_term { get; set; }
    public String search_category { get; set; }
    
    public List<Campaign> events { get; set; }
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> results { get; set; }
    public List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions> promotions { get; set; }
    
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> filtered_results 
    {
        get
        { 
            filtered_results = results;
            if( filtered_results != null )
            {
                filtered_results = LPDCR_BLDocuments.filterDocuments( filtered_results,
			                                                          new List<String>( species_filter ),
			                                                          new List<String>( file_type_filter ),
			                                                          internalOnly,
			                                                          null );
            }
            return filtered_results;
        }
        set; 
    }
    
    public List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions> filtered_promotions 
    {
        get
        { 
            filtered_promotions = promotions;
            if( filtered_promotions != null )
            {
                filtered_promotions = LPDCR_BLPromotions.filterPromotions( filtered_promotions,
	                                                                      new List<String>( species_filter ),
	                                                                      internalOnly,
	                                                                      null );
            }
            return filtered_promotions;
        }
        set; 
    }
    
    public List<Campaign> filtered_events 
    {
        get
        { 
            filtered_events = events;
            if( events != null && species_filter != null && species_filter.size() > 0 )
            {
                String l_query = ' SELECT Id, Name, Event_Date_Range__c, Event_Location__c, Short_Description__c '
                               + ' FROM Campaign '
                               + ' WHERE Id IN :events ';
                if( species_filter != null && species_filter.size() > 0 )
                {
                    l_query += ' AND Specie_Focus__c IN :species_filter ';
                }
                filtered_events = Database.query( l_query );
            }
            return filtered_events;
        }
        set; 
    }
    
    public Set<String> species_filter
    {
        get
        {
            return ( ( LPDCR_SearchResultsController ) pageController ).filterController.species_filter;
        } 
        set; 
    }
    public Set<String> file_type_filter
    {
        get
        {
            return ( ( LPDCR_SearchResultsController ) pageController ).filterController.file_type_filter;
        } 
        set; 
    }
    public Boolean internalOnly
    {
        get
        {
            return ( ( LPDCR_SearchResultsController ) pageController ).filterController.internalOnly;
        } 
        set; 
    }

/******************************************************************************
 * Constructor
 */
	public
	LPDCR_SearchResultsListController()
	{
		System.debug( 'START: LPDCR_SearchResultsListController.constructor()' );
		System.debug( 'END: LPDCR_SearchResultsListController.constructor()' );
	}

/******************************************************************************
 * Action Function method to perform the search process. The search category
 * passed into the page determines the type of search (Kentico or Salesforce)
 * and the document type of the results returned
 */
    public
    void
    doSearch()
    {
        System.debug( 'START: LPDCR_SearchResultsController.doSearch()' );
        
        LPDCR_SearchOverviewController l_overview_controller = new LPDCR_SearchOverviewController();
        l_overview_controller.term = this.search_term;
        
        if( this.search_category == null || this.search_category.trim() == '' )
        {   
            this.search_category = LPDCR_SearchOverviewController.DOCUMENTS_SEARCH_CATEGORY;
        }
        
                                                 // Determine what type of search 
                                                 // should be done
        if( this.search_category == LPDCR_SearchOverviewController.EVENTS_SEARCH_CATEGORY )
        {
            l_overview_controller.searchEvents();
            events = l_overview_controller.events;
        }
        else
        {
            l_overview_controller.searchContent();
            
            if( this.search_category == LPDCR_SearchOverviewController.PROMOTIONS_SEARCH_CATEGORY )
            {
	            promotions = l_overview_controller.promotions;
            }
            else if( this.search_category == LPDCR_SearchOverviewController.VIDEOS_SEARCH_CATEGORY )
            {
                results = l_overview_controller.videos;
            }
            else if( this.search_category == LPDCR_SearchOverviewController.IMAGES_SEARCH_CATEGORY )
            {
                results = l_overview_controller.images;
            }
            else if( this.search_category == LPDCR_SearchOverviewController.DOCUMENTS_SEARCH_CATEGORY )
            {
                results = l_overview_controller.documents;
            }
            else if( this.search_category == LPDCR_SearchOverviewController.SALES_RESOURCES_SEARCH_CATEGORY )
            {
                results = l_overview_controller.sales_resources;
            }
            /*
            else if( this.search_category == LPDCR_SearchOverviewController.FEED_MANUALS_SEARCH_CATEGORY )
            {
                results = l_overview_controller.feed_manuals;
            }
            */
        }// /END if( this.search_category )
        
        
        
        System.debug( 'END: LPDCR_SearchResultsController.doSearch()' );
    }


} // /END Class