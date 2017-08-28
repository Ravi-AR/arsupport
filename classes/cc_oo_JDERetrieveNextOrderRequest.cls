//ClassName:cc_oo_JDERetrieveNextOrderRequest 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                         12/21/2016                                      OO-517 - Real-Time Order No from JDE

//-----------------------------------------------------------------------------------------------------------------------
public class cc_oo_JDERetrieveNextOrderRequest {

    public String replacetokentype;
    public CallMethod callMethod;

    public class Params {
       public String szKeyCompany;
       public String szOrderType;
       public String BranchPlant;
    }

    public class CallMethod {
        public String replacetokenapp;
        public String replacetokenname;
        public String replacetokenrunOnError;
        public String replacetokenreturnNullData;
        public Params params;
    }

    public static String serialize(cc_oo_JDERetrieveNextOrderRequest req) {
        String jsonString = System.JSON.serialize(req);
        jsonString = jsonString.replaceAll('replacetoken', '@');
        return jsonString;
    }
}