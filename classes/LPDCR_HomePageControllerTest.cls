/**
*   @Author:    Shruti Mishra
*   @Date:      07.10.2016
*   @Jira:      LPDCR-533
*   @Purpose:   Test Class behind LPDCR_HomepageController
*/

@isTest(seeallData =true)
private class LPDCR_HomePageControllerTest{
    
    static testMethod void testFetchAttachmentRecord(){
        System.debug('------ Begin: LPDCR_HomePageControllerTest.LPDCR_HomePageControllerTest');
        User pu = LPDCR_TestUtil.getCommunityUser();
        System.RunAs(pu){
            LPDCR_HomePageController controller = new LPDCR_HomePageController();//insert record for campaign
            Campaign lstCam1 = new Campaign();
            lstCam1.Name ='TestCampaign';
            lstCam1.Promotion_Discount_Code__c ='TestCode';
            lstCam1.Promotion_Description__c ='test description';
            lstCam1.IsActive = TRUE;
            lstCam1.Display_Order__c=2;
            RecordType rt =[select id,Name,DeveloperName from RecordType where sObjectType='Campaign' AND Name='Promotions and Pre-Booking' AND DeveloperName='PromotionsPrebooking' limit 1];
            lstCam1.RecordType = rt;
            insert lstCam1;
            List<Campaign> lstCamObj = new List<Campaign>();
            lstCamObj.add(lstCam1);
            //LPDCR_HomePageController.lstCam = lstCamObj;
            controller.lstCam = lstCamObj;
            //LPDCR_HomePageController.fetchAttachmentRecord();
            controller.fetchAttachmentRecord();
            System.assertEquals(controller!=null,true);
        }
        System.debug('------ End: LPDCR_HomePageControllerTest.LPDCR_HomePageControllerTest');
    } 
    
    static testMethod void testinitialize(){
          
        User pu = LPDCR_TestUtil.getCommunityUser();
        System.RunAs(pu){
            Account ac = LPDCR_TestUtil.getAccountRecord();
            LPDCR_HomePageController controller = new LPDCR_HomePageController();//insert record for campaign
            Campaign lstCam1 = new Campaign();
            lstCam1.Name ='TestCampaign';
            lstCam1.Promotion_Discount_Code__c ='TestCode';
            lstCam1.Promotion_Description__c ='test description';
            lstCam1.IsActive = TRUE;
            lstCam1.Display_Order__c=2;
            lstCam1.ExternalVisibilityStartDate__c = Date.Today()-2;
            lstCam1.ExternalVisibilityEndDate__c = Date.Today()+2;
            RecordType rt =[select id,Name,DeveloperName from RecordType where sObjectType='Campaign' AND Name='Promotions and Pre-Booking' AND DeveloperName='PromotionsPrebooking' limit 1];
            lstCam1.RecordType = rt;
            insert lstCam1;
            List<Campaign> lstCam = new List<Campaign>();
            lstCam.add(lstCam1);
            
            CustomerEventMetadata__c metadata = new CustomerEventMetadata__c(Campaign__c = lstCam1.Id, DocumentDeveloperName__c = 'Slide_Chickdays1', DocumentFolderDeveloperName__c = 'LOL_Campaign_Images', MetadataType__c = 'Slide Carousel');            
            insert metadata;
            
            Document doc = new Document(DeveloperName = 'Slide_Chickdays1', FolderId = [Select Id from Folder Where Name='BB Documents'].Id, Name = 'Slide_Chickdays1'); //, Folder.DeveloperName = 'LOL_Campaign_Images' 
            insert doc;
            
                
            //LPDCR_HomePageController.lstCam = lstCam;
            controller.lstCam = lstCam;
            Campaign campRecord = [Select Id,Name from Campaign where Id=:lstCam1.Id];
            //insert attachment for campaign
            List<Attachment> att = new List<Attachment>();
            att.add(new Attachment(parentId = campRecord.Id,Name = 'Download.pdf',Body = Blob.valueOf('test')));
            att.add(new Attachment(parentId = campRecord.Id,Name = 'Carousel-Desktop.jpg',Body = Blob.valueOf('test')));
            att.add(new Attachment(parentId = campRecord.Id,Name = 'Carousel-Mobile.jpg',Body = Blob.valueOf('test')));
            att.add(new Attachment(parentId = campRecord.Id,Name = 'Banner-Desktop.jpg',Body = Blob.valueOf('test')));
            att.add(new Attachment(parentId = campRecord.Id,Name = 'Banner-Mobile.jpg',Body = Blob.valueOf('test')));
            insert att;
                
    
            controller.initialize(); 
            //controller.checkCache();                   
            //controller.getSSBalanceAmt();
            controller.fetchAttachmentRecord();
            System.assertEquals(ApexPages.currentPage().getParameters().get('selectedAccountId')!=null,false);
            ApexPages.currentPage().getParameters().put('selectedAccountId',null);
                
        }
    }
            
    static testmethod void testSessionCache(){
        Account ac = LPDCR_TestUtil.getAccountRecord();
        PageReference pageRef = Page.LPDCR_CC_HomePage;
        pageRef.getParameters().put('selectedAccountId',ac.Id);
        System.Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(ac);
        LPDCR_HomePageController controller = new LPDCR_HomePageController(sc);
        controller = new LPDCR_HomePageController();
        Account a = controller.selectedAcc;
        List<Account> accLst = controller.accLst;
        Id selectedAccountId = controller.selectedAccountId;
        //controller.checkCache();
        system.assertEquals(controller!=null,true);
    }
}