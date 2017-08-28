global class cc_oo_RefreshCategoryCache implements Schedulable {
        global void execute(SchedulableContext sc) {
            /*String categoryQuery = 'SELECT ID, Name,ccrz__CategoryID__c' 
                                                + ',ccrz__ChildCategoryCount__c,ccrz__EndDate__c'
                                                + ',ccrz__LongDesc__c,ccrz__LongDescRT__c,ccrz__ParentCategory__c'
                                                + ',ccrz__ProductCount__c,ccrz__Sequence__c,ccrz__ShortDesc__c'
                                                + ',ccrz__ShortDescRT__c,ccrz__StartDate__c FROM ccrz__E_Category__c';
			*/
            String categoryQuery = 'SELECT ccrz__Default__c,ccrz__Storefront__c,ccrz__Type__c,ccrz__Value__c,Name FROM ccrz__E_StorefrontConfigSettings__c';
            ccrz.cc_job_LoadCategoryTreeStorefront  catBatch =  new ccrz.cc_job_LoadCategoryTreeStorefront(categoryQuery);
              database.executebatch(catBatch);
        }
}