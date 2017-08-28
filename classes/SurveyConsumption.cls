@RestResource(urlMapping='/surveyconsumption')
global class SurveyConsumption {
    @HttpPost
    global static void CreateSurveyConsumption(string contactleadid, string eventid, List<wrapQuestionAnswers> QuestionAnswers) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        string jsonResponse = '';
        string streventid = '';
        string strcontactleadid = '';
        
        streventid = eventid;
        strcontactleadid =  contactleadid;
        
        if(strcontactleadid == null || strcontactleadid == '') {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : contactleadid"}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }else if(streventid == null || streventid == '') {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : eventid"}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        } else if(QuestionAnswers == null || QuestionAnswers.size() == 0) {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : No Question and Answers found"}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        } else {
            jsonResponse = surveyconsumptionDetails(QuestionAnswers ,strcontactleadid,streventid);
            try {
                res.statusCode = 200;
                string strMsg='';
                JSONParser parser = JSON.createParser(jsonResponse);
                //system.debug('parser :'+parser );
                string strMessage = '';
                while (parser.nextToken() != null){
                    if ((parser.getText() == 'result')){
                        parser.nextToken();
                        strMessage = parser.getText();
                    }
                }
                
                jsonResponse  = jsonResponse.unescapeEcmaScript();
                jsonResponse  = jsonResponse.replace('"[','[');
                jsonResponse  = jsonResponse.replace(']"',']');
                res.responseBody = blob.valueOf(jsonResponse);
                //system.debug('jsonResponse  :'+jsonResponse  );
                return;
                
            }catch ( Exception ex ){
                res.statusCode = 500;
                jsonResponse = '{"status": "Failure", "message": "' + ex + '"}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }
        }
    }
    public static string surveyconsumptionDetails(List<wrapQuestionAnswers> lstQuestionAnswers, string strContactLeadid,string strEventid){
        List<Survey_Results__c> lstSurveyResultToInsert = new List<Survey_Results__c>();  
        // List<CampaignMember> lstCampaignMemberToInsert = new List<CampaignMember>();  
        List<RecordType> lstRT = new List<RecordType>([SELECT DeveloperName, Id, SobjectType FROM RecordType 
                where SobjectType = 'Survey_Results__c' and  DeveloperName= 'Digigraph_Survey_Results' limit 1]);
        /* List<CampaignMember> lstCMember = new List<CampaignMember>([SELECT Id, LeadId, ContactId, CampaignId FROM CampaignMember where 
                                CampaignId=: strEventid and (ContactId=: strContactLeadid or LeadId=: strContactLeadid)]); */
        String PrefixOfId = String.valueOf(strContactLeadid).substring(0,3);
        /*
         if(lstCMember.size() == 0){
            CampaignMember objCMember = new CampaignMember(); 
            if(PrefixOfId.equals('003')) {
                objCMember.ContactId = strContactLeadid;
            } else if(PrefixOfId.equals('00Q')) {
                objCMember.LeadId = strContactLeadid;
            }
            objCMember.CampaignId = strEventid ;
            lstCampaignMemberToInsert.add(objCMember);
        }
        */
        
        for(wrapQuestionAnswers objQuestionAnswers: lstQuestionAnswers) {
            Survey_Results__c objSurveyResult = new Survey_Results__c();
            if(lstRT != null && lstRT.size() > 0)
                objSurveyResult.recordtypeId = lstRT[0].id;    
                
            if(objQuestionAnswers.questionID != null)
                objSurveyResult.Question_Answer_ID__c = objQuestionAnswers.questionID;
                
            if(objQuestionAnswers.answerid != null)
                objSurveyResult.Answer_Lookup__c = objQuestionAnswers.answerid;
            
            if(strEventid != null)
                objSurveyResult.Customer_Event__c = strEventid;
            else
                strEventid = '';
                 
            if(PrefixOfId.equals('003')){
                objSurveyResult.Contact__c = strContactLeadid;
                
            }else if(PrefixOfId.equals('00Q')){
                objSurveyResult.Lead__c = strContactLeadid;                
            }else{
                strContactLeadid = '';
            }    
            lstSurveyResultToInsert.add(objSurveyResult);
        }
        
        /*
         if(lstCampaignMemberToInsert.size() > 0) {
            insert lstCampaignMemberToInsert;
        }
		*/
        
        if(lstSurveyResultToInsert.size() > 0) {
            insert lstSurveyResultToInsert;
        }
        
        List<Survey_Results__c> lstSurveyResult = new List<Survey_Results__c>();
        lstSurveyResult = [select id,Name,Question_Answer_ID__c,Question__c,Answer_Lookup__c,
                            Contact__c,Customer_Event__c,Lead__c,Segmentation__c  from Survey_Results__c
                            where id in: lstSurveyResultToInsert];
        
        string strMsg = '';
        string jsonResponse = '';
        strMsg = jsonstringContact(lstSurveyResult);
        jsonResponse = '{\"result\":\"Success\",';
        jsonResponse += '\"message\":\"Survey Results is created\",';
        jsonResponse += '\"survey results\":' + strMsg + '}';

        return jsonResponse ;               
    }
    public static string jsonstringContact(List<Survey_Results__c> lstSurvey){
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartArray();
        for(Survey_Results__c obj : lstSurvey){
            generator.writeStartObject();
            //generator.writeStringField('id',obj.Id);
            generator.writeStringField('surveyidentifier',obj.id);
            
            if(obj.Question_Answer_ID__c != null)        
                generator.writeStringField('surveyquestionid',obj.Question_Answer_ID__c);
            else
                generator.writeStringField('surveyquestionid','');

            if(obj.Question__c != null)        
                generator.writeStringField('surveyquestion',obj.Question__c);
            else
                generator.writeStringField('surveyquestion','');
                
            if(obj.Answer_Lookup__c != null)        
                generator.writeStringField('answerid',obj.Answer_Lookup__c);
            else
                generator.writeStringField('answerid','');
            
            if(obj.Segmentation__c != null)        
                generator.writeStringField('segmentation',obj.Segmentation__c);
            else
                generator.writeStringField('segmentation','');
            
            if(obj.Contact__c != null)        
                generator.writeStringField('contactid',obj.Contact__c);
            else
                generator.writeStringField('contactid','');
            
            if(obj.Lead__c != null)        
                generator.writeStringField('leadid',obj.Lead__c);
            else
                generator.writeStringField('leadid','');

            if(obj.Customer_Event__c != null)        
                generator.writeStringField('eventid',obj.Customer_Event__c);
            else
                generator.writeStringField('eventid','');
            //surveyidentifier   
            generator.writeEndObject();
        }
        generator.writeEndArray();
        return generator.getAsString();
    }
    
    global class wrapQuestionAnswers {
        global String questionID { get; set; }
        global String answerid { get; set; }
    }
}