/**
*   @Author:    Heena Tanna
*   @Date:      20.12.2016
*   @Jira:      LPDCR-852
*   @Purpose:   Controller behind LPDCR_BBEnrollment page
*
*/

public without sharing class LPDCR_BBEnrollmentController
{ 
    public static User userName{get;set;}
    public static Contact contactObj{get;set;}
    public static Account dealerAccount{get;set;} 
    public SellingSupportProgramYear__c ssprgmYearObj{get;set;}
    public BusinessBuilderProgramYear__c bbprgmYear {get; set;}
    public static string selectedAccId;
    public static string selectedProgYearId;
    public Document documentObj { get; set; }
    @TestVisible private final Account acct; 
    Set<ID> dealerAccountIdSet = new Set<Id>();
    

        // Constructor
        public LPDCR_BBEnrollmentController() 
        {         
         selectedAccId = ApexPages.currentPage().getParameters().get('Accountid');
         selectedProgYearId = ApexPages.currentPage().getParameters().get('BBYearId');
         getAccountdetails();
         
        }
        
        public List<Account> getAccountdetails()
        {
        userName = [Select Name,ContactId from User where Id=:UserInfo.getUserId()];
        contactObj = [Select OwnerId,Name,AccountId from Contact where Id=:userName.ContactId];
        if(contactObj.AccountId!=null)
        {
            dealerAccount = [Select Id, Name from Account where Id =: selectedAccId];
            System.debug ('+++++'+ dealerAccount);
            
            dealerAccountIdSet.add(dealerAccount.Id);
        }
       
        
        if(dealerAccountIdSet.size()>0)
            {
               bbprgmYear = [Select Id,Name,TermsandConditionsforProgramYear__c 
                               FROM BusinessBuilderProgramYear__c 
                               WHERE Id=:selectedProgYearId];
               
               System.debug('BBYear'+ bbprgmYear);
               
                List<SellingSupportProgramYear__c> ssprgmYear = [SELECT Id,Name, Account__r.Name,Account__c,
                                                                LPSProjectNumberofFieldDays__c,LPSworkingmin100FieldDays__c,
                                                                SalespersonNumberofFieldDays__c,Salespersonworkingmin100fielddays__c,BusinessBuilderProgramStatus__c,
                                                                TermsandConditionsAccepted__c,BusinessBuilderProgramYear__r.Id,BusinessBuilderProgramYear__r.TermsandConditionsforProgramYear__c 
                                                                FROM SellingSupportProgramYear__c 
                                                                    WHERE Account__r.id =:dealerAccountIdSet 
                                                                    AND BusinessBuilderProgramYear__r.Id =: selectedProgYearId];
                
                if(ssprgmYear.size()>0){
                    ssprgmYearObj = ssprgmYear[0];   
                    ssprgmYearObj.BusinessBuilderProgramStatus__c ='Enrolled';               
                }
                /*else if([Select Id, Name from SellingSupportProgramYear__c 
                WHERE Account__r.id =:dealerAccountIdSet AND BusinessBuilderProgramYear__r.Id =: selectedProgYearId]){
                
                }*/
                else{
                    ssprgmYearObj = new SellingSupportProgramYear__c();
                    ssprgmYearObj.BusinessBuilderProgramYear__c =selectedProgYearId;
                    ssprgmYearObj.Name = selectedProgYearId;
                    ssprgmYearObj.Program_Year_Allocation__c = null;
                    ssprgmYearObj.BusinessBuilderProgramStatus__c = 'Enrolled';
                    ssprgmYearObj.Account__c = dealerAccount.Id;
                }
                System.debug('Year+++' + ssprgmYearObj);
            }
            
            getBBDocumentPDF();
            
            return null;
        }
        
        public PageReference updateSSProgYear()
        {
            if(ssprgmYearObj.TermsandConditionsAccepted__c == false)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please accept Terms and Conditions');
                ApexPages.addMessage(myMsg);
                return null;
            }
            else{
                System.debug('PNFD'+ ssprgmYearObj.LPSProjectNumberofFieldDays__c);
                System.debug('PNFDcheckbox'+ ssprgmYearObj.LPSworkingmin100FieldDays__c);
                System.debug('SNFD'+ssprgmYearObj.SalespersonNumberofFieldDays__c);
                System.debug('SNFDcheckbox'+ssprgmYearObj.Salespersonworkingmin100fielddays__c);
                upsert ssprgmYearObj;
                PageReference congratsPage = new PageReference('/apex/LPDCR_BBConfirmation');
                congratsPage.setRedirect(true);
                return congratsPage;
            }
        }
        
        public void getBBDocumentPDF(){
        
            List<CustomerEventMetadata__c> custEveList = new List<CustomerEventMetadata__c>();        
            custEveList = [SELECT Id, Business_Builder_Program_Year__c, Business_Builder_Program_Year__r.Name, Document_Name__c, DocumentDeveloperName__c,
                            DocumentFolderDeveloperName__c, MetadataType__c, Description__c, Display_Order_for_Type__c 
                            FROM CustomerEventMetadata__c 
                                WHERE Business_Builder_Program_Year__c =: bbprgmYear.Id 
                            AND ((DocumentFolderDeveloperName__c =: LPDCR_Constants.CONS_BB_DOCUMENTS) 
                            AND (Display_Start_Date__c <=: Date.Today() AND Display_End_Date__c >=: Date.Today()))];
                            
            System.debug('custEveList ---'+custEveList.size());        
        
            documentObj = new Document();            
            documentObj = [SELECT Id, Name, DeveloperName, Folder.DeveloperName FROM Document WHERE Folder.DeveloperName =: custEveList[0].DocumentFolderDeveloperName__c AND DeveloperName =: custEveList[0].DocumentDeveloperName__c];
            
            System.debug('documentObj ---'+documentObj);
            
        }
     
}