/******************************************************************************
 * Test class for the LPDCR_CC_Header_Controller class
 *
 * @Author: Magnet 360
 * @Date: Mar 14, 2017
 * @Jira: LPDCR-2141
 */
@isTest( SeeAllData=false )
private class 
LPDCR_CC_Header_ControllerTest 
{

/******************************************************************************
 * Setup the test data 
 */
    @testSetup
    static void testSetup()
    {
                                                 // Create the logout URL in
                                                 // the custom setting
        LPDCR_Org_Settings__c l_settings = new LPDCR_Org_Settings__c();
        l_settings.Dealer_Community_Logout_URL__c = 'secur/logout.jsp';
        insert l_settings;
    } 

/******************************************************************************
 * Method to test 
 */
    static testMethod 
    void 
    test_Method() 
    {
		System.debug( 'START: LPDCR_CC_Header_ControllerTest.testMethod()' );
        LPDCR_CC_Header_Controller l_controller = new LPDCR_CC_Header_Controller();
        User l_user = LPDCR_TestUtil.getCommunityUser();
        
        System.runAs( l_user )
        {
            l_controller = new LPDCR_CC_Header_Controller();
            Boolean init = l_controller.init;
            l_controller.search_term = 'Purina';
            String accId = l_controller.selectedAccountId;
            Account selectedAcc = l_controller.selectedAcc;
            System.assert( l_controller.current_user != null, 'Current user not found' );
            System.assert( l_controller.logout_url != null, 'Logout Url not found' );
            //System.assert(l_controller.current_user == null, 'l_user.getUserId()');
            
                                                 // These values are retrieved 
                                                 // from webservices which
                                                 // are null in this test class
            String l_profile_url = l_controller.my_profile_url;
            List<LOLMyLinksCallouts.MyLinkData> l_resources = l_controller.resources;
            
        }// /END System.runAs( community user )

        System.debug( 'END: LPDCR_CC_Header_ControllerTest.testMethod()' );
    }
    
}// /END Test Class