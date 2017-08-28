trigger AnswerTrigger on Answer__c (after insert, after update,after delete,after undelete) {
    AnswerTriggerHandler.AnswerAPI(trigger.new,trigger.old,trigger.oldmap,trigger.isInsert,trigger.isUpdate,
        trigger.isAfter,trigger.isDelete,trigger.isundelete);   
}