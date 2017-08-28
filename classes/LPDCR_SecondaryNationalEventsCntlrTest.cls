/**
*   @Author:    Heena Tanna
*   @Date:      04.05.2017
*   @Jira:      LPDCR-2471
*   @Purpose:   Test class behind LPDCR_SecondaryNationalEventsController
*/
@isTest
public class LPDCR_SecondaryNationalEventsCntlrTest {
    
    static testmethod void testCampaign()
    {
     RecordType rt1 = [SELECT Id,Name FROM RecordType WHERE Name='National/Regional Events' AND SobjectType='Campaign'AND isActive=true];
    
     //insert record for campaign
     Campaign lstNatCam = new Campaign();
     lstNatCam.recordTypeId=rt1.id;
     lstNatCam.Name ='TestNationalEventsCampaign';
     lstNatCam.Status ='Planned';
     lstNatCam.Short_Description__c ='test NationalEvents';
     lstNatCam.Type ='National';
     lstNatCam.Specie_Focus__c ='Cattle';
     lstNatCam.Display_in_Dealer_Community__c = true; 
     lstNatCam.Short_Description__c='Test data';
     lstNatCam.Event_Location__c ='Minneapolis, MN';   
     lstNatCam.Date_of_Event__c = System.Today();
     lstNatCam.Registration_Opens__c = System.Today();
     lstNatCam.EndDate = System.Today().addDays(20);
     insert lstNatCam;
        
     Campaign l_lstNatCam = new Campaign();
     l_lstNatCam.recordTypeId=rt1.id;
     l_lstNatCam.Name ='NationalEventsCampaign';
     l_lstNatCam.Status ='Planned';
     l_lstNatCam.Short_Description__c ='test NationalEvents';
     l_lstNatCam.Type ='National';
     l_lstNatCam.Specie_Focus__c ='Cattle';
     l_lstNatCam.Display_in_Dealer_Community__c = true; 
     l_lstNatCam.Short_Description__c='Test data';
     l_lstNatCam.Event_Location__c ='Minneapolis, MN';   
     l_lstNatCam.Date_of_Event__c = System.Today().addDays(10);
     l_lstNatCam.Registration_Opens__c = System.Today();
     l_lstNatCam.EndDate = System.Today().addDays(20);
     insert l_lstNatCam;   
     
     LPDCR_SecondaryNationalEventsController controller = new LPDCR_SecondaryNationalEventsController();
     Test.startTest();
     controller.getNationalEventLst();
     
     controller.search_term = 'Test';
     controller.species_filter = new List<String>();
     controller.sort_filter=null;   
     Boolean internal = controller.internal_only;	
     Boolean init = controller.init;
     System.assert( controller != null );
      
        
      LPDCR_SecondaryNationalEventsController.CampaignWrapper campWrapp = new LPDCR_SecondaryNationalEventsController.CampaignWrapper();
      LPDCR_SecondaryNationalEventsController.CampaignWrapper campWrap = new LPDCR_SecondaryNationalEventsController.CampaignWrapper(lstNatCam);
      LPDCR_SecondaryNationalEventsController.CampaignWrapper campWrap1 = new LPDCR_SecondaryNationalEventsController.CampaignWrapper(l_lstNatCam);
      campWrap.camp=  lstNatCam; 
      LPDCR_SecondaryNationalEventsController.sortBy  ='Date DESC';
      campWrap.compareTo(campWrap1);
      campWrap1.compareTo(campWrap);
      LPDCR_SecondaryNationalEventsController.sortBy  ='Date ASC';
      campWrap.compareTo(campWrap1);
      campWrap1.compareTo(campWrap);
      LPDCR_SecondaryNationalEventsController.sortBy  ='Name DESC';
      campWrap.compareTo(campWrap1);
      campWrap1.compareTo(campWrap);  
      LPDCR_SecondaryNationalEventsController.sortBy  ='Name ASC';
      campWrap.compareTo(campWrap1);
      campWrap1.compareTo(campWrap);    
     Test.stopTest();
    }
}