/******************************************************************************
 * Base controller for the secondary pages that is meant to be extended. Follows
 * the design pattern outlined here - https://developer.salesforce.com/page/Controller_Component_Communication -
 * to allow multiple components on the VF page to interact with each other 
 * 
 * @Author: Magnet 360
 * @Date: Mar 28, 2017 
 * @Jira: LPDCR-2230
 *
 * @Update: 8/4/2017 : Magnet 360
 *  Changed the class to run WITHOUT SHARING and added the check to make sure the
 *  selected account was in the users RelatedAccounts so that the community user 
 *  could see the FLM Flag for accounts they are not directly assigned to
 */

public virtual without sharing class 
LPDCR_SecondaryPageBaseController
{
    private LPDCR_ComponentBaseController myComponentController;
    private Map<String, LPDCR_ComponentBaseController> componentControllerMap;
    private String active_subtab;
    public String selectedAccountId { get; set; }
    public Account selectedAcc { get; set; }
    public Boolean isFLMAccount { 
        get
        {
            if(isFLMAccount == null){
                isFLMAccount = false;
            }
            
            return isFLMAccount;
        } 
        set;}
    
    
/******************************************************************************
 * Getter method for the myComponentController private variable
 */ 
    public virtual 
    LPDCR_ComponentBaseController 
    getMyComponentController() {
        return myComponentController;
    }

/******************************************************************************
 * Setter method for the myComponentController private variable
 */
    public virtual 
    void 
    setComponentController( LPDCR_ComponentBaseController compController ) {
        myComponentController = compController;
    }


/******************************************************************************
 * Getter method for the componentControllerMap private variable
 */    
    public virtual 
    Map<String, LPDCR_ComponentBaseController> 
    getComponentControllerMap() {
        return componentControllerMap;
    }
    
/******************************************************************************
 * Setter method for the componentControllerMap private variable
 */
    public virtual 
    void 
    setComponentControllerMap( String key, LPDCR_ComponentBaseController compController ){
        if( componentControllerMap == null ) { 
            componentControllerMap = new Map<String, LPDCR_ComponentBaseController>();
        }
        
        componentControllerMap.put( key, compController );
    }

/******************************************************************************
 * Getter method to return an instance of this class
 */    
    public 
    LPDCR_SecondaryPageBaseController 
    getThis() {
        return this;
    }

/******************************************************************************
 * Method to initialize any cached data used on the Secondary page. This method
 * should be called from the "action" parameter of the page.
 */ 
    public
    void
    initCachedData()
    {
        LPDCR_ContentServiceUtil l_content_service = new LPDCR_ContentServiceUtil();
        List<LPDCR_BLSpecies.PurinaBusinessLink_Species> l_species_list 
            = l_content_service.getSpecies().getSpeciesList();
        
        List<Account> selectedAcc;
        List<User> l_community_user;
        
        //Change Account Logic
        if(selectedAccountId == null){
            selectedAccountId = LPDCR_ChangeAccountController.getSelectedAccId();
        } 
        
        if( UserInfo.getUserType() != 'STANDARD' )
        {
            l_community_user = [ SELECT ContactId
                                 FROM User
                                 WHERE Id = :UserInfo.getUserId()
                                 LIMIT 1 ];
                                 
        }
        
        if( l_community_user != null && l_community_user.size() > 0 )
        {
                                                 // Since the class has to run
                                                 // WITHOUT SHARING, make sure
                                                 // the current user has access
                                                 // to the Selected Account in 
                                                 // their RelatedAccounts
	        selectedAcc = [SELECT Id, Name, Feed_License_Manufacturer__c, Dealer_Category_catcode30__c, Member_Type_catcode1__c, AR_Customer_Group_JDE__c, BusinessBuilderProgramStatus__c,AccountNumber
	                       FROM Account
	                       WHERE Id =: selectedAccountId
	                           AND Id IN (SELECT AccountId 
										  FROM AccountContactRelation 
									      WHERE ContactId = :l_community_user[ 0 ].ContactId 
							                  AND ( IsDirect =: true OR Account.ParentId = null OR Account.ParentId != null ) ) 
	                       LIMIT 1];
        }
        System.debug('selectedAcc--'+selectedAcc);
        
        // LPDCR-2801
        if(selectedAcc != null && selectedAcc.size() > 0 && selectedAcc[ 0 ].Feed_License_Manufacturer__c){
            isFLMAccount = True;
        }
        System.debug('isFLMAccount ---'+isFLMAccount );
    }

} // /END Class