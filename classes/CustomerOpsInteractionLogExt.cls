// CustomerOpsInteractionLogExt
// Custom interaction log for Customer Ops users to add activities for Service
//  Requests.
//------------------------------------------------------------------------------
// Author					Date			Description
// -----------------------------------------------------------------------------
// Mark Purick				10/04/2016		Created
// Mark Purick				10/06/2016		Replaced hard coded ids with helper
// 											 function call.
// 
public with sharing class CustomerOpsInteractionLogExt {
   public String caseId { 
      get {
         caseId = ApexPages.currentPage().getParameters().get('id');
         return caseId;
      }
      set; 
   }
   public String defaultStatus { get; set; }
   public String profileId { get; set; }
   public String caseObjectId { get; set; }
   public String caseRecordType { get; set; }
   public String caseRecordTypeStr { get; set; }
   public Boolean showActivityReason { get; set; }
   public RecordTypeHelper rth = new RecordTypeHelper();
   public Case currentCase { get; set; }
    
   public Task task {
      get {
         if(task == null) {
            task = new Task();
         }
         return task;
      }
      set;
   }
    
   public CustomerOpsInteractionLogExt(ApexPages.StandardController controller) {
      init();
   }
    
   public void init() {
      task.Status = 'In Progress';
      getRecordType();
      updateTaskData();
   }
    
   // Called once the case is saved to update related information on the task
   public void updateTaskData() {
      Integer count = [Select COUNT() from Case where id = :caseId];
      if (count==0) {
         return;
      }
      else {
         currentCase = [SELECT id, contactId, Sales_Order__c FROM Case WHERE id = :caseId];
         task.whoId = currentCase.contactId;
         task.whatId = currentCase.id;
      }
   }
    
   // Called to determine the Task record type based on record type of Service Request.
   // Refreshes picklists to show correct values related to the record type.
   public void getRecordType() {      
      Id consumer = [SELECT id FROM Profile p WHERE p.name = 'Consumer Group'].Id;
      profileId = UserInfo.getProfileId();

      caseObjectId = ApexPages.currentPage().getParameters().get('objectId');
      if (caseObjectId != null && caseObjectId != '') {
         caseRecordType = [SELECT RecordTypeId FROM Case WHERE Id = :caseObjectId LIMIT 1].RecordTypeId;
      }
        
      if (caseRecordType != null) {
         caseRecordTypeStr = [SELECT Name FROM RecordType WHERE Id = :caseRecordType].Name;
         if (caseRecordTypeStr.contains('Consumer')) {
            task.RecordTypeId = rth.getIdFromName('Consumer Task',task);
            showActivityReason = true;
         }
         else if (caseRecordTypeStr.contains('Customer') || caseRecordTypeStr.contains('Mass Channel')) {
            task.RecordTypeId = rth.getIdFromName('Customer Ops Task',task);
            showActivityReason = false;
         }
         else if (profileId != null) {
            // Consumer Profile
            if (profileId == consumer) {
               task.RecordTypeId = rth.getIdFromName('Consumer Task',task);
               showActivityReason = true;
            }
            else {
               task.RecordTypeId = rth.getIdFromName('Customer Ops Task',task);
               showActivityReason = false;
            }
         }
      }
   }
    
   public void save() {
      if (task.whatId == null) {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please save the Service Request first'));
      }
      else {
         updateTaskData();
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Your activity has been saved. Please refresh to view in related lists.'));
         upsert task;
      }
   }
    
   public void saveNew() {
      save();
      task = null;
      init();
   }
    
   public void clear() {
      task = null;
      init();
   }
}