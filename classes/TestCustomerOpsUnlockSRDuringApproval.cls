// TestCustomerOpsUnlockSRDuringApproval
// Test the CustomerOpsUnlockSRDuringApproval class 
//------------------------------------------------------------------------------
// Author					Date			Description
// -----------------------------------------------------------------------------
// Mark Purick				10/14/2016		Created
// Juan Rivera				10/17/2016		Updated for adjustments on CustomerOpsUnlockSRDuringApproval
@isTest
public class TestCustomerOpsUnlockSRDuringApproval {   
    static Case init() {
        Account caseAcct = addAccount();
        Branch__c casePlant = addPlant();
        Case testCase = new Case(AccountId=caseAcct.Id,Shipping_Plant_Lookup__c=casePlant.Id);
        insert testCase;
        return testCase;
    }
    
    static Branch__c addPlant() {
       Branch__c testPlant = new Branch__c(Name='Hacka',Customer_Ops_Plant_Type__c='Shipping');
       insert testPlant;
       return testPlant;
    }
    
    static Account addAccount() {
        Account testAccount = new Account(Name='Test Account 123xyz');
        insert testAccount;
        return testAccount;
    }
   
    static testMethod void testBothLockAndUnlock() {
        Case caseToLock = init();
        Test.startTest();
        CustomerOpsUnlockSRDuringApproval.lockUnlockSR(caseToLock.Id);
        CustomerOpsUnlockSRDuringApproval.lockUnlockSR(caseToLock.Id);
        Test.stopTest();
    }
    
    static testMethod void testLockError() {
        Case caseToLock = init();
        Id testId = null;
        Test.startTest();
        String result = '';
        result = CustomerOpsUnlockSRDuringApproval.lockUnlockSR(testId);
        System.debug(result);
        Test.stopTest();
        System.assertNotEquals('Record locked successfully!', result);
    }
}