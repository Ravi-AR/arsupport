// TestAssignAgentToAccountDataFactory
// Test class for AssignAgentToAccountController
// ------------------------------------------------------------------
// Author               Date            Description
// ------------------------------------------------------------------
// Mark Purick          09/08/2016      Created
@isTest
public class TestAssignAgentToAccountController {
   public String queryPart1 {
      get {
         queryPart1 = 'select Name, Dedicated_Customer_Op_Rep__c, ShippingCity, ShippingState,';
         queryPart1 = queryPart1 + ' Secondary_Workgroup__c, Primary_Plant_Lookup__c, Top_25_Account__c from account ';        
         return queryPart1;
      } 
      set;
   }

   public static testMethod void testFullQuery() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(2);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(2);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(31, 1);
       
         ctrl.dedicatedCOR.Id = users[0].Id;
         ctrl.searchAccount.Name = accts[0].Name;
         ctrl.dedicatedCOR.Customer_Ops_Region__c = users[0].Customer_Ops_Region__c;
         ctrl.searchAccount.ShippingCity = accts[0].ShippingCity;
         ctrl.searchAccount.ShippingStateCode = accts[0].ShippingStateCode;
         ctrl.searchAccount.Top_25_Account__c = accts[0].Top_25_Account__c;
         ctrl.primaryPlant.plantId = plants[0].Id;
         ctrl.search();
         Integer testTotal = ctrl.totalRecs;
         Integer testPageStart = ctrl.pageStart;
         Integer testPageEnd = ctrl.pageEnd;
         Test.stopTest();
      }
   }

   public static testMethod void testQueryMinusDedicatedCOR() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(1);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(1, 1);
       
         ctrl.searchAccount.Name = accts[0].Name;
         ctrl.dedicatedCOR.Customer_Ops_Region__c = users[0].Customer_Ops_Region__c;
         ctrl.searchAccount.ShippingCity = accts[0].ShippingCity;
         ctrl.searchAccount.ShippingStateCode = accts[0].ShippingStateCode;
         ctrl.searchAccount.Top_25_Account__c = accts[0].Top_25_Account__c;
         ctrl.primaryPlant.plantId = plants[0].Id;
         ctrl.search();
         Test.stopTest();
      }
   }

   public static testMethod void testQueryMinusName() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(1);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(1, 1);
       
         ctrl.searchAccount.Name = '';
         ctrl.dedicatedCOR.Customer_Ops_Region__c = users[0].Customer_Ops_Region__c;
         ctrl.searchAccount.ShippingCity = accts[0].ShippingCity;
         ctrl.searchAccount.ShippingStateCode = accts[0].ShippingStateCode;
         ctrl.searchAccount.Top_25_Account__c = accts[0].Top_25_Account__c;
         ctrl.primaryPlant.plantId = plants[0].Id;
         ctrl.search();
         Test.stopTest();
      }
   }

   public static testMethod void testQueryMinusRegion() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(1);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(1, 1);
       
         ctrl.searchAccount.Name = '';
         ctrl.searchAccount.ShippingCity = accts[0].ShippingCity;
         ctrl.searchAccount.ShippingStateCode = accts[0].ShippingStateCode;
         ctrl.searchAccount.Top_25_Account__c = accts[0].Top_25_Account__c;
         ctrl.primaryPlant.plantId = plants[0].Id;
         ctrl.search();
         Test.stopTest();
      }
   }

   public static testMethod void testQueryMinusCity() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(1);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(1, 1);
       
         ctrl.searchAccount.Name = '';
         ctrl.searchAccount.ShippingStateCode = accts[0].ShippingStateCode;
         ctrl.searchAccount.Top_25_Account__c = accts[0].Top_25_Account__c;
         ctrl.primaryPlant.plantId = plants[0].Id;
         ctrl.search();
         Test.stopTest();
      }
   }

   public static testMethod void testQueryMinusState() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(1);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(1, 1);
       
         ctrl.searchAccount.Name = '';
         ctrl.searchAccount.Top_25_Account__c = accts[0].Top_25_Account__c;
         ctrl.primaryPlant.plantId = plants[0].Id;
         ctrl.search();
         Test.stopTest();
      }
   }

   public static testMethod void testQueryMinusWorkgroup() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(1);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(1, 1);
       
         ctrl.searchAccount.Name = '';
         ctrl.primaryPlant.plantId = plants[0].Id;
         ctrl.search();
         Test.stopTest();
      }
   }

   public static testMethod void testQueryMinusPlant() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(1);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(1, 1);
       
         ctrl.searchAccount.Name = '';
         ctrl.search();
         Test.stopTest();
      }
   }
    
   public static testMethod void testDedicatedCORSelectOptions(){
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController(); 
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(1);
          
         Test.startTest();
         List<selectOption> testOpts = ctrl.dedicatedCORs;
         Test.stopTest();
      }
   }
    
   public static testMethod void testPrimaryPlantsSelectOptions(){
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1); 
          
         Test.startTest();
         List<selectOption> testOpts = ctrl.primaryPlants;
         Test.stopTest();
      }
   }

   public static testMethod void testBooleans(){
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();
          
         Test.startTest();
         Boolean testNext = ctrl.hasNext;
         Boolean testPrevious = ctrl.hasPrevious;
         Integer testPageNumber = ctrl.pageNumber;
         Test.stopTest();
      }
   }    

   public static testMethod void testButtonFunctionality(){
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();
          
         Test.startTest();
         ctrl.first();
         ctrl.previous();
         ctrl.next();
         ctrl.last();
         Integer testTotal = ctrl.totalRecs;
         Integer testPageStart = ctrl.pageStart;
         Integer testPageEnd = ctrl.pageEnd;
         Test.stopTest();
      }
   }    

   public static testMethod void testGetSelected() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(1);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(1, 1);
         ctrl.searchAccount.Name = '';
         ctrl.search();
         ctrl.acctSetCon.getRecords();
         ctrl.wrappedAccounts[0].isSelected=true;
         ctrl.getSelected(); 
         Test.stopTest();
      }
   }  

   public static testMethod void testGetSelectedWithoutSearch() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(1);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(1, 1);
         ctrl.searchAccount.Name = '';
         ctrl.getSelected(); 
         Test.stopTest();
      }
   }

   public static testMethod void testGetSelectedWithoutSelected() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(1);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(1, 1);
         ctrl.searchAccount.Name = '';
         ctrl.search();
         ctrl.getSelected(); 
         Test.stopTest();
      }
   }      

   public static testMethod void testUpdateSelected() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         Test.startTest();
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(2);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(1);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(1, 1);
         
         ctrl.newDedicatedCOR.Id = users[1].Id;
         ctrl.searchAccount.Name = '';
         ctrl.search();
         ctrl.acctSetCon.getRecords();
         ctrl.wrappedAccounts[0].isSelected=true;
         ctrl.getSelected(); 
         ctrl.updateSelected();
         Test.stopTest();
      }
   }  

   public static testMethod void testOutlierWrappedAccountList() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController(); 
         ctrl.acctSetCon = null;
         Integer testTotal = ctrl.totalRecs;
         System.assert(ctrl.wrappedAccounts.isEmpty());
      }
   }
    
   public static testMethod void testSelectAll() {
      User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
      System.runAs (thisUser) {
         AssignAgentToAccountController ctrl = new AssignAgentToAccountController();  
    
         List<User> users = TestAssignAgentToAccountDataFactory.loadUsers(2);
         List<Branch__c> plants = TestAssignAgentToAccountDataFactory.loadPlants(3);
         List<Account> accts = TestAssignAgentToAccountDataFactory.loadAccounts(10, 2);
         
         ctrl.checked = true;
         ctrl.searchAccount.Name = 'test';
         ctrl.search();
         ctrl.acctSetCon.getRecords();
          
         Test.startTest();
         ctrl.selectAll();
         ctrl.getSelected(); 
         Test.stopTest(); 
      }
   }
}