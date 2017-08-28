//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Rajeev Choudhary                         02/10/2017                                      OO-1772 - Amend Order

//-----------------------------------------------------------------------------------------------------------------------
public without sharing class cc_oo_ServiceModifyOrderCallOut {
    public static final string CLASS_NAME = 'cc_oo_ServiceModifyOrderCallOut';
    public static boolean modifyOrder(cc_oo_JDEModifyOrderRequest modifyOrderReq, string JDEOrderNumber){
        try{
            string body = cc_oo_JDEModifyOrderRequest.serialize(modifyOrderReq);
            System.debug('body-->' + body);
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','body-->' + body);
            cc_oo_serviceResponse resp = cc_oo_serviceCallout.runService('ModifyOrder', body, JDEOrderNumber);
            //string stringResp = resp.response.getStatus();
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','actualResp-->' + resp.response.getStatus());
            string stringRespStatus = resp.response.getStatus();
            cc_oo_HelperController.createLog(body, 'AmendOrder', 'Request','cc_oo_ServiceModifyOrderCallOut','modifyOrder');
            cc_oo_HelperController.createLog(resp.response.getBody(), 'AmendOrder', 'Response','cc_oo_ServiceModifyOrderCallOut','modifyOrder');
            System.debug('stringRespStatus---->' + stringRespStatus);
            if(resp != null){  
                if(resp.response.getBody() != null){ //OO-4462
                    if(resp.response.getBody().contains('"status" : "success"')){
                        return true;
                    }
                }//OO-4462
            }
            return false;
        }catch(Exception ex){
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString());
            cc_oo_HelperController.CreateErrorLog(ex,CLASS_NAME,'modifyOrder');
            return null;
        } 
    }
}