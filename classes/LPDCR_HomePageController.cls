/**
*   @Author:    Shruti Mishra
*   @Date:      03.10.2016
*   @Jira:      LPDCR-519
*   @Purpose:   Controller behind LPDCR_Homepage
*/

public without sharing class LPDCR_HomePageController{

    public List<Campaign> lstCam {get;set;}
    public CampWrapper camObj{get;set;}
    //public static Decimal currentBalance{get;set;}
    //public static String currentYear {get;set;}
    //public static List<Attachment> attachments{get;set;}    
    public List<Account> accObj{get;set;}
    public Account selectedAcc{get;set;}
    //public User userName{get;set;}
    //public Contact contactObj{get;set;}
    public List<Account> accLst{get;set;}
     //Private
    //public Id accountId;
     public Id selectedAccountId{get;set;}

    public LPDCR_HomePageController() {
        accObj = new List<Account>();        
        initialize();
        
    }
    public LPDCR_HomePageController(ApexPages.StandardController controller){
    }
    public void checkCache()
    {    
        selectedAccountId = LPDCR_ChangeAccountController.getSelectedAccId();
        system.debug('**selectedAccountId'+selectedAccountId);   
    
    }
    public void initialize(){
        try{
            
            fetchAttachmentRecord();
            //getSSBalanceAmt(); 
        }
        catch(Exception ex){
           LOLUtilities.LogErrMsg('LPDCR_HomePageController',ex, 'Exception occurred');
           System.debug('HPexception'+ ex);
        }
        
    }

    // Method to get Selling Support Balance Amount
    /*public Decimal getSSBalanceAmt(){
        //Id accId = Apexpages.currentPage().getParameters().get('AccountId');
        currentBalance = 0;
        currentYear = String.valueOf(Date.Today().Year());
        try{
                User userName=[Select Id,Name,ContactId from User where Id=:UserInfo.getUserId()];
                Contact c = [Select OwnerId,Name,AccountId from Contact where Id=:userName.ContactId];
                accObj = [Select Id,Ultimate_Parent__c,Member_Type_catcode1__c,AR_Customer_Group_JDE__c,BusinessBuilderProgramStatus__c,Business_Builder_Program_Tier__c,(Select Id,Name,Account__c,Available_Balance__c from Selling_Support_Program_Years__r where Name =:currentYear ) from Account where Id=:c.AccountId];
                if(accObj!=null){
                    System.debug('accObj -- '+accObj );
                    if(accObj[0].Ultimate_Parent__c==null)
                    {
                        if(accObj.size()>0 && accObj[0].Selling_Support_Program_Years__r.size()>0 && accObj[0].BusinessBuilderProgramStatus__c =='Registration Approved')
                        {                
                           currentBalance = Math.ceil(accObj[0].Selling_Support_Program_Years__r[0].Available_Balance__c.Abs());
                        }   
                    }                 
                    else{                    
                        //System.debug('accObj[0].Ultimate_Parent__c-----'+accObj[0].Ultimate_Parent__c);
                        accObj = [Select Id,BusinessBuilderProgramStatus__c,Member_Type_catcode1__c,AR_Customer_Group_JDE__c,Business_Builder_Program_Tier__c,(Select Id,Name,Account__c,Available_Balance__c from Selling_Support_Program_Years__r where Name =:currentYear ) from Account where Id=:accObj[0].Ultimate_Parent__c];
                        if(accObj!=null && accObj.size()>0 && accObj[0].BusinessBuilderProgramStatus__c =='Registration Approved')
                        {  
                            if(accObj[0].Selling_Support_Program_Years__r[0].Available_Balance__c!=null)
                            {
                                currentBalance = Math.ceil(accObj[0].Selling_Support_Program_Years__r[0].Available_Balance__c.Abs());
                            }
                        } 
                    }  
                }
                System.debug('accObj.size -- '+accObj.size());           
        }
        catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'No Contact for logged in user');
            ApexPages.addMessage(myMsg);
            
            LOLUtilities.LogErrMsg('LPDCR_HomePageController',ex, 'Exception occurred');
        }

        return currentBalance;
    }*/
        
    
    //LPDCR- 971 Method to fetch images from Documents.
    public void fetchAttachmentRecord()
    {
        List<Id> camIds=new List<Id>();
        for(Campaign c:[SELECT Id,Name,Pre_Book_Discount_Code__c,Pre_Book_Start_Date__c,Pre_Book_End_Date__c,Display_Order__c,Promotion_Start_Date__c,Promotion_End_Date__c,
            Promotion_Discount_Code__c,Date_Range__c FROM Campaign WHERE IsActive = TRUE AND (RecordType.DeveloperName =: LPDCR_Constants.CONS_CampRecType OR RecordType.DeveloperName =: LPDCR_Constants.CONS_CampBBRecType) AND (ExternalVisibilityStartDate__c<=:Date.Today() AND ExternalVisibilityEndDate__c>=:Date.Today()) ORDER BY Display_Order__c ASC])
        {
            camIds.add(c.Id);   
        }
      
        List<CustomerEventMetadata__c> custEveList = new List<CustomerEventMetadata__c>();
        custEveList =[Select Id,Campaign__c,DocumentDeveloperName__c,DocumentFolderDeveloperName__c,MetadataType__c FROM CustomerEventMetadata__c WHERE Campaign__c IN : camIds and MetadataType__c=:'Slide Carousel' ORDER BY Campaign__r.Display_Order__c ASC  ];//and MetadataType__c=:'Carousel Desktop' changed to MetadataType__c=:'Slide Carousel'9th Mar Heena
    
        if(custEveList.size()>0)
        {
            Set<String> folderDeveloperNameSet = new Set<String>();
            Set<String> docDeveloperNameSet = new Set<String>();
            
            for(CustomerEventMetadata__c cem : custEveList)
            {
                folderDeveloperNameSet.add(cem.DocumentFolderDeveloperName__c);
                docDeveloperNameSet.add(cem.DocumentDeveloperName__c);
            }
            //Display order of Carousel 
            List<Document> tempLst = new List<Document>();
            List<Document> allDocs = new List<Document>();
            tempLst = [SELECT Id, DeveloperName, Folder.DeveloperName FROM Document WHERE Folder.DeveloperName IN: folderDeveloperNameSet AND DeveloperName IN: docDeveloperNameSet];
            
            for(String str : docDeveloperNameSet){
                for(Document dmt : tempLst){
                    if(dmt.DeveloperName == str){
                        allDocs.add(dmt);
                        break;
                    }
                }
            }
            System.debug('Alldocs'+ allDocs);
            if(allDocs!=null && allDocs.size()>0)
            {
                camObj = new CampWrapper();
                camObj.docList = allDocs;
            }
        }
    }
    
    public class CampWrapper{
       // public List<Attachment> attLst{get;set;}
        public List<Document> docList{get;set;}
    }
    
    
}