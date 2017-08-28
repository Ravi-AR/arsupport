@isTest(seeAllData=true)
public class TestCaseAssignTrigger {

    public static Case newCase;
    public static String accountName;
    public static String issueCat;
    public static String potProdLiability;
    public static Id recordType;
    public static Id shippingPlant;
    
    static void init(){
       RecordTypeHelper rth = new RecordTypeHelper();
       Branch__c p = new Branch__c(Name='TestPlant88',
                                   Customer_Ops_Plant_Type__c = 'Shipping',
                                   Customer_Ops_Region__c = 'Great East');
       try {
          insert p;
       }
       catch (Exception e) {
          System.debug('ERROR: ' + e);
       }        
       accountName = 'CENTRAL FARM SUPPLY, INC.(MONROEVILLE)-308415';
       issueCat = '001-Transportation';
       potProdLiability = 'No';
       shippingPlant = p.Id;
        
       newCase = new Case(Issue_Category__c=issueCat,Potential_Product_Liability__c=potProdLiability,Shipping_Plant_Lookup__c=shippingPlant);
       recordType = rth.getIdFromName('Customer Care',newCase);
       newCase.RecordTypeId = recordType;
    }
    
    static testMethod void testCaseAssignmentTriggerWorks(){
       init();
       Test.startTest();
		
       insert newCase;
        
       //pull the case to verify that the owner field has changed to great east region
       newCase = [
          SELECT Id, Owner.Name
          FROM Case
          WHERE Id = :newCase.Id
       ];
	   System.assertEquals(newCase.Owner.Name, 'Great East Region');
       Test.stopTest();
    }    
}