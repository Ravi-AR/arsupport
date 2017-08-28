global without sharing class cc_oo_ScheduleAmendJDEBatch implements Schedulable {
	global void execute(SchedulableContext sc){
		cc_oo_AmendJDEBatch amendBatch = new cc_oo_AmendJDEBatch();
		ID batchprocessid = Database.executeBatch(amendBatch,Integer.valueOf(Lolsettings__c.getValues('AmendJDeBatchRecordSize').Value__c));//chunk 50 recrods at a time. 
	}
}