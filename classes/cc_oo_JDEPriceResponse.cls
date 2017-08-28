//JDE Price Output Response
public class cc_oo_JDEPriceResponse {

    public String replacetokenenvironment;
    public String replacetokensessionidle;
    public String replacetokensession;
    public String replacetokentype;
    public String replacetokenuser;
    public CallMethod callMethod;

    public class Params {
        public String AN8_ShipToNUmber;
        public String MCU_BranchPlant;
        public String DCTO_OrderType;
        public String UPRC_UnitPrice;
        public String LITM_ItemNumber;
        public String VERS_P4210Version;
        public String szFreightHandlingCode;
        public String UOM_Input;
        public String UOM1_Primary;
        public String mnAmountExtendedPrice;
        public String UOM_Pricing;
    }

    public class errors {
        public List<error> error;
    }

    public class error{
        public string replacetokencode;
        public string replacedoller;
    }

    public class CallMethod {
        public String replacetokenapp;
        public String replacetokenname;
        public ReturnCode returnCode;
        public Params params;
        public errors errors;
    }

    public class ReturnCode {
        public String replacetokencode;
    }

    public static cc_oo_JDEPriceResponse parse(String json) {
    	if(json != null && json != ''){//Performanace check
	        json = json.replace('@', 'replacetoken').replace(Matcher.quoteReplacement('$'),'replacedoller');
	        return (cc_oo_JDEPriceResponse) System.JSON.deserialize(json, cc_oo_JDEPriceResponse.class);
    	}
    	return null;//Performanace check
    }
}