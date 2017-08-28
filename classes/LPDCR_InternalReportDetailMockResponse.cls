/******************************************************************************
 * Generates a mock HTTP response for the OBIEE Tons & VIP Points Detail report
 *
 * @Author: Heena Tanna
 * @Date: June 11, 2017
 * @Jira: LPDCR-2029
 */
@isTest( SeeAllData=false )
global class LPDCR_InternalReportDetailMockResponse implements HttpCalloutMock{


 /******************************************************************************
 * Create the mock response
 */
    global 
    HTTPResponse 
    respond( HTTPRequest req ) 
    {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals( 'GET', req.getMethod() );
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody( LPDCR_TestUtil.LPDCR_InternalVipTonesReportTest_JSON);
        res.setStatusCode( 200 );
        return res;
    }
}