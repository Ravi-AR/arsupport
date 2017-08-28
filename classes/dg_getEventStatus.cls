@RestResource(urlMapping='/dg_getEventStatus')
global class dg_getEventStatus{
    @HttpGet
    global static void getEventStatus() 
    {        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        string jsonResponse = '';
       
        jsonResponse =  getEventStatus_Work();
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
            // system.debug('jsonResponse  :'+jsonResponse  );
            return;
            
        }catch ( Exception ex ){
            res.statusCode = 500;
            jsonResponse = '{"status": "Failure", "message": "' + ex + '"}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }

       
    }
    
    public static string getEventStatus_Work()
    {
        // Return string
        string jsonResponse = '';
 		string strEventsQuery = 'select Id, Digigraph_Active__c, IsDeleted from campaign ALL ROWS';    	
       
        List<Campaign> objCampaigns = new List<Campaign>();
        objCampaigns = Database.query(strEventsQuery);
          
        if( objCampaigns.size() == 0 || objCampaigns == null )
        {
            jsonResponse = '{\"result\":\"Failure - Count = ' + string.valueOf(objCampaigns.size()) + '\",';
            jsonResponse += '\"message\":\"No events found. Count = ' + string.valueOf(objCampaigns.size()) + '\"}';
            return jsonResponse;
        }

        jsonResponse = '{\"result\":\"Success\",';
        jsonResponse += '\"message\":\"Events found.\",';

        string jstr = getEvents_JSON(objCampaigns);
        jsonResponse += '\"Data\":' + jstr ;
        jsonResponse += '}';

        return jsonResponse;
        
    } 
    
    public static string getEvents_JSON( List<Campaign> objEvents )
    {
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartArray();
        
        for(Campaign obj : objEvents)
        {
            generator.writeStartObject();
            generator.writeStringField('id', obj.Id);
            generator.writeStringField('active', string.valueOf(obj.Digigraph_Active__c) );
            generator.writeStringField('isDeleted', string.valueOf(obj.IsDeleted) );
            generator.writeEndObject();
        }
        
        generator.writeEndArray();
        
        return generator.getAsString();
    }

}