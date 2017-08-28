/**
*   @Author:    Heena Tanna
*   @Date:      14.03.2017
*   @Jira:      LPDCR-1991
*   @Purpose:   Test class for LPDCR_ChangeAccountController 
*
*/
@isTest
public class LPDCR_ChangeAccountControllerTest {
    
    static testMethod void testgetAccountDetail() 
    {
        
          User pu = LPDCR_TestUtil.getCommunityUser();
          System.RunAs(pu){
              Account ac = LPDCR_TestUtil.getAccountRecord();
              LPDCR_ChangeAccountController controller = new LPDCR_ChangeAccountController();
              System.assert( controller.init == false );
              PageReference pageRef = Page.LPDCR_CC_HomePage;
              System.Test.setCurrentPage(pageRef);
              ApexPages.currentPage().getParameters().put('selectedAccountId',ac.Id);    
              controller = new LPDCR_ChangeAccountController();
              System.assert( controller.init == false );
              ApexPages.currentPage().getParameters().put('selectedAccountId',null);    
              controller = new LPDCR_ChangeAccountController();
              System.assert( controller.init == false );
              ApexPages.currentPage().getParameters().put('selectedAccountId','');
              controller = new LPDCR_ChangeAccountController();
              
              System.assert( controller.init == false );
          }// /END System.runAs()
    }
   
}