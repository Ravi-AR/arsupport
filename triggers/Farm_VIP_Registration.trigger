trigger Farm_VIP_Registration on Farm_VIP_Registration__c ( after update) {
    // only care about after update since the FARM vip registration event needs to be created then submitted for approval before it becomes approved.
    Farm_VIP_Approval approval_helper = new Farm_VIP_Approval();
	if(trigger.isAfter && trigger.isUpdate){
		approval_helper.checkApproved(trigger.newMap, trigger.oldMap);
	}

}