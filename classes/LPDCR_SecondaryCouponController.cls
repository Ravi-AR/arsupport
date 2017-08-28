/**
*   @Author:    Heena Tanna
*   @Date:      08.05.2017
*   @Jira:      LPDCR-2032
*   @Purpose:   Controller behind LPDCR_SecondaryCouponPage
*/

public without sharing class LPDCR_SecondaryCouponController {

    public Account acc{get;set;}
    public String couponName {get;set;} 
    //public Decimal couponValue{get;set;}
    public Decimal subTotal{get;set;}
    public Decimal totalCouponCount{get;set;}
    public Decimal grandTotal{get;set;}
    public Decimal postageExpense{get;set;}
    public List<CouponRequestWrapper> couponReqWrapperList{get;set;}
    public Integer indexToDelete{get;set;}
                                                 // Populate this map in the constructor
                                                 // and use it to validate the coupon codes
                                                 // entered
    public Map<String,Coupon__c> active_coupon_map { get; set; }
    public Decimal pmiCouponCount{get;set;}
    public Decimal purinaCouponCount{get;set;} 
    public Decimal pmiPostageExpense{get;set;}
    public Decimal purinaPostageExpense{get;set;}
    public String invoice{get;set;}
    public boolean isOpenInNewTab {get;set;}
    public string pdfURL {get;set;}
    
    private Integer rowIndex;
    private Coupon_Request__c couponRequest;
    private Boolean errorOnSingleRow;
    //Change Account 
    public String selectedAccountId
    {
        get {
            if( selectedAccountId == null ) {
                selectedAccountId = LPDCR_ChangeAccountController.getSelectedAccId();
            }
            return selectedAccountId;
        }
        set;
    }
    
    //Contructor
    
    public LPDCR_SecondaryCouponController(){
        
     active_coupon_map = new Map<String,Coupon__c>();
        for( Coupon__c l_c : [ SELECT Id, 
                                      Name,
                                      Coupon_Value__c,
                                      Description__c,
                                      Description_Long__c,
                                      Expiration_Date__c,
                                      Postmark_Date__c,
                                      Previous_Expiration_Date__c
                               FROM Coupon__c
                               WHERE Postmark_Date__c >= TODAY ] )
        {
            active_coupon_map.put( l_c.Name, l_c );
        }   
                                                 // Start with one empty row in
                                                 // the list of coupons
     rowIndex = 1;
     getAccountDetails();
     couponName ='';   
     couponReqWrapperList = new List<CouponRequestWrapper>();
     couponReqWrapperList.add(new CouponRequestWrapper(rowIndex));
     subTotal =0.00;
     totalCouponCount =0;
     grandTotal =0.00;
     postageExpense = 0.00;
     
    }
    

    
    //Get Account details
    public void getAccountDetails()
    {
        List<Account> acct = [ Select Id,Name,AccountNumber,BillingAddress,ShippingAddress,ShippingStreet,ShippingCity,ShippingState,
                                ShippingPostalCode,Phone FROM Account WHERE ID=:selectedAccountId LIMIT 1];
        if( acct.size() > 0 )
        {
            acc = acct[ 0 ];
        }
        else
        {
            acc = new Account();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'This page is only available for use by Dealers.' );
            ApexPages.addMessage(myMsg);
        }
    }
    
    //Get Coupon details
    public void getCouponNumber()
    {    
        
        couponName = ApexPages.currentPage().getParameters().get('couponName');
        System.debug( 'CouponName----' + couponName );
        
        Coupon__c l_c = active_coupon_map.get( couponName );
       
        System.debug( 'getCouponNumber coupon = ' + l_c );
       
        if( l_c == null )
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'The coupon number entered is invalid or expired.' );
            ApexPages.addMessage(myMsg);
            return;
        }
        
    }
    
    
    //Upsert Coupon Request
    public void upsertCouponRequest(){ //changed from void too static Boolean
    
    
    //Create map of Coupon
    Set<String> couponSet = new Set<String>();
    
    System.debug('couponReqWrapperList--' + couponReqWrapperList);
    
    for(CouponRequestWrapper crw: couponReqWrapperList)
    {   
        Coupon__c l_c = active_coupon_map.get( crw.couponNumber );// added to check if coupon number is invalid //LPDCR-3151 
        System.debug('crw.couponNumber---' + crw.couponNumber);   // then not to insert coupon           //LPDCR-3151 
        if(String.isNotBlank(crw.couponNumber) & l_c != null )
            couponSet.add(crw.couponNumber);
    }
    System.debug('couponSet--' + couponSet.size());
    //To check if atleast one row of line item has data.
    if(couponSet.size()>0)
    {
       //Check if the coupon request is already created.
        if(couponRequest == null)
        {
            couponRequest = new Coupon_Request__c();
            couponRequest.Account__c = acc.Id;
            couponRequest.Address__c = acc.ShippingStreet;
            couponRequest.City__c = acc.ShippingCity;
            couponRequest.State__c = acc.ShippingState;
            couponRequest.Zip__c = acc.ShippingPostalCode;
            couponRequest.Invoice__c = invoice;
            insert couponRequest;
        }
        
        
        List<Coupon_Request_Line_Item__c> crliList = new List<Coupon_Request_Line_Item__c>();
        
        for(CouponRequestWrapper crw: couponReqWrapperList)
        {          //LPDCR-3151 
                /*Coupon__c l_c = active_coupon_map.get( crw.couponNumber );
               
                System.debug( 'getCouponNumber coupon = ' + l_c );
               
                if( l_c == null )
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'The coupon number entered is invalid or expired.' );
                    ApexPages.addMessage(myMsg);
                    return;
                }   */       
                
                Coupon__c couponObj = active_coupon_map.get(crw.couponNumber);
                
                // To check if the 2nd Coupon added is valid else show msg
                if(String.isNotBlank(crw.couponNumber) & couponObj != null ){ //Start //LPDCR-3151 
                System.debug('Map'+ active_coupon_map.get(crw.couponNumber));
                //Assign references to wrapper
                crw.couponObj = couponObj;
                crw.couponReqObj = couponRequest;
                
                System.debug('crw.couponObj' + crw.couponObj);
                // New object for coupon request line item
                Coupon_Request_Line_Item__c coupreqline;
                // If the line item is not created, will create new.
                if(crw.couponReqLineObj == null)
                {
                    coupreqline = new Coupon_Request_Line_Item__c();
                    coupreqline.Coupon_Request__c = couponRequest.id;
                    coupreqline.Coupon_Number__c = couponObj.Id;
                }
                else //if line item already exists will assign the reference.
                {
                    coupreqline = crw.couponReqLineObj;
                    
                }
              
                System.debug('coupreqline.Coupon_Number__c'+ coupreqline.Coupon_Number__c);
               
                //get the updated number of coupons and extended value
                
                coupreqline.Number_of_Coupons__c = crw.couponQuantity;          
                coupreqline.ExtendedValue__c = Decimal.valueOf(crw.extendedValue);
              
                crw.couponReqLineObj = coupreqline;
                
                
                crliList.add(crw.couponReqLineObj);
            
           }//End    //LPDCR-3151   
           
           else {//LPDCR-3151 
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Please enter a valid coupon number to submit the request' );
             ApexPages.addMessage(myMsg);
             errorOnSingleRow = true;
             return;
         
         }
               
        }
        
        if(crliList.size()>0)
        {
            upsert crliList;
        }
        
       
        //Query Coupon Request to get Sub Total and Total Coupon Count
        Coupon_Request__c insertedCoupon =[SELECT Id,Name,Sub_Total__c,Total_Number_of_Coupons__c,Postage_Expense__c,
        Grand_Total_Amount__c,Address__c,Total_Number_of_PMI_Coupons__c,Total_Number_of_Purina_Coupons__c FROM Coupon_Request__c WHERE ID =:couponRequest.Id];
        
       
         totalCouponCount =insertedCoupon.Total_Number_of_Coupons__c;
         pmiCouponCount =insertedCoupon.Total_Number_of_PMI_Coupons__c;
         purinaCouponCount = insertedCoupon.Total_Number_of_Purina_Coupons__c;
         
         System.debug('pmiCouponCount---' + pmiCouponCount);
         System.debug('purinaCouponCount---' + purinaCouponCount);
       //Query to fetch postage expense from custom settings  
       List<Coupon_Postage_Expense_Table__c> couponPostage =[Select Estimated_Weight_oz__c,Maximum_of_Coupons__c,Minimum_of_Coupons__c,Postage_Expense__c  FROM Coupon_Postage_Expense_Table__c 
        WHERE Minimum_of_Coupons__c <=:totalCouponCount AND  Maximum_of_Coupons__c >=:totalCouponCount LIMIT 1];
       
       if(couponPostage != null && couponPostage.size()>0)
       {
           postageExpense = couponPostage[0].Postage_Expense__c; 
           couponRequest.Postage_Expense__c = postageExpense ; 
           update couponRequest;
        }
        
        List<Coupon_Postage_Expense_Table__c> couponPostagePMI =[Select Estimated_Weight_oz__c,Maximum_of_Coupons__c,Minimum_of_Coupons__c,Postage_Expense__c  FROM Coupon_Postage_Expense_Table__c 
        WHERE Minimum_of_Coupons__c <=:pmiCouponCount AND  Maximum_of_Coupons__c >=:pmiCouponCount LIMIT 1];
       
       if(couponPostagePMI != null && couponPostagePMI.size()>0)
       {
           pmiPostageExpense = couponPostagePMI[0].Postage_Expense__c; 
           couponRequest.Postage_Expense_of_PMI_Coupons__c = pmiPostageExpense ; 
           update couponRequest;
        }
         List<Coupon_Postage_Expense_Table__c> couponPostagePurina =[Select Estimated_Weight_oz__c,Maximum_of_Coupons__c,Minimum_of_Coupons__c,Postage_Expense__c  FROM Coupon_Postage_Expense_Table__c 
        WHERE Minimum_of_Coupons__c <=:purinaCouponCount AND  Maximum_of_Coupons__c >=:purinaCouponCount LIMIT 1];
       
       if(couponPostagePurina != null && couponPostagePurina.size()>0)
       {
           purinaPostageExpense = couponPostagePurina[0].Postage_Expense__c; 
           couponRequest.Postage_Expense_of_Purina_Coupons__c = purinaPostageExpense ; 
           update couponRequest;
        }
       
    }
     else {//LPDCR-3151 
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Please enter a valid coupon number to submit the request' );
             ApexPages.addMessage(myMsg);
             errorOnSingleRow = true;
             return;
         
         }
    
    } //Close upsertCoupon Method 
   
 
    //Method to delete Items in wrapper List
    public void deleteItems(){
        indexToDelete = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        List<Coupon_Request_Line_Item__c> deleteList = new List<Coupon_Request_Line_Item__c>();
     if(couponReqWrapperList != null && couponReqWrapperList.size() >0 && couponReqWrapperList.size() >= indexToDelete){
         
         CouponRequestWrapper crw = couponReqWrapperList[indexToDelete-1];
         if(crw.couponReqLineObj != null) //To check if the record to be removed was inserted.
         {
             deleteList.add(crw.couponReqLineObj);

         }
         
        couponReqWrapperList.remove(indexToDelete-1);
        }
        //Delete the record from database.
        if(deleteList.size()>0)
        {
            delete deleteList;
        }
        
        if(couponReqWrapperList.size()==0)
        {
            rowIndex = 0;
        }
         else
         {
            rowIndex = 1; 
         }
            //If all the rows are deleted, a blank row will be added  
         if(rowIndex == 0){
            
            couponReqWrapperList.add(new CouponRequestWrapper(rowIndex));
            rowIndex++;
               
         }
            System.debug('rowIndex Second---' + rowIndex);
        //Rearrange rowIndex        
        for(CouponRequestWrapper crw: couponReqWrapperList)
        {
            crw.rowIndex = rowIndex;
            
            System.debug('crw.rowIndex initial---' + crw.rowIndex);
            if(couponReqWrapperList.size()!=rowIndex)
                  rowIndex++;
            
        }
        
        // To re-calculate the updated coupon request line item.
        calculateTotal();
        
    }

    public void calculateTotal()
    {
       //Query to fetch postage expense from custom settings  
       totalCouponCount = 0;
       subTotal = 0.00;
       postageExpense=0.00;
       
        for(CouponRequestWrapper crw: couponReqWrapperList) 
        {
            if(crw.couponNumber != null && crw.couponQuantity != null)
            {
               crw.couponValue = active_coupon_map.get(crw.couponNumber) != null ? active_coupon_map.get(crw.couponNumber).Coupon_Value__c : 0;
               crw.extendedValue = String.valueOf(crw.couponQuantity *  crw.couponValue);
               
               totalCouponCount = totalCouponCount + crw.couponQuantity;
               subTotal = subTotal +  Decimal.valueOf(crw.extendedValue);
               
            }
        } 
        
        List<Coupon_Postage_Expense_Table__c> couponPostage =[Select Estimated_Weight_oz__c,Maximum_of_Coupons__c,Minimum_of_Coupons__c,Postage_Expense__c  FROM Coupon_Postage_Expense_Table__c 
        WHERE Minimum_of_Coupons__c <=:totalCouponCount AND  Maximum_of_Coupons__c >=:totalCouponCount LIMIT 1];
             
       if(couponPostage != null && couponPostage.size()>0)
       {
           postageExpense = couponPostage[0].Postage_Expense__c; 
           
       }
       
       grandTotal = subTotal + postageExpense;
    }
    //Save and Add another coupon method
    public void addCoupon()
    {
        errorOnSingleRow = false;
        upsertCouponRequest();  
        if(!errorOnSingleRow)   //False Check
        {
            rowIndex++; 
            couponReqWrapperList.add(new CouponRequestWrapper(rowIndex));
        }
       
        
        
    }
    //To redirect to download pdf
    public void downloadCouponRequest(){
        
                
                upsertCouponRequest();
                if(couponRequest!=null)
                {  
                    isOpenInNewTab = true;
                    pdfURL = '/LPDCR_CC_CouponPDF?id=' + couponRequest.id; 
                }
                else
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please fill out and save your coupon items in the form above. If you wish to fill out the forms by hand you may download our blank forms');
                    ApexPages.addMessage(myMsg);
                    
                }
               //return null; 
    }
    public class CouponRequestWrapper
    {   
        public String couponNumber{get;set;}
        public Integer couponQuantity{get;set;}
        public Decimal couponValue{get;set;}
        public String extendedValue{get;set;}
        public Integer rowIndex{get;set;}
        public Coupon_Request_Line_Item__c couponReqLineObj{get;set;}
        public Coupon__c couponObj{get;set;}
        public Coupon_Request__c couponReqObj{get;set;}
        public CouponRequestWrapper(Integer rowIndex){           
           this.rowIndex = rowIndex;           
        }
        
        
    }
    
}