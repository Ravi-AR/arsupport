@RestResource(urlMapping='/leadcreation')
global class LeadCreation {
    @HttpPost
    global static void CreateLeadRecord() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        string jsonResponse = '';
        
        string strfirstname = '';
        string strlastname = '';
        string strstreet = '';
        string strcity = '';
        string strstate = '';
        string strpostalcode = '';
        string stremail = '';
        string strphone = '';
        string strmobilephone = '';
        string strcompany = '';
        
        strfirstname = req.params.get('firstname'); 
        strlastname = req.params.get('lastname'); 
        strstreet = req.params.get('street'); 
        strcity = req.params.get('city'); 
        strstate = req.params.get('state'); 
        strpostalcode = req.params.get('postalcode'); 
        stremail = req.params.get('email'); 
        strphone = req.params.get('phone'); 
        strmobilephone = req.params.get('mobilephone');  
        strcompany = req.params.get('company');  
        
        if(strfirstname == null || strfirstname == '') {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : firstname"}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }else if(strlastname == null || strlastname == '') {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : lastname"}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }else if(stremail == null || stremail == '') {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : email "}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }else if(strphone == null || strphone == '') {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : phone"}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }else if(strcompany == null || strcompany == '') {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Missing Required Parameter : company"}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }else{
         
            jsonResponse =  jsonstringCreateLead(stremail,strphone,strfirstname,strlastname,strstreet,strcity,strstate,strpostalcode,strmobilephone,strcompany);
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
  
    public static string jsonstringCreateLead(string strEmailId, string strPhone,string strFirstname,string strLastname,string strStreet,string strCity,string strState,string strPostalcode,string strMobilephone,string strCompany){
        
        string strMsg = '';
        string jsonResponse = '';

        Lead obj = new Lead();
        List<RecordType> lstRT = new List<RecordType>([SELECT DeveloperName, Id, SobjectType FROM RecordType 
            where SobjectType = 'Lead' and  DeveloperName= 'Producer_Consumer_Lead' limit 1]);
        
        if(lstRT != null && lstRT.size() > 0)
            obj.recordtypeId = lstRT[0].id;    
            
        if(strFirstname != null)
            obj.FirstName = strFirstname;
        else
            strFirstname = '';
            
        if(strLastname != null)
            obj.LastName = strLastname;
        else
            strLastname = '';
            
        if(strStreet != null)
            obj.Street = strStreet;
        else
            strStreet = '';
            
        if(strCity != null)
            obj.City = strCity;
        else
            strCity = '';
            
        if(strState != null)
            obj.State = strState;
        else
            strState = '';
            
        if(strPostalcode != null)
            obj.PostalCode = strPostalcode;
        else
            strPostalcode = '';
            
        if(strMobilephone != null)
            obj.MobilePhone = strMobilephone;
        else
            strMobilephone = '';
            
        if(strEmailId!= null)
            obj.email = strEmailId;
        else
            strEmailId= '';
            
        if(strPhone != null)
            obj.Phone = strPhone;  
        else
            strPhone = '';
        obj.LeadSource = 'Digigraph';
        obj.Company = strCompany;
        insert obj;  
        
        /*strMsg += '\"id\":'+'\"'+obj.id+'\",';
        strMsg += '\"firstname\":'+'\"'+ strFirstname +'\",';
        strMsg += '\"lastname\":'+'\"'+strLastname +'\",';
        strMsg += '\"email\":'+'\"'+strEmailId+'\",';
        strMsg += '\"phone\":'+'\"'+strPhone +'\",';
        strMsg += '\"company\":'+'\"'+obj.id+'\",';
        strMsg += '\"street\":'+'\"'+strStreet  +'\",';
        strMsg += '\"city\":'+'\"'+strCity +'\",';
        strMsg += '\"state\":'+'\"'+strState +'\",';
        strMsg += '\"postalcode\":'+'\"'+strPostalcode +'\",';
        strMsg += '\"mobilephone\":'+'\"'+strMobilephone +'\"';*/
        List<Lead> lstLead = new List<Lead>([select id,FirstName,LastName,Email,Phone,Street,
                        City,State,PostalCode,MobilePhone,Company From Lead Where Id =: obj.id]);
        if(lstLead.size() > 0) {
            strMsg += '\"id\":'+'\"'+lstLead[0].id+'\",';
            strMsg += '\"firstname\":'+'\"'+ lstLead[0].FirstName+'\",';
            strMsg += '\"lastname\":'+'\"'+lstLead[0].LastName+'\",';
            strMsg += '\"email\":'+'\"'+lstLead[0].Email+'\",';
            strMsg += '\"phone\":'+'\"'+lstLead[0].Phone+'\",';
            strMsg += '\"company\":'+'\"'+lstLead[0].Company+'\",';
            if(lstLead[0].Street != null && lstLead[0].Street != '')
                strMsg += '\"street\":'+'\"'+lstLead[0].Street+'\",';
            else
                strMsg += '\"street\":'+'\"'+strStreet+'\",'; 
            if(lstLead[0].City != null && lstLead[0].City != '')
                strMsg += '\"city\":'+'\"'+lstLead[0].City+'\",';
            else
                strMsg += '\"city\":'+'\"'+strCity+'\",'; 
            if(lstLead[0].State != null && lstLead[0].State != '')
                strMsg += '\"state\":'+'\"'+lstLead[0].State+'\",';
            else
                strMsg += '\"state\":'+'\"'+strState+'\",';
            if(lstLead[0].PostalCode != null && lstLead[0].PostalCode != '')
                strMsg += '\"postalcode\":'+'\"'+lstLead[0].PostalCode+'\",';
            else
                strMsg += '\"postalcode\":'+'\"'+strPostalcode+'\",'; 
            if(lstLead[0].MobilePhone != null && lstLead[0].MobilePhone != '')
                strMsg += '\"mobilephone\":'+'\"'+lstLead[0].MobilePhone+'\"';
            else
                strMsg += '\"mobilephone\":'+'\"'+strMobilephone+'\"';
        }
        jsonResponse = '{\"result\":\"Success\",';
        jsonResponse += '\"message\":\"Lead is created\",';
        jsonResponse += '\"Lead\":[{' + strMsg + '}]}';

        return jsonResponse ;  
    }
    
}