/******************************************************************************
 * LMSA_SelectedManagementTipsController
 * @Description: Controller for the LMSA_SelectedManagementTips visualforce component.
 *               This class contains all functionality for showing tips list on management tip email template
 *
 * @Date: 11/05/2015
 * @Author: Adeel Ahmad (Magnet360)
 *
 * @Updated:
 ******************************************************************************/
public with sharing class LMSA_SelectedManagementTipsController {
    
    public list<Tip__c> tips {get{
        if( tips == null ){
            tips = new List<Tip__c>();
            User currentUser = [select Selected_Management_Tips__c from user where Id = :UserInfo.getUserId()];
            if( String.isNotBlank( currentUser.Selected_Management_Tips__c ) ){
                List<String> tipIds = currentUser.Selected_Management_Tips__c.split(',');
                tips = [select Name, Tip__c from Tip__c where Id in :tipIds];
                
                currentUser.Selected_Management_Tips__c = null;
                update currentUser;
            }
        }
        return tips;
    } set; }
    
	public LMSA_SelectedManagementTipsController() {
		
	}
}