// AssignAgentToAccountController
// Controller for the AssignAgentToAccount VS Page used to search for
// accounts and update the corresponding Dedicated Agent.
// ------------------------------------------------------------------
// Author              	Date         	Description
// ------------------------------------------------------------------
// Mark Purick			09/08/2016		Created
// Mark Purick			10/10/2016		Replaced search strings
// 										Added Contact update logic
// 										Added Primary Plant search
// Mark Purick			10/13/2016		Fixed Navigation bugs and 
// 										added/removed fields

public with sharing class AssignAgentToAccountController {
   // Define strings for dynamically building the query
   public String queryFinal {get; set;}
   public String queryPart1 {get; set;}
   public String parentAcctName {get; set;}
   public Boolean checked {get; set;}
   public String acctID {get; set;}
   // Define integers for navigation labels
   public Integer totalRecs {
      get{
         if(acctSetCon != null) {
            return acctSetCon.getResultSize();
         }
         else {
            return 200;
         }
      }
      set;
   }
   public Integer pageStart {
      get {
         if(acctSetCon != null) {
            return (acctSetCon.getPageNumber() * 200) - 199;
         }
         else {
            return 1;
         }
      }
      set;
   }
   public Integer pageEnd {
      get {
         if(acctSetCon != null) {
            if(totalRecs < 200)  {
               return totalRecs;
            }             
            else if((acctSetCon.getPageNumber() * 200) < totalRecs) {
               return pageStart + 199;
            }
            else {
               return Math.mod(totalRecs,200) + pageStart - 1;
            }
         }
         else {
            return 200;
         }
      }
      set;
   }
    
   public User newDedicatedCOR {get; set;}
   public User dedicatedCOR {get; set;}
   public PrimaryPlant primaryPlant {get; set;}
   public Account searchAccount {get; set;}
   public WrappedAccount wrappedAccount {get; set;}
   // Controller initially to display no results
   public ApexPages.StandardSetController acctSetCon {
      get {
         if(acctSetCon == null) {
            String queryPart2 = queryPart1 + 'where Name = \'zzzyyyxxxx\'';
            acctSetCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryPart2));  
            acctSetCon.setPageSize(15);
            System.debug('In Standard Set Controller');
         }
         return acctSetCon;
      } 
      set;
   }
    
   public List<Account> selectedAccounts {get; set;}  
   public List<Contact> relatedContacts {get; set;}
    
   public class PrimaryPlant {
      public Id plantId {get; set;}     
      public Name plantName {get; set;}
   }
    
   // Wrapper class for Account to include selection checkbox
   public List<WrappedAccount> wrappedAccounts {  
      get {  
         try {
            for(Account a:(List<Account>) acctSetCon.getRecords()) {
               wrappedAccounts.add(new WrappedAccount(this, a));
            }
            return wrappedAccounts;
         }
         catch (Exception e) { 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'We have encountered an error: ' + e));
            return null ;  
         }
      }  
      set;
   }       
    
   public void getData(String query, Integer pgSize) {          
      try {
         acctSetCon = new ApexPages.StandardSetController(Database.getQueryLocator(query));  
         acctSetCon.setPageSize(pgSize);
      }
      catch (Exception e) { 
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'We have encountered an error: ' + e)); 
      }
   } 
   
   // Picklist value definition: Only Customer Ops users
   public List<selectOption> dedicatedCORs {  
      get {
         List<selectOption> options = new List<selectOption>();
         options.add(new selectOption('', '- None -'));
         for (User users : [SELECT Id, Name FROM User WHERE Profile.Name = 'Customer Operations' ORDER BY LastName, FirstName]) {
            options.add(new selectOption(users.Id, users.Name));
         }
         return options; 
      }
      set;
   }
   // Picklist value definition: All Plants
   public List<selectOption> primaryPlants {
      get {
	     List<selectOption> options = new List<selectOption>();
	     options.add(new selectOption('', '- None -'));
	     for (Branch__c plants : [SELECT Id, Name FROM Branch__c ORDER BY Name]) {
	        options.add(new selectOption(plants.Id, plants.Name));
         }
         return options; 
      }
      set;
   }
    
   public AssignAgentToAccountController () {
      queryPart1 = 'select Name, Parent.Id, Parent.Name, Dedicated_Customer_Op_Rep__c, ShippingCity, ShippingState,';
      queryPart1 = queryPart1 + ' Region__c, Primary_Plant_Lookup__c, Top_25_Account__c from Account ';
      newDedicatedCOR = new User();
      dedicatedCOR = new User();
      searchAccount = new Account();
      primaryPlant = new PrimaryPlant();
      selectedAccounts = new List<Account>();
      relatedContacts = new List<Contact>();
      wrappedAccounts = new List<WrappedAccount>();
      primaryPlants = new List<SelectOption>();
      dedicatedCORs = new List<SelectOption>();
      wrappedAccount = new WrappedAccount(this, searchAccount);
   }
      
   public class WrappedAccount {
      public Account acct {get; set;}
      public boolean isSelected {get; set;}
       
      public WrappedAccount(AssignAgentToAccountController ctrl, Account a) {
         acct = a;
         isSelected = false;
      }
   }  
   
   // Search Accounts based on dynamic query
   public PageReference search() {
      queryFinal = '';
      wrappedAccounts.clear();  
      checked = false;
       
      if(dedicatedCOR.Id != null) {
         if(queryFinal == '') {
            queryFinal = queryPart1 + ' where Dedicated_Customer_Op_Rep__r.Id = \'' + dedicatedCOR.Id + '\'';
         } else {
            queryFinal = queryFinal + ' and Dedicated_Customer_Op_Rep__r.Id = \'' + dedicatedCOR.Id + '\'';
         } 
      }
      if(!searchAccount.Name.equals('')) {
         if(queryFinal == '') {
            queryFinal = queryPart1 + ' where Name like \'%' + searchAccount.Name + '%\' ';
         } else {
            queryFinal = queryFinal + ' and Name like \'%' + searchAccount.Name + '%\' '; 
         }
      }
      if(parentAcctName != null && !parentAcctName.equals('')) {
         if(queryFinal == '') {
            queryFinal = queryPart1 + ' where Parent.Name like \'%' + parentAcctName + '%\' ';
         } else {
            queryFinal = queryFinal + ' and Parent.Name like \'%' + parentAcctName + '%\' ';
         }
      }
      if(dedicatedCOR.Customer_Ops_Region__c != null && !dedicatedCOR.Customer_Ops_Region__c.equals('')) {
         if(queryFinal == '') {
            queryFinal = queryPart1 + ' where Dedicated_Customer_Op_Rep__r.Customer_Ops_Region__c = \'' + dedicatedCOR.Customer_Ops_Region__c + '\' ';
         } else {
            queryFinal = queryFinal + ' and Dedicated_Customer_Op_Rep__r.Customer_Ops_Region__c = \'' + dedicatedCOR.Customer_Ops_Region__c + '\' ';
         }
      }
      if(searchAccount.ShippingCity != null && !searchAccount.ShippingCity.equals('')) {
         if(queryFinal == '') {
            queryFinal = queryPart1 + ' where ShippingCity like \'%' + searchAccount.ShippingCity + '%\' ';
         } else {
            queryFinal = queryFinal + ' and ShippingCity like \'%' + searchAccount.ShippingCity + '%\' ';
         }
      }
      if(searchAccount.ShippingStateCode != null && !searchAccount.ShippingStateCode.equals('')) {
         if(queryFinal == '') {
            queryFinal = queryPart1 + ' where ShippingStateCode = \'' + searchAccount.ShippingStateCode + '\' ';
         } else {
            queryFinal = queryFinal + ' and ShippingStateCode = \'' + searchAccount.ShippingStateCode + '\' ';
         }
      }
      if(searchAccount.Top_25_Account__c == true) {
         if(queryFinal == '') {
            queryFinal = queryPart1 + ' where Top_25_Account__c = ' + searchAccount.Top_25_Account__c + ' ';
         } else {
            queryFinal = queryFinal + ' and Top_25_Account__c = ' + searchAccount.Top_25_Account__c + ' ';
         }
      }
      if(primaryPlant.plantId != null) {
         if(queryFinal == '') {
            queryFinal = queryPart1 + ' where Primary_Plant_Lookup__r.Id = \'' + primaryPlant.plantId + '\' ';
         } else {
            queryFinal = queryFinal + ' and Primary_Plant_Lookup__r.Id = \'' + primaryPlant.plantId + '\' ';
         }
      } 
      if(queryFinal == '') {
         queryFinal = queryPart1;
      }
      queryFinal = queryFinal + ' ORDER BY Name LIMIT 10000';
      System.debug('Final query is: ' + queryFinal);

      if(queryFinal != '') {
         getData(queryFinal,200);
      	 pageStart = 1;
         pageEnd = 200;
         totalRecs = acctSetCon.getResultSize();
      }
      return null;
   }
   // Booleans for hiding navigation values depending on what page the user is viewing
   public Boolean hasNext {  
      get {  
         return acctSetCon.getHasNext();  
      }  
      set;  
   }  
   public Boolean hasPrevious {  
      get {  
         return acctSetCon.getHasPrevious();  
      }  
      set;  
   }  
   public Integer pageNumber {  
      get {  
         return acctSetCon.getPageNumber();  
      }  
      set;  
   }  
   // Navigation functions
   public void first() {
      wrappedAccounts.clear();  
      acctSetCon.first();
   }    
   public void previous() {  
      wrappedAccounts.clear();  
      acctSetCon.previous();
   } 
   public void next() {  
      wrappedAccounts.clear();  
      acctSetCon.next();  
   } 
   public void last() {
      wrappedAccounts.clear();  
      acctSetCon.last();
   }
   // User updates accounts' and related contacts' Dedicated Customer Ops field
   public PageReference updateSelected() {
      getSelected();   
      if(!selectedAccounts.isEmpty()) {
         update selectedAccounts;
         if(!relatedContacts.isEmpty()) {
            update relatedContacts;
         }
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, selectedAccounts.size() + ' records updated successfully!'));
      }
      search();
      return null;
   }
   // Get account records the user selected
   public PageReference getSelected() {
      selectedAccounts.clear();
      relatedContacts.clear();
      if(!wrappedAccounts.isEmpty()) {
         for(WrappedAccount w : wrappedAccounts) {
            if(w.isSelected == true) {
               w.acct.Dedicated_Customer_Op_Rep__c = newDedicatedCOR.Id;
               selectedAccounts.add(w.acct);
            }
         }
         if(!selectedAccounts.isEmpty()) {
            relatedContacts = [SELECT Id, Name FROM Contact WHERE Contact.AccountId IN :selectedAccounts];
            for(Contact c : relatedContacts) {
               c.Dedicated_Customer_Ops_Rep__c = newDedicatedCOR.Id;
            } 
         }
         else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select records before using the update function.'));
         }
      }
      else {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please search for records before using the update function.'));
      }
      return null;
   }
    
   public PageReference selectAll() {
      try{
         for(WrappedAccount w : wrappedAccounts) {
            if(checked) {
               w.isSelected = true;
            }
            else {
               w.isSelected = false;
            }
         }
      }
      catch(Exception e) {
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'We have encountered an error: ' + e));
      }
      return null;
   } 
}