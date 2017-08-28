/******************************************************************************
 * Generates a Mock HTTP Response for the getDocuments callout for use in test classes
 *
 * @Author: Heena Tanna
 * @Date: 31.03.2017
 * @Jira: LPDCR-2011
 */
global class LPDCR_DocumentsMockHttpResponseGenerator implements HttpCalloutMock {
    
    /******************************************************************************
 * Create the Mock Response
 */
    global HTTPResponse respond( HTTPRequest req ) 
    {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assert( String.valueOf( req.getEndpoint() ).contains( Label.LPDCR_Kentico_Documents_Table ) );
        System.assertEquals( 'GET', req.getMethod() );
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(LPDCR_TestUtil.LPDCR_BLDocumentsTest_JSON );
        res.setStatusCode( 200 );
        return res;
    }
    
}