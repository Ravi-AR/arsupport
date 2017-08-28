/*
 * ContactTriggerHandler
 * Logic for what should happen when handling Contacts.
 * Currently, this updates Account to 'Consumer Account' when type of Contact is
 * Consumer. 
 * 
 * ---------------------------------------------------------------------------------
 * Author					Date					Description
 * ---------------------------------------------------------------------------------
 * Juan Rivera				10/13/2016				Created
 */
public with sharing class ContactTriggerHandler {
    public void assignToConsumerAccount(List<Contact> contacts){
        // Get 'Consumer Account' Account information
        List<Account> acctList = getConsumerAccount();
        Account acct;
        // Checks 'Consumer Account' exist, if not, creates it
        if(acctList.isEmpty()){
            // Logic to create 'Consumer Account'
            acct = createConsumerAccount();
        }
        else{
            acct = acctList.get(0);   
        }
        
        // Loop through Contacts 
        for(Contact c : contacts){
            // Check If Contact type == Consumer
            if(c.Contact_Type__c == 'Consumer'){
                // Assign Contact Account to 'Consumer Account' Account
                c.AccountId = acct.Id;
            }
        }
        
        
        
    }
    
    public Account createConsumerAccount(){
        RecordTypeHelper rth = new RecordTypeHelper();
        Account account = new Account();
        account.Name = 'Consumer Account';
        account.RecordTypeId = rth.getIdFromName('Other Account', account);
        account.Type = 'Other';
        account.Status__c = 'Active';
        insert account;
        return account;
    }
    
    public List<Account> getConsumerAccount(){
        String acctName = 'Consumer Account';
        List<Account> acctList = [SELECT
                           Id,
                           Name
                           FROM Account
                           WHERE Name = :acctName
                           LIMIT 1          
        ];
        return acctList;
    }
    
}