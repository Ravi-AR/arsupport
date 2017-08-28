/*
 * ContactTrigger
 * Main Trigger for Contacts. Logic for what should happen for given
 * action should be handled in handler classes.  
 * 
 * ---------------------------------------------------------------------------------
 * Author					Date					Description
 * ---------------------------------------------------------------------------------
 * Juan Rivera				10/13/2016				Created
 */
trigger ContactTrigger on Contact (
   before insert, after insert,
   before update, after update,
   before delete, after delete) {
   if(Trigger.isBefore){
      if(Trigger.isInsert){
          // Logic for Account assignment to 'Consumer Account'
          ContactTriggerHandler cth = new ContactTriggerHandler();
          cth.assignToConsumerAccount(Trigger.new);
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