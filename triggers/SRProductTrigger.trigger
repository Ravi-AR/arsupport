/*
 * SRProductTrigger
 * Main Trigger for Service Request Products. Logic for what should happen for given
 * action should be handled in handler classes.  
 * 
 * ---------------------------------------------------------------------------------
 * Author                   Date                    Description
 * ---------------------------------------------------------------------------------
 * Juan Rivera              10/05/2016              Created
 */
trigger SRProductTrigger on Service_Request_Product__c (
   before insert, after insert,
   before update, after update,
   before delete, after delete) {
        
   if(Trigger.isBefore){
      if(Trigger.isInsert){
         // Logic of SRPUpdatePlantUserEmails
         try {
            SRProductHandler srpHandler = new SRProductHandler(Trigger.new);
            srpHandler.populateSRPEmailFields();
         }
         catch (System.NullPointerException e) {
            Trigger.new[0].addError('The Service Request is Closed. Please update status before adding products');
         }
         catch (Exception e) {
            Trigger.new[0].addError(e);
         }
      }
      if(Trigger.isUpdate){}
      if(Trigger.isDelete){}
   }

   if(Trigger.isAfter){
      if(Trigger.isInsert){}
      if(Trigger.isUpdate){}
      if(Trigger.isDelete){}
   }        
}