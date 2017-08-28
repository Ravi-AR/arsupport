/**
*   @Author:    Shruti Mishra
*   @Date:      01.03.2017
*   @Purpose:   Test class for LPDCR_Constants
**/

@isTest
public class LPDCR_ConstantsTest{
   static testMethod void testConstantVars() 
   {
       LPDCR_Constants controller = new LPDCR_Constants();
       
       System.assertEquals(LPDCR_Constants.CONS_STATUS, LPDCR_Constants.CONS_STATUS);
       System.assertEquals(LPDCR_Constants.CONS_ProgramYear, LPDCR_Constants.CONS_ProgramYear);
       System.assertEquals(LPDCR_Constants.CONS_EXPENSE, LPDCR_Constants.CONS_EXPENSE);
       System.assertEquals(LPDCR_Constants.CONS_BalanceAdjustment, LPDCR_Constants.CONS_BalanceAdjustment);
       System.assertEquals(LPDCR_Constants.CONS_CampRecType, LPDCR_Constants.CONS_CampRecType);
       System.assertEquals(LPDCR_Constants.CONS_CampBBRecType, LPDCR_Constants.CONS_CampBBRecType);
       System.assertEquals(LPDCR_Constants.CONS_CommunityUser, LPDCR_Constants.CONS_CommunityUser);
       System.assertEquals(LPDCR_Constants.CONS_STATUS_SAVED, LPDCR_Constants.CONS_STATUS_SAVED);
       System.assertEquals(LPDCR_Constants.CONS_SUBMITDATE, LPDCR_Constants.CONS_SUBMITDATE);
       System.assertEquals(LPDCR_Constants.CONS_DESC, LPDCR_Constants.CONS_DESC);
        
   }
}