/**
*   @Author:    Shruti Mishra
*   @Date:      06.06.2017
*   @Jira:      LPDCR-
*   @Purpose:   Test class for LPDCR_Community_HomeCntrlr.cls
*/

@isTest( SeeAllData=true )
private class LPDCR_Community_HomeCntrlrTest{
    
    /*
     * Test Constructor
     */
    static testMethod void test_CommunityConstructor(){
        System.debug('START: LPDCR_Community_HomeCntrlrTest.test_CommunityConstructor');
        LPDCR_Community_HomeCntrlr controller = new LPDCR_Community_HomeCntrlr();
        controller.navigateToCommunity();
        System.debug('END: LPDCR_Community_HomeCntrlrTest.test_CommunityConstructor');
    }
}