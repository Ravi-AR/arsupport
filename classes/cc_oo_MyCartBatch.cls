//ClassName:cc_oo_MyCartBatch 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                        Description
//----------------------------------------------------------------------------------------------------------------------
//Saloni Kale                        		3/15/2017                                      									
//-----------------------------------------------------------------------------------------------------------------------

global class cc_oo_MyCartBatch implements Database.Batchable<sObject> {
    
    Integer days=Integer.valueOf(LOLSettings__c.getValues('LastNDays').Value__c);
    Date Last60Days = Date.today()-days;
    String cartStatusArchive = String.valueOf(LOLSettings__c.getValues('cartStatusArchive').Value__c);
    String cartStatusOpen = String.valueOf(LOLSettings__c.getValues('cartStatusOpen').Value__c);
    global String query = 'SELECT ccrz__CartStatus__c,ccrz__CartType__c,CreatedDate FROM ccrz__E_Cart__c WHERE ccrz__CartStatus__c =: cartStatusOpen and CreatedDate <= LAST_N_DAYS:'+days;
    //global String query = 'SELECT ccrz__CartStatus__c,ccrz__CartType__c,CreatedDate FROM ccrz__E_Cart__c WHERE ccrz__CartStatus__c = \'Open\' and CreatedDate <= LAST_N_DAYS:5';
    global cc_oo_MyCartBatch(){   
    }
    //initate batch jobs 
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('query--->'+query);
        return Database.getQueryLocator(query);  
    }
    //batch apex execution
    global void execute(Database.BatchableContext BC, List<ccrz__E_Cart__c> scope){ 
    try{
        List<ccrz__E_Cart__c> cartList = new List<ccrz__E_Cart__c>();
        for(ccrz__E_Cart__c cart : scope){
            if(cart!=NULL){
                cartList.add(cart);
                cart.ccrz__CartStatus__c = cartStatusArchive;
             }   
        }
        System.debug('cartList--->'+cartList);
        if(cartList.size()>0){
        //if(!cartList.isEmpty()){
            update cartList;
        }
        //}
        
    }catch(Exception error){
        cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();
        errorLog.cc_oo_Description__c = error.getMessage() + ' \n ' +error.getStackTraceString();
        insert errorLog;
    }
    }
    //finish batch jobs
    global void finish(Database.BatchableContext BC){
    }
}