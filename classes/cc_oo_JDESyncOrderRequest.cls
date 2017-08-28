//ClassName:cc_oo_JDESyncOrderRequest 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Piyali Mukherjee                         12/21/2016                                      OO-517 - Real-Time Order No from JDE

//-----------------------------------------------------------------------------------------------------------------------
public class cc_oo_JDESyncOrderRequest {
    
    public DataArea DataArea;
    
    public class DataArea{
    	public PurchaseOrder PurchaseOrder;
    }
    
    public class PurchaseOrder {
       public String replacetokentypeCode; 
       public PurchaseOrderHeader PurchaseOrderHeader;
       public List<PurchaseOrderLine> PurchaseOrderLine;
    }
    
    public class PurchaseOrderHeader {
        public String ID;
        public List<DocumentIDSet> DocumentIDSet;
        public String LastModificationDateTime;
        public String Description;
        public Status Status;
        public CustomerParty CustomerParty;
        public ShipToParty ShipToParty;
        public BillToParty BillToParty;
        public List<TransportationTerm> TransportationTerm;
        public String RequestedShipDateTime;
        public String PaymentMethodCode;
        public String ShippingInstructions;
        public String OrderDateTime;
        public String Note;//OO-4469
        public BuyerParty BuyerParty;
        public List<ShipFromParty> ShipFromParty;
        public SalesOrderReference SalesOrderReference;
        //public string PickUpTime;//US:1973  
    }
    
    public class DocumentIDSet {
        public List<DocumentID> ID;
    }
    
    public class DocumentID {
    	public String replacetokentypeCode;
        public String replaceDollar;
    }
    
    public class Status {
        public String Description;
    }
    
    public class CustomerParty {
        public List<LocationCustomer> Location;
    }
    
    public class ShipToParty {
        public String ID;
        //public List<Location> Location;
    }
    
    public class BillToParty {
        public List<String> ID;
        public List<BillToLocation> Location;
    }
    
    public class BillToLocation {
    	public List<String> Note; 
    }
    
    public class TransportationTerm {
    	public String replacetokentypeCode;
        public String FreightTermCode;
    }
    
    public class BuyerParty {
        public String ID;
    }
    
    public class ShipFromParty {
        public List<String> ID;
        public List<Location> Location;
    }
    
    public class SalesOrderReference {
        public List<String> ID;
    }
    
    public class Location {
        public String ID; 
    }
    
    public class LocationCustomer {
        public List<Contact> Contact;
    }
    
    public class Contact {
        public List<PersonName> PersonName;
    }
    
    public class PersonName {
        public String FormattedName;
    }
    
    public class PurchaseOrderLine {
        public String LineNumberID;
        public List<Item> Item;
        public List<Quantity> Quantity;
        public UnitPrice UnitPrice;
        public ContractReference ContractReference;
        public List<PurchaseOrderSubLine> PurchaseOrderSubLine;
    } 
    
   public class Quantity {
   		public String replacetokenunitCode;
   		public String replaceDollar;
   }
    
    public class Item {
        public String ID;
        public String Note;
    }  
    
    public class UnitPrice {
        //public String ID;
        public String ChargeAmount;
    }
    
    public class ContractReference {
        public String ID;
    }
    
    public class PurchaseOrderSubLine {
        public AmountDiscount amountDiscount;
    }
    
    public class AmountDiscount {
        public List<String> ID;
        public String percentage;
        public List<String> description;
    }
  

    public static String serialize(cc_oo_JDESyncOrderRequest req) {
        String jsonString = System.JSON.serialize(req);
        jsonString = jsonString.replaceAll('replacetoken', '@');
        jsonString = jsonString.replaceAll('replaceDollar', Matcher.quoteReplacement('$'));
        return jsonString;
    }
}