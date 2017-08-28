/******************************************************************************
 * Generates a Mock HTTP Response for the getSpecies callout for use in test classes
 *
 * @Author: Magnet 360
 * @Date: Mar 28, 2017
 * @Jira: LPDCR-2230
 */
@isTest( SeeAllData=false )
global class 
LPDCR_SpeciesMockHttpResponseGenerator
    implements HttpCalloutMock 
{

/******************************************************************************
 * Create the Mock Response
 */
    global 
    HTTPResponse 
    respond( HTTPRequest req ) 
    {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assert( String.valueOf( req.getEndpoint() ).contains( Label.LPDCR_Kentico_Species_Table ) );
        System.assertEquals( 'GET', req.getMethod() );
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody( LPDCR_TestUtil.LPDCR_BLSpeciesTest_JSON );
        res.setStatusCode( 200 );
        return res;
    }

}// /END Test Class