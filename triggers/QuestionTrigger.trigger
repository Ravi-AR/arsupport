trigger QuestionTrigger on Question__c (after update,before delete) {
    if(!QuestionTriggerHandler.isQuestionRecursive) {
        QuestionTriggerHandler.QuestionAPI(trigger.new,trigger.old,
                trigger.isUpdate,trigger.isAfter,trigger.isdelete);
    }
}