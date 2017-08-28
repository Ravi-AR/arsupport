/***************************************************************************************
 * Generates a Mock HTTP Response for the getCarouselPromotions callout for use in test classes
 *
 * @Author: Magnet 360
 * @Date: Apr 3, 2017
 * @Jira: LPDCR-1987
 */

@isTest( SeeAllData=false )
global class LPDCR_CarouselMockHttpResGenerator
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
        res.setBody( LPDCR_TestUtil.LPDCR_Carousel_Promotions_JSON );
        res.setStatusCode( 200 );
        return res;
    }
}// /END Test Class