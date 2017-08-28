/**
*   @Author:    Heena Tanna
*   @Date:      14.03.2017
*   @Jira:      LPDCR-1995
*   @Purpose:   Controller behind LPDCR_CC_ContactUs page
*/

public without sharing class LPDCR_ContactUsController {
    
    public User userName{get;set;}
    public Contact contactObj{get;set;}
    public OrgWideEmailAddress emailObj{get;set;}
    public String selectedAccountId{get;set;}
    public Account selectedAcc{get;set;}
    public List<EmailServicesAddress> addresses { get; set; }
    public String toSendAddress { 
        get{
            if(toSendAddress == null || toSendAddress == ''){
                toSendAddress = Label.LPDCR_Contact_DefaultEmail;
                setContactReason();
            }
            return toSendAddress;
        }
        set; }
    public String displayAddress { 
        get {
            if(displayAddress == null || displayAddress == ''){
                displayAddress = Label.LPDCR_Contact_DefaultEmail;
            }
            return displayAddress;
        }
        set; }
    public String emailBody { get; set; } 
    public String subject { get; set; }
    public String contactReason { get; set; }
    
    /** Constructor**/
    public LPDCR_ContactUsController(){
        //initialize();
        getContactDetails();
    }
   
    //Initialize Method
    public void initialize(){
        try{
            selectedAccountId = LPDCR_ChangeAccountController.getSelectedAccId();
            if(selectedAccountId != null){
                selectedAcc = [Select Id, Name, Customer_Ops_Region__c, Dealer_Category_catcode30__c, Member_Type_catcode1__c, AR_Customer_Group_JDE__c, BusinessBuilderProgramStatus__c,AccountNumber from Account where Id =: selectedAccountId];
                System.debug('selectedAcc--'+selectedAcc);
                subject = selectedAcc.Name;
            }
        }
        catch(Exception ex){
            ApexPages.addmessages(ex);
            LOLUtilities.LogErrMsg('LPDCR_ContactUsController',ex, 'Exception occurred');
        }
    }
    
    //Get Contact Details  
    public void getContactDetails(){  
      
        userName = [Select Name,ContactId,Email from User where Id=:UserInfo.getUserId()];
        if(userName.ContactId!=null){
            contactObj = [Select Id,OwnerId,Name,Email,AccountId,Account.BillTo_flag__c from Contact where Id=:userName.ContactId];
        	//System.debug('~~~getContactDetails()-> contactObj ' + contactObj);
        }
        //Get OrgWideEmailAddress
        emailObj=[SELECT Address,CreatedById,CreatedDate,DisplayName FROM OrgWideEmailAddress where DisplayName =: system.label.LPDCR_PurinaCCEmailDisplayName];
        //System.debug('~~~getContactDetails()-> emailObj ' + emailObj);
    }
   
    //Method to send email to the community user
    public PageReference sendEmail(){   
        try{ 
            //toSendAddress = system.label.LPDCR_PurinaEmailServiceAddress;
            
            List<String> sendAddressLst = new List<String>();
            sendAddressLst.add(toSendAddress);
            //New single email message object
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            //Assign To address            
        	//System.debug('~~~sendEmail()-> sendAddressLst ' + sendAddressLst);
            message.setToAddresses(sendAddressLst);
            
            //Set subject
            message.setSubject(subject);
            message.setUseSignature(false);
            //Set html content of the email
            message.setHtmlBody(emailBody);
            
            //Send the email
            if (String.isBlank(emailBody)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Please add your Message to complete the form.'));
                return null;
             }
            List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage> {message};
         	//System.debug('~~~sendEmail()-> messages ' + messages);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(messages);
                
            
            if (results.size()>0 && results[0].success){
                System.debug('The email was sent successfully.');  
                PageReference congratsPage = new PageReference('/apex/LPDCR_CC_ContactUs_Confirmation');
                congratsPage.setRedirect(true);  
                return congratsPage;        
            }
            
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'The email failed to send: ' + results[0].errors[0].message ) ); 
            }
        }
        catch(Exception ex){
            ApexPages.addmessages(ex);
            LOLUtilities.LogErrMsg('LPDCR_ContactUsController',ex, 'Exception occurred');        
        }
        return null;
    }
    
    public void setContactReason(){
        
        if(addresses == null){
            addresses = [SELECT EmailDomainName, IsActive, AuthorizedSenders, LocalPart FROM EmailServicesAddress];
        }
        
        if(contactReason == null || contactReason == '' || contactReason == Label.LPDCR_Contact_Regarding_Other){
            // All/Other Option
            contactReason = Label.LPDCR_Contact_Regarding_Other;
            displayAddress = Label.LPDCR_Contact_OtherEmail;
        }
        else if(contactReason != null ){
            Contact_Us_Regional_Emails__c regionalEmailObj;
            // Order / Pricing Related Questions option
            if(selectedAcc != null){
                regionalEmailObj = Contact_Us_Regional_Emails__c.getValues(selectedAcc.Customer_Ops_Region__c);
            }
            else if(selectedAcc == null && contactReason == Label.LPDCR_Contact_Regarding_Other){
                displayAddress = Label.LPDCR_Contact_OtherEmail;
            }
            else{
                displayAddress = Label.LPDCR_Contact_DefaultEmail;
            }
            if(regionalEmailObj != null){
                displayAddress = regionalEmailObj.Email__c;
            }
            
            if(selectedAcc != null && (regionalEmailObj == null || displayAddress == null)){
                displayAddress = Label.LPDCR_Contact_DefaultEmail;
            }
            
        }
        /*if(UserInfo.getUserType() == 'STANDARD'){
            displayAddress = Label.LPDCR_Contact_DefaultEmail;
        }*/
        
        if(displayAddress != null){
            for(EmailServicesAddress address: addresses){
                if(displayAddress.contains(address.LocalPart)){
                    toSendAddress = address.LocalPart+'@'+address.EmailDomainName;
                    break;
                }
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Email Address not available'));            
        }
        
        
        System.debug('contactReason- '+contactReason+', toSendAddress- '+toSendAddress);
    }
}