/*
 * TestContactTrigger
 * Test ContactTrigger and ContactTriggerHandler
 * 
 * ---------------------------------------------------------------------------------
 * Author					Date					Description
 * ---------------------------------------------------------------------------------  
 * Juan Rivera				10/13/2016				Created
 */
@isTest
public class TestContactTrigger {
    static testMethod void insertContactWithConsumerAccount(){
        Account acct = createConsumerAccount();
        
        Contact con = new Contact();
        con.FirstName = 'Jane';
        con.LastName = 'Doe';
        con.Phone = '8675309';
        con.Email = 'jane.doe@puppies.com';
        con.Contact_Type__c = 'Consumer';
        
        insert con;
    }
    
    static testMethod void insertContactWithOutConsumerAccount(){
        Contact con = new Contact();
        con.FirstName = 'Jane';
        con.LastName = 'Doe';
        con.Phone = '8675309';
        con.Email = 'jane.doe@puppies.com';
        con.Contact_Type__c = 'Consumer';
        
        insert con;        
    }

    static testMethod Account createConsumerAccount(){
        RecordTypeHelper rth = new RecordTypeHelper();
        Account account = new Account();
        account.Name = 'Consumer Account';
        account.RecordTypeId = rth.getIdFromName('Other Account', account);
        account.Type = 'Other';
        account.Status__c = 'Active';
        insert account;
        return account;
    }    
}