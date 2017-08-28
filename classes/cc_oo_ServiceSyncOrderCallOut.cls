//ClassName:cc_oo_ServiceSyncOrderCallOut 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                         12/21/2016                                      OO-517 - Real-Time Order No from JDE

//-----------------------------------------------------------------------------------------------------------------------
public without sharing class cc_oo_ServiceSyncOrderCallOut {
    public static final string CLASS_NAME = 'cc_oo_ServiceSyncOrderCallOut';
    
    public static cc_oo_serviceResponse syncOrder(cc_oo_JDESyncOrderRequest syncReq){
    	//string stringResp='';
        try{
            string body = cc_oo_JDESyncOrderRequest.serialize(syncReq);
            System.debug('body-->' + body); 
            cc_oo_serviceResponse resp = cc_oo_serviceCallout.runService('SyncOrder', body, null);
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c= '---->'+ resp);
            /*if(resp !=null){
            	System.debug('actualResp-->' + resp.response.getBody());//this will throw null pointer exception response 
            	stringResp = resp.response.getBody();
            }*/
            
            //Future metod can't be called from service callout  - this will cause issue for batch service. 
            //cc_oo_HelperController.createLog(body, 'SyncOrder', 'Request','cc_oo_ServiceSyncOrderCallOut','syncOrder');
            //cc_oo_HelperController.createLog(stringResp, 'SyncOrder', 'Response','cc_oo_ServiceSyncOrderCallOut','syncOrder');
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c= '---->'+ stringResp);
            /*cc_oo_JDESyncOrderResponse jdeResponse = null;
            if(stringResp != null && stringResp != '') {
            	jdeResponse = cc_oo_JDESyncOrderResponse.parse(stringResp);
            }
            system.debug('jdeResponse-->'+ jdeResponse);*/
            
            return resp;
        }catch(Exception ex){
        	
        	//INSTEAD THROW ANY Exception to CALLING Method, and try to HANDLE it FROM THERE - CALLING an Insert from same process where
        	//service is being called will cause System.CalloutException
            cc_oo_HelperController.CreateErrorLog(ex,CLASS_NAME,'syncOrder');
           /*	throw ex;*/
            return null;
        }
    }   

    
}