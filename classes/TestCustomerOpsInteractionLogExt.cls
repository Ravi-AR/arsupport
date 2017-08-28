//TestCustomerOpsInteractionLogExt
//Test the CustomerOpsInteractionLogExt class
//------------------------------------------------------------------------
// Author					Date			Description
// -----------------------------------------------------------------------
// Juan Rivera				09/27/2016		Created
// 
@isTest
public class TestCustomerOpsInteractionLogExt {
   RecordTypeHelper rth = new RecordTypeHelper();
    
   public static testMethod void testSaveNewPass(){
      RecordTypeHelper rth = new RecordTypeHelper();
      // Case Information needed for Controller
      Branch__c p = testPlant();
      Case c = new Case();
      c.Shipping_Plant_Lookup__c = p.Id;
      // Consumer 
      //c.RecordTypeId = '0127A0000000Fg7QAE';	
      c.RecordTypeId = rth.getIdFromName('Consumer',c);
      insert c;
      ApexPages.currentPage().getParameters().put('id',c.Id);
      ApexPages.currentPage().getParameters().put('recordType', c.RecordTypeId);
       
      ApexPages.StandardController sc = new ApexPages.StandardController(c);
      CustomerOpsInteractionLogExt cgil = new CustomerOpsInteractionLogExt(sc);
      cgil.caseId = c.Id;
      cgil.caseRecordType = c.RecordTypeId;
      cgil.task.type2__c = 'Support Call';
      cgil.task.activity__c = 'Other';
      cgil.task.ActivityDate = date.ValueOf('1968-09-21');
      cgil.saveNew();
   }

   public static testMethod void testSaveNewPassCustomer(){
      RecordTypeHelper rth = new RecordTypeHelper();
      // Case Information needed for Controller
      Branch__c p = testPlant();
      Case c = new Case();
      c.Shipping_Plant_Lookup__c = p.Id;
    	
      // Customer Care
      //c.RecordTypeId = '012j0000000eTliAAE';	 
      c.RecordTypeId = rth.getIdFromName('Customer Care',c);
      insert c;
      ApexPages.currentPage().getParameters().put('id',c.Id);
      ApexPages.currentPage().getParameters().put('objectId', c.Id);
      ApexPages.currentPage().getParameters().put('recordType', c.RecordTypeId);
        
      ApexPages.StandardController sc = new ApexPages.StandardController(c);
      CustomerOpsInteractionLogExt cgil = new CustomerOpsInteractionLogExt(sc);
      cgil.caseId = c.Id;
      cgil.caseRecordType = c.RecordTypeId;
      cgil.caseObjectId = c.Id;
      cgil.saveNew();
   }    
    
   public static testMethod void testSaveNewFail(){
      // Info for Plant but not Case
      Branch__c p = testPlant();
        
      // Testing with wrong standard controller
      ApexPages.StandardController sc = new ApexPages.StandardController(p);
      CustomerOpsInteractionLogExt cgil = new CustomerOpsInteractionLogExt(sc);
      cgil.clear();
      cgil.saveNew();
   }
    
   // Helper Methods 
    
   public static User testUser(){
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
      com.ProfileId =  [SELECT id FROM Profile p WHERE p.name = 'System Administrator'].Id;
      //com.ProfileId = '00ej0000000WVCU';
      insert com;
	  return com;        
   }
    
   public static Branch__c testPlant(){
      // User for Shipping Plant
      User u = testUser();
        
      // Shipping Plant info
      Branch__c sPlant = new Branch__c();
      sPlant.Name = 'Hacka';
      sPlant.Customer_Ops_Plant_Type__c = 'Shipping';
      sPlant.Customer_Operations_Manager__c = u.Id;
      sPlant.Plant_Manager__c = u.Id;
      sPlant.Plant_Quality_Manager__c = u.Id;
      sPlant.Plant_Supervisor__c = u.Id;
      sPlant.Quality_Supervisor__c = u.Id;
      sPlant.Customer_Op_Team_email__c = u.Email;
      insert sPlant;  
      return sPlant;
    }
}