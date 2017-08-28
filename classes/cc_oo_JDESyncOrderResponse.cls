//ClassName:cc_oo_JDESyncOrderResponse 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                         12/21/2016                                      OO-517 - Real-Time Order No from JDE

//-----------------------------------------------------------------------------------------------------------------------
public class cc_oo_JDESyncOrderResponse {

    public String status;
    /* public String replacetokensessionidle;
    public String replacetokensession;
    public String replacetokentype;
    public String replacetokenuser;
    public CallMethod callMethod;

    public class Params {
        public String mnOrderNumber;
        public String szKeyCompany;
        public String szOrderType;
        public String BranchPlant;
    }

    public class CallMethod {
        public String replacetokenapp;
        public String replacetokenname;
        public ReturnCode returnCode;
        public Params params;
    }

    public class ReturnCode {
        public String replacetokencode;
    } */

    public static cc_oo_JDESyncOrderResponse parse(String json) {
        return (cc_oo_JDESyncOrderResponse) System.JSON.deserialize(json, cc_oo_JDESyncOrderResponse.class);
    }
}