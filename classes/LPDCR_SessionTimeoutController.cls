/******************************************************************************
 * Controller for the LPDCR_SessionTimeout VF page. 
 * 
 * @Author: Magnet 360
 * @Date: Apr 25, 2017 
 * @Jira: LPDCR-1696
 */

public with sharing class 
LPDCR_SessionTimeoutController 
{

/******************************************************************************
 * Redirects the user to the Community Logout page when their session is invalid
 */
    public
    PageReference
    redirectToLogoutPage()
    {
        System.debug( 'START: LPDCR_SessionTimeoutController.redirectToLogoutPage()' );
        
        PageReference l_page = new PageReference( Network.getLogoutUrl( Network.getNetworkId() ) );
        l_page.setRedirect( true );
        
        System.debug( 'END: LPDCR_SessionTimeoutController.redirectToLogoutPage()' );
        return l_page;
    }

} // /END Class