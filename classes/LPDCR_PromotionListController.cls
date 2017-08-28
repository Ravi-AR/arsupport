/**
*   @Author:    Heena Tanna
*   @Date:      30.09.2016
*   @Jira:      LPDCR-20
*   @Purpose:   Controller for LPDCR_PromotionList and LPDCR_PromotionsDetail
*/

public without sharing class LPDCR_PromotionListController
{    

    public string attachmentId {get;set;}   
    public CampWrapperClass cam{get;set;}  
    public string bannerdesktopId {get;set;}  
    public String ccUri {get; private set;}
    
  @TestVisible  private Campaign camp;
  
    public List<Campaign> getCampaigns()
        {
            List<Campaign> lstCam = new List<Campaign>();
            
            try{
                    lstCam = [SELECT Id,Name,Pre_Book_Discount_Code__c,Pre_Book_Start_Date__c,Pre_Book_End_Date__c,
                        Promotion_Discount_Code__c,Date_Range__c,Pre_Book_Date_Range__c,Promotion_Start_Date__c,Promotion_End_Date__c
                    FROM Campaign 
                    WHERE IsActive = TRUE 
                          AND (RecordType.DeveloperName =:  LPDCR_Constants.CONS_CampRecType OR RecordType.DeveloperName =: LPDCR_Constants.CONS_CampBBRecType) 
                          AND (ExternalVisibilityStartDate__c<=:Date.Today() 
                                AND ExternalVisibilityEndDate__c>=:Date.Today()) 
                    ORDER BY Display_Order__c ASC];
                
            }
            catch(Exception ex){
                
                 LOLUtilities.LogErrMsg('LPDCR_PromotionListController',ex, 'Exception occurred');
            }
            return lstCam;
        }   
        
        public void getCampaignDetail(){
        
            Id campId = Apexpages.currentPage().getParameters().get('Id');
            Campaign c = [SELECT Id,Name,Pre_Book_Discount_Code__c,Pre_Book_Start_Date__c,Pre_Book_End_Date__c,
                Promotion_Discount_Code__c,Call_To_Action_URL__c,Brochure_Content__c ,Promotion_Description__c ,Call_To_Action_Button_Text__c,Date_Range__c,Pre_Book_Date_Range__c,Promotion_Start_Date__c,Promotion_End_Date__c FROM Campaign where Id=: campId];
            List<Attachment> attObj = [Select Id,Name FROM Attachment WHERE ParentId =:c.id];
            cam = new CampWrapperClass();
            cam.camObj = c;
            
            //cam.attLst = attObj;//LPDCR-971
            if(cam!=null)
            fetchAttachmentRecord();
            
        }
        
        public class CampWrapperClass{
            public Campaign camObj{get;set;}
            //public List<Attachment> attLst{get;set;}
            //public List<Document> docList{get;set;}
        }
                
       public LPDCR_PromotionListController(ApexPages.StandardController stdController)
       {   
           
            //### TODO: Decide whether to populate the URL using CC_Portal_Sign_Up_URL_Non_SSO__c or 
            //###       the CC_Portal_Sign_Up_URL_SSO__c field from the custom setting
           ccUri = ''; 
           if (!Test.isRunningTest())
           {
               stdController.addFields(new List<String>{'Promotion_Discount_Code__c'});
               this.camp = (Campaign)stdController.getRecord();
               ccUri = LPDCR_Org_Settings__c.getInstance().CC_Portal_Sign_Up_URL_Non_SSO_User__c;
               System.debug('ccUri: ' + ccUri);
               if(ccUri != null && this.camp.Promotion_Discount_Code__c != null)
               //ccUri = ccUri.replace('[PROMO_CODE]',this.camp.Promotion_Discount_Code__c);
               //LPDCR-1160 23rd Nov  
               ccUri = ccUri.replace('[PROMO_CODE]',this.camp.Pre_Book_Discount_Code__c);        
           }
           fetchAttachmentRecord();
       }


      public LPDCR_PromotionListController(){}
   
    
    //LPDCR- 971 Method to fetch images from Documents. Do not delete.
    public void fetchAttachmentRecord()
    {
      
        List<CustomerEventMetadata__c> custEveList = new List<CustomerEventMetadata__c>();
        if(cam!=null && cam.camObj!=null)
        custEveList =[Select Id,Campaign__c,DocumentDeveloperName__c,DocumentFolderDeveloperName__c,MetadataType__c FROM CustomerEventMetadata__c WHERE Campaign__c=: cam.camObj.Id ];
    
        if(custEveList.size()>0)
        {
            Set<String> folderDeveloperNameSet = new Set<String>();
            Set<String> docDeveloperNameSet = new Set<String>();
            Map<String,CustomerEventMetadata__c> fileDetailMap = new Map<String,CustomerEventMetadata__c>();
            
            for(CustomerEventMetadata__c cem : custEveList)
            {
                folderDeveloperNameSet.add(cem.DocumentFolderDeveloperName__c);
                docDeveloperNameSet.add(cem.DocumentDeveloperName__c);
                
                fileDetailMap.put(cem.MetadataType__c, cem);
            }
            System.debug('folderDeveloperNameSet--'+folderDeveloperNameSet);
            System.debug('docDeveloperNameSet--'+docDeveloperNameSet);
            System.debug('fileDetailMap--'+fileDetailMap);
            
            
            List<Document> allDocs = [SELECT Id, DeveloperName, Folder.DeveloperName FROM Document WHERE Folder.DeveloperName IN: folderDeveloperNameSet AND DeveloperName IN: docDeveloperNameSet];
            System.debug('allDocs--'+allDocs);
            if(allDocs!=null && allDocs.size()>0)
            {
               for(Document docObj : allDocs)
               {
               
                  if(fileDetailMap.containsKey('Banner Desktop') && 
                  fileDetailMap.get('Banner Desktop').DocumentDeveloperName__c == docObj.DeveloperName)
                  {
                      bannerdesktopId = docObj.Id;
                  }
                  if(fileDetailMap.containsKey('Download PDF') && 
                  fileDetailMap.get('Download PDF').DocumentDeveloperName__c == docObj.DeveloperName)
                  {
                      attachmentId = docObj.Id;
                  }
                  
               }
            }
        }
    }
                  
}