/******************************************************************************
 * Generates a mock HTTP response for the OBIEE Tons & VIP Points Detail report
 *
 * @Author: Heena Tanna
 * @Date: June 11, 2017
 * @Jira: LPDCR-2029
 */
@isTest( SeeAllData=false )
global class LPDCR_DealerReportDetailMockResponse implements HttpCalloutMock{


 /******************************************************************************
 * Create the mock response
 */
    global 
    HTTPResponse 
    respond( HTTPRequest req ) 
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody( LPDCR_TestUtil.LPDCR_DealerVipTonesReportTest_JSON);
        res.setStatusCode( 200 );
        return res;
    }
}