//JDI Price Input Request
public class cc_oo_JDEPriceRequest {

    /*public String replacetokentype;
    public String replacetokensession;
    public String replacetokensessionidle;
    public CallMethod callMethod;*/
    public Params params;
    public class Params {
        public String AN8_ShipToNUmber;
        public String MCU_BranchPlant;
        public String DCTO_OrderType;
        public String LITM_ItemNumber;
        public String VERS_P4210Version;
        //public String szFreightHandlingCode;
    }

    /*public class CallMethod {
        public String replacetokenapp;
        public String replacetokenname;
        public Params params;
    }*/
    
     /*public static cc_oo_JDEPriceRequest parse(String json) {
        return (cc_oo_JDEPriceRequest) System.JSON.deserialize(json, cc_oo_JDEPriceRequest.class);
    }*/

    public static String serialize(cc_oo_JDEPriceRequest req) {
        String jsonString = System.JSON.serialize(req);
        jsonString = jsonString.replaceAll('replacetoken', '@');
        return jsonString;
    }
}