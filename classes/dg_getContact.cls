@RestResource(urlMapping='/dg_getContact')
global class dg_getContact{
    @HttpGet
    global static void FindLeadContactRecord() 
    {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        string jsonResponse = '';
        
        string strLeadID = '';
        strLeadID = req.params.get( 'lead_id' );
         
        if( strLeadID == null || strLeadID == '' )
        {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : email,phone "}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }
        else{
         
            jsonResponse =  GetLeadContactDetails( strLeadID );
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
    
    public static string GetLeadContactDetails( string strLeadID )
    {
             
        string jsonResponse = '';
        boolean blnFound = false;
        List<Lead> lstLead = new List<Lead>();
        List<Contact> lstContact = new List<Contact>();
        
        string strLeadQuery = '';
        string strContactQuery = '';
        
        string strCriteria = '';
        
        strCriteria = ' id = \'' + strLeadID + '\'';
        
        strLeadQuery += 'select id,FirstName, LastName, Street, City, State, PostalCode, Email, Phone, MobilePhone from Lead where ' + strCriteria + ' and isconverted=false';

        strContactQuery += 'select id,FirstName,LastName,MailingStreet,MailingCity,MailingState,MailingPostalCode,Email,Phone,MobilePhone from Contact Where ' + strCriteria;
        
        lstContact= Database.Query(strContactQuery);

        if( lstContact.size() > 0 )
        {
            jsonResponse = '{\"result\":\"Success\",';
            jsonResponse += '\"message\":\"Contact records found.\",';
            
            string jstr = jsonstringContact(lstContact);
            jsonResponse += '\"Contact_Lead\":' + jstr ;    
            
            
            jsonResponse += '}';
            return jsonResponse;
        }
        
        lstLead = Database.Query(strLeadQuery);
        
       	if( lstLead.size() > 0 )
        {
            
            jsonResponse = '{\"result\":\"Success\",';
            jsonResponse += '\"message\":\"Lead records found.\",';
            
            string jstr = jsonstringLead(lstLead);
            jsonResponse += '\"Contact_Lead\":' + jstr ;
            
            jsonResponse += '}';
            return jsonResponse;
        }
        
        jsonResponse = '{\"result\":\"Failure\",';
        jsonResponse += '\"message\": \"Contact or Lead not found.\"}';
        return jsonResponse;
    }
    
    public static string jsonstringLead( List<Lead> lstLead )
    {
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartArray();
                    
        for(Lead obj : lstLead){
        
            generator.writeStartObject();
            generator.writeStringField('id',obj.Id);
            
            string strName = obj.Firstname + ' ' + obj.LastName;
                               
            generator.writeStringField('Name', ScrubValue(strName) );
            
            if( obj.FirstName != null )
            {
            	generator.writeStringField('first_name',ScrubValue(obj.FirstName));
            }
            else
            {
                generator.writeStringField('first_name', '' );
            }

            if( obj.LastName != null )
            {
            	generator.writeStringField('last_name',ScrubValue(obj.LastName));
            }
            else
            {
                generator.writeStringField('last_name', '' );
            }            
                       
            
            if(obj.Street != null)        
                generator.writeStringField('street',ScrubValue(obj.Street));
            else
                generator.writeStringField('street','');
                
            if(obj.City!= null)        
                generator.writeStringField('city',ScrubValue(obj.City));
            else
                generator.writeStringField('city','');
            
            if(obj.State != null)        
                generator.writeStringField('state',ScrubValue(obj.State));
            else
                generator.writeStringField('state','');
            
            if(obj.PostalCode!= null)        
                generator.writeStringField('postalcode',ScrubValue(obj.PostalCode));
            else
                generator.writeStringField('postalcode','');

            if(obj.Email != null)        
                generator.writeStringField('email',ScrubValue(obj.Email));
            else
                generator.writeStringField('email','');
            
            if(obj.Phone!= null)        
                generator.writeStringField('phone',ScrubValue(obj.Phone));
            else
                generator.writeStringField('phone','');
            
            if(obj.MobilePhone != null)        
                generator.writeStringField('mobilephone',ScrubValue(obj.MobilePhone));
            else
                generator.writeStringField('mobilephone','');
            generator.writeStringField('type','Lead');
            generator.writeEndObject();
        }
        
        generator.writeEndArray();
        return generator.getAsString();
    }
    
    
    public static string jsonstringContact( List<Contact> lstContact){
        
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartArray();
        
        for(Contact obj : lstContact){
        
			generator.writeStartObject();        
            
            generator.writeStringField('id',obj.Id);
            
            
            string strName  ='';
            
            if( obj.FirstName != null )
            {
            	strName = obj.Firstname + ' ' + obj.LastName;
            }
            else
            {
                strName = obj.LastName;
            }
                               
            generator.writeStringField('Name',ScrubValue(strName));
            
            if( obj.FirstName != null )
            {
            	generator.writeStringField('first_name',ScrubValue(obj.FirstName));
            }
            else
            {
                generator.writeStringField('first_name', '' );
            }

            if( obj.LastName != null )
            {
            	generator.writeStringField('last_name',ScrubValue(obj.LastName));
            }
            else
            {
                generator.writeStringField('last_name', '' );
            }            

            if(obj.MailingStreet != null)        
                generator.writeStringField('street',ScrubValue(obj.MailingStreet));
            else
                generator.writeStringField('street','');
                
            if(obj.MailingCity != null)        
                generator.writeStringField('city',ScrubValue(obj.MailingCity));
            else
                generator.writeStringField('city','');
            
            if(obj.MailingState != null)        
                generator.writeStringField('state',ScrubValue(obj.MailingState));
            else
                generator.writeStringField('state','');
            
            if(obj.MailingPostalCode != null)        
                generator.writeStringField('postalcode',ScrubValue(obj.MailingPostalCode));
            else
                generator.writeStringField('postalcode','');

            if(obj.Email != null)        
                generator.writeStringField('email',ScrubValue(obj.Email));
            else
                generator.writeStringField('email','');
            
            if(obj.Phone!= null)        
                generator.writeStringField('phone',ScrubValue(obj.Phone));
            else
                generator.writeStringField('phone','');
            
            if(obj.MobilePhone != null)        
                generator.writeStringField('mobilephone',ScrubValue(obj.MobilePhone));
            else
                generator.writeStringField('mobilephone','');
            
            
            
            generator.writeEndObject();

        }
        
        
        generator.writeEndArray();
        return generator.getAsString();
    }
    
    public static string ScrubValue( string strInput )
    {
        strInput = strInput.replace('[', '');
        strInput = strInput.replace( ']', '');
        strInput = strInput.replace( '"', '');
        strInput = strInput.replace( '\'', '');
        return strInput;
    }    

}