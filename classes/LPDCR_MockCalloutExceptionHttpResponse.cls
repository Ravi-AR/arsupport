/******************************************************************************
 * Mock response to test callout exceptions
 *
 * @Author: Magnet 360
 * @Date: Mar 28, 2017
 * @Jira: LPDCR-2230
 */
@isTest( SeeAllData=false )
global class 
LPDCR_MockCalloutExceptionHttpResponse 
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
        
        // Create a callout exception response
        CalloutException l_exception = ( CalloutException ) CalloutException.class.newInstance();
        l_exception.setMessage( 'Callout Exception Instantiated from test class' );
        
        throw new LPDCR_ContentServiceUtil.LPDCR_CalloutException( 'Table Name', 'All', l_exception );
    }
    
}// /END Test Class