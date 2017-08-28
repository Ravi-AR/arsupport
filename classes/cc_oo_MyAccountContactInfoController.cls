//ClassName:cc_oo_MyAccountContactInfoController 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Annapurna.VND                             10/18/2016                                      OO-771- Test class cc_oo_MyAccountContactInfoControllerTest
//                                                                                                (to view the shipping address of an order under the header)
//-----------------------------------------------------------------------------------------------------------------------

global class cc_oo_MyAccountContactInfoController {
	
	 
	/************************************************************************************************************************
      Method Name : getAddressFields 
      Description : getAddressFields  is to fetch the selected shipping address and display same in  Pre-Book or Online Order
      Parameter   : shiptoId  
                    shiptoId  is used to identify the shipping address
      Return type : Returns 
      UserStory   : OO-771 method is to display correct shipping address selected by user
                    
      *************************************************************************************************************************/ 
    
	 @RemoteAction 
	global static ccrz.cc_RemoteActionResult getAddressFields(final ccrz.cc_RemoteActionContext ctx,string shiptoId ){ 
		 ccrz.cc_CallContext.initRemoteContext(ctx);
		ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
		 //final Map<String,Object> result = new Map<String,Object>();
		 List <Account> listAccounts=[SELECT AccountNumber, SHIPPINGSTREET, SHIPPINGCITY, SHIPPINGSTATE, SHIPPINGPOSTALCODE, SHIPPINGCOUNTRY, SHIPPINGSTATECODE,
                Billing_Street__c,Billing_City__c, BillingCity__c, BillingState__c,Billing_Zip_Postal_Code__c,Billing_State_Province__c , Billing_Country__c from Account where accountNumber = : shipToId];
	if(!listAccounts.isEmpty()){
		res.success = true;
			/*for(Account aList : listAccounts){
	     	result.put(aList.accountNumber, aList);
	   		}*/
	   		//result.put(shiptoId,listAccounts.get(0));
	   		
	   		res.data=listAccounts.get(0);
	}	
    else{
    	res.success = false;
    }
		return res;
    
	}
}