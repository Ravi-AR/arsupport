//ClassName:cc_oo_MyAccountContactInfoControllerTest
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Annapurna.VND                             10/18/2016                                     
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class  cc_oo_MyAccountContactInfoControllerTest {
	
    
	 @isTest
	 static void  getAddressFieldsTest(){ 
		 ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
       	 System.debug('Fetching User');
       	 User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		 Account testAccount =  cc_lol_TestData.testAccount;
         system.runas(thisUser){
        	 System.debug('Set AccountNumber');
         	 testAccount.AccountNumber='250287';
        	 }
        //Test the scenario
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_MyAccountContactInfoController.getAddressFields(ctx,testAccount.AccountNumber);
         Test.startTest(); 
         System.debug('Starting remote');              
         System.debug('Account shipping/billing address Items'+ remoteResult.data);
         Test.stopTest();
        //Validate the test data
         system.assertEquals(remoteResult.data!=null,true);
    }
}