/**
*   @Author:    Heena Tanna
*   @Date:      04.05.2017
*   @Jira:      LPDCR-2471
*   @Purpose:   Test class behind LPDCR_SecondaryVIPFarmController
*/
@isTest(seeAllData =false)
public class LPDCR_SecondaryVIPFarmControllerTest {
    
    static testmethod void testCampaign(){
    
     RecordType rt = [SELECT Id,Name FROM RecordType WHERE Name='Farm VIP Event' AND SobjectType='Campaign'AND isActive=true];
    
     //insert record for campaign
     Campaign lstCam = new Campaign();
     lstCam.recordTypeId=rt.id;
     lstCam.Name ='TestCampaign';
     lstCam.Status ='Planned';
     lstCam.Short_Description__c ='test description';
     lstCam.Type ='National VIP';
     lstCam.Display_in_Dealer_Community__c = true; 
     lstCam.Short_Description__c='Test data';
     lstCam.Event_Location__c ='Minneapolis, MN';   
     lstCam.Date_of_Event__c = System.Today();
     lstCam.Registration_Opens__c = System.Today();
     lstCam.EndDate=System.Today().addDays(20);
     insert lstCam;
        
     Campaign l_lstCam = new Campaign();
     l_lstCam.recordTypeId=rt.id;
     l_lstCam.Name ='FarmCampaign';
     l_lstCam.Status ='Planned';
     l_lstCam.Short_Description__c ='test description';
     l_lstCam.Type ='National VIP';
     l_lstCam.Display_in_Dealer_Community__c = true; 
     l_lstCam.Short_Description__c='Test data';
     l_lstCam.Event_Location__c ='Minneapolis, MN';     
     l_lstCam.Date_of_Event__c = System.Today().addDays(10);
     l_lstCam.Registration_Opens__c = System.Today();
     l_lstCam.EndDate=System.Today().addDays(20);
     insert l_lstCam;   
     
    List<Document> docObjList = new List<Document>();
    docObjList.add(new Document(FolderId = [select id from folder where name = 'Farm VIP Documents'].id,DeveloperName='Farm_Event_Detailer_Sample',Name ='Farm Event Detailer Sample' ));
    docObjList.add(new Document(FolderId = [select id from folder where name = 'Farm VIP Documents'].id,DeveloperName='Test_Farm_VIP_Event_Detailer_Sample',Name ='Test Farm VIP Event Detailer Sample' ));    
    insert docObjList;  
    
    List<CustomerEventMetadata__c> cusEveList = new List<CustomerEventMetadata__c>();
    cusEveList.add(new CustomerEventMetadata__c(Campaign__c =lstCam.Id,DocumentDeveloperName__c = 'Farm_Event_Detailer_Sample',DocumentFolderDeveloperName__c = 'Farm_VIP_Documents',MetadataType__c = 'Download PDF'));
    cusEveList.add(new CustomerEventMetadata__c(Campaign__c =lstCam.Id,DocumentDeveloperName__c = 'Test_Farm_VIP_Event_Detailer_Sample',DocumentFolderDeveloperName__c = 'Farm_VIP_Documents',MetadataType__c = 'Download PDF'));     
    insert cusEveList;    
     
     LPDCR_SecondaryVIPFarmController controller = new LPDCR_SecondaryVIPFarmController();
     Test.startTest();
     controller.getFarmVipLst();
     controller.search_term = 'test';
     controller.species_filter = new List<String>();
     Boolean internal = controller.internal_only;   
     Boolean init =controller.init;
      LPDCR_SecondaryVIPFarmController.CampaignWrapper campWrapp = new LPDCR_SecondaryVIPFarmController.CampaignWrapper();
      LPDCR_SecondaryVIPFarmController.CampaignWrapper campWrap = new LPDCR_SecondaryVIPFarmController.CampaignWrapper(lstCam);
      LPDCR_SecondaryVIPFarmController.CampaignWrapper campWrap1 = new LPDCR_SecondaryVIPFarmController.CampaignWrapper(l_lstCam);
      campWrap.camp=  lstCam; 
      LPDCR_SecondaryVIPFarmController.sortBy  ='Date DESC';
      campWrap.compareTo(campWrap1);
      campWrap1.compareTo(campWrap);
      LPDCR_SecondaryVIPFarmController.sortBy  ='Date ASC';
      campWrap.compareTo(campWrap1);
      campWrap1.compareTo(campWrap);
      LPDCR_SecondaryVIPFarmController.sortBy  ='Name DESC';
      campWrap.compareTo(campWrap1);
      campWrap1.compareTo(campWrap);  
      LPDCR_SecondaryVIPFarmController.sortBy  ='Name ASC';
      campWrap.compareTo(campWrap1);
      campWrap1.compareTo(campWrap);       
     Test.stopTest();
    }
    
}