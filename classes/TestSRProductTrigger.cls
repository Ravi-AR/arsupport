/*
 * TestSRProductTrigger
 * Test Trigger SRProductTrigger 
 * 
 * ---------------------------------------------------------------------------------
 * Author					Date					Description
 * ---------------------------------------------------------------------------------
 * Juan Rivera				09/09/2016				Created
 * Juan Rivera				09/19/2016				Modified to test update of Vet & Nutritionist info while running w/o seeAllData=true
 * Juan Rivera				09/20/2016				Update Plant_Type__c to Customer_Ops_Plant_Type__c
 * Juan Rivera				09/22/2016				Deleted references to Plant User Emails on SR since they were moved to SR Product
 * 													Add insert for Custom setting Purina_Species and commented out the seeAllData=true
 * Juan Rivera				10/03/2016				Replace reference to Plant_Product__c with Product__c
 * Juan Rivera				10/03/2016				Renamed class from SRPUpdatePlantUserEmail to SRProductTrigger 
 * Juan Rivera				10/06/2016				Replace references to RecordTypeId to reference RecordType.Name instead
*/
@isTest //(seeAllData=true)
public class TestSRProductTrigger {
   static testMethod Case insertServiceRequest(){
      
      // Case Record Type
      RecordTypeHelper rth = new RecordTypeHelper();
        
      // account info
      Account acct = new Account();
      acct.Name = 'Checkboard Farms';
      insert acct;
        
      // user info
      User com = new User();
      com.LastName = 'Smittle';
      com.Alias = 'dsmit';
      com.Email = 'andrew.smittle@purina.com.magnetdev';
      com.Username = 'd.smittle@magnet360.com';
      com.TimeZoneSidKey = 'America/Denver';
      com.LocaleSidKey = 'en_US';
      com.EmailEncodingKey = 'UTF-8';
      com.LanguageLocaleKey = 'en_US';
      com.ProfileId = '00ej0000000WVCU';
      insert com;
        
      // Shipping Plant info
      Branch__c sPlant = new Branch__c();
      sPlant.Name = 'Hacka';
      sPlant.Customer_Ops_Plant_Type__c = 'Shipping';
      sPlant.Customer_Operations_Manager__c = com.Id;
      sPlant.Plant_Manager__c = com.Id;
      sPlant.Plant_Quality_Manager__c = com.Id;
      sPlant.Plant_Supervisor__c = com.Id;
      sPlant.Quality_Supervisor__c = com.Id;
      sPlant.Customer_Op_Team_email__c = com.Email;
      insert sPlant;
        
      // Custom Settings Purina_Species__C
      /* Testing with seeAllData */
      insert new Purina_Species__c(Dairy_Nutritionist_Email__c = 'pancho.villa@purina.com.magnetdev', Dairy_Veterinarian_Email__c = 'juanito.gancho@purina.com.magnetdev');

      // sales user info
      User user2 = new User();
      user2.LastName = 'Boswell';
      user2.Alias = 'aboswell';
      user2.Email = 'a.boswell@purina.com.magnetdev';
      user2.Username = 'a.boswell@magnet360.com';
      user2.TimeZoneSidKey = 'America/Denver';
      user2.LocaleSidKey = 'en_US';
      user2.EmailEncodingKey = 'UTF-8';
      user2.LanguageLocaleKey = 'en_US';
      user2.ProfileId =  [SELECT id FROM Profile p WHERE p.name = 'Sales Specialist'].Id; 
      insert user2;    
       
      // service request info
      Case sr = new Case();
      sr.Shipping_Plant_Lookup__c = sPlant.Id;
      sr.AccountId = acct.Id;
      sr.Specie_Affected__c = 'Dairy';       
      sr.Status = 'New';
      sr.Priority = 'High';
      sr.Issue_Category__c  = '002 - Damaged Product (torn)'; 
      sr.Issue_Sub_Category__c = 'Damaged by Low Quality Pallets';
      sr.RecordTypeId = rth.getIdFromName('Consumer', sr);
      sr.Potential_Product_Liability__c = 'Yes';
      sr.Purina_Salesperson__c = user2.Id;
      insert sr;
      return sr;
   }
    
   static testMethod void insertSRProduct(){
        
      // service request info
      Case sr = insertServiceRequest();
      system.debug(LoggingLevel.ERROR, 'sr retrieved : ' + sr);
      system.debug('sr Vet email listed: ' + sr.Veterinarian_Email__c);
      system.debug('sr Nutritionist email listed: ' + sr.Nutritionist_Email__c);
        
      // user info
      User user = new User();
      user.LastName = 'Rivera';
      user.Alias = 'jrivera';
      user.Email = 'juan.rivera@purina.com.magnetdev';
      user.Username = 'j.rivera@magnet360.com';
      user.TimeZoneSidKey = 'America/Denver';
      user.LocaleSidKey = 'en_US';
      user.EmailEncodingKey = 'UTF-8';
      user.LanguageLocaleKey = 'en_US';
      user.ProfileId =  [SELECT id FROM Profile p WHERE p.name = 'System Administrator'].Id; 
      insert user;       
        
      // manufacturing plant info
      Branch__c mPlant = new Branch__c();
      mPlant.Name = 'BuildAPlant';
      mPlant.Customer_Ops_Plant_Type__c = 'Manufacturing';
      mPlant.Customer_Operations_Manager__c = user.Id;
      mPlant.Plant_Manager__c = user.Id;
      mPlant.Plant_Quality_Manager__c = user.Id;
      mPlant.Plant_Supervisor__c = user.Id;
      mPlant.Quality_Supervisor__c = user.Id;
      insert mPlant;    
        
      // plant product
      Product2 pProduct = new Product2();
      pProduct.Name = 'Logs';
      // pProduct.Branch__c = mPlant.Id;
      insert pProduct;
        
      // Service Request Product info
      Service_Request_Product__c srp = new Service_Request_Product__c();
      srp.Service_Request__c = sr.Id;
      system.debug('service request assigned: ' + srp.Service_Request__c + '	');
      srp.Manufacturing_Plant__c = mPlant.Id;
      system.debug('manufacturing Plant assigned: ' + srp.Manufacturing_Plant__c + '	');
      system.debug('manufacturing Plant Manager assigned: ' + srp.Plant_Manager_Email_Manufacturing__c + '	');
      system.debug('manufacturing Plant Supervisor assigned: ' + srp.Plant_Supervisor_Email_Manufacturing__c + '	');
      srp.Product__c = pProduct.Id;
      system.debug('Plant Product assigned: ' + srp.Product__c + '	');
      insert srp;
   }
}