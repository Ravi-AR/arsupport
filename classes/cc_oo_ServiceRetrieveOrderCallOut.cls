//ClassName:cc_oo_ServiceRetrieveOrderCallOut 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                         12/13/2016                                      OO-324 - Real-Time Order No from JDE

//-----------------------------------------------------------------------------------------------------------------------
public without sharing class cc_oo_ServiceRetrieveOrderCallOut {
    public static final string CLASS_NAME = 'cc_oo_ServiceRetrieveOrderCallOut';
    
    public static cc_oo_serviceResponse getNextOrderNumber(cc_oo_JDERetrieveNextOrderRequest orderReq){
        try{
            string body = cc_oo_JDERetrieveNextOrderRequest.serialize(orderReq);
            System.debug('body-->' + body);
            cc_oo_serviceResponse resp = cc_oo_serviceCallout.runService('RetrieveOrder', body, null);
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c= '---->'+ resp);
            /*System.debug('actualResp-->' + resp.response.getBody());
            string stringResp = resp.response.getBody();*/
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c= '---->'+ stringResp);
            /*cc_oo_JDERetrieveNextOrderResponse jdeResponse = null;
            if(stringResp != null && stringResp != '') {
            	jdeResponse = cc_oo_JDERetrieveNextOrderResponse.parse(stringResp);
            }
            system.debug('jdeResponse-->'+ jdeResponse);*/
            
            return resp;
        }catch(Exception ex){
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString());
            cc_oo_HelperController.CreateErrorLog(ex,CLASS_NAME,'getNextOrderNumber');           
            return null;
        }
    }   

    
}