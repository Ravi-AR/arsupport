/*
ClassName: cc_oo_FooterController

Developer Name                    Date										User story
Saloni Kale						2/9/2017							US:OO-2036 Contact customer service display Updates
*/
global class cc_oo_FooterController{
    public String CSREmailAddress {get;set;}
    public String dedicatedCustomerOpRep {get;set;}
    public String dedicatedCustomerOpRepName{get;set;}
    public String CSRPhoneNumber {get;set;}
    public String fromEmailAddress {get;set;}
    public String shipToNumber{get;set;}
    public String dedicatedCustomerOpRepFirstNameInitial{get;set;}
    public String dedicatedCustomerOpRepLastName{get;set;}
    /*Used to display details on CSR popup*/
    public cc_oo_FooterController(){
        CSREmailAddress = LOLSettings__c.getAll().get('CSR_EmailAddress').Value__c;
        CSRPhoneNumber = LOLSettings__c.getAll().get('CSR_PhoneNumber').Value__c;
        Account accData = [select Name, AccountNumber,Email__c, Dedicated_Customer_Op_Rep__c,Dedicated_Customer_Op_Rep__r.FirstName,Dedicated_Customer_Op_Rep__r.LastName from Account where id=: ccrz.cc_CallContext.currAccountId Limit 1];
        User userData = [select Name, Email,FirstName,LastName from User where Id = :UserInfo.getUserId() Limit 1];
        System.debug('accData: ' + accData);
        System.debug('userData: ' + userData);
        if(accData.AccountNumber!=Null){
            shipToNumber = accData.AccountNumber;
        }
        if(accData.Dedicated_Customer_Op_Rep__c!=NULL){
            dedicatedCustomerOpRepFirstNameInitial = accData.Dedicated_Customer_Op_Rep__r.FirstName.substring(0,1);
            dedicatedCustomerOpRepLastName = accData.Dedicated_Customer_Op_Rep__r.LastName;
            dedicatedCustomerOpRepName = dedicatedCustomerOpRepFirstNameInitial + ' ' + dedicatedCustomerOpRepLastName;
        }
        if(accData.Name!=Null){
            dedicatedCustomerOpRep = accData.Name;
        }
        
        if(userData.Email!=Null){
            fromEmailAddress = userData.Email;
        }
    }
}