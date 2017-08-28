/**
*   @Author:    Heena Tanna
*   @Date:      15.03.2017
*   @Jira:      LPDCR-1995
*   @Purpose:   Test Class behind LPDCR_ContactUsController
*
*/
@isTest(seeAllData=false)

public class LPDCR_ContactUsControllerTest {
 
    static testMethod void testgetContactDetails()
    {
        User pu = LPDCR_TestUtil.getCommunityUser();
          System.RunAs(pu){
	          Account ac = LPDCR_TestUtil.getAccountRecord();
              ac.Dedicated_Customer_Op_Rep__c = pu.Id;
              Contact_Us_Regional_Emails__c regionalEmail = new Contact_Us_Regional_Emails__c(Name='Great East',Customer_Ops_Region__c='Great East',Email__c='davin.leier+purinagreateast@magnet360.com');
              insert regionalEmail;
	          Test.startTest();
	          LPDCR_ContactUsController controller = new LPDCR_ContactUsController();
              controller.setContactReason();
              
              controller.contactReason = Label.LPDCR_Contact_Regarding_OrderPricing;
              controller.selectedAcc = ac;
              controller.setContactReason();
              controller.emailBody ='Test email';
	          controller.sendEmail();
	          controller.emailBody = null;
	          controller.sendEmail();
              controller.initialize();
              
              regionalEmail.Email__c = null;
              update regionalEmail;
              controller.contactReason = Label.LPDCR_Contact_Regarding_OrderPricing;
              controller.toSendAddress = null;
              controller.setContactReason();
	          Test.stopTest();
	          System.assertEquals(controller.emailBody==null,true);
          }  
    }
    
}