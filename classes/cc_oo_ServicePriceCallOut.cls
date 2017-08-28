//ClassName:cc_oo_servicePriceCallOut 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Shrivaths Kulkarni                         12/13/2016                                      OO-324 - Real-Time Price from JDE

//-----------------------------------------------------------------------------------------------------------------------
public without sharing class cc_oo_ServicePriceCallOut {
    public static final string CLASS_NAME = 'cc_oo_ServicePriceCallOut';
    
    public static Map<string, object> getProductPrice(cc_oo_JDEPriceRequest priceReq){
        //Prepare request object
        try{
            string body = cc_oo_JDEPriceRequest.serialize(priceReq);
            System.debug('body-->' + body);

            cc_oo_serviceResponse resp = cc_oo_serviceCallout.runService('RetrievePrice', body, null);
            
            //cc_oo_HelperController.createLog(body, 'JDEPrice', 'Request','cc_oo_ServicePriceCallOut','getProductPrice');
            //cc_oo_HelperController.createLog(stringResp, 'JDEPrice', 'Response','cc_oo_ServicePriceCallOut','getProductPrice');

            List<cc_oo_ErrorLog__c> listLog = new List<cc_oo_ErrorLog__c>();
            cc_oo_JDEPriceResponse jdeResponse = null;
            string stringResp = '';

            if(resp != null){
                if(resp.errorMsg != null && resp.errorMsg != ''){
                    stringResp = resp.errorMsg;
                }else{
                    stringResp = resp.response.getBody();
                    jdeResponse = cc_oo_JDEPriceResponse.parse(stringResp);
                }
            }
            body = body.replace('"','');//Peformance change
            stringResp = stringResp.replace('"','').replaceAll('\n','').replaceAll('\r','');//Peformance change
            cc_oo_ErrorLog__c req = getLogRecord(body, 'JDEPrice', 'Request','cc_oo_ServicePriceCallOut','getProductPrice');
            cc_oo_ErrorLog__c res = getLogRecord(stringResp, 'JDEPrice', 'Response','cc_oo_ServicePriceCallOut','getProductPrice');
            listLog.add(req);
            listLog.add(res);

            system.debug('jdeResponse-->'+ jdeResponse);

            Map<string, object> responseData = new Map<string, object>();
            responseData.put('response', jdeResponse);
            responseData.put('logs', listLog);
            return responseData;
        }catch(Exception ex){
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString());
            cc_oo_HelperController.CreateErrorLog(ex,CLASS_NAME,'getProductPrice');
            return null;
        }
    }


    //Create Error Log object to store the service callout details
    public static cc_oo_ErrorLog__c getLogRecord(string body, string name, string type, string className, string methodName){
        cc_oo_ErrorLog__c log = new cc_oo_ErrorLog__c();
        log.cc_oo_Description__c = body;
        log.cc_oo_ApexClass__c = className;
        log.cc_oo_MethodName__c = methodName;
        log.Name = name;
        log.cc_oo_LogType__c = type;
        return log;
    }   
}