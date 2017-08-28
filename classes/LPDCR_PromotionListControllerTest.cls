/**
*   @Author:    Heena Tanna
*   @Date:      10.10.2016
*   @Jira:      LPDCR-20
*   @Purpose:   Test class for Controller LPDCR_PromotionList
*/

@isTest
public class LPDCR_PromotionListControllerTest
{

    static testmethod void testCampaignfields()
    {
    test.startTest();
    User pu = LPDCR_TestUtil.getCommunityUser();
    System.RunAs(pu){
     PageReference pageRef = Page.LPDCR_PromotionsDetail;
     //insert record for campaign
     Campaign lstCam = new Campaign();
     lstCam.Name ='TestCampaign';
     lstCam.Promotion_Discount_Code__c ='TestCode';
     lstCam.Promotion_Description__c ='test description';
     insert lstCam;
     
    List<Document> docObjList = new List<Document>();
    docObjList.add(new Document(FolderId = [select id from folder where name = 'LOL Campaign Images'].id,DeveloperName='Chick_Days_2016_Banner_Image',Name ='Chick Days 2016 Banner Image' ));
    docObjList.add(new Document(FolderId = [select id from folder where name = 'LOL Campaign Images'].id,DeveloperName='Chick_Days_2016_Download_PDF',Name ='Chick Days 2016 Download PDF' ));    
    insert docObjList;  
    
    List<CustomerEventMetadata__c> cusEveList = new List<CustomerEventMetadata__c>();
    cusEveList.add(new CustomerEventMetadata__c(Campaign__c =lstCam.Id,DocumentDeveloperName__c = 'Chick_Days_2016_Banner_Image',DocumentFolderDeveloperName__c = 'LOL_Campaign_Images',MetadataType__c = 'Banner Desktop'));
    cusEveList.add(new CustomerEventMetadata__c(Campaign__c =lstCam.Id,DocumentDeveloperName__c = 'Chick_Days_2016_Download_PDF',DocumentFolderDeveloperName__c = 'LOL_Campaign_Images',MetadataType__c = 'Download PDF'));     
    insert cusEveList; 

     
    /* LPDCR_Org_Settings__c orgSet = new LPDCR_Org_Settings__c();
     orgSet.CC_Portal_Sign_Up_URL_Non_SSO_User__c = 'https://ccrz.cs2.visual.force.com/apex/homepage?isCSRFlow=true&orderType=preBook&portalUser=[$UserInfo.getUserId()]&store=PurinaMills&promoCode=[lstCam.Promotion_Discount_Code__c]';
     orgSet.CC_Portal_Sign_Up_URL_SSO__c ='https://ccrz.cs2.visual.force.com/apex/homepage?orderType=preBook&store=PurinaMills&promoCode=[lstCam.Promotion_Discount_Code__c]';
     insert orgSet;*/
     
        
        //Applying page context here
        Campaign campRecord = [Select Id,Name from Campaign where Id=:lstCam.Id];
        
         LPDCR_PromotionListController.CampWrapperClass cam = new LPDCR_PromotionListController.CampWrapperClass();
         cam.camObj = campRecord;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',lstCam.id);
        ApexPages.StandardController sc = new ApexPages.standardController(campRecord);
        LPDCR_PromotionListController controller = new LPDCR_PromotionListController();
        //Constructor 
        controller = new LPDCR_PromotionListController(sc);
        controller.camp = campRecord;
        Campaign c = controller.camp;
        controller.getCampaignDetail();
        System.assertNotEquals(null,controller.getCampaigns());
        controller.fetchAttachmentRecord();
        }
        test.stopTest();     
        
    }

}