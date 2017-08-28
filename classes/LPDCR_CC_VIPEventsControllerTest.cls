/**
*   @Author:    Heena Tanna
*   @Date:      16.03.2017
*   @Jira:      LPDCR-2064
*   @Purpose:   Test class behind LPDCR_CC_VIPEventsController
*/
@isTest
public class LPDCR_CC_VIPEventsControllerTest {
    
    static testmethod void testCampaign()
    {
    
    RecordType rt = [SELECT Id,Name FROM RecordType WHERE Name='Farm VIP Event' AND SobjectType='Campaign'AND isActive=true];
    
     //insert record for campaign
     Campaign lstCam = new Campaign();
     lstCam.recordTypeId=rt.id;
     lstCam.Name ='TestCampaign';
     lstCam.Status ='Planned';
     lstCam.Short_Description__c ='test description';
     lstCam.Type ='National VIP';
     lstCam.Date_of_Event__c = System.Today();
     lstCam.EndDate=System.Today().addDays(20);
     insert lstCam;
     
     RecordType rt1 = [SELECT Id,Name FROM RecordType WHERE Name='National/Regional Events' AND SobjectType='Campaign'AND isActive=true];
    
     //insert record for campaign
     Campaign lstNatCam = new Campaign();
     lstNatCam.recordTypeId=rt1.id;
     lstNatCam.Name ='TestNationalEventsCampaign';
     lstNatCam.Status ='Planned';
     lstNatCam.Short_Description__c ='test NationalEvents';
     lstNatCam.Type ='National';
     lstNatCam.Date_of_Event__c = System.Today();
     lstNatCam.EndDate=System.Today().addDays(20);
     insert lstNatCam;
     
     
     LPDCR_CC_VIPEventsController controller = new LPDCR_CC_VIPEventsController();
     Test.startTest();
     //controller.getFarmVipLst();
     controller.getHomepageCampaigns();
     //controller.getNationalEventLst();
     LPDCR_SecondaryPageMediaToolsCtrlr l_controller = new LPDCR_SecondaryPageMediaToolsCtrlr();
     l_controller.search_term = 'Search Term';
     l_controller.species_filter = new List<String>();
     Test.stopTest();
    }
    
    static testmethod void exception(){
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE Name='Promotions and Pre-Booking' AND SobjectType='Campaign'AND isActive=true];
    
     //insert record for campaign
     Campaign lstCam = new Campaign();
     lstCam.recordTypeId=rt.id;
     lstCam.Name ='TestException';
     lstCam.Promotion_Description__c ='test description';
     insert lstCam;
     
     
     LPDCR_CC_VIPEventsController controller = new LPDCR_CC_VIPEventsController();
     Test.startTest();
     //controller.getFarmVipLst();
     controller.getHomepageCampaigns();   
     //controller.getNationalEventLst();
     Test.stopTest(); 
        
    }
}