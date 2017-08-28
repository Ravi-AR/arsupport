/*
ClassName: cc_oo_ContactUSEmailController

Developer Name                    Date										User story
Saloni Kale						2/9/2017							US:OO-2036 Contact customer service display Updates
*/
global class cc_oo_ContactUSEmailController{
    public static final string CLASS_NAME = 'cc_oo_ContactUSEmailController';
    public static String CSREmailAddress {get;set;}
    public static String dedicatedCustomerOpRep {get;set;}
    public static String dedicatedCustomerOpRepName{get;set;}
    public static String CSRPhoneNumber {get;set;}
    public static String fromEmailAddress {get;set;}
    public static String shipToNumber{get;set;}
    public String dedicatedCustomerOpRepFirstName{get;set;}
    public String dedicatedCustomerOpRepLastName{get;set;}
    
    public static String accName {get;set;}
    /*To display ship to number, email address in the CSR popup*/
    public cc_oo_ContactUSEmailController(){
        CSREmailAddress = LOLSettings__c.getAll().get('CSR_EmailAddress').Value__c;
        CSRPhoneNumber =ccrz.cc_CallContext.pageLabels.get('CSRphone');
        Account accData = [select Name, AccountNumber,Email__c, Dedicated_Customer_Op_Rep__c,Dedicated_Customer_Op_Rep__r.FirstName,Dedicated_Customer_Op_Rep__r.LastName from Account where id=: ccrz.cc_CallContext.currAccountId Limit 1];
        User userData = [select Name, Email from User where Id = :UserInfo.getUserId() Limit 1];
        System.debug('accData: ' + accData);
        System.debug('userData: ' + userData);
        if(accData.AccountNumber!=Null){
            shipToNumber = accData.AccountNumber;
        }
        if(accData.Dedicated_Customer_Op_Rep__c!=NULL){
            dedicatedCustomerOpRepFirstName = accData.Dedicated_Customer_Op_Rep__r.FirstName.substring(0,1);
            dedicatedCustomerOpRepLastName = accData.Dedicated_Customer_Op_Rep__r.LastName;
            dedicatedCustomerOpRepName = dedicatedCustomerOpRepFirstName + ' ' + dedicatedCustomerOpRepLastName;
        }
        if(userData.Email!=Null){
            fromEmailAddress = userData.Email;
        }
        if(accData.Name!=Null){
            accName = accData.Name;
        }
    }
    
    /*Getting the To Email, from email address, ship to account, account name for sending an email*/
    @RemoteAction
    global static ccrz.cc_RemoteActionResult sendEmailDetails(final ccrz.cc_RemoteActionContext ctx, String message){
        System.debug('In sendEmailDetails----->');
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        res.success = true; 
        String ToEmail, FromEmail, subject;
        CSREmailAddress = LOLSettings__c.getAll().get('CSR_EmailAddress').Value__c;
        Account accData = [select Id, Name, AccountNumber,Email__c, Dedicated_Customer_Op_Rep__c,Dedicated_Customer_Op_Rep__r.Name from Account where id=: ccrz.cc_CallContext.currAccountId Limit 1];
        
        System.debug('current account id---->' +ccrz.cc_CallContext.currAccountId);
        User userData = [select Name, Email from User where Id = :UserInfo.getUserId() Limit 1];
        if(userData.Email!=Null){
            fromEmailAddress = userData.Email;
        }
         System.debug('Account data: ' +accData.Name);
        if(accData.Name!=Null){
            accName = accData.Name;
        }
       
        System.debug('account name ---->' +accName);
        if(accData.AccountNumber!=Null){
            shipToNumber = accData.AccountNumber;
        }
        try
        { 
            cc_oo_HelperController helperCtrl = new cc_oo_HelperController();
            helperCtrl.sendEmail(CSREmailAddress,fromEmailAddress,accName+'-'+shipToNumber,message);
            res.success = true;
            return res;
        }catch(Exception ex){
            cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'sendEmailDetails');
        }
        return res;
     }
}