@RestResource(urlMapping='/dg_SyncSearchData')
global class dg_SyncSearchData
{
    @HttpGet
    global static void FindLeadContactRecord() 
    {
        // This function returns the email and phone number of all Contacts
        // in batches of 1000;
                 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        string jsonResponse = '';
        
        // Specifies the next record to collect.
        string strLeadID = '';
        strLeadID = req.params.get( 'next_lead_id' );
        
 /*
        if( strLeadID == null )
        {
            strLeadID = '';
        }
*/
        
        // Specifies if we are looking for leads or contacts;
        string strRecordType = '';
        strRecordType = req.params.get( 'record_type' );
        
        // Determines what kind of records we are searching for.
        // ALL = any record (other than deleted)
        // UPDATE = any record that has been modified since the supplied time.
        // DELETE = any record that has been marked deleted since the supplied time.
        // 
        string strActionType = '';
        strActionType = req.params.get( 'action_type');
        
        string strSince = '';
        strSince = req.params.get('since');

        if( strRecordType == null )
       {
            strRecordType = '';
        }
        
        if( strActionType == null )
        {
            strActionType = '';
        }
        
        if( strSince == null )
        {
            strSince = '';       
        }

        
		if( strRecordType == '' || strRecordType == '' || strActionType == '')        
        {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : Record Type { contact or lead } "}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }
        else if( strRecordType != 'contact' && strRecordType != 'lead' )
        {
            // Could check other conditions here - but it will get
            // ugly very quickly.  Because specific jobs are going
            // to be calling the pages, it is reasonable not
            // to be as particular about the enforcement.
            
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Invalid Required Parameter : Record Type { contact or lead } = ' + strRecordType + '" }';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }
        else
        {
         
            // Valid parameters provided.  Continue.
            
            jsonResponse = GetLeadContactDetails( strLeadID, strRecordType, strActionType, strSince  );
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

    public static string GetLeadContactDetails( string strLeadID, string strRecordType, string strActionType, string strSince )
    {
             
        string jsonResponse = '';
        
        string strLeadQuery = '';
        string strContactQuery = '';
        
        string strCriteria = '';
        
      	// Establish the critera
      	
        if( strActionType == 'all' )
        {
            if( strLeadID == '' )
            {
                if( strRecordType == 'contact')
                {
                    strCriteria = ' where ( email <> \'\' or phone <> \'\' or MobilePhone <> \'\' ) order by id limit 1000';    
                }
                else
                {
                    strCriteria = ' where ( email <> \'\' or phone <> \'\' or MobilePhone <> \'\' ) and isconverted = false order by id limit 5000';
                }
                
            }
            else
            {
                if( strRecordType == 'contact')
                {
                    strCriteria = 'where id > \'' + strLeadID + '\' and ( email <> \'\' or phone <> \'\' or MobilePhone <> \'\' ) order by id limit 1000';    
                }
                else
                {
                    strCriteria = 'where id > \'' + strLeadID + '\' and ( email <> \'\' or phone <> \'\' or MobilePhone <> \'\' ) and isconverted = false order by id limit 5000';
                }
            }
        }
        else if( strActionType == 'update')
        {
        	// We need records updated after a certain date.
        	// We don't need a lead_id.  We need a "since" date
            if( strLeadID == '' )
            {
                if( strRecordType == 'contact')
                {                	
                    strCriteria = ' where LastModifiedDate >=' + strSince + ' order by id limit 1000';   
                    
                }
                else
                {
                    strCriteria = ' where isconverted=false and LastModifiedDate >=' + strSince + ' order by id limit 1000'; 
                }    
            }
            else
            {
                if( strRecordType == 'contact')
                {
                    strCriteria = 'where id > \'' + strLeadID + '\' and LastModifiedDate >=' + strSince + ' order by id limit 1000'; 
                }
                else
                {
                    strCriteria = 'where id > \'' + strLeadID + '\' and isconverted=false and LastModifiedDate >=' + strSince + ' order by id limit 1000';
                }
            }
        }
        else if( strActionType == 'delete' )
        {
            // We are dealing with deletes.
            if( strLeadID == '' )
            {
                if( strRecordType == 'contact')
                {
                	strCriteria = ' where LastModifiedDate >=' + strSince + ' and IsDeleted=true order by id limit 1000 ALL ROWS'; 
                }
                else
                {
                    strCriteria = ' where isconverted=false and LastModifiedDate >=' + strSince + ' and IsDeleted=true order by id limit 1000 ALL ROWS'; 
                }    
            }
            else
            {
                if( strRecordType == 'contact')
                {
                    strCriteria = 'where id > \'' + strLeadID + '\' and LastModifiedDate >=' + strSince + ' and IsDeleted=true order by id limit 1000 ALL ROWS'; 
                }
                else
                {
                    strCriteria = 'where id > \'' + strLeadID + '\' and isconverted=false and LastModifiedDate >=' + strSince + ' and IsDeleted=true order by id limit 1000 ALL ROWS'; 
                }
            }
        }
        else
        {
            // Need code to stop this function.
            return '';
        }
            
        
               
        // Select the appropriate query by type.      
        string strSFQuery = '';

        if( strRecordType == 'contact')
        {
            // Contact Query
			strSFQuery = 'select id,FirstName,LastName,MailingStreet,MailingCity,MailingState,MailingPostalCode,Email,Phone,MobilePhone from Contact ' + strCriteria;
			
            
            List<Contact> lstContact = new List<Contact>();
            lstContact = Database.Query(strSFQuery);
            
            if( lstContact == null && lstContact.size() <= 0)
            {
                jsonResponse = '{\"result\":\"Failure\",';
                jsonResponse += '\"message\": \"No results found.\"}';
            }
            else
            {
                jsonResponse = '{\"result\":\"Success\",';
                jsonResponse += '\"message\":\"Records found. Contact requested.\",';
                
                string jstr = getContacts_JSON(lstContact);
                jsonResponse += '\"Data\":' + jstr ;
                
                jsonResponse += '}';
            }            
        }
        else
        {
            // Lead Query
        	strSFQuery = 'select id,FirstName, LastName, Street, City, State, PostalCode, Email, Phone, MobilePhone from Lead ' + strCriteria;
        	// strSFQuery = 'select id,FirstName, LastName, Street, City, State, PostalCode, Email, Phone, MobilePhone from Lead where IsDeleted = true ALL ROWS';
            List<Lead> lstLead = new List<Lead>();
            lstLead = Database.Query(strSFQuery);
            
            if( lstLead == null && lstLead.size() <= 0)
            {
                jsonResponse = '{\"result\":\"Failure\",';
                jsonResponse += '\"message\": \"Contact or Lead not found.\"}';
            }
            else
            {
                jsonResponse = '{\"result\":\"Success\",';
                jsonResponse += '\"message\":\"Records found.  Lead requested.\",';
                
                string jstr = getLeads_JSON(lstLead);
                jsonResponse += '\"Data\":' + jstr ;
    
                jsonResponse += '}';
            }            
        }
        
        return jsonResponse;               

        // strLeadQuery += 'select id,FirstName, LastName, Street, City, State, PostalCode, Email, Phone, MobilePhone from Lead where ' + strCriteria;
        // strContactQuery += 'select id,FirstName,LastName,MailingStreet,MailingCity,MailingState,MailingPostalCode,Email,Phone,MobilePhone from Contact Where ' + strCriteria;              

    }
    
    public static string getContacts_JSON( List<Contact> lstContact )
    {
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartArray();
        
        for(Contact obj : lstContact)
        {
            generator.writeStartObject();
            generator.writeStringField('id',obj.Id);
            string strfnm  ='';
            if(obj.Firstname != null)
            {
                strfnm = obj.Firstname ;
            }
            
            string strName = strfnm + ' ' + obj.Lastname;

            generator.writeStringField('Name', ScrubValue(strName));

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
                generator.writeStringField('mobilephone', ScrubValue(obj.MobilePhone));
            else
                generator.writeStringField('mobilephone','');
            generator.writeStringField('type','Contact');
            generator.writeEndObject();
        }
        
        generator.writeEndArray();
        return generator.getAsString();
    }

    public static string getLeads_JSON( List<Lead> lstLead )
    {
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartArray();
                    
        for(Lead obj : lstLead){
        
            generator.writeStartObject();
            generator.writeStringField('id',obj.Id);
                        
            string strName = obj.Firstname + ' ' + obj.Lastname;

            generator.writeStringField('Name', ScrubValue(strName));            
            
            if(obj.Street != null)
                generator.writeStringField('street', ScrubValue(obj.Street));
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
                generator.writeStringField('postalcode', ScrubValue(obj.PostalCode));
            else
                generator.writeStringField('postalcode','');

            if(obj.Email != null)        
                generator.writeStringField('email', ScrubValue(obj.Email));
            else
                generator.writeStringField('email','');
            
            if(obj.Phone!= null)
            {
                generator.writeStringField('phone', ScrubValue( obj.Phone ) );
            }
            else
                generator.writeStringField('phone','');
            
            if(obj.MobilePhone != null)
            {
                generator.writeStringField('mobilephone', ScrubValue(obj.MobilePhone) );
            }
            else
                generator.writeStringField('mobilephone','');
            generator.writeStringField('type','Lead');
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