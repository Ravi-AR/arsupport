@RestResource(urlMapping='/dg_AddUserToEvent')
global class dg_AddUserToEvent{
    @HttpGet
    global static void AddUserToEvent() 
    {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        string jsonResponse = '';
        
        string strLeadID = '';
        strLeadID = req.params.get( 'lead_id' );
        
        string strEventID = '';
        strEventID = req.params.get( 'event_id');
         
        if( strLeadID == '' || strEventID == '' )
        {
            res.statusCode = 400;
            jsonResponse = '{"status": "Failure", "message": "Error - both Lead ID and Event ID are required."}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }
        else{
         
            jsonResponse =  AddUserToEvent_Work( strLeadID, strEventID );
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
    
    public static string AddUserToEvent_Work( string strLeadID, string strEventID )
    {
        // Return string
        string jsonResponse = '';
     	
        // Determine if we are dealing with a lead or a Contact
        // Search contacts first.
        // If no result, search Leads
        
        string strContactQuery = 'select id from Contact where id = \'' + strLeadID + '\'';
        string strLeadQuery = 'select id from Lead where id = \'' + strLeadID + '\'';
        
        List<Contact> objContacts = Database.query(strContactQuery);
        List<Lead> objLeads;
        
        string strType = '';
        
        if( objContacts.size() > 0)
        {
            // We are dealing with a contact.
            strType = 'CONTACT';
        }
        else
        {
        	objLeads = Database.query(strLeadQuery);
            if( objLeads.size() > 0)
            {
                // We are dealing with a lead.
                strType = 'LEAD';
            }
            else
            {
                strType = 'NONE';
            }
        }
        
		if( strType == 'NONE')
        {
            jsonResponse = '{\"result\":\"Failure\",';
            jsonResponse += '\"message\":\"Could not find the lead or contact.\"}';
            return jsonResponse;
        }
        
        // 
        
        string strCampaignQuery = 'select id from Campaign where id = \'' + strEventID + '\'';
        List<Campaign> objCampaigns = Database.query(strCampaignQuery);
            
        if( objCampaigns.size() <= 0 )
        {
            jsonResponse = '{\"result\":\"Failure\",';
            jsonResponse += '\"message\":\"Could not find the event.\"}';
            return jsonResponse;
        }
        
        
        // We have a valid lead/contact and event
        // 
        string strCMQuery = 'SELECT Id FROM CampaignMember WHERE CampaignId=\'' + strEventID + '\' and ( LeadId=\'' + strLeadID + '\' or ContactId = \'' + strLeadID + '\')';
        List<CampaignMember> objCampaignMembers = Database.query( strCMQuery );
        
        if( objCampaignMembers.size() > 0 )
        {
            jsonResponse = '{\"result\":\"Success\",';
            jsonResponse += '\"message\":\"Already associated with the event.\"}';
            return jsonResponse;
        }
        
        // Connect the Person to the Event.
        // 
        CampaignMember objCampaignMember;
        
        if( strType == 'CONTACT' )
        {
        	objCampaignMember = new CampaignMember( CampaignId = strEventID, ContactId = strLeadId );
        }
        else // strType == 'LEAD'
        {
            objCampaignMember = new CampaignMember( CampaignId = strEventID, LeadId = strLeadId );
        }
        
        insert objCampaignMember;
        
        jsonResponse = '{\"result\":\"Success\",';
        jsonResponse += '\"message\":\"' + strLeadID + ' has been associated with event ' + strEventID + '\"}';
        return jsonResponse;
     
    }    

}