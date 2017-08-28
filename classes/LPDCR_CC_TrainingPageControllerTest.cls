/******************************************************************************
 * Test class for LPDCR_CC_TrainingPageController.cls 
 *
 * @Author: Shruti Mishra
 * @Date: Apr 13, 2017
 * @Jira: LPDCR-2033
 */
@isTest( SeeAllData=false )
private class LPDCR_CC_TrainingPageControllerTest {
    
/******************************************************************************
 * Method to test the constructor and doSearch() methods
 */
    static testMethod void test_Constructor() 
    {
        System.debug( 'START: LPDCR_CC_TrainingPageControllerTest.test_Constructor()' );

        Test.startTest();
        PageReference pageRef = Page.LPDCR_CC_TrainingPage;
        Test.setCurrentPage(pageRef);
        LPDCR_CC_TrainingPageController controller = new LPDCR_CC_TrainingPageController();
        System.assert( controller != null );
        
        // Test the doSearch() method
        controller.search_term = 'Search Term';
        controller.page_title ='test';
        controller.selected_title ='test';
        controller.subtab='';
        controller.doSearch();
        
        controller.getSortBy();
        controller.getInternalUserCheck();
        controller.getFileTypeFilter();
        
        

        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_TrainingPageControllerTest.test_Constructor()' );
    }

/******************************************************************************
 * Test getSpecieList() method
 */
    static testMethod void test_getSpecieList() 
    {
        System.debug( 'START: LPDCR_CC_TrainingPageControllerTest.test_getSpecieList()' );
        
        List<String> l_specie_list;
        LPDCR_SecondaryPageFiltersController l_filters_controller;
        Test.startTest();
        PageReference pageRef = Page.LPDCR_CC_TrainingPage;
        Test.setCurrentPage(pageRef);
        LPDCR_CC_TrainingPageController l_controller = new LPDCR_CC_TrainingPageController ();
        System.assert( l_controller != null );
            
                                                 // Test returning a value when
                                                 // none is found
        l_filters_controller = l_controller.filterController;                                         
                                                 // Test setting & getting the
                                                 // filter component controller
        l_controller.setComponentControllerMap( 'filtersComponent',  new LPDCR_SecondaryPageFiltersController() );
        l_filters_controller = l_controller.filterController;
        System.assert( l_filters_controller != null );
        
        l_specie_list = l_controller.getSpecieList();
        System.assert( l_specie_list != null );
        
        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_TrainingPageControllerTest.test_getSpecieList()' );
    }

/******************************************************************************
 * Test setting and getting each of the component controllers
 */
    static testMethod void test_ComponentControllerMethods() 
    {
        System.debug( 'START: LPDCR_CC_TrainingPageControllerTest.test_ComponentControllerMethods()' );
        LPDCR_SecondaryPageTrainingController  trainingController;
        LPDCR_SecondaryPurinaUniversityCntrlr purinaUniversityController;
        LPDCR_SecondaryPurinaTVCntrlr purinaTVController;
        LPDCR_SecondaryLearningCenterCntlr learningCenterController;
        Test.startTest();
        PageReference pageRef = Page.LPDCR_CC_TrainingPage;
        Test.setCurrentPage(pageRef);
        LPDCR_CC_TrainingPageController controller = new LPDCR_CC_TrainingPageController();
        Boolean init = controller.init;
        System.assert( controller != null );
        
        trainingController = controller.trainingsController;
        purinaTVController = controller.purinaTVController;
        purinaUniversityController = controller.purinaUniversityController;
        learningCenterController =controller.learningCenterController;
        controller.setComponentControllerMap( 'tt30Component',  new LPDCR_SecondaryPageTrainingController() );
        controller.setComponentControllerMap( 'purinaTVComponent',  new LPDCR_SecondaryPurinaTVCntrlr() );
        controller.setComponentControllerMap( 'puComponent',  new LPDCR_SecondaryPurinaUniversityCntrlr() );  
        controller.setComponentControllerMap( 'learningCenterComponent',  new LPDCR_SecondaryLearningCenterCntlr() );
        trainingController = controller.trainingsController;
        System.assert( trainingController != null );  
        purinaTVController = controller.purinaTVController; 
        System.assert( purinaTVController != null );  
        purinaUniversityController = controller.purinaUniversityController; 
        System.assert( purinaUniversityController != null ); 
        learningCenterController =controller.learningCenterController;
        System.assert( learningCenterController != null ); 
        controller.selected_title='PurinaUniversity';
        controller.page_title =Label.LPDCR_Purina_University_Subtab_Name;
        controller.setPageTitle();
        controller.selected_title='TalentLink';
        controller.page_title =Label.LPDCR_Talentlink_Subtab_Name;
        controller.setPageTitle();
        controller.selected_title='PurinaTV';
        controller.page_title =Label.LPDCR_PurinaMills_TV_Subtab_Name;
        controller.setPageTitle();
        controller.selected_title='';
        controller.page_title =Label.LPDCR_Targeted_Training_Subtab_Name;
        controller.setPageTitle(); 
        controller.subtab ='TT30';
        controller.setPageTitle();
        Test.stopTest();
        
        System.debug( 'END: LPDCR_CC_TrainingPageControllerTest.test_ComponentControllerMethods()' );
    }
    
}// /END Test Class