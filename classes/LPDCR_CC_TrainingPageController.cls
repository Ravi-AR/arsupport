/******************************************************************************
 * Controller for the LPDCR_CC_TrainingPage VF page.
 * @Author: Shruti
 * @Date: Apr 13, 2017 
 * @Jira: LPDCR-2033
 */
public with sharing class LPDCR_CC_TrainingPageController extends LPDCR_SecondaryPageBaseController{
      
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> purinaUniversityDocList { get; set; }
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> trainingVdoList { get; set; }    
    public String page_title { get; set; }
    public String subtab { get; set; }
    public String selected_title { get; set; }
    public String search_term { get; set; }  
    private Set<String> pageSpecieList;
    private Set<String> pageFileFilterList;
    private String sortFilter;
    private Boolean internalUserOnly;
    
    public Boolean init{
        set;
        get{
            getTrainingData();
            return false;
        }
    }
    
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
    
    //TT30 component variable
    public LPDCR_SecondaryPageTrainingController trainingsController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPageTrainingController l_controller;
                l_controller = ( LPDCR_SecondaryPageTrainingController ) getComponentControllerMap().get( 'tt30Component' );
                if( l_controller != null ) {
                    
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryPageTrainingController(); 
        }
    }
    
    //Purina University Component Variable
    public LPDCR_SecondaryPurinaUniversityCntrlr purinaUniversityController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPurinaUniversityCntrlr l_controller;
                l_controller = ( LPDCR_SecondaryPurinaUniversityCntrlr ) getComponentControllerMap().get( 'puComponent' );
                if( l_controller != null ) {
                    
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryPurinaUniversityCntrlr(); 
        }
    }
    
    //Purina TV Component Variable
    public LPDCR_SecondaryPurinaTVCntrlr purinaTVController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPurinaTVCntrlr l_controller;
                l_controller = ( LPDCR_SecondaryPurinaTVCntrlr ) getComponentControllerMap().get( 'purinaTVComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryPurinaTVCntrlr(); 
        }
    }
    
    // Learning Center Component Variable
    public LPDCR_SecondaryLearningCenterCntlr learningCenterController
    {
        set;
        get
        {
                                                 // get the map, then the component 
                                                 // controller using the appropriate key
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryLearningCenterCntlr l_controller;
                l_controller = ( LPDCR_SecondaryLearningCenterCntlr ) getComponentControllerMap().get( 'learningCenterComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
                                                 // just in case something goes wrong 
                                                 // return something
            return new LPDCR_SecondaryLearningCenterCntlr(); 
        }
    }
/******************************************************************************
 * Method to pass the search term into the component to filter the results
 * returned 
 */
    public void doSearch()
    {
        System.debug( 'search_term = ' + search_term );
    }

/******************************************************************************
 * Getter method to return the sort_filter from the filterComponent variable
 */
    public String getSortBy()
    {
        sortFilter = filterController.sort_filter;
        System.debug('sortFilter---'+sortFilter);
        return sortFilter;
    } 

/******************************************************************************
 * Getter method to return the species_filter from the filterComponent variable
 */
    public List<String> getSpecieList()
    {
        pageSpecieList = filterController.species_filter;
        return new List<String>( pageSpecieList );
    }
 /******************************************************************************
 * Getter method to return the file_type_filter from the filterComponent 
 * variable
 */
    public
    List<String>
    getFileTypeFilter()
    {
        pageFileFilterList = filterController.file_type_filter;
        return new List<String>( pageFileFilterList );
    }
    
 // To check salesContent files
    public Boolean getInternalUserCheck(){
        internalUserOnly = filterController.internalOnly;
        return internalUserOnly;
    }

    
/******************************************************************************
 * Constructor
 */
    public LPDCR_CC_TrainingPageController()
    {
        System.debug( 'START: LPDCR_CC_TrainingPageController.constructor()' );
        
        String l_subtab = ApexPages.currentPage().getParameters().get( 'subtab' );
        if( l_subtab == null )
        {
            page_title = Label.LPDCR_Targeted_Training_Subtab_Name;
        }
        else
        {
            selected_title = l_subtab;
        }
        setPageTitle();
        
        System.debug( 'END: LPDCR_CC_TrainingPageController.constructor()' );
    }
    
    public void getTrainingData(){
        trainingVdoList = trainingsController.getTrainingData();
        purinaUniversityDocList = purinaUniversityController.getPurinaUniversityContent();
        System.debug('trainingVdoList ---'+trainingVdoList );
        System.debug('purinaUniversityDocList ---'+purinaUniversityDocList );
    }


/******************************************************************************
 * Setter method to update the page_title when a subtab is selected. The page
 * title is set using a whitelist rather than directly from the URL parameter
 * for security, since the page_title is displayed directly on the page
 */
    public
    void
    setPageTitle()
    {
        System.debug( 'START: LPDCR_CC_TrainingPageController.setPageTitle()' );
        System.debug( 'Param: selected_title = ' + selected_title );
        
        //Reset filters
        /*trainingsController.species_filter = new List<String>();
        trainingsController.internal_only = False;
        trainingsController.sort_filter = '';
        //trainingsController.getTrainingData();
        
        purinaUniversityController.species_filter= new List<String>();
        purinaUniversityController.internal_only = False;
        purinaUniversityController.sort_filter = '';
        
        purinaTVController.species_filter= new List<String>();
        purinaTVController.internal_only = False;
        purinaTVController.sort_filter = '';
        //purinaTVController.getPurinaTVContent();*/
        
        // Set Page Titles
        if( selected_title == 'TT30' || selected_title == null )
        {
            page_title = Label.LPDCR_Targeted_Training_Subtab_Name;
            //subtab = 'TT30';
        }
        else if( selected_title == 'PurinaUniversity' )
        {
            page_title = Label.LPDCR_Purina_University_Subtab_Name;
            //subtab = 'University';
        }
        else if( selected_title == 'TalentLink' )
        {
            page_title = Label.LPDCR_Talentlink_Subtab_Name;
            //subtab = 'Talent';
        }
        else if( selected_title == 'PurinaTV' )
        {
            page_title = Label.LPDCR_PurinaMills_TV_Subtab_Name;
            //subtab = 'PurinaTV';
        }
        else
        {
            page_title = Label.LPDCR_Targeted_Training_Subtab_Name;
            //subtab = 'TT30';
        }
        
        System.debug( 'END: LPDCR_CC_TrainingPageController.setPageTitle()' );
        //return new PageReference('https://dlrcommdev-landolakespartners.cs2.force.com/mypurinamills/LPDCR_CC_TrainingPage?subtab='+subtab+'&pageTitle='+page_title );
        
    }
    
} // /END Class