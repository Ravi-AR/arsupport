//ClassName:cc_oo_NavigationBarControllerTest 
//Summary: Test class for cc_oo_NavigationBarController
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Lalit Borase                        10/24/2016                                       OO-212 Ability to redirect user back to the community page from the online ordering system.
//-----------------------------------------------------------------------------------------------------------------------
 
@isTest
private class cc_oo_NavigationBarControllerTest {
 	
 	@isTest
    static void test_cc_oo_NavigationBarController() {
        // TO DO: implement unit test
        cc_lol_TestData.setupOOSettings(); 
        cc_oo_NavigationBarController testCtrl = new cc_oo_NavigationBarController();
        System.assert(testCtrl!=NULL);
    }
}