/**
*   @Author:    Heena Tanna
*   @Date:      15.10.2016
*   @Jira:      LPDCR-852, LPDCR-853, LPDCR-720
*   @Purpose:   Controller behind LPDCR_BBPLandingMember page
*/

public without sharing class LPDCR_BBPLandingMemberController 
{
    //public User userName{get;set;}
    //public Contact contactObj{get;set;}
    public BusinessBuilderProgramYear__c selectedProgYear{get;set;}
    public Id selectedProgYearId{get;set;}
    public Account selectedAcc{get;set;}
    public List<Account> accLst{get;set;}//Uncommenting this line of code for AR CI deployment to work - please fix the reference on LPDCR_BBPLandingMember visual force page
    public List<BBWrapper> bbWrapperList{get;set;}//LPDCR 1712 
    
    public String selectedAccountId
    {
        get {
            if( selectedAccountId == null) {
                selectedAccountId = LPDCR_ChangeAccountController.getSelectedAccId();
            }
            return selectedAccountId;
        }
        set;
    }
    
    public List<BusinessBuilderProgramYear__c> activeBBProgramYrs
    {
        get {
            if( activeBBProgramYrs == null && UserInfo.getUserType() != 'Standard' ) {
                //Get Active BBPY list
                activeBBProgramYrs = [ SELECT Id, Name, EnrollmentStartDate__c, EnrollmentEndDate__c, StartDate__c, EndDate__c 
                                       FROM BusinessBuilderProgramYear__c 
                                       WHERE ((StartDate__c <=: Date.Today() 
                                                AND EndDate__c >=: Date.Today()) 
                                             OR(EnrollmentStartDate__c <=: Date.Today() 
                                                 AND EnrollmentEndDate__c >=: Date.Today()) 
                                             ) 
                                       ORDER BY StartDate__c limit 2 ];
            }
            return activeBBProgramYrs;
        }
        
        set;
    }
    
    public List<SellingSupportProgramYear__c> activeSSProgramYrs
    {
        get {
            if( activeSSProgramYrs == null && UserInfo.getUserType() != 'Standard' ) {
                //Get Active SSPY list
                activeSSProgramYrs = [ SELECT Id, Name, Program_Year_Allocation__c, BusinessBuilderProgramYear__r.EnrollmentStartDate__c, BusinessBuilderProgramYear__r.Name, BusinessBuilderProgramStatus__c 
                                       FROM SellingSupportProgramYear__c 
                                       WHERE Account__c =: selectedAccountId 
                                           AND BusinessBuilderProgramStartDate__c <=: Date.Today() 
                                           AND BusinessBuilderProgramEndDate__c >: Date.Today() ];
            }
            return activeSSProgramYrs;
        }        
        
        set;
    }
    
    //Called from LPDCR_CC_BusinessBuilder Component
    public Boolean init{
        get{
            
            initialize();
            return false;
        }set;
    }
    
    //Constructor
    public LPDCR_BBPLandingMemberController(){  
       /* if( UserInfo.getUserType() != 'Standard' && selectedAcc.ParentId == null ){    
            getbbdocument();//LPDCR 1712      
        }*/
    }

    //Initialize method
    public void initialize(){
        System.debug( 'START: LPDCR_BBPLandingMemberController.initialize()' );
        try{
            if(selectedAccountId != null && UserInfo.getUserType() != 'Standard' ){
                //Get Selected Account from AccountId passed
                selectedAcc = [Select Id, ParentId,Name, Dealer_Category_catcode30__c, Member_Type_catcode1__c, AR_Customer_Group_JDE__c, BusinessBuilderProgramStatus__c,AccountNumber from Account where Id =: selectedAccountId];
                System.debug('BBlanding selectedAcc.ParentId' + selectedAcc.ParentId);
                if(selectedAcc.ParentId == null){
                getAccVsYearDetails();
                getbbdocument();
                }
            }//If null check ends
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_BBPLandingMemberController',ex, 'Exception occurred');
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'An error occurred while trying to retreive your current account and program year information.' ) );
        }
        
        System.debug( 'END: LPDCR_BBPLandingMemberController.initialize()' );
    }
    
    //Method to get Account Details based on Year    
    public List<AccountVsYear> getAccVsYearDetails(){
        List<AccountVsYear> accVsYearLst = new List<AccountVsYear>();
        try {
        if(UserInfo.getUserType() != 'Standard' && selectedAcc.ParentId == null){
        
            List<SellingSupportProgramYear__c> sspyLst = [Select Id, Name, Available_Balance__c, BusinessBuilderProgramTier__c, Total_Pending_Requests__c, Program_Year_Allocation__c, BusinessBuilderProgramEndDate__c, Total_Approved_Requests__c,Total_Balance_Adjustments__c, BusinessBuilderProgramYear__r.EnrollmentStartDate__c, BusinessBuilderProgramYear__r.Name, BusinessBuilderProgramStatus__c
                from SellingSupportProgramYear__c where Account__c =: selectedAccountId AND 
                ((BusinessBuilderProgramStartDate__c <=: Date.Today() AND BusinessBuilderProgramEndDate__c >=: Date.Today()) OR 
                BusinessBuilderProgramStatus__c =: LPDCR_Constants.CONS_ENROLLED)]; // BusinessBuilderProgramStatus__c = 'Enrolled' added Task 1585
            
            Map<Id,SellingSupportProgramYear__c> sspyVsBbpyMap = new Map<Id,SellingSupportProgramYear__c>();
            
            for(SellingSupportProgramYear__c s: sspyLst){
                sspyVsBbpyMap.put(s.BusinessBuilderProgramYear__c, s);
            }
            
            //Initialize all fields for inner class
            for(BusinessBuilderProgramYear__c bbYear: activeBBProgramYrs){
            System.debug('bbYear---'+bbYear);
                AccountVsYear accVsYr = new AccountVsYear();
                accVsYr.programYear = bbYear.Name;
                accVsYr.bbPYRec = bbYear;
                accVsYr.ssPYRec = sspyVsBbpyMap.get(bbYear.Id);
                if(accVsYr.ssPYRec!=null){
                    accVsYr.availableBalance = accVsYr.ssPYRec.Available_Balance__c /* + accVsYr.ssPYRec.Total_Pending_Requests__c */ ;
                    accVsYr.totalEarned = accVsYr.ssPYRec.Total_Approved_Requests__c + accVsYr.ssPYRec.Total_Pending_Requests__c;
                    // if((accVsYr.totalEarned !=null && accVsYr.ssPYRec.Program_Year_Allocation__c!=null && accVsYr.ssPYRec.Total_Balance_Adjustments__c!=null) && ( (accVsYr.ssPYRec.Program_Year_Allocation__c + accVsYr.ssPYRec.Total_Balance_Adjustments__c) != 0)){
                    if(accVsYr.ssPYRec.Program_Year_Allocation__c != null && accVsYr.ssPYRec.Program_Year_Allocation__c != 0 ){
                        // accVsYr.earnedPerc = (accVsYr.totalEarned/(accVsYr.ssPYRec.Program_Year_Allocation__c+accVsYr.ssPYRec.Total_Balance_Adjustments__c) * 100).setScale(2);
                        accVsYr.earnedPerc = (1 - (( accVsYr.availableBalance / accVsYr.ssPYRec.Program_Year_Allocation__c )).setScale( 2 ) ) * 100;
                        if( accVsYr.earnedPerc < 0 )
                        {
                            accVsYr.earnedPerc = 0;
                        }
                    }
                }
                accVsYr.showenrollMsg = false;
                accVsYr.showAccount = false;
                accVsYr.showTier = false;
                accVsYr.showqualifyMsg = false;
                accVsYr.balanceButNotEnrolled = false;
                accVsYr.showAvailBlncMsg = false;
                accVsYr.createNewPPY = false;
                accVsYr.showAvailBlnc = false;
                accVsYr.enrollStartDate = bbYear.EnrollmentStartDate__c;
                accVsYr.enrollEndDate = bbYear.EnrollmentEndDate__c;
                accVsYr.programStartDate = bbYear.StartDate__c;
                accVsYr.programEndDate = bbYear.EndDate__c;
                //accVsYr.enrollStartDate = accVsYr.bbPYRec.EnrollmentStartDate__c;
                //accVsYr.enrollEndDate = accVsYr.bbPYRec.EnrollmentEndDate__c;
                accVsYr.enrollStartYear = accVsYr.bbPYRec.Name;
                accVsYr.disableEnrollNow = false;
                accVsYearLst.add(accVsYr);
            }
            
            //Check if Direct Account is Eligible or not
            //LPDCR-1591-- 05/01/2017; LPDCR-1720 -- 10/01/2017
            if((selectedAcc.BusinessBuilderProgramStatus__c != LPDCR_Constants.CONS_INELIGIBLE) && ((selectedAcc.Member_Type_catcode1__c == LPDCR_Constants.CONS_COOPERATIVE || selectedAcc.Member_Type_catcode1__c == LPDCR_Constants.CONS_INDEPENDENT_RETAILER) || ((selectedAcc.Member_Type_catcode1__c == LPDCR_Constants.CONS_CO || selectedAcc.Member_Type_catcode1__c == LPDCR_Constants.CONS_IN) && selectedAcc.AR_customer_group_JDE__C == LPDCR_Constants.CONS_RE))){
                for(AccountVsYear accVsYr: accVsYearLst){
                    //Check if Direct Account has any active SSPY Records
                    if(accVsYr.ssPYRec != null){
                        //Added condition for LPDCR-2195; Shruti
                        if(accVsYr.ssPYRec.BusinessBuilderProgramEndDate__c < Date.Today()){
                            accVsYr.showenrollMsg = false;
                            accVsYr.showAccount = false;
                            accVsYr.showTier = false;
                            accVsYr.showqualifyMsg = false;
                            accVsYr.balanceButNotEnrolled = false;
                            accVsYr.showAvailBlncMsg = false;
                            accVsYr.createNewPPY = false;
                        }                        
                        //Check if account is enrolled in active SSPY
                        else if(accVsYr.ssPYRec.BusinessBuilderProgramStatus__c == LPDCR_Constants.CONS_ENROLLED){
                            if(accVsYr.ssPYRec.Program_Year_Allocation__c == null){                                    
                                accVsYr.showAvailBlncMsg = true;                             
                                accVsYr.enrollStartDate = accVsYr.bbPYRec.EnrollmentStartDate__c;
                                System.debug('1--Enrolled and Program Year Allocation is null');
                            }
                            else if(accVsYr.bbPYRec.StartDate__c > Date.Today() || accVsYr.bbPYRec.EndDate__c < Date.Today()){
                                accVsYr.showAvailBlncMsg = true;    
                                accVsYr.showAvailBlnc = true;
                                accVsYr.showTier = true;//1747 
                                accVsYr.enrollStartYear = accVsYr.bbPYRec.Name;//1747                          
                                accVsYr.enrollStartDate = accVsYr.bbPYRec.EnrollmentStartDate__c;
                                System.debug('Additional Criteria if Program Year is not started');
                            }
                            else{
                                if(accVsYr.ssPYRec.Program_Year_Allocation__c != 0 && accVsYr.bbPYRec.StartDate__c <= Date.Today() && accVsYr.bbPYRec.EndDate__c >= Date.Today()){                                                                            
                                    accVsYr.showAccount = true;
                                    accVsYr.showTier = true;
                                    accVsYr.enrollStartYear = accVsYr.bbPYRec.Name;
                                    accVsYr.enrollStartDate = accVsYr.bbPYRec.EnrollmentStartDate__c;
                                    accVsYr.enrollStartYear = accVsYr.bbPYRec.Name;
                                    
                                    System.debug('2--Enrolled, Not null and Program Year Allocation is not 0');
                                }
                                else{
                                    accVsYr.showqualifyMsg = true;                                        
                                    System.debug('3--Enrolled, Not null and Program Year Allocation is 0');
                                }
                            }
                        }
                        else{
                            if(accVsYr.ssPYRec.Program_Year_Allocation__c != 0){
                                accVsYr.showTier = true;
                                accVsYr.balanceButNotEnrolled = true;
                                if(accVsYr.bbPYRec.EnrollmentEndDate__c < Date.Today() && accVsYr.ssPYRec.BusinessBuilderProgramStatus__c != LPDCR_Constants.CONS_ENROLLED){
                                    accVsYr.disableEnrollNow = true;
                                }
                                System.debug('4--Not Enrolled and Program Year Allocation is not equal to 0');
                            }
                            else{
                                if(accVsYr.bbPYRec.EnrollmentEndDate__c < Date.Today() && accVsYr.ssPYRec.BusinessBuilderProgramStatus__c != LPDCR_Constants.CONS_ENROLLED){
                                    accVsYr.disableEnrollNow = true;
                                }
                                accVsYr.showqualifyMsg = true;
                                System.debug('5--Not Enrolled and Program Year Allocation is 0');
                            }
                        }
                    }
                    //Direct Acc doesn't have any active SSPY Record
                    else{
                        if(accVsYr.bbPYRec.EnrollmentStartDate__c <= Date.Today() && accVsYr.bbPYRec.EnrollmentEndDate__c >= Date.Today() && accVsYr.ssPYRec.BusinessBuilderProgramStatus__c != LPDCR_Constants.CONS_ENROLLED ){
                            //BusinessBuilderProgramStatus__c = 'Enrolled' added for task 1585
                            accVsYr.createNewPPY = true;
                            accVsYr.showenrollMsg = true;
                            accVsYr.showAvailBlncMsg =true;//1561- added this line
                            accVsYr.enrollStartDate = accVsYr.bbPYRec.EnrollmentStartDate__c;
                            accVsYr.enrollStartYear = accVsYr.bbPYRec.Name;     
                            System.debug('6--No active SSPY Record but Active enrollment date');                                                    
                        }
                        else{                               
                            System.debug('Data is not setup properly.');
                        }
                    }
                }
            }
            //Direct Acc is not eligible
            else{ System.debug('else236'+ accVsYearLst);
                if(accVsYearLst!=null && accVsYearLst.size()>0){
                    for(AccountVsYear accVsYr: accVsYearLst){
                        
                        System.debug('Account not eligible');
                        return null;
                    }
                }
                
            }
            /*else{
                if(selectedAcc.ParentId != null){
                    System.debug('selectedAcc.ParentId if');
                }
              }*/
            }
        }
        catch(Exception ex){
            LOLUtilities.LogErrMsg('LPDCR_BBPLandingMemberController',ex, 'Exception occurred');
        }
            
        return accVsYearLst;
    }
     
    //Method to create SSPY record if Account doesn't have any SSPY record
    public PageReference createSSPYRecord(){
        
        if(selectedProgYearId!=null){
            selectedProgYear = [Select Id, Name from BusinessBuilderProgramYear__c where Id=: selectedProgYearId];
        }
        
        //RecordType rt = [SELECT Id FROM RecordType WHERE Name=: LPDCR_Constants.CONS_STANDARD AND SobjectType=: LPDCR_Constants.CONS_SSPY_API];
        RecordType rt = [SELECT Id FROM RecordType WHERE Name=: 'Standard' AND SobjectType=: 'SellingSupportProgramYear__c'];
        SellingSupportProgramYear__c sspyRec = new SellingSupportProgramYear__c();   
        if(selectedProgYear!=null){
            sspyRec.recordTypeId=rt.id;
            sspyRec.Name = selectedProgYear.Name;
            sspyRec.Account__c = selectedAcc.Id;
            sspyRec.BusinessBuilderProgramYear__c = selectedProgYear.Id;
            sspyRec.BusinessBuilderProgramStatus__c = LPDCR_Constants.CONS_ENROLLMENT_REQUESTED;
            insert sspyRec;
        }
        
        PageReference retURL = new PageReference('/apex/LPDCR_BBEnrollment?AccountId='+selectedAcc.Id+'&SellingSupportYearId='+sspyRec.Id);
        retURL.setRedirect(true);
        
        return retURL;
    }
    
    //LPDCR 1712 
    //Method to get BB Documents
    public void getbbdocument(){
        List<Id> bbpyIds = new List<Id>();
        bbWrapperList = new List<BBWrapper>();
        for(BusinessBuilderProgramYear__c bbpy:[Select Id,Name,EndDate__c,StartDate__c,EnrollmentEndDate__c,
        EnrollmentStartDate__c FROM BusinessBuilderProgramYear__c WHERE (StartDate__c<=:Date.Today() AND EndDate__c>=:Date.Today())]){
            bbpyIds.add(bbpy.Id);
        }
            
        List<CustomerEventMetadata__c> custEveList = new List<CustomerEventMetadata__c>();
        
        custEveList =[Select Id,Business_Builder_Program_Year__c,Business_Builder_Program_Year__r.Name,Document_Name__c,DocumentDeveloperName__c,
        DocumentFolderDeveloperName__c,MetadataType__c,Description__c,Display_Order_for_Type__c FROM CustomerEventMetadata__c 
        WHERE Business_Builder_Program_Year__c IN : bbpyIds AND 
        ((DocumentFolderDeveloperName__c =:LPDCR_Constants.CONS_BB_DOCUMENTS) AND (Display_Start_Date__c<=:Date.Today() AND Display_End_Date__c>=:Date.Today())) 
        ORDER BY Business_Builder_Program_Year__r.Name, Display_Order_for_Type__c];
        
        if(custEveList.size()>0){
            Set<String> folderDeveloperNameSet = new Set<String>();
            Set<String> docDeveloperNameSet = new Set<String>();
            
            //Map for Object CustomerEvent
            Map<String,CustomerEventMetadata__c> cemMap = new Map<String,CustomerEventMetadata__c>();
            Map<String,String> docFolderMap = new Map<String,String>();//Map to get doc and folder 
            
            for(CustomerEventMetadata__c cem : custEveList){
                folderDeveloperNameSet.add(cem.DocumentFolderDeveloperName__c);
                docDeveloperNameSet.add(cem.DocumentDeveloperName__c);                
                cemMap.put(cem.DocumentDeveloperName__c, cem);
            }
            
            //Get BB Documents
            List<Document> tempLst = new List<Document>();
            List<Document> allDocs = new List<Document>();
            tempLst = [SELECT Id,Name,DeveloperName, Folder.DeveloperName FROM Document WHERE Folder.DeveloperName IN: folderDeveloperNameSet AND DeveloperName IN: docDeveloperNameSet];
            
            for(Document doc: tempLst){
                if(cemMap.containsKey(doc.DeveloperName)){
                    BBWrapper ob = new BBWrapper();
                    ob.docObj = doc;
                    ob.cemObj = cemMap.get(doc.DeveloperName);
                    bbWrapperList.add(ob);
                }
            }
            // Code to Sort the bbWrapperList
            List<String> sortOrderList = new List<String>();
            Map<String,BBWrapper> sortOrderMap = new Map<String,BBWrapper>();
            
            for(BBWrapper bbObj : bbWrapperList){
                sortOrderList.add(bbObj.cemObj.Document_Name__c);
                sortOrderMap.put(bbObj.cemObj.Document_Name__c,bbObj);
            }
            
            sortOrderList.sort();            
            bbWrapperList = new List<BBWrapper>();
            
            for(String i:sortOrderList){
                BBWrapper obj = sortOrderMap.get(i);
                bbWrapperList.add(obj);
            }
        }
    }
    
          
    //Inner class for Account Vs SSPY
    public class AccountVsYear{
        public String programYear{get;set;}
        public Decimal availableBalance{get;set;}
        public Decimal totalEarned{get;set;}
        public Decimal earnedPerc{get;set;}
        public BusinessBuilderProgramYear__c bbPYRec{get;set;}
        public SellingSupportProgramYear__c ssPYRec{get;set;}
        public Boolean showenrollMsg{get;set;}
        public Boolean showAccount {get;set;}
        public Boolean showTier{get;set;}
        public Boolean showqualifyMsg{get;set;}
        public Boolean balanceButNotEnrolled{get;set;}
        public Boolean showAvailBlncMsg{get;set;}
        public Boolean createNewPPY{get;set;}
        public DateTime enrollStartDate{get;set;}
        public DateTime enrollEndDate{get;set;}
        public DateTime programStartDate{get;set;}
        public DateTime programEndDate{get;set;}
        public String enrollStartYear{get;set;}
        public Boolean showAvailBlnc{get;set;}
        public Boolean disableEnrollNow{get;set;}
       
    }
    
    //Inner class to get Document vs DocumentMetadata
    public class BBWrapper{  
        public Document docObj{get;set;}
        public CustomerEventMetadata__c cemObj{get;set;}
    }
}