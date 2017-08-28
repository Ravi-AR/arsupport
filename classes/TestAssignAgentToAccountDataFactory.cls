// TestAssignAgentToAccountDataFactory
// Provide test data for AssignAgentToAccountController test class
// ------------------------------------------------------------------
// Author              	Date         	Description
// ------------------------------------------------------------------
// Mark Purick			09/08/2016		Created
@isTest
public class TestAssignAgentToAccountDataFactory {
   public static List<Account> loadAccounts(Integer numAccts, Integer numContacts) {
      List<Account> accts = new List<Account>();
      for(Integer i=0;i<numAccts;i++) {
         Account a = new Account(Name='TestAccount' + i,
                                 ShippingCity='Gainesville',
                                 ShippingStateCode='Fl',
                                 Top_25_Account__c=true);
         accts.add(a);
      }
      insert accts;
      
      List<Contact> contacts = new List<Contact>();
      for(Integer j=0;j<numAccts;j++) {
         Account acct = accts[j];
          
         for(Integer i=0;i<numAccts;i++) {
            contacts.add(new Contact(LastName='TestContact' + i, AccountID=acct.id));
         }
      }
      insert contacts;
      return accts;
   }
    
   public static List<Branch__c> loadPlants(Integer numPlants) {
      List<Branch__c> plants = new List<Branch__c>();
      for(Integer i=0;i<numPlants;i++) {
         Branch__c p = new Branch__c(Name='TestPlant' + i,
                                     Customer_Ops_Plant_Type__c = 'Shipping');
         plants.add(p);
      }
      try {
         insert plants;
      }
      catch (Exception e) {
         System.debug('ERROR: ' + e);
      }
      return plants;
   }
    
   public static List<User> loadUsers(Integer numUsers){
      List<User> users = new List<User>();
      Id sProfileId = [SELECT id FROM Profile p WHERE p.name = 'Customer Operations'].Id;
      for(Integer i=0;i<numUsers;i++) {
         User u = new User(LastName='TestCOR' + i, 
                           Alias='TestCOR' + i,
                           Email='TestCOR' + i + '@purina.com.magnetdev',
                           Username='TestCOR' + i + '@magnet360.com',
                           Customer_Ops_Region__c='Great East',
                           TimeZoneSidKey = 'America/Denver',
                           LocaleSidKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LanguageLocaleKey = 'en_US',
                           ProfileId = sProfileId);
         users.add(u);
      }
      insert users;
	  return users;        
   }
}