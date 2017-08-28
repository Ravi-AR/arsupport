/******************************************************************************
 * LMSA_CreateFacilityWalkThruController
 * @Description: Controller for the LMSA_CreateFacilityWalkThru page. This
 *               class contains all functionality around the editing of the 
 *               Facility (checklist) Walkthrough.
 *
 * @Date: 10/8/2015
 * @Author: Jason Flippen (Magnet360)
 *
 * @Updated:
 ******************************************************************************/
public with sharing class LMSA_CreateFacilityWalkThruController
{
    public Facility_Checklist__c FacilityChecklist {get;set;}
    public ApexPages.StandardController StdController {get;set;}
    public String FacilityTip {get;set;}
    public String FacilityQuestion {get;set;}
    public String FacilityAnswer {get;set;} 
    public Id selectedEmailTemplated { get; set;}
    public Map<String,String> labelsMap { get; set;  }

    private List<Attachment> checklistAttachmentList;
    private static String tipRT_Management = 'Management';
    private static String tipRT_Mobile = 'Mobile';
    public ID selectedTipId {get; set;}
    public LIST<Tip__c> tipAttachments {get; set;}
    private SET<Tip__c> tipAttachmentsSet {get; set;}
    public List<tipAttachmentsWrapper> tipAttachmentsWrapList { get; set;}

    public Set<String> allFieldSetNames {get ; set; }
    public Map<String, List<WrapperClass>> sectionToSubSecToFSMembersMap {get; set ; }

    /******************************************************************************
     * LMSA_CreateFacilityWalkThruController
     * @Description: Constructor method for class.
     *
     * @Date: 10/8/2015
     * @Author: Jason Flippen (Magnet360)
     *
     * @Param: None. //ApexPages.StandardController (a_controller).
     * @Return: None.
     ******************************************************************************/

    public LMSA_CreateFacilityWalkThruController()
    {
        Id param = ApexPages.currentPage().getParameters().get('facilityId');
        if (param != null) {

            //System.debug('*** START: LMSA_CreateFacilityWalkThruController.Constructor()');
            if( !Test.isRunningTest() ) {
                List<String> fields = getFieldsOnLoad();
                fields.add('Confirmed__c');
                fields.add('Name');
                // a_controller.addFields(fields);

                String query = 'SELECT Id, ' + String.join(fields, ',');
                query += ' FROM Facility_Checklist__c ';
                query += ' WHERE Id = \'' + param + '\'';

                System.debug('query: ' + query);

                // this.FacilityChecklist = (Facility_Checklist__c)a_controller.getRecord();
                this.FacilityChecklist = (Facility_Checklist__c) Database.query(query);
            }

        }else{
            String accountId = (String) ApexPages.currentPage().getParameters().get('accountId');
            if(accountId != null && !accountId.startsWith('001'))
            {
                accountId = null;
            }
            this.FacilityChecklist = new Facility_Checklist__c(Producer_Facility__c = accountId);            
        }


        this.checklistAttachmentList = new List<Attachment>();
        multipicklistFields = new List<String>();
        tipAttachments = new LIST<Tip__c>();
        tipAttachmentsWrapList = new List<tipAttachmentsWrapper>();
        tipAttachmentsSet = new SET<Tip__c>();
        
        if(this.FacilityChecklist.Id != null) {
            for( String f : populateFieldSet.keySet() ){
                for( Schema.FieldSetMember fm : populateFieldSet.get(f) ){
                    Tip__c t = questionToTipMap.get( fm.getLabel());
                    
                    Object fieldValue = this.FacilityChecklist.get(fm.getFieldPath());
                    if(fieldValue == null) continue;
                    
                    String stringFieldValue = '';
                    if( fieldValue instanceof Boolean ) {
                        stringFieldValue = String.valueOf( ( Boolean ) fieldValue );
                    }else if(fieldValue instanceof Decimal){
                        stringFieldValue = String.valueOf( ( Decimal ) fieldValue );                        
                    } else {
                        stringFieldValue = (String) fieldValue;
                    }
                    
                    if(t.Facility_Answer__c != null &&
                      stringFieldValue.toUpperCase() == t.Facility_Answer__c.toUpperCase()) {
                          tipAttachmentsWrapList.add(new tipAttachmentsWrapper(t, true));
                          tipAttachmentsSet.add(t);
                    }
                }
            }
        }
        
        tipAttachments.addAll(tipAttachmentsSet);
        
        populateCustomSettings();

        String msg = System.currentPageReference().getParameters().get('msg');
        if(!String.isEmpty(msg)) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, EncodingUtil.urlDecode(msg, 'UTF-8')));
        }
        
        
        //tipAttachments  = new LIST<tipAttachmentsWrapper>();

    } // End Constructor


    public void populateCustomSettings()
    {
        if( allFieldSetNames == null ) allFieldSetNames = new Set<String>(); 
        if( sectionToSubSecToFSMembersMap == null  ) sectionToSubSecToFSMembersMap = new Map<String, List<WrapperClass>>(); 

        Map<String, Schema.FieldSetMember> fieldApiNameToFSMemberMap = new Map<String, Schema.FieldSetMember>() ; 

        // Get All fields set and FieldSetMembers        
        Schema.FieldSet fieldSetObj ; 
        List<Schema.FieldSetMember> fsMembers ; 
        Map<String, Schema.FieldSet> allFieldSet = Schema.SObjectType.Facility_Checklist__c.fieldSets.getMap() ;
        for( String fsName : allFieldSet.keySet() )
        {
            fieldSetObj = allFieldSet.get(fsName) ;
            fsMembers = fieldSetObj.getFields() ;
            //if( fsMembers.size() > 0 ) allFieldSetNames.add(fsName) ;

            // Populate map with Field API Name and settings
            for( Schema.FieldSetMember fsm : fsMembers )
            {
                fieldApiNameToFSMemberMap.put( fsm.getFieldPath(), fsm );
            }
        }


        for( Facility_Check_List_Labels_Settings__c fcs : [ SELECT Section_Label__c, Sub_Section_Label__c, Field_API_Name_s_1_CSV__c, Field_API_Name_s_2_CSV__c, 
                                                                    SortOrder__c, Id 
                                                            FROM Facility_Check_List_Labels_Settings__c ORDER BY SortOrder__c , Sub_Section_Label__c ] )
        {
            List<Schema.FieldSetMember> fsMembersFromSettings = new List<Schema.FieldSetMember>() ; 
            if(!allFieldSetNames.contains(fcs.Section_Label__c)) allFieldSetNames.add(fcs.Section_Label__c) ;
            
            List<WrapperClass> wrapperList = sectionToSubSecToFSMembersMap.get(fcs.Section_Label__c) ;
            if( wrapperList == null )
            {   
                wrapperList = new List<WrapperClass>();
                sectionToSubSecToFSMembersMap.put(fcs.Section_Label__c, wrapperList ) ;
            }
            for( String field : fcs.Field_API_Name_s_1_CSV__c.split(',') )
            {
                if(fieldApiNameToFSMemberMap.get(field) != null  ) fsMembersFromSettings.add( fieldApiNameToFSMemberMap.get(field) ) ;
            }

            WrapperClass wc = new WrapperClass(); 
            wc.subClassSectionName = fcs.Sub_Section_Label__c ; 
            wc.fieldSetMembers = fsMembersFromSettings ; 

            wrapperList.add(wc);
        }

        System.debug('UAC: sectionToSubSecToFSMembersMap ' + sectionToSubSecToFSMembersMap );
    }

    /******************************************************************************
     * getFacilityTip
     * @Description: Method to determine which Tip is diplayed to the User.
     *
     * @Date: 10/8/2015
     * @Author: Jason Flippen (Magnet360)
     *
     * @Param: None.
     * @Return: String (l_returnValue) - Text of the Tip.
     ******************************************************************************/
    public String getFacilityTip()
    {
        String tip = '';

        Tip__c matchingTip = [SELECT Id, Name, RecordTypeId, RecordType.DeveloperName, Tip__c, Facility_Answer__c
                                FROM   Tip__c
                                WHERE  Facility_Question__c = :this.FacilityQuestion
                                AND    Facility_Answer__c = :this.FacilityAnswer];

        System.debug('*** matchingTip: ' + matchingTip);

        tip = matchingTip.Tip__c;
        
        // If the RecordType of this Tip is "Management", we need to copy all its Attachments.
        if (matchingTip.RecordType.DeveloperName == tipRT_Management)
        {
            getAttachments(new List<ID>{matchingTip.Id});
        }

        return tip ;

    } // End Method: getFacilityTip()

    /******************************************************************************
     * getAttachments
     * @Description: Method to clone the Attachments from a Tip that matches the
     *               Facility Checklist question/answer combination.
     *
     * @Date: 10/8/2015
     * @Author: Jason Flippen (Magnet360)
     *
     * @Param: Id (a_tipId) - The Id of the matching Tip record.
     * @Return: None.
     ******************************************************************************/
    private void getAttachments(List<Id> a_tipIds)
    {
        System.debug('*** START: LMSA_CreateFacilityWalkThruController.getAttachments()');
        System.debug('*** Param: a_tipId: ' + a_tipIds);

        Map<Id,Attachment> attachMap = new Map<Id,Attachment>([ SELECT Id, ParentId, Name, Body, ContentType, Description
                                                                FROM   Attachment
                                                                WHERE  ParentId in :a_tipIds]);

        System.debug('*** attachMap: ' + attachMap );

        if (!attachMap.isEmpty())
        {
            for (Attachment a : attachMap.values())
            {
                Attachment att = a.clone();
                this.checklistAttachmentList.add(att);
            }
            System.debug('*** checklistAttachmentList: ' + this.checklistAttachmentList);
        }

        System.debug('*** END: LMSA_CreateFacilityWalkThruController.getAttachments()');

    } // End Method: getAttachments()

    /******************************************************************************
     * SaveNew
     * @Description: Method to save the new Facility Checklist and insert any
     *               related Attacments.
     *
     * @Date: 10/8/2015
     * @Author: Jason Flippen (Magnet360)
     *
     * @Param: None.
     * @Return: PageReference (l_returnPageRef) - PageReference to redirect the 
     *          User to the Facility Checklist "View" page.
     ******************************************************************************/
    /*public PageReference SaveNew()
    {
        System.debug('*** START: LMSA_CreateFacilityWalkThruController.SaveNew()');
        
        PageReference l_returnPageRef = null;

        insert(this.FacilityChecklist);

        if (this.FacilityChecklist.Id != null)
        {
            if (this.checklistAttachmentList.size() > 0)
            {
                saveNewAttachments();
            }
            l_returnPageRef = new PageReference('/' + this.FacilityChecklist.Id);
            l_returnPageRef.setRedirect(true);
        }

        System.debug('*** END: LMSA_CreateFacilityWalkThruController.SaveNew()');
        
        return l_returnPageRef;

    }*/ // End Method: SaveNew()

    /******************************************************************************
     * saveNewAttachments
     * @Description: Method to insert any Attacments related to the Facility
     *               Checklist.
     *
     * @Date: 10/8/2015
     * @Author: Jason Flippen (Magnet360)
     *
     * @Param: None.
     * @Return: None.
     ******************************************************************************/
    private void saveNewAttachments()
    {
        System.debug('*** START: LMSA_CreateFacilityWalkThruController.saveNewAttachments()');
        
                                                 // Iterate through the associated
                                                 // attachment records and set
                                                 // their ParentId value to the Id
                                                 // of the Facility Checklist that
                                                 // was just created.
        for (Attachment a : this.checklistAttachmentList)
        {
            if( !Test.isRunningTest() ) a.ParentId = this.FacilityChecklist.Id;
        }
        System.debug('*** checklistAttachmentList: ' + this.checklistAttachmentList);

        upsert(this.checklistAttachmentList);

        System.debug('*** END: LMSA_CreateFacilityWalkThruController.saveNewAttachments()');
        
    } // End Method: saveNewAttachments()
    
    public PageReference saveRecord(){
        PageReference pr=null ;
        system.debug(logginglevel.INFO, 'MTList:'+FacilityChecklist);
        Integer reqCount =0;
        if (FacilityChecklist.Producer_Facility__c == null) {
        	reqCount++;
        	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Producer Facility: This field is required.') );
        } else if (FacilityChecklist.Contact_1__c == null && FacilityChecklist.Contact_2__c == null && FacilityChecklist.Contact_3__c == null) {
        	reqCount++;
        	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact 1: This field is required.') );
        }
        if (reqCount > 0) {
        	return null;
        }
        try{ 
            for( String fieldName : multipicklistFields ){
                String picklistValue ='';
                Integer counter =0;
                for( String pValue :fieldNameToMultiPicklistValues.get( fieldName )){
                    String param = ApexPages.currentPage().getParameters().get(fieldName+'_'+String.valueOf(counter));
                    if( param != null ){
                        picklistValue += param +';';
                    }
                    counter ++;
                }
                FacilityChecklist.put( fieldName , picklistValue );
                system.debug('AZ:: ' + picklistValue );
            }
            
            system.debug('AZ:: all ' + ApexPages.currentPage().getParameters() );
            System.debug('UAC: FacilityChecklist ' + FacilityChecklist ) ;
            if (FacilityChecklist.Producer_Facility__c != null) {
            	Integer cCount = 0;
            	Integer cAdded = 0;
            	Map<Id, Contact> cs = new Map<Id, Contact>(
					[SELECT id, AccountId FROM Contact WHERE accountid = :FacilityChecklist.Producer_Facility__c LIMIT 50000]
				);
				if (FacilityChecklist.Contact_1__c != null) {
					cAdded++;
					if (cs.containsKey(FacilityChecklist.Contact_1__c)) {
						cCount++;
					} else {
						Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact 1: The Contact does not belong to the Producer Facility selected.') );
					}
				}
				if (FacilityChecklist.Contact_2__c != null) {
					cAdded++;
					if (cs.containsKey(FacilityChecklist.Contact_2__c)) {
						cCount++;
					} else {
						Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact 2: The Contact does not belong to the Producer Facility selected.') );
					}
				}
				if (FacilityChecklist.Contact_3__c != null) {
					cAdded++;
					if (cs.containsKey(FacilityChecklist.Contact_3__c)) {
						cCount++;
					} else {
						Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact 3: The Contact does not belong to the Producer Facility selected.') );
					}
				}
				if (cAdded != cCount) {
					system.debug('cAdded: ' + cAdded + ' - cCount: ' + cCount);
					throw new DmlException();
				}
            }
            upsert FacilityChecklist;
            
            // Save Attachments
            List<Id> tipIds = new List<Id>();
            for(tipAttachmentsWrapper tipwrap: tipAttachmentsWrapList)
            {
                if(tipwrap.isSelected)
                    tipIds.add(tipwrap.tipAttachment.ID);
                
            }
            getAttachments(tipIds);
            saveNewAttachments();
            
           
            pr = new PageReference('/apex/LMSA_CreateFacilityWalkThru?facilityId='+ FacilityChecklist.Id);
            pr.setRedirect(true);
            System.debug(logginglevel.INFO, 'Inserted FacilityChecklist:'+FacilityChecklist);
            pr.getParameters().put('msg', EncodingUtil.urlEncode('Facility Checked List saved successfully!', 'UTF-8'));
        }catch(DmlException ex){
            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ex.getMessage() ));
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter a Producer Facility and Contact 1.') );
        }
        
        
        return pr;
        
    } 
    
    public Map<String , List<SelectOption>> fieldNameToPicklistValues {
        get{
            if(fieldNameToPicklistValues==null){
                fieldNameToPicklistValues = new Map<String , List<SelectOption>>();
            }
            return fieldNameToPicklistValues;
           }
        private set;
    }
    public Map<String , List<String>> fieldNameToMultiPicklistValues {
        get{
            if(fieldNameToMultiPicklistValues==null){
                fieldNameToMultiPicklistValues = new Map<String , List<String>>();
            }
            return fieldNameToMultiPicklistValues;
           }
        private set;
    }
    public Map<String , List<String>> fieldNameToValues {get{
        if( fieldNameToValues == null ){
            fieldNameToValues = new Map<String , List<String>>();
        }
        return fieldNameToValues;
    } set;}
    
    private List<String> multipicklistFields;
    private List<Schema.FieldSetMember> getFieldSetMembers(String fieldSetName){
        
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType sObjectTypeObj = GlobalDescribeMap.get('Facility_Checklist__c');
        Schema.DescribeSObjectResult DescribeSObjectResultObj = sObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        List<Schema.FieldSetMember> fieldSetMembers = fieldSetObj.getFields();
       
        for( Schema.FieldSetMember fsm : fieldSetMembers ){
            String fieldType = String.ValueOf( fsm.getType() );
            fieldNameToPicklistValues.put( fsm.getFieldPath() ,new List<SelectOption>() );
            fieldNameToMultiPicklistValues.put( fsm.getFieldPath() ,new List<String>() );
           
            if( fieldType == 'Picklist' ){
                Schema.SObjectField sObjField = Schema.SObjectType.Facility_Checklist__c.fields.getMap().get( fsm.getFieldPath() );
                Schema.DescribeFieldResult fieldResult = sObjField.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
                List<SelectOption> picklistValues = fieldNameToPicklistValues.get( fsm.getFieldPath() );
                
                for( Schema.PicklistEntry f : ple){
                    picklistValues.add( new SelectOption( f.getValue() , f.getLabel()) );
                }                
            }
            if( fieldType == 'multipicklist' ){
                
                multipicklistFields.add( fsm.getFieldPath() );
                fieldNameToValues.put( fsm.getFieldPath(), new List<String>() );
                Schema.SObjectField sObjField = Schema.SObjectType.Facility_Checklist__c.fields.getMap().get( fsm.getFieldPath() );
                Schema.DescribeFieldResult fieldResult = sObjField.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
                List<String> picklistValues = fieldNameToMultiPicklistValues.get( fsm.getFieldPath() );
                
                for( Schema.PicklistEntry f : ple){
                    picklistValues.add( f.getValue() );
                }                
            }
        }
        return fieldSetMembers;
    }
    
    public Map<String,Tip__c> questionToTipMap{
        get{
            if(questionToTipMap==null){
                questionToTipMap = new Map<String,Tip__c>();
                for( String f : populateFieldSet.keySet() ){
                    for( Schema.FieldSetMember fm : populateFieldSet.get(f) ){
                        if( fm != null ) questionToTipMap.put( fm.getLabel() , new Tip__c() );
                    }
                }
                
                List<Tip__c> tpList = [SELECT Name, Id, Facility_Question__c, Tip__c, Facility_Answer__c, RecordType.DeveloperName 
                                       FROM Tip__c 
                                       where Facility_Question__c in: questionToTipMap.keySet() ];
                
                questionToTipMap.put( null , new Tip__c() );
                for(Tip__c t : tpList){
                    questionToTipMap.put(t.Facility_Question__c , t );
                }
            }
            return questionToTipMap;
        }
        private set;
    }
    public Map<String, List<Schema.FieldSetMember>> populateFieldSet{
        get{
            if(populateFieldSet==null){
                populateFieldSet = new  Map<String, List<Schema.FieldSetMember>>();
                LIST<String> fieldSetNames = getAllFieldsSetNames();
                if(fieldSetNames != null && fieldSetNames.size() > 0){
                    for(String fName : fieldSetNames){
                        populateFieldSet.put(fName,getFieldSetMembers(fName));                        
                    }
                }
                /*
                populateFieldSet.put('Facility',getFieldSetMembers('Facility'));
                populateFieldSet.put('General',getFieldSetMembers('General'));
                populateFieldSet.put('Environment',getFieldSetMembers('Environment'));
                populateFieldSet.put('Air',getFieldSetMembers('Air'));
                populateFieldSet.put('Feed',getFieldSetMembers('Feed'));
                populateFieldSet.put('Water',getFieldSetMembers('Water'));
                */
            }
            return populateFieldSet;
        }
        private set;
    }

    public LIST<String> getAllFieldsSetNames(){
        String fields = String.valueOf(Org_Settings__c.getInstance().FaciityChecklist_Fieldsets__c);

        return new LIST<String>(fields.split(','));
    }

    public list<String> getFieldsOnLoad()
    {
        Set<String> fields = new Set<String>();
        for(string fieldset:populateFieldSet.keySet())
        {
            for(Schema.FieldSetMember member:populateFieldSet.get(fieldset))
            {
                fields.add(member.getFieldPath());   
            }
        }
        return new List<String>( fields);
    }
    
    public PageReference SendEmail()
    {   
        PageReference pr;
        saveRecord();
        if(FacilityChecklist.id != null){

            List<Facility_Checklist__c> cntctList = [Select id, Contact_1__c, Contact_2__c, Contact_3__c From Facility_Checklist__c 
                                                        Where Id =: FacilityChecklist.id];

            List<ID> lstids= new List<ID>();
                for(Facility_Checklist__c c:cntctList){
                    if(c.Contact_1__c !=null)
                        lstids.add(c.Contact_1__c);
                    if(c.Contact_2__c !=null)
                        lstids.add(c.Contact_2__c);
                    if(c.Contact_3__c !=null)
                        lstids.add(c.Contact_3__c);
            }

            List<Contact> cntIdList=[Select Id From Contact Where id in: lstids];
            
            try{
                List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
                List<Task> taskList = new List<Task>(); 

                For(Contact ct : cntIdList){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTargetObjectId(ct.Id);
                    mail.setWhatId(FacilityChecklist.id);
                    mail.setTemplateId(selectedEmailTemplated);
                    
                    
                    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                    List<Attachment> attId = [select Name, Body, BodyLength from Attachment where ParentId=:FacilityChecklist.id];
                    for (Attachment a : attId)
                    {
                        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                        efa.setFileName(a.Name);
                        efa.setBody(a.Body);
                        fileAttachments.add(efa);
                    }
                    mail.setFileAttachments(fileAttachments);
                    
                    mailList.add(mail);

                    Task tsk = new Task( Status ='Completed', Type = 'Support Call', ActivityDate = date.today(), Subject = 'Facility Checklist Created', 
                                         WhatId = FacilityChecklist.Producer_Facility__c, Activity__c = 'Farmgate', Priority = 'Normal', Description = FacilityChecklist.Id,
                                         Type2__c = 'Support Call' ) ;
                    taskList.add(tsk);
                }
                Messaging.sendEmail( mailList );  
                if(taskList.size() > 0 ) insert taskList ;

                FacilityChecklist.Confirmed__c = true;
                upsert FacilityChecklist;
                 
                pr = new PageReference ('/apex/LMSA_CreateFacilityWalkThru?facilityId='+FacilityChecklist.id);
                pr.setRedirect(true);
                pr.getParameters().put('msg', EncodingUtil.urlEncode('Email sent successfully!', 'UTF-8'));
                
            }catch(Exception e)
            {
                 pr = null;
                 Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()) );
            }
        }
        else
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please save Facility checklist first') );
        }
        return pr;
    }

   Public List<SelectOption> emailTemplates {
        get{
            
            if(emailTemplates == null)
            {
                emailTemplates = new List<SelectOption>();

                List<EmailTemplate> templateList = [SELECT Id, Name, DeveloperName, NamespacePrefix, OwnerId,IsActive, Folder.DeveloperName, Folder.Name 
                                                    FROM EmailTemplate 
                                                    WHERE isActive = true AND Folder.DeveloperName = 'Facility_Walk_Thru_Email_Templates' ] ;
                for(EmailTemplate et: templateList )
                {
                    emailTemplates.add(new SelectOption(et.Id, et.Name));
                }
                // Select first template as default if templates found
                if(templateList.size() > 0 ) selectedEmailTemplated = templateList[0].Id; 
            }
            return emailTemplates;
            
        } set;
    }
    Public PageReference cancel(){
        PageReference pr;
        Schema.DescribeSObjectResult r = Facility_Checklist__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        if (retURL != null) {
                pr = new PageReference(retURL);
            }else{
                pr = new PageReference('/'+keyPrefix);                
            }
        return pr;
    }
    
    
    public PageReference addAttachToChecklist(){
        tipAttachments = new LIST<Tip__c>();
        tipAttachmentsWrapList = new List<tipAttachmentsWrapper>();
        if(selectedTipId != null){
            LIST<Tip__c> selectedTipRec = [SELECT Name, Id, Facility_Question__c, Tip__c, RecordType.DeveloperName,Facility_Answer__c FROM Tip__c WHERE Id =: selectedTipId];
           // if(selectedTipRec.size() > 0){
                tipAttachmentsSet.addAll(selectedTipRec);
            //}  
        }
        tipAttachments.addAll(tipAttachmentsSet);
        for(Tip__c tip:tipAttachmentsSet)
        {
            tipAttachmentsWrapList.add(new tipAttachmentsWrapper(tip, true) );
        }
        System.debug('AA:tipAttachments' + tipAttachments);
        //tipAttachments
        return null;
    }
    
    public String getUl(){
        return '<ul class=\"inner steps_ul\">';
    }
    
    public class tipAttachmentsWrapper{
        public Boolean isSelected {get; set;}
        public Tip__c tipAttachment {get; set;}
        Public tipAttachmentsWrapper( Tip__c tipAttach, Boolean isSelected)
        {
            this.isSelected = isSelected;
            this.tipAttachment = tipAttach;
        }
    }

    public class WrapperClass {
        public void WrapperClass(String subSection, List<Schema.FieldSetMember> fsMembers ){
            this.subClassSectionName = subSection ;
            this.fieldSetMembers = fsMembers ;
        }
        public String subClassSectionName{ get; set; }
        public List<Schema.FieldSetMember> fieldSetMembers{ get ; set; }
    }
} // End Class