/***************************************************************************************
 * Generates a Mock HTTP Response for the getPromotions callout for use in test classes
 * @Author: Shruti Mishra
 * @Date: Mar 30, 2017
 */

@isTest( SeeAllData=false )
global class LPDCR_PromotionsMockHttpResGenerator
implements HttpCalloutMock 
{

/******************************************************************************
 * Create the Mock Response
 */
    global HTTPResponse respond( HTTPRequest req ) 
    {
        System.assert( String.valueOf( req.getEndpoint() ).contains( Label.LPDCR_Kentico_Promotions_Table ) );
        System.assertEquals( 'GET', req.getMethod() );
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody( LPDCR_TestUtil.LPDCR_BLPromotionsTest_JSON );
        res.setStatusCode( 200 );
        return res;
    }
}