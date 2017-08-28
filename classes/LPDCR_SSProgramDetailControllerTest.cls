/**
*   @Author:    Shruti Mishra
*   @Date:      28.09.2016
*   @Jira:      LPDCR-532
*   @Purpose:   Test Class for LPDCR_SSProgramDetailController
*
*/

@isTest
private class LPDCR_SSProgramDetailControllerTest {
    
    static testMethod void testgetAccountDetail() 
    {
        
        User pu = LPDCR_TestUtil.getCommunityUser();
        System.RunAs(pu)
        {
            //AMASellingSupportExpense__c expense = LPDCR_TestUtil.getSSExpenseRecord();
            Account ac = LPDCR_TestUtil.getAccountRecord();
            LPDCR_SSProgramDetailController controller = new LPDCR_SSProgramDetailController();
        }
        
        
    }
}