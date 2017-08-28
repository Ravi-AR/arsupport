/******************************************************************************
 * LMSA_ProgramEvaluationCalculator
 * @Description: Controller for the LMSA_ProgramEvaluation page. This
 *               class contains all functionality around the calculating score
 *
 * @Date: 10/26/2015
 * @Author: Adeel Ahmad (Magnet360)
 *
 * @Updated:
 ******************************************************************************/
public class LMSA_ProgramEvaluationController {
    public Program_Evaluation__c progEvaluation {get; set;}
    public ApexPages.StandardController stdCntrl {get;set;}
    public Boolean isRecordSaved {get; set; }

    public LMSA_ProgramEvaluationController(ApexPages.StandardController sc){

        List<String> fieldList = new List<String>();
        Map<String, SobjectField> fieldMap = Program_Evaluation__c.getsObjectType().getDescribe().Fields.getMap(); 
 
        if( !Test.isRunningTest() )
        {
            for(String f :  fieldMap.keySet())
            {
                fieldList.add( fieldMap.get(f).getDescribe().getName() );
            }
            sc.addFields(fieldList);
        }

        if(sc.getId() != null){
                progEvaluation = (Program_Evaluation__c)sc.getRecord();
                //progEvaluation = [ SELECT Id, Producer_Facility__c, Contact__c FROM Program_Evaluation__c WHERE Id = :sc.getId() ] ;
                System.debug('UAC: ' + progEvaluation ) ;
            }else{
                String accountId = (String) ApexPages.currentPage().getParameters().get('accountId');
                if(accountId != null && !accountId.startsWith('001'))
                {
                    accountId = null;
                }

                progEvaluation = new Program_Evaluation__c(Producer_Facility__c=accountId);
            }
        stdCntrl = sc;  
        
        isRecordSaved = progEvaluation.Id != null ? true : false ;
    }

//    public void saveRecord(){
    public PageReference saveRecord(){
        PageReference pr;
        Integer reqCount =0;
        if (progEvaluation.Producer_Facility__c == null) {
        	reqCount++;
        	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Facility Producer Account: This field is required.') );
        } else if (progEvaluation.Contact__c == null) {
        	reqCount++;
        	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact: This field is required.') );
        }
        if (reqCount > 0) {
        	return null;
        }
        try{
            if(progEvaluation != null){
            	system.debug('progEvaluation: ' + progEvaluation);
                if (progEvaluation.Producer_Facility__c != null) {
                    Integer cCount = 0;
                    Integer cAdded = 0;
                    Map<Id, Contact> cs = new Map<Id, Contact>(
                        [SELECT id, AccountId FROM Contact WHERE accountid = :progEvaluation.Producer_Facility__c LIMIT 50000]
                    );
                    if (progEvaluation.Contact__c != null) {
                        cAdded++;
                        if (cs.containsKey(progEvaluation.Contact__c)) {
                            cCount++;
                        } else {
                            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contact: The Contact does not belong to the Facility Producer Account selected.') );
                        }
                    }
                    if (cAdded != cCount) {
                        system.debug('cAdded: ' + cAdded + ' - cCount: ' + cCount);
                        throw new DmlException();
                    }
                }
                upsert progEvaluation;
                isRecordSaved = true ;
            	Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Program Evaluation Saved Successfully ' ));
            }
        }catch(DmlException ex){
            isRecordSaved = false ; 
            //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ex.getMessage() ));
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter a Facility Producer and Contact.') );
        }
        pr = progEvaluation.Id != null ? new PageReference('/apex/LMSA_ProgramEvaluation?id=' + progEvaluation.Id) : null ;
        //if( pr != null ) {
            //pr.setRedirect(true) ;
            //pr.getParameters().put('msg', EncodingUtil.urlEncode('Program Evaluation Saved Successfully!', 'UTF-8'));
        //}
        //Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Program Evaluation Saved Successfully ' ));
		//return pr ;
		try{
			if (progEvaluation.Id != null) {
				progEvaluation = [SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Diet_Name_1__c, Diet_Name_2__c, Diet_Name_3__c, Diet_Name_4__c, Diet_Name_5__c, Lbs_1__c, Lbs_2__c, Lbs_3__c, Lbs_4__c, Lbs_5__c, lb_diet_1__c, lb_diet_2__c, lb_diet_3__c, lb_diet_4__c, lb_diet_5__c, pigs_in__c, pigs_out_currentprogram__c, avg_wt_in__c, avg_wt_out__c, days_on_feed__c, number_dead__c, percent_dead__c, Percent_Full_Value__c, Curren_Program_Total_Gain__c, UC_Diet_Name_1__c, UC_Diet_Name_2__c, UC_Diet_Name_3__c, UC_Diet_Name_4__c, UC_Diet_Name_5__c, UC_lbs_1__c, UC_Lbs_2__c, UC_lbs_3__c, UC_Lbs_4__c, UC_Lbs_5__c, UC_lb_diet_1__c, UC_lb_diet_2__c, UC_lb_diet_3__c, UC_lb_diet_4__c, UC_lb_diet_5__c, UC_pigs_in__c, UC_pigs_out__c, UC_number_dead__c, UC_percent_dead__c, UC_Percent_Full_Value__c, UC_avg_wt_in__c, UC_avg_wt_out__c, UC_Total_Gain__c, UC_days_on_feed__c, Current_Program_ADG__c, UltraCare_ADG__c, Diff_ADG__c, Current_Program_Total_Feed_Lbs__c, Ultracare_Total_Feed_Lbs__c, dollar_pig_fed_1__c, dollar_pig_fed_2__c, dollar_pig_fed_3__c, dollar_pig_fed_4__c, dollar_pig_fed_5__c, UC_dollar_pig_fed_1__c, UC_dollar_pig_fed_2__c, UC_dollar_pig_fed_3__c, UC_dollar_pig_fed_4__c, UC_dollar_pig_fed_5__c, Current_Program_Total_Feed_Dollar__c, Total_Feed_Cost_Ultracare__c, Current_Program_Feed_Gain__c, UltraCare_Feed_Gain__c, Feed_Gain_Difference__c, Current_Program_lb_gain__c, UltraCare_Program_lb_gain__c, Lb_Gain_Difference__c, Producer_Facility__c, Contact__c, UC_Avg_Wt_Out_Result_Field__c, Diff_ADG_Input__c, UC_Total_Gain_ADG_Input__c FROM Program_Evaluation__c WHERE id =: progEvaluation.Id ];
				//isRecordSaved = true ;
			} else {
				isRecordSaved = false ; 
			}
		}catch(Exception ex){
            isRecordSaved = false ; 
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please enter a Facility Producer and Contact.') );
        }
        
        return null;
    }

    public void sendEmail(){
    	// Check for Account
        if( progEvaluation.Producer_Facility__c == null ){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Facility Producer Account: This field is required.' ));
            return ;
        }
        // Check for Contact
        if( progEvaluation.Contact__c == null ){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Contact: This field is required.' ));
            return ;
        }
        
        // Get Email template Id from CustomSettings
        Id templateId =  Org_Settings__c.getinstance().Program_Evaluation_Email_Template_Id__c ;

        // Get Email Template
        List<EmailTemplate> templateList = [SELECT Id, Name, DeveloperName, NamespacePrefix, OwnerId,IsActive, Folder.DeveloperName, Folder.Name 
                                            FROM EmailTemplate 
                                            WHERE isActive = true AND Id = :templateId ] ;
        if(templateList.size() == 0 ){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No email template available to send email' ));   
            return ;
        }

        // Send Email 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        mail.setTargetObjectId(progEvaluation.Contact__c);
        mail.setWhatId(progEvaluation.Id);
        mail.setTemplateId(templateList[0].Id);
        emails.add(mail);
        if( !test.isRunningTest()) Messaging.sendEmail(emails);  
        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email sent successfully!'));

        //saveRecord();
    }

    public PageReference cloneRecord(){
        PageReference pr ;
        Program_Evaluation__c clonedPE = progEvaluation.clone(false, true, true, false);
        clonedPE.put('Diff_ADG_Input__c', null);
        clonedPE.put('UC_avg_wt_out__c', null);
        try{
            if(clonedPE != null){
                upsert clonedPE;
                isRecordSaved = true ;
            }
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Program Evalution cloned and save Successfully ' ));
        }catch(DmlException ex){
            isRecordSaved = false ; 
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, ex.getMessage() ));
        }

        pr = clonedPE.Id != null ? new PageReference('/apex/LMSA_ProgramEvaluation?id=' + clonedPE.Id) : null ;
        if( pr != null ) {
            //pr.setRedirect(true) ;
            pr.getParameters().put('cloned', EncodingUtil.urlEncode('1', 'UTF-8'));
            pr.getParameters().put('msg', EncodingUtil.urlEncode('Program Evaluation Saved Successfully!', 'UTF-8'));
        }
//        return pr ;
		progEvaluation = [SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, Diet_Name_1__c, Diet_Name_2__c, Diet_Name_3__c, Diet_Name_4__c, Diet_Name_5__c, Lbs_1__c, Lbs_2__c, Lbs_3__c, Lbs_4__c, Lbs_5__c, lb_diet_1__c, lb_diet_2__c, lb_diet_3__c, lb_diet_4__c, lb_diet_5__c, pigs_in__c, pigs_out_currentprogram__c, avg_wt_in__c, avg_wt_out__c, days_on_feed__c, number_dead__c, percent_dead__c, Percent_Full_Value__c, Curren_Program_Total_Gain__c, UC_Diet_Name_1__c, UC_Diet_Name_2__c, UC_Diet_Name_3__c, UC_Diet_Name_4__c, UC_Diet_Name_5__c, UC_lbs_1__c, UC_Lbs_2__c, UC_lbs_3__c, UC_Lbs_4__c, UC_Lbs_5__c, UC_lb_diet_1__c, UC_lb_diet_2__c, UC_lb_diet_3__c, UC_lb_diet_4__c, UC_lb_diet_5__c, UC_pigs_in__c, UC_pigs_out__c, UC_number_dead__c, UC_percent_dead__c, UC_Percent_Full_Value__c, UC_avg_wt_in__c, UC_avg_wt_out__c, UC_Total_Gain__c, UC_days_on_feed__c, Current_Program_ADG__c, UltraCare_ADG__c, Diff_ADG__c, Current_Program_Total_Feed_Lbs__c, Ultracare_Total_Feed_Lbs__c, dollar_pig_fed_1__c, dollar_pig_fed_2__c, dollar_pig_fed_3__c, dollar_pig_fed_4__c, dollar_pig_fed_5__c, UC_dollar_pig_fed_1__c, UC_dollar_pig_fed_2__c, UC_dollar_pig_fed_3__c, UC_dollar_pig_fed_4__c, UC_dollar_pig_fed_5__c, Current_Program_Total_Feed_Dollar__c, Total_Feed_Cost_Ultracare__c, Current_Program_Feed_Gain__c, UltraCare_Feed_Gain__c, Feed_Gain_Difference__c, Current_Program_lb_gain__c, UltraCare_Program_lb_gain__c, Lb_Gain_Difference__c, Producer_Facility__c, Contact__c, UC_Avg_Wt_Out_Result_Field__c, Diff_ADG_Input__c, UC_Total_Gain_ADG_Input__c FROM Program_Evaluation__c WHERE id =: clonedPE.Id];
        
        return null;
    }

    Public PageReference cancel(){
        PageReference pr;
        Schema.DescribeSObjectResult r = Program_Evaluation__c.sObjectType.getDescribe();
        String keyPrefix = r.getKeyPrefix();
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        if (retURL != null) {
                pr = new PageReference(retURL);
            }else{
                pr = new PageReference('/'+keyPrefix);                
            }
        return pr;
    }

}