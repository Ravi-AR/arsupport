/******************************************************************************
 * Generates a Mock HTTP Response that will cause an error when the JSON 
 * body is parsed
 *
 * @Author: Magnet 360
 * @Date: Mar 28, 2017
 * @Jira: LPDCR-2230
 */
@isTest( SeeAllData=false )
global class 
LPDCR_MockParsingExceptionHttpResponse 
    implements HttpCalloutMock
{

/******************************************************************************
 * Create the Mock Response
 */
    global 
    HTTPResponse 
    respond( HTTPRequest req ) 
    {
        System.assertEquals( 'GET', req.getMethod() );
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody( '{ Body to generate an error when parsing }' );
        res.setStatusCode( 200 );
        return res;
    }
    
}// /END Test Class