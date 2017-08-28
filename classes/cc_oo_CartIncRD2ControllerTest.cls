//ClassName:cc_oo_CartIncRD2ControllerTest
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Shrivaths Kulkarni                         9/7/2016                                      OO-121 - Test class for cc_oo_CartIncRD2Controller
//-----------------------------------------------------------------------------------------------------------------------
@isTest
private class cc_oo_CartIncRD2ControllerTest {
        
    @isTest 
    static void getProductsDetailsTest(){
        
        //Prepare Test Data
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext(); 
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        ccrz__E_Cart__c testCart;
        system.runas(thisUser){
            cc_lol_TestData.setupCatalog();
            testCart = cc_lol_TestData.createCart(); 
            cc_lol_TestData.addCartItem(testCart, cc_lol_TestData.products[0].Id,12,200.00);
        }  
            
        //Test the scenario
        Test.startTest(); 
                      
        ccrz.cc_RemoteActionResult remoteResult = cc_oo_CartIncRD2Controller.getProductsDetails(ctx,testCart.id);
        
        Test.stopTest();
        
        //Validate the test data
        system.assertEquals(remoteResult.success,true);
        if(remoteResult.success){
            Map<String, ccrz__E_CartItem__c> mapProductData = (Map<String, ccrz__E_CartItem__c>)remoteResult.data;
            system.assertEquals(mapProductData.size()>0,true);
        }
    }
   
}