global class DigigrapghAPI{
    
    global static string strResBody{get;set;}
    global static string strToken{get;set;}
    global static string strParam{get;set;}
    // Not sure where to change below, so hardcode for now
    global static string strEndPointURL = system.label.DigigrapghEndPoint;
    
    @future(callout=true)
    public static void pingUser() {        
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        string endpoint = strEndPointURL + 'users/ping';
       
        //String endpoint = 'https://canvas.instructure.com/api/v1/courses?access_token=1875~pNUbvc2hrzBTs4HVO6BAZPxwCcuOux8Fi7NX3IQncBv3Ldu0HK3njkjceZsLzCmg';
        request.setEndPoint(endpoint);
        // Set the HTTP verb to POST.
        request.setMethod('POST');
        // Send the HTTP request and get the response.
        HttpResponse response = httpProtocol.send(request);
        strResBody = response.getBody();
        
    }
    
    //Create Event
    @future(callout=true)
    public static void CreateEvent(string streventid,string strzipcode,string strname,string stranimalType, Boolean strIsActive, Date dtStartDate, Date dtEndDate, string strPayload ) {  
        
        System.debug('>> DigigraphAPI.CreateEvent() has started <<');
        System.debug( 'CREATE :: is_active value == ' + strIsActive );
        
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        
        // Set the endpoint URL.
        string endpoint = strEndPointURL + 'events/created'; 
        request.setEndPoint(endpoint);
        
        // Set the Content body.
        String content = '{"eventId":"'+streventid+'","zipCode":"'+strzipcode+'","name":"'+strname+'","eventType":"'+stranimalType+'","isActive": "'+strIsActive+'", "startDate": "'+dtStartDate+'", "endDate": "'+dtEndDate+'", "payload": "'+strPayload+'"}';
        request.setHeader('Content-Type','application/raw');              
        request.setMethod('POST');
        request.setBody(content);
        // Send the HTTP request and get the response.
        HttpResponse response = httpProtocol.send(request);
        strResBody = response.getBody();
        system.debug('strResBody :'+strResBody );
        API_Log__c objAPILogInsert = new API_Log__c();
        objAPILogInsert = CreateAPILog(streventid,'',content,endpoint,strResBody,'');
        insert objAPILogInsert;
    }
    
    //Edit Event
    @future(callout=true)
    public static void EditEvent(string streventid,string strzipcode,string strname,string strtype,
            Boolean strIsActive, Boolean isDelete, Date dtStartDate, Date dtEndDate, string strPayload ) {  
                
                System.debug('>> DigigraphAPI.EditEvent() has started <<');
                System.debug( 'is_active value == ' + strIsActive );
                
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        
        // Set the endpoint URL.
        string endpoint = strEndPointURL + 'events/' + streventid + '/edited'; 
        request.setEndPoint(endpoint);
        
                
      	string strStartDate = '';
        string strEndDate = '';
        
        if( dtStartDate != null )
        {
            strStartDate = dtStartDate.format();
        }
        
        if( dtEndDate != null )
        {
            strEndDate = dtEndDate.format();
        }                
                
        // Set the Content body
        String content = '{"zipCode":"'+strzipcode+'","name":"'+strname+'","eventType":"'+strtype+'","isActive":"'+strIsActive+'", "startDate": "' + dtStartDate + '", "endDate": "' + dtEndDate +'", "payload": "' + strPayload + '"}';
        request.setHeader('Content-Type','application/raw');        
        request.setMethod('POST');
        request.setBody(content);
        
        // Send the HTTP request and get the response.
        HttpResponse response = httpProtocol.send(request);
        strResBody = response.getBody();
        API_Log__c objAPILogInsert = new API_Log__c();
        if(isDelete) {
            streventid = '';
        }
        objAPILogInsert = CreateAPILog(streventid,'',content,endpoint,strResBody,'');
        insert objAPILogInsert;
                
                System.debug('>> DigigraphAPI.EditEvent() will return <<');
    }
    
    //Delete Event
    @future(callout=true)
    public static void DeleteEvent(string streventid) { 
        
        System.debug('>> DigigraphAPI.DeleteEvent() has started <<');
        //system.debug('streventidDLT:'+streventid);  
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        string endpoint = strEndPointURL + 'events/' + streventid + '/deleted';
       
        request.setEndPoint(endpoint);
        // Set the HTTP verb to DELETE.
        request.setMethod('DELETE');
        Boolean blnIsactive = false;
        String content = '{"IsActive":'+blnIsactive+'}';
        request.setHeader('Content-Type','application/raw');
        request.setBody(content);
        // Send the HTTP request and get the response.
        HttpResponse response = httpProtocol.send(request);
        strResBody = response.getBody();
        //system.debug('strResBody ddd:'+strResBody ); 
        API_Log__c objAPILogInsert = new API_Log__c();
        objAPILogInsert = CreateAPILog(streventid,'',content,endpoint,strResBody,'');
        insert objAPILogInsert; 
    }
    
    //Get events
    @future(callout=true)
    public static void FindEvent(string strzcode) {   
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        string strZipCode = '';
        if(strzcode != null && strzcode!= '')
            strZipCode = strzcode;
        string content = 'zip_code='+strZipCode;
        string endpoint = strEndPointURL + 'events?zip_code='+strZipCode ;
       
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        HttpResponse response = httpProtocol.send(request);
        strResBody = response.getBody();
        API_Log__c objAPILogInsert = new API_Log__c();
        objAPILogInsert = CreateAPILog('','',content,endpoint,strResBody,'');
        insert objAPILogInsert; 
    }  
    
    //Create Question
    @future(callout=true)
    public static void Question(string strquesId,string strbody,string strquestionOrder,string streventAnimalType,
            string stranswers,boolean blnActive) {   
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        string endpoint = strEndPointURL + 'surveys/questions/created' ;
        request.setEndPoint(endpoint);
        
        // Set the Content body.
        String content = '{"questionId":"'+strquesId+'","body":"'+strbody+'","questionOrder":"'+strquestionOrder+'","isActive":"'+blnActive+'"';
        content += ',"eventAnimalType":"'+streventAnimalType+'","answers":'+stranswers+'}';
        request.setHeader('Content-Type','application/raw');        
        request.setMethod('POST');
        request.setBody(content);
        //system.debug('endpointcccc::'+ endpoint + 'content!! :'+content ); 
        // Send the HTTP request and get the response.
        HttpResponse response = httpProtocol.send(request);
        strResBody = response.getBody();
        API_Log__c objAPILogInsert = new API_Log__c();
        objAPILogInsert = CreateAPILog('',strquesId,content,endpoint,strResBody,'');
        insert objAPILogInsert; 
        //system.debug('strResBodyccc::'+ strResBody ); 
    }  
    
    //Edit Question
    @future(callout=true)
    public static void EditQuestion(string strquesId,string strbody,string strquestionOrder,string streventAnimalType,
                string stranswers,boolean blnActive,boolean isDelete) {   
        //system.debug('streventidCreate:'); 
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        string endpoint = strEndPointURL + 'surveys/questions/'+strquesId+'/edited';
        request.setEndPoint(endpoint);
        
        // Set the Content body.
        String content = '{"body":"'+strbody+'","questionOrder":'+strquestionOrder+',"eventAnimalType":"'+streventAnimalType;
        content += '","isActive": "'+blnActive+'","answers":'+stranswers+'}';
        //system.debug('endpoint::'+ endpoint + 'content!! :'+content ); 
        request.setHeader('Content-Type','application/raw');    

        request.setMethod('POST');
        request.setBody(content);
        // Send the HTTP request and get the response.
        HttpResponse response = httpProtocol.send(request);
        strResBody = response.getBody();
        API_Log__c objAPILogInsert = new API_Log__c();
        if(isDelete) {
            strquesId = '';
        }
        objAPILogInsert = CreateAPILog('',strquesId,content,endpoint,strResBody,'');
        insert objAPILogInsert; 
        //system.debug('strResBody eeee::'+ strResBody ); 
    }
    
    //Delete Question
    @future(callout=true)
    public static void DeleteQuestion(string strquestionId){
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        
        // Set the endpoint URL.
        string endpoint = strEndPointURL + 'surveys/questions/'+strquestionId+'/deleted';
        request.setEndPoint(endpoint);
       
        // Set the HTTP verb to DELETE.
        request.setMethod('DELETE');
        // Send the HTTP request and get the response.
        HttpResponse response = httpProtocol.send(request);
        strResBody = response.getBody();
        API_Log__c objAPILogInsert = new API_Log__c();
        objAPILogInsert = CreateAPILog('',strquestionId,'',endpoint,strResBody,'');
        insert objAPILogInsert; 
    }
    
    //Upload Survey
    @future(callout=true)
    public static void UploadSurvey(blob filebody){
         Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        
        // Set the endpoint URL.
        string endpoint = strEndPointURL + 'surveys/questions/uploaded';
        request.setEndPoint(endpoint);
        String boundary = '----------------------------';
        request.setHeader('Content-type','multipart/form-data; boundary='+boundary);
        String queryheader = '--'+boundary+'\n';
        String body = EncodingUtil.base64Encode(filebody); 
        
        string querybody= body+'Content-Disposition: form-data; name="field"\n\n'+EncodingUtil.urlEncode('SID', 'UTF-8')+'\n';
        
        request.setBody(querybody);
        request.setHeader('Content-Length',String.valueof(querybody.length()));
        request.setMethod('POST');
        // Send the HTTP request and get the response.
        HttpResponse response = httpProtocol.send(request);
        strResBody = response.getBody();
    }
    
    //Get Random Questions
    @future(callout=true)
    public static void RandomQuestions(string streventId,string struserId){
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        
        // Set the endpoint URL.
        string endpoint = strEndPointURL + 'surveys/events/'+streventId+'/users/'+struserId+'/questions';
        request.setEndPoint(endpoint);

        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        HttpResponse response = httpProtocol.send(request);
        strResBody = response.getBody();
        API_Log__c objAPILogInsert = new API_Log__c();
        objAPILogInsert = CreateAPILog(streventId,'','',endpoint,strResBody,'');
        insert objAPILogInsert; 
    }
    
    //Save Answers
    @future(callout=true)
    public static void SaveAnswers(string streventId,string struserId,string stranswers){
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        
        // Set the endpoint URL.
        string endpoint = strEndPointURL + 'surveys/events/'+streventId+'/users/'+struserId+'/answers';
        request.setEndPoint(endpoint);
        
        // Set the Content body.
        String content = '{"answers":"'+stranswers+'"}';
        
        request.setHeader('Content-Type','application/raw');        
        request.setMethod('POST');
        request.setBody(content);
        // Send the HTTP request and get the response.
        HttpResponse response = httpProtocol.send(request);
        strResBody = response.getBody();
        API_Log__c objAPILogInsert = new API_Log__c();
        objAPILogInsert = CreateAPILog(streventId,'',content,endpoint,strResBody,'');
        insert objAPILogInsert; 
    }
    
    Public static API_Log__c CreateAPILog(string strCustomerEventId, string strQuestionId, string strRequestBody,
                string strRequestURL,string strResponseBody,string strSurveyResultsId) {
        API_Log__c objAPILog = new API_Log__c();
        if(!string.IsBlank(strCustomerEventId)) {
            objAPILog.Customer_Event__c = strCustomerEventId;
        }
        if(!string.IsBlank(strQuestionId)) {
            objAPILog.Question__c = strQuestionId;
        }
        objAPILog.Request_Body__c = strRequestBody;
        objAPILog.Request_URL__c = strRequestURL;
        objAPILog.Response_Body__c = strResponseBody;
        if(!string.IsBlank(strSurveyResultsId)) {
            objAPILog.Survey_Results__c = strSurveyResultsId;
        }
        return objAPILog;
    }
}