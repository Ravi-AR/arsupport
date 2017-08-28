/******************************************************************************
 * Test class for LPDCR_DealerVIPPointsTonsReportCntrlr.cls
 *
 *
 * @Author: Heena Tanna
 * @Date: July 11, 2017
 * @Jira: LPDCR-2029
 */

@isTest(SeeAllData=true)
private class LPDCR_InternalVIPPtsTonsReportCtrlrTest {
    
    /******************************************************************************
 * Method to test the class constructor
 */
    static testMethod 
    void 
    test_Constructor() 
    {
        System.debug( 'START: LPDCR_InternalVIPPtsTonsReportCtrlrTest .test_Constructor()' );
        
        Test.startTest();
        
       
        
        
        Test.stopTest();

        System.debug( 'END: LPDCR_InternalVIPPtsTonsReportCtrlrTest .test_Constructor()' );
    }

    static testMethod void test_internalReport()
    {   
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User l_user;
        
        List<User> l_users = [ SELECT Id FROM User WHERE Employee_Number__c = 12345 LIMIT 1 ];
        if( l_users.size() == 1 )
        {
            l_user = l_users[ 0 ]; 
        }
        else
        {
            l_user = new User (alias ='IntUser',LastName='Internal',Employee_Number__c=12345,FederationIdentifier ='12345',Email='internal@test.com',
                           emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US',timezonesidkey='America/Los_Angeles', 
                           username='internal@test.com.internal',ProfileId = p.Id);
            insert l_user;
        }
        
        System.RunAs(l_user){
	        Test.startTest();    
	        Test.setMock( HttpCalloutMock.class, new LPDCR_InternalReportDetailMockResponse() );
	        LPDCR_InternalVIPPointsTonsReportCntrlr l_controller = new LPDCR_InternalVIPPointsTonsReportCntrlr();
	        l_controller.getInternalTerritoryList();
	        Test.stopTest();
	        l_controller.territory_id='1513900';
	        l_controller.getInternalAccountList();  
	        l_controller.customer_number='24730';
	        l_controller.getInternalLevel3List();
	        l_controller.level3_id='1513900';
	        l_controller.getInternalProductList();
	        LPDCR_InternalVIPPointsTonsReportCntrlr.getInternalFullReport();
           
            
        }// /END System.runAs()
        LPDCR_InternalVIPPointsTonsReportCntrlr controller = new LPDCR_InternalVIPPointsTonsReportCntrlr();
        controller.getInternalTerritoryList();
        controller.getInternalAccountList();
        controller.getInternalLevel3List();
        controller.getInternalProductList();
    }
    
}