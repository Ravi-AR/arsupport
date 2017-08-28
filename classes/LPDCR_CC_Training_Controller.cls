/******************************************************************************
 * Controller for the LPDCR_CC_Training VF component
 * @Author: Shruti
 * @Date: Apr 13, 2017 
 * @Jira: LPDCR-2230
 */
public with sharing class LPDCR_CC_Training_Controller extends LPDCR_SecondaryPageBaseController{
        
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> purinaTVDocList { get; set; }
    public List<LPDCR_BLDocuments.PurinaBusinessLink_Documents> trainingVdoList { get; set; }
    public Boolean init{
        set;
        get{
            getTrainingData();
            return false;
        }
    }
    
    public LPDCR_BLDocuments.PurinaBusinessLink_Documents training_doc { get; set; }
    public LPDCR_BLDocuments.PurinaBusinessLink_Documents training_video { get; set; }
    
/******************************************************************************
 * Constructor
 */
    public LPDCR_CC_Training_Controller()
    {
        System.debug( 'START: LPDCR_CC_Training_Controller.constructor()' );
        training_video = new LPDCR_BLDocuments.PurinaBusinessLink_Documents();
        training_doc = new LPDCR_BLDocuments.PurinaBusinessLink_Documents();
        System.debug( 'END: LPDCR_CC_Training_Controller.constructor()' );
    }
    
    public void getTrainingData(){
        LPDCR_SecondaryPageTrainingController trainingsController = new LPDCR_SecondaryPageTrainingController();
        LPDCR_SecondaryPurinaTVCntrlr purinaTVController = new LPDCR_SecondaryPurinaTVCntrlr();
        trainingVdoList = trainingsController.getTrainingData();
        if( trainingVdoList.size() > 0 ){
            training_video = trainingVdoList[ 0 ];
        }
        
        purinaTVDocList = purinaTVController.getPurinaTVContent();
        if( purinaTVDocList.size() > 0 ){
            training_doc = purinaTVDocList[ 0 ];
        }
        
    }
    
} // /END Class