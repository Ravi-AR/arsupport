trigger UpdateAnimalTotalsOnAccount on Animal_Count_Lifestage__c (after insert, after update, after delete ) {
    if(trigger.isInsert || trigger.isUpdate)
        AnimalCountAndLifeStageController.isAfter(trigger.newmap);
    if(trigger.isDelete)
        AnimalCountAndLifeStageController.isAfter(trigger.oldmap);

}