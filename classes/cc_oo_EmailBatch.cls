//ClassName:cc_oo_EmailBatch 
//Summary:
//----------------------------------------------------------------------------------------------------------------------
//Author                                      Date                                           Description
//----------------------------------------------------------------------------------------------------------------------
//Samruddhi Gokhale                         10/07/2016                                     OO-211 Send Order Acknowledgement Mail
//-----------------------------------------------------------------------------------------------------------------------
global class cc_oo_EmailBatch implements Database.Batchable<sObject> {
    public static final string CLASS_NAME = 'cc_oo_EmailBatch';
    global String query = 'select ccrz__OriginatedCart__r.cc_oo_Alternate_Email_Id__c,ccrz__Contact__c,ccrz__User__c, ccrz__User__r.Email, CreatedBy.Name, ccrz__OrderStatus__c, Name, ccrz__BillTo__r.ccrz__CompanyName__c, ccrz__BillTo__r.ccrz__AddressFirstline__c, ccrz__BillTo__r.ccrz__AddressSecondline__c, ccrz__BillTo__r.ccrz__State__c, ccrz__BillTo__r.ccrz__Country__c, ccrz__BillTo__r.ccrz__PostalCode__c, ccrz__ShipTo__r.ccrz__AddressFirstline__c, ccrz__ShipTo__r.ccrz__AddressSecondline__c, ccrz__ShipTo__r.ccrz__State__c, ccrz__ShipTo__r.ccrz__Country__c, ccrz__ShipTo__r.ccrz__PostalCode__c, (SELECT ccrz__Product_Name__c,ccrz__Quantity__c from ccrz__E_OrderItems__r), ccrz__Contact__r.Email from ccrz__E_Order__c where cc_oo_AcknowledgementEmailSent__c = FALSE';
    global cc_oo_EmailBatch(){
        
    }
    
     //initate batch jobs 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);  
    }
    
    //batch apex execution
    global void execute(Database.BatchableContext BC, List<CCRZ__E_Order__c> scope){ 
        List<Messaging.SingleEmailMessage> messageList = new List<Messaging.SingleEmailMessage>();
        List<EmailTemplate> templateList = [select id from EmailTemplate where DeveloperName='Order_Acknowledgement_Email_VF'];
        if(!templateList.isEmpty()){
            OrgWideEmailAddress[] owea = null;
            LOLSettings__c lolSetting = LOLSettings__c.getInstance('EmailFromAddress');
            if(lolSetting != null && lolSetting.Value__c!=null){
                owea = [select Id from OrgWideEmailAddress where Address =:lolSetting.Value__c];
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                String[] toAddresses = new String[]{};
            if(scope!=null)
            { 
	            for(CCRZ__E_Order__c order : scope){
	                
	                toAddresses.add(order.ccrz__User__r.Email);
	                if(order.ccrz__OriginatedCart__r.cc_oo_Alternate_Email_Id__c != null){
	                     toAddresses.add(order.ccrz__OriginatedCart__r.cc_oo_Alternate_Email_Id__c);
	                }
	                mail.setToAddresses(toAddresses);
	                mail.setUseSignature(false);
	                mail.setSaveAsActivity(false);
		            if(owea == null){
		                mail.setSenderDisplayName('Land O\'Lakes');
		            }
		            mail.setTargetObjectId(order.ccrz__User__c);
		            mail.setTemplateId(templateList[0].Id);
		            mail.setWhatId(order.Id);
		            if ( owea != null && !owea.isEmpty()) {
		                mail.setOrgWideEmailAddressId(owea.get(0).Id);
		        	}
		        	order.cc_oo_AcknowledgementEmailSent__c = true;
            }
            messageList.add(mail);
            }
            try{
                if(!messageList.isEmpty())
                    Messaging.sendEmail(messageList);
                update scope;
            }catch(Exception ex){
                cc_oo_HelperController.CreateErrorLog(ex, CLASS_NAME, 'execute');
            }
        }
    }
    
    //finish batch jobs
    global void finish(Database.BatchableContext BC){
    }

	

}