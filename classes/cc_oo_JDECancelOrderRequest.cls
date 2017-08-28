public without sharing class cc_oo_JDECancelOrderRequest {
	public cc_oo_JDECancelOrderRequest() {
		
	}

	public DataArea DataArea;

	public class IDObj{
	    public String replacetokentypeCode;
	    public String replaceDollar;
	}

	public class DocumentIDSet{
	    public List<IDObj> IDObj;
	}

	public class PurchaseOrderHeader{
	    public List<DocumentIDSet> DocumentIDSet;
	}

	public class PurchaseOrder{
	    public String replacetokentypeCode;
	    public PurchaseOrderHeader PurchaseOrderHeader;
	}

	public class ActionExpression{
	    public String replacetokenactionCode;
	    public String replaceDollar;
	}

	public class ActionCriteria{
	    public List<ActionExpression> ActionExpression;
	}

	public class Sync{
	    public List<ActionCriteria> ActionCriteria;
	}

	public class DataArea{
	    public List<PurchaseOrder> PurchaseOrder;
	    public Sync Sync;
	}

	public static String serialize(cc_oo_JDECancelOrderRequest req) {
        String jsonString = System.JSON.serialize(req);
        jsonString = jsonString.replaceAll('replacetoken', '@');
        jsonString = jsonString.replaceAll('IDObj', 'ID');
        jsonString = jsonString.replaceAll('replaceDollar', Matcher.quoteReplacement('$'));
        return jsonString;
    }
}