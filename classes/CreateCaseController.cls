/****************************************/
/*
 * Controller class for mobile case creation with attachment
 * Author : adeel.ahmad@magnet360.com
 * Date   : 01-23-2015
 * 
****************************************/
public class CreateCaseController {
    public Case newCase                     {get; set;}
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Case.FieldSets.Case_Create_Fieldset.getFields();
    }
    public String accountId {get; set;}
    public LIST<Attachment> attachments {
                                  get {
                                      if ( attachments == null ){
                                          attachments = new LIST<Attachment>();
                                          for(Integer i=0;i<10;i++){
                                              attachments.add(new Attachment());
                                          }
                                          return attachments;
                                      }     
                                      return attachments;
                                      }
                                  set;
                                 }    
     
    public Boolean isS1(){
       String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
       return String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
       String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
       ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
      (String.isNotBlank(retUrl) && retURL.contains('projectone'));
    }

    
    public CreateCaseController(){ 
        newCase = new Case();
        accountId = (String) ApexPages.currentPage().getParameters().get('id');
        if(accountId != null && !accountId.startsWith('001'))
        {
            accountId = null;
        }
        
        
        System.debug('AA:AccountId ' + accountId);
    }
   
    public PageReference SubmitCase(){
        try{
            if(accountId != null){
                newCase.AccountId = accountId;
            }
            insert newCase;
            
            //Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
            transient Messaging.EmailFileAttachment [] eAttachmentList = new List<Messaging.EmailFileAttachment> () ;
            
            if(attachments != null && attachments.size() > 0)
            {
                for(Attachment att : attachments){
                    if(att.body != null && att.name != null){
                        att.OwnerId = UserInfo.getUserId();
                        att.ParentId = newCase.Id;
                        att.IsPrivate = true;
                        insert att;    
                        
                        //Set Attachment
                        Messaging.EmailFileAttachment fileAtt = new Messaging.EmailFileAttachment();    
                        fileAtt.setbody(att.body);
                        fileAtt.setContenttype(att.contenttype);
                        fileAtt.setfilename(att.name);
                        fileAtt.setinline(false);
                        eAttachmentList.add(fileAtt);
                    }
                }
            }
            SEt<ID> recepientIds = new Set<Id>();
            ID TemplateId;
            try
            {
                For( groupMember gm : [select userorgroupid 
                                        from groupMember 
                                        where group.name = 'Customer support team' and 
                                        group.type = 'Queue'])
                {
                    recepientIds.add(gm.userorgroupid);
                }
                templateId = [Select id from EmailTemplate where name = 'New Case Notification - Customer Support'].Id;
            }
            catch(Exception ex)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Customer support team queue or template not found'));
            }
            if(!recepientIds.isempty() && templateId != null)
            {
                List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                for(Id uid : recepientIds)
                {
                    Messaging.SingleEmailMessage  email = new Messaging.SingleEmailMessage();
                    email.setSaveAsActivity(false);
                    email.settargetObjectId(uid);
                    email.settempLateId(templateId);
                    email.setWhatId(newCase.Id);
                    if(eAttachmentList != null) {
                        email.setFileAttachments(eAttachmentList); 
                    }
                    emails.add(email);
                }
                Messaging.sendEmail( emails );
            }
            PageReference pr;
            if(accountId != null){
                pr = new PageReference('/'+accountId);    
            }
            else
            {
                if(isS1()){
                    if(accountId != null){
                        pr = new PageReference('/'+accountId);                         
                    }else{
                        pr = new PageReference('/'+newCase.Id); 
                    }

                }else{
                    pr = new PageReference('/'+newCase.Id);
                }
                
            }
            newCase = new Case();
            attachments = null;
            return pr;
        }catch( DmlException exc ){
            ApexPages.addMessages( exc );
        }
        return null;
    }
}