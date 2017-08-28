/******************************************************************************
 * Generates a mock HTTP response for the kentico promotions search test classes
 *
 *
 * @Author: Magnet 360
 * @Date: Jun 1, 2017
 * @Jira: LPDCR-1992
 */
@isTest( SeeAllData=false )
global class 
LPDCR_PromotionSearchMockHTTResponse
    implements HttpCalloutMock  
{

/******************************************************************************
 * Create the mock response
 */
    global 
    HTTPResponse 
    respond( HTTPRequest req ) 
    {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals( 'GET', req.getMethod() );
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        res.setBody( LPDCR_TestUtil.LPDCR_Promotion_Search_Response_XML );
        res.setStatusCode( 200 );
        return res;
    }
    
}// /END Test Class