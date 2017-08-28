@RestResource(urlMapping='/findleadcontact')
global class FindLeadContact{
    @HttpGet
    global static void FindLeadContactRecord() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        string jsonResponse = '';
        string stremail = '';
        string strphone = '';
        stremail = req.params.get('email'); 
        strphone = req.params.get('phone');
         
        if((stremail == null || stremail == '') && (strphone == null || strphone == '')) {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : email,phone "}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }/*else if(strphone == null || strphone == '') {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : phone"}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }*/
        else{
         
            jsonResponse =  GetLeadContactDetails(stremail,strphone);
            try {
                res.statusCode = 200;
                string strMsg='';
                JSONParser parser = JSON.createParser(jsonResponse);
                system.debug('parser :'+parser );
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
                system.debug('jsonResponse  :'+jsonResponse  );
                return;
                
            }catch ( Exception ex ){
                res.statusCode = 500;
                jsonResponse = '{"status": "Failure", "message": "' + ex + '"}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }
            
           
        }
       
    }
    public static string GetLeadContactDetails(string strEmailId, string strPhone){
             
        string jsonResponse = '';
        boolean blnFound = false;
        List<Lead> lstLead = new List<Lead>();
        List<Contact> lstContact = new List<Contact>();
        
        string strLeadQuery = '';
        string strContactQuery = '';
        
        string strCriteria = '';

        if(!string.IsBlank(strEmailId)) {
            strCriteria += ' Email = \''+strEmailId+'\'';
        }
        if(!string.IsBlank(strPhone)) {
            strPhone = FormatPhoneField(strPhone);
            if (!string.IsBlank(strEmailId)) {
                strCriteria += ' OR ';
            }
            strCriteria += ' Phone__c = \''+strPhone+'\'';
            strCriteria += ' OR Mobile__c = \''+strPhone+'\'';
        }
        
        strLeadQuery += 'select id,FirstName, LastName, Street, City, State, PostalCode, Email, Phone, MobilePhone from Lead where ' + strCriteria;
        
        strContactQuery += 'select id,FirstName,LastName,MailingStreet,MailingCity,MailingState,MailingPostalCode,Email,Phone,MobilePhone from Contact Where ' + strCriteria;
        
        if(!string.IsBlank(strEmailId) || !string.IsBlank(strPhone)) {
            lstLead = Database.Query(strLeadQuery);
            lstContact= Database.Query(strContactQuery);            
        }
        
        if(lstContact != null && lstContact.size() > 0){
            blnFound = true;
        }
       
        if(lstLead != null && lstLead.size() > 0){
            blnFound = true;
        }
        
        if(!blnFound){
            jsonResponse = '{\"result\":\"Failure\",';
            jsonResponse += '\"message\": \"Contact or Lead not found.\"}';
        }else{
            jsonResponse = '{\"result\":\"Success\",';
            jsonResponse += '\"message\":\"Records found.\",';
            
            string jstr = jsonstring(lstLead,lstContact);
            jsonResponse += '\"Contact_Lead\":' + jstr ;

            jsonResponse += '}';
        }
    
        return jsonResponse;               
    }
    
    public static string jsonstring(List<Lead> lstLead,List<Contact> lstContact){
        
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartArray();
                    
        for(Lead obj : lstLead){
        
            generator.writeStartObject();
            generator.writeStringField('id',obj.Id);
            generator.writeStringField('Name',obj.Firstname + ' ' + obj.Lastname);
            
            if(obj.Street != null)        
                generator.writeStringField('street',obj.Street);
            else
                generator.writeStringField('street','');
                
            if(obj.City!= null)        
                generator.writeStringField('city',obj.City);
            else
                generator.writeStringField('city','');
            
            if(obj.State != null)        
                generator.writeStringField('state',obj.State);
            else
                generator.writeStringField('state','');
            
            if(obj.PostalCode!= null)        
                generator.writeStringField('postalcode',obj.PostalCode);
            else
                generator.writeStringField('postalcode','');

            if(obj.Email != null)        
                generator.writeStringField('email',obj.Email);
            else
                generator.writeStringField('email','');
            
            if(obj.Phone!= null)        
                generator.writeStringField('phone',obj.Phone);
            else
                generator.writeStringField('phone','');
            
            if(obj.MobilePhone != null)        
                generator.writeStringField('mobilephone',obj.MobilePhone);
            else
                generator.writeStringField('mobilephone','');
            generator.writeStringField('type','Lead');
            generator.writeEndObject();
        }
        for(Contact obj : lstContact){
        
            generator.writeStartObject();
            generator.writeStringField('id',obj.Id);
            string strfnm  ='';
            if(obj.Firstname != null)
                strfnm = obj.Firstname ;
            generator.writeStringField('Name', strfnm + ' ' + obj.Lastname);

            if(obj.MailingStreet != null)        
                generator.writeStringField('street',obj.MailingStreet);
            else
                generator.writeStringField('street','');
                
            if(obj.MailingCity != null)        
                generator.writeStringField('city',obj.MailingCity);
            else
                generator.writeStringField('city','');
            
            if(obj.MailingState != null)        
                generator.writeStringField('state',obj.MailingState);
            else
                generator.writeStringField('state','');
            
            if(obj.MailingPostalCode != null)        
                generator.writeStringField('postalcode',obj.MailingPostalCode);
            else
                generator.writeStringField('postalcode','');

            if(obj.Email != null)        
                generator.writeStringField('email',obj.Email);
            else
                generator.writeStringField('email','');
            
            if(obj.Phone!= null)        
                generator.writeStringField('phone',obj.Phone);
            else
                generator.writeStringField('phone','');
            
            if(obj.MobilePhone != null)        
                generator.writeStringField('mobilephone',obj.MobilePhone);
            else
                generator.writeStringField('mobilephone','');
            generator.writeStringField('type','Contact');
            generator.writeEndObject();
        }
        generator.writeEndArray();
        return generator.getAsString();
    }
    public static string jsonstringContact(List<Contact> lstContact){
        
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartArray();
                    
        for(Contact obj : lstContact){
        
            generator.writeStartObject();
            generator.writeStringField('id',obj.Id);
            string strfnm  ='';
            if(obj.Firstname != null)
                strfnm = obj.Firstname ;
            generator.writeStringField('Name', strfnm + ' ' + obj.Lastname);

            if(obj.MailingStreet != null)        
                generator.writeStringField('street',obj.MailingStreet);
            else
                generator.writeStringField('street','');
                
            if(obj.MailingCity != null)        
                generator.writeStringField('city',obj.MailingCity);
            else
                generator.writeStringField('city','');
            
            if(obj.MailingState != null)        
                generator.writeStringField('state',obj.MailingState);
            else
                generator.writeStringField('state','');
            
            if(obj.MailingPostalCode != null)        
                generator.writeStringField('postalcode',obj.MailingPostalCode);
            else
                generator.writeStringField('postalcode','');

            if(obj.Email != null)        
                generator.writeStringField('email',obj.Email);
            else
                generator.writeStringField('email','');
            
            if(obj.Phone!= null)        
                generator.writeStringField('phone',obj.Phone);
            else
                generator.writeStringField('phone','');
            
            if(obj.MobilePhone != null)        
                generator.writeStringField('mobilephone',obj.MobilePhone);
            else
                generator.writeStringField('mobilephone','');
            generator.writeEndObject();
        }
        
        generator.writeEndArray();
        return generator.getAsString();
    }
    
    Private Static String RemovePhoneSymbol(String strPhone) {
        if (strPhone.Contains(' ') == true) strPhone = strPhone.Replace(' ', '');
        strPhone = strPhone.replaceAll('[^0-9]', '');       
        return strPhone;
    }
    
    Private Static String FormatPhoneField(String strPhoneValue){
        strPhoneValue = RemovePhoneSymbol(strPhoneValue);
        if(strPhoneValue.trim().length() == 11 && strPhoneValue.startswith('1')) {
            return strPhoneValue.trim().substring(1,strPhoneValue.length());
        }
        return strPhoneValue;
    }
}