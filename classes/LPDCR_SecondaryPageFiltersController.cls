/******************************************************************************
 * Controller for the LPDCR_SecondaryPageFilters component
 * 
 * @Author: Magnet 360
 * @Date: Mar 28, 2017 
 * @Jira: LPDCR-2230
 */

public with sharing class 
LPDCR_SecondaryPageFiltersController
    extends LPDCR_ComponentBaseController
{

    public LPDCR_ContentServiceUtil content_service
    {
        get
        {
            if( content_service == null )
            {
                content_service = new LPDCR_ContentServiceUtil();
            }
            return content_service;
        }
        set;
    }
    
    private List<LPDCR_BLSpecies.PurinaBusinessLink_Species> species_list { get; set; }
    
    public Set<String> species_filter { get; set; }
    public Set<String> file_type_filter { get; set; }
    public Boolean internalOnly { get; set;}
    public String clicked_specie { get; set; }
    public String clicked_file_type { get; set; }
    //String pageName = ApexPages.CurrentPage().getUrl().substringAfter('apex/');
    
    public String sort_filter
    {
        get; 
        set
        {
                                                 // If sort_filter is already set
                                                 // to the value being passed to it,
                                                 // the user has deselectd the sort
                                                 // option. Reset the sort_filter 
                                                 // value to be empty
            if( sort_filter == value )
            {
               sort_filter = '';
               //sort_filter ='Date DESC';
            }
            else
            {
                sort_filter = value;
            }            
        }
    }

/******************************************************************************
 * Constructor
 */
    public
    LPDCR_SecondaryPageFiltersController()
    {
        System.debug( 'START: LPDCR_SecondaryPageFiltersController.constructor()' );
        
        species_filter = new Set<String>();
        file_type_filter = new Set<String>();
        sort_filter = '';
        internalOnly = False;
        System.debug('sort_filter Value Controller--' + sort_filter);
        System.debug( 'END: LPDCR_SecondaryPageFiltersController.constructor()' );
    }

/******************************************************************************
 * Method to add or remove the specified Specie name from the species_filter
 */
    public
    PageReference
    updateSpeciesFilter()
    {
        System.debug( 'START: LPDCR_SecondaryPageFiltersController.updateSpeciesFilter()' );
        System.debug( 'Param: clicked_specie = ' + clicked_specie );
        
        if( species_filter.contains( clicked_specie ) )
        {
            species_filter.remove( clicked_specie );
        }
        else
        {
            species_filter.add( clicked_specie );
        }
        
        System.debug( 'species_filter = ' + species_filter );
        System.debug( 'END: LPDCR_SecondaryPageFiltersController.updateSpeciesFilter()' );
        
        return null;
    } 

/******************************************************************************
 * Method to add or remove the specified File Type name from the file_type_filter set
 */
    public
    PageReference
    updateFileTypeFilter()
    {
        System.debug( 'START: LPDCR_SecondaryPageFiltersController.updateFileTypeFilter()' );
        System.debug( 'Param: clicked_file_type = ' + clicked_file_type );
        
        if( file_type_filter.contains( clicked_file_type ) )
        {
            file_type_filter.remove( clicked_file_type );
        }
        else
        {
            file_type_filter.add( clicked_file_type );
        }
        
        System.debug( 'file_type_filter = ' + file_type_filter );
        System.debug( 'END: LPDCR_SecondaryPageFiltersController.updateFileTypeFilter()' );
        return null;
    } 


/******************************************************************************
 * Method to reset all the filter variables to empty
 */
    public
    PageReference
    resetFilters()
    {
        System.debug( 'START: LPDCR_SecondaryPageFiltersController.resetFilters()' );
        
        species_filter.clear();
        file_type_filter.clear();
        sort_filter = '';
        //sort_filter ='Date DESC';
        if(sort_filter == ''){
            sort_filter ='Date DESC';
        }
        internalOnly = False;
        
        System.debug('reset sort_filter-- ' + sort_filter );
        System.debug( 'END: LPDCR_SecondaryPageFiltersController.resetFilters()' );
        return null;
    } 

/******************************************************************************
 * Getter method to return the species list
 */
    public
    List<LPDCR_BLSpecies.PurinaBusinessLink_Species>
    getSpeciesList()
    {
        System.debug( 'START: LPDCR_SecondaryPageFiltersController.getSpeciesList()' );
        
        if( species_list == null )
        {
            species_list = content_service.getSpecies().getSpeciesList();
        }
        
        System.debug( 'Return: species_list = ' + species_list );
        System.debug( 'END: LPDCR_SecondaryPageFiltersController.getSpeciesList()' );
        
        return species_list;
    }
    
    //Set sort Filter
    public PageReference setSortFilter(){
        System.debug( 'START: LPDCR_SecondaryPageFiltersController.setSortFilter()' );
        
        System.debug( 'sort_filter = ' + sort_filter);
       
        System.debug( 'after if sort_filter = ' + sort_filter);
        System.debug( 'END: LPDCR_SecondaryPageFiltersController.setSortFilter()' );
        
       //LPDCR_SecondaryNationalEventsController.sortBy = sort_filter;
       //LPDCR_SecondaryVIPFarmController.sortBy = sort_filter;
        
        
        return null;
    }

/******************************************************************************
 * Getter method to return the list of available file types for the documents
 */
    public
    Set<String>
    getMarketingFileTypes()
    {
        System.debug( 'START: LPDCR_SecondaryPageFiltersController.getMarketingFileTypes()' );
        String pageName = ApexPages.CurrentPage().getUrl().substringAfter('apex/');
        Set<String> l_file_types;
        List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> l_documents;
        System.debug('pageName---'+ pageName);
        
        if(pageName.startsWithIgnoreCase( 'LPDCR_CC_MarketingPage' ) ) {
            l_documents = ( ( LPDCR_CC_MarketingPageController ) pageController ).mediaToolsController.documentList;
            
            System.debug( 'PageController Document List = ' + l_documents );
        }
        
        else if(pageName.startsWithIgnoreCase( 'LPDCR_CC_VIP' ) ) {
            l_documents = ( ( LPDCR_CC_VIP_Controller ) pageController ).eventPlanningController.documentList;
            
            System.debug( 'PageController Document List = ' + l_documents );
        }
        
        else if(pageName.startsWithIgnoreCase( 'LPDCR_CC_ProductPage' )
                && ( ( LPDCR_CC_ProductPageController ) pageController ).salesToolsController.salesToolLst != null 
                && ( ( LPDCR_CC_ProductPageController ) pageController ).page_title == Label.LPDCR_ProductSalesTools_Subtab_Name) {
            l_documents = ( ( LPDCR_CC_ProductPageController ) pageController ).salesToolsController.salesToolLst;
        }
        
        else if(pageName.startsWithIgnoreCase( 'LPDCR_CC_Business_Management' )
                && ( ( LPDCR_CC_BusinessManagementController ) pageController ).VFDController.vfdLst != null 
                && ( ( LPDCR_CC_BusinessManagementController ) pageController ).page_title == Label.LPDCR_VFD_Subtab_Name) { 
            l_documents = ( ( LPDCR_CC_BusinessManagementController ) pageController ).VFDController.vfdLst;
            
            System.debug( '.......PageController Document List = ' + l_documents );
        }
        
        else if(pageName.startsWithIgnoreCase( 'LPDCR_CC_Business_Management' ) 
                && ( ( LPDCR_CC_BusinessManagementController ) pageController ).FeedSafetyController.feedSafetyLst != null 
                && ( ( LPDCR_CC_BusinessManagementController ) pageController ).page_title == Label.LPDCR_Feed_Safety_Subtab_Name) { 
            l_documents = ( ( LPDCR_CC_BusinessManagementController ) pageController ).FeedSafetyController.feedSafetyLst;
            
            System.debug( 'PageController Document List = ' + l_documents );
        }
        
        else if(pageName.startsWithIgnoreCase( 'LPDCR_CC_Business_Management' ) 
                && ( ( LPDCR_CC_BusinessManagementController ) pageController ).flmContentController.flmLst != null 
                && ( ( LPDCR_CC_BusinessManagementController ) pageController ).page_title == Label.LPDCR_FLM_Subtab_Name) { 
            l_documents = ( ( LPDCR_CC_BusinessManagementController ) pageController ).flmContentController.flmLst;
            
            System.debug( 'PageController Document List = ' + l_documents );
        }
      
        if(pageName.startsWithIgnoreCase( 'LPDCR_SearchResults' ) ) {
            l_documents = ( ( LPDCR_SearchResultsController ) pageController ).resultsListController.results;
            
            System.debug( 'PageController Document List = ' + l_documents );
        }
    
        System.debug( 'Final Document List = ' + l_documents );
        if( l_documents != null ) {
            l_file_types = LPDCR_BLDocuments.getFileTypes( l_documents );
        }
        
        System.debug( 'Return: l_file_types = ' + l_file_types );
        System.debug( 'END: LPDCR_SecondaryPageFiltersController.getMarketingFileTypes()' );
        
        return l_file_types;
    }
    
    //Check Internal USer
    public void updateSalesContentFilter(){
        if(internalOnly == False){
            internalOnly = True;
        }
        else{
            internalOnly = False;
        }
    }

} // /END Class