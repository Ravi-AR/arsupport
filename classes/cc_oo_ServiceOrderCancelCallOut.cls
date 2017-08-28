/* className: cc_oo_ServiceOrderCancelCallOut
----------------------------------------------------------------------------------------------------------------------
Author                                      Date                                           Description
----------------------------------------------------------------------------------------------------------------------
Saloni Kale                             2/13/2017                               OO- 521: When a customer amends or cancels an order the reason code will default to customer accommodation (S13).
*/
public without sharing class cc_oo_ServiceOrderCancelCallOut {
	public static final string CLASS_NAME = 'cc_oo_ServiceOrderCancelCallOut';
    public static boolean cancelOrder(string JDEOrderNumber){
        try{
            cc_oo_JDECancelOrderRequest req = cc_oo_HelperController.createCancelOrderRequest(JDEOrderNumber);
            string body = cc_oo_JDECancelOrderRequest.serialize(req);
            cc_oo_serviceResponse resp = cc_oo_serviceCallout.runService('orderCancel', body, JDEOrderNumber);
            
            //insert new cc_occ_oo_JDECancelOrderRequest req = cc_oo_HelperController.o_ErrorLog__c(cc_oo_Description__c= '---->'+ resp);
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','actualResp-->' + resp.response.getStatus());
            System.debug('actualResp----->' +  resp.response.getStatus());
            string stringRespStatus = resp.response.getStatus();
            cc_oo_HelperController.createLog(body, 'CancelOrder', 'Request','cc_oo_ServiceOrderCancelCallOut','cancelOrder');
            cc_oo_HelperController.createLog(resp.response.getBody(), 'CancelOrder', 'Response','cc_oo_ServiceOrderCancelCallOut','cancelOrder');
            System.debug('stringRespStatus---->' + stringRespStatus);
            Integer stringRespcode = resp.response.getStatusCode();
            System.debug('----stringRespcode-----'+stringRespcode);
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c= '---->'+ stringRespStatus);
            //OO-4462
            if(resp.response.getBody().contains('"status" : "success"')){
                return true;
            }
            
            return false;
        }catch(Exception ex){
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString());
            cc_oo_HelperController.CreateErrorLog(ex,CLASS_NAME,'cancelOrder');
            return null;
        } 
    }
}