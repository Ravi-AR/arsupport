/******************************************************************************
 * LMSA_ManagementTipsController
 * @Description: Controller for the LMSA_ManagementTip page. This
 *               class contains functionality for sending tip attachment to selected contact
 *
 *
 * @Date: 10/28/2015
 * @Author: Adeel Ahmad (Magnet360)
 *
 * @Updated:
 ******************************************************************************/
public with sharing class LMSA_ManagementTipsController {
	public LIST<Attachment> tipAttachments {get; set;}
	public LIST<Tip__c> tips {get; set;}
	public String selectedTips {get; set;}
	public Tip__c contactRecord {get; set;}
	private SET<ID> selectedTipIds { get; set; }

	public LMSA_ManagementTipsController(ApexPages.StandardController sc) {
		tipAttachments = new LIST<Attachment>();
		selectedTips = '';
		contactRecord = new Tip__c();
		selectedTipIds = new SET<ID>(); 
		tips = new LIST<Tip__c>();
	}

	public void addSelectedTips(){
		if(selectedTips != null && selectedTips != ''){
			LIST<String> sTips = selectedTips.split(',');
			tips = [SELECT Id,
                           Name,
                           RecordTypeId,
                           RecordType.DeveloperName,
                           Tip__c,
                           Facility_Answer__c
                    FROM   Tip__c
                    WHERE  ID in :sTips];
		}
		System.debug('AA:tips ' + tips);
	}

	public PageReference sendAttachmentEmail(){
		PageReference pr = null;

		if (contactRecord.Producer_Facility__c != null) {
        	Integer cCount = 0;
        	Integer cAdded = 0;
        	Map<Id, Contact> cs = new Map<Id, Contact>(
				[SELECT id, AccountId FROM Contact WHERE accountid = :contactRecord.Producer_Facility__c LIMIT 50000]
			);
			if (contactRecord.Contact__c != null) {
				cAdded++;
				if (cs.containsKey(contactRecord.Contact__c)) {
					cCount++;
				} else {
					Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact: The Contact does not belong to the Facility Producer selected.') );
				}
			}
			if (cAdded != cCount) {
				system.debug('cAdded: ' + cAdded + ' - cCount: ' + cCount);
				return null;
			}
        }

		if(tips != null && tips.size() > 0){
			String selectedTipIdsStr = '';
            for(Tip__c t : tips){
				selectedTipIds.add(t.Id);
                selectedTipIdsStr += t.Id + ',';
			}
            selectedTipIdsStr = selectedTipIdsStr.substring( 0, selectedTipIdsStr.length() -1 );
            
            User currentUsr = new User( Id = UserInfo.getUserId() );
            currentUsr.Selected_Management_Tips__c = selectedTipIdsStr;
            update currentUsr;
            
			tipAttachments = [SELECT Id,
                                    ParentId,
                                    Name,
                                    Body,
                                    ContentType,
                                    Description
                             FROM   Attachment
                             WHERE  ParentId in :selectedTipIds];
			
            sendEmail();
		}

        

		return pr;
	}

	public PageReference sendEmail(){
        PageReference pr;
		// Check for Contact
        if( contactRecord.Contact__c == null ){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please choose contact.' ));
            pr = null;
            return pr;
        }

        // Get Email template Id from CustomSettings
        Id templateId =  Org_Settings__c.getinstance().Management_Tip_Email_Template_Id__c ;

        // Get Email Template
        List<EmailTemplate> templateList = [SELECT Id, Name, DeveloperName, NamespacePrefix, OwnerId,IsActive, Folder.DeveloperName, Folder.Name 
                                            FROM EmailTemplate 
                                            WHERE isActive = true AND Id = :templateId ] ;
        if(templateList.size() == 0 ){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No email template available to send email' ));
            pr = null;
            return pr;   
        }

        // Send Email 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>(); 
        mail.setTargetObjectId(contactRecord.Contact__c);
        mail.setTemplateId(templateList[0].Id);
        List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();
        for (Attachment a : tipAttachments)
        {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(a.Name);
            efa.setBody(a.Body);
            efa.setContentType(a.ContentType);
            efa.setInline(false);
            fileAttachments.add(efa);
        }
        mail.setFileAttachments(fileAttachments);

        emails.add(mail);
        Messaging.sendEmail(emails);  

        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email sent successfully!' ));

        tips = new LIST<Tip__c>();
        pr = new PageReference('/apex/LMSA_ManagementTips');
        pr.setRedirect(true);
        
        return pr;

	}


}