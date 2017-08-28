/******************************************************************************
 * Controller for the LPDCR_SearchResults page
 * 
 * @Author: Magnet 360
 * @Date: May 25, 2017 
 * @Jira: LPDCR-1992
 */

public with sharing class 
LPDCR_SearchResultsController 
    extends LPDCR_SecondaryPageBaseController
{
                                                 // Create a variable for the
                                                 // controller for each component
                                                 // on the page
    public LPDCR_SecondaryPageFiltersController filterController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPageFiltersController l_controller;
                l_controller = ( LPDCR_SecondaryPageFiltersController ) getComponentControllerMap().get( 'filtersComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryPageFiltersController(); 
        }
    }
    
    public LPDCR_SearchResultsListController resultsListController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SearchResultsListController l_controller;
                l_controller = ( LPDCR_SearchResultsListController ) getComponentControllerMap().get( 'resultsListComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SearchResultsListController(); 
        }
    }

    public String term { get; set; }
    public String type { get; set; }

    public Set<String> species_filter
    {
        get
        {
            return filterController.species_filter;
        } 
        set; 
    }
    public Set<String> file_type_filter
    {
        get
        {
            return filterController.file_type_filter;
        } 
        set; 
    }
        

/******************************************************************************
 * Constructor
 */
	public
	LPDCR_SearchResultsController()
	{
		System.debug( 'START: LPDCR_SearchResultsController.constructor()' );
		System.debug( 'END: LPDCR_SearchResultsController.constructor()' );
	}


    public
    PageReference
    validate()
    {
        System.debug( 'START: LPDCR_SearchResultsController.constructor()' );
        
                                                 // The search term and type should
                                                 // be passed in to the page as parameters
                                                 // If there is no search term, redirect
                                                 // the user to the global search
        this.term = ApexPages.currentPage().getParameters().get( 'term' );
        this.type = ApexPages.currentPage().getParameters().get( 'type' );
        if( this.term == null || this.term.trim() == '' )
        {
            PageReference l_global_search = Page.LPDCR_SearchOverview;
            l_global_search.setRedirect( true );
            return l_global_search;
        }
        
        if( this.type == null || this.type.trim() == '' )
        {   
            this.type = LPDCR_SearchOverviewController.DOCUMENTS_SEARCH_CATEGORY;
        }

        System.debug( 'END: LPDCR_SearchResultsController.constructor()' );
        
        return null;
    }


} // /END Class