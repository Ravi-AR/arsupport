//ClassName:cc_oo_serviceCallout 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Shrivaths Kulkarni                         12/13/2016                                      OO-324 - Real-Time Price from JDE

//-----------------------------------------------------------------------------------------------------------------------
public class cc_oo_serviceCallout{
    
    //Method to hit the service with end point with header details
    public Static cc_oo_serviceResponse callWebservice(String body , String endpoint , String timeout, String contentType, String requtestMethod, String authKey, String authValue){

        HttpResponse res ;

        try{
            Http h = new Http();
            HttpRequest req = new HttpRequest();

            if(requtestMethod != null)
                req.setMethod(requtestMethod);

            if(authKey != null){
                req.setHeader(authKey, authValue);
            }

            if(contentType != null){
                req.setHeader('Content-Type',contentType);
                req.setHeader('Accept',contentType);
            }

            if(body != null){
                req.setBody(body);
            }

            if(timeout != null){
                req.setTimeout(Integer.Valueof(timeout));
            }

            if(endpoint != null){
                req.setEndpoint(endpoint);
            }

            res = h.send(req);
            
            cc_oo_serviceResponse serResponse = new cc_oo_serviceResponse();
            serResponse.response = res;
            serResponse.errorMsg = '';
            serResponse.responseStatus = res.getStatusCode();
            return serResponse;
        }catch(Exception ex){
            cc_oo_serviceResponse serResponse = new cc_oo_serviceResponse();
            serResponse.response = res;
            serResponse.errorMsg = ex.getMessage();
            //serResponse.responseStatus = res.getStatusCode();
            //insert new cc_oo_ErrorLog__c(cc_oo_Description__c = ex.getMessage() + '   ' +ex.getStackTraceString());
            return serResponse;

        }

    }

    //To get the service details from custom settings
    public static cc_oo_ServiceData__c getServiceDetails(string serviceName){
        return cc_oo_ServiceData__c.getValues(serviceName);
    }

    //To get the endpoint based on the host and URI input
    public static string getEndPoint(cc_oo_ServiceData__c serviceData){
        string endPoint = '';
        
        endPoint += serviceData.cc_oo_Host__c;
        //Get port if available
        if(serviceData.cc_oo_Port__c != null){
            endPoint += ':' + serviceData.cc_oo_Port__c;                
        }

        //get URI
        endPoint += serviceData.cc_oo_URI__c; 
        return  endPoint;              
    }

    //to make make the callout by passing name of the service, body, params
    public static cc_oo_serviceResponse runService(string serviceName,string body,string params){
        cc_oo_ServiceData__c serviceData = getServiceDetails(serviceName);
        string endPoint = getEndPoint(serviceData);
        cc_oo_serviceResponse resp = null;
        if(serviceData.cc_oo_AuthMechanism__c == 'Basic'){
            Blob encryptedCred = Blob.valueOf(serviceData.cc_oo_Username__c + ':' + serviceData.cc_oo_Password__c);
            String authValue = 'Basic ' + EncodingUtil.base64Encode(encryptedCred);
            if(params != null && params != ''){
                endPoint += '/' + params;
            }
            resp = callWebservice(body, endPoint, serviceData.cc_oo_Timeout__c, serviceData.cc_oo_ContentType__c, serviceData.cc_oo_RequestMethod__c,'Authorization', authValue);
        }
        //system.debug('resp--->' + resp.response.getBody());
        return resp;
    }
    
}