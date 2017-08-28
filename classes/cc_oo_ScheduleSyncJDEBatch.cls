global class cc_oo_ScheduleSyncJDEBatch implements Schedulable 
{
	global void execute(SchedulableContext sc){
		cc_oo_SyncJDEBatch syncBatch = new cc_oo_SyncJDEBatch();
		ID batchprocessid = Database.executeBatch(syncBatch,Integer.valueOf(Lolsettings__c.getValues('SyncJDeBatchRecordSize').Value__c));//chunk 50 recrods at a time. 
	}
    
}