/******************************************************************************
 * Controller for the LPDCR_CC_Products.component
 * 
 * @Author: Ron Soppeland
 * @Date: Mar 30, 2017 
 * @Jira: LPDCR-2339
 */

public with sharing class LPDCR_CC_Products_Controller {
    private LOLMyLinksCallouts my_links_callout { get; set; }
    public String currentFedId {get; set;}
    public Boolean areProdManAvailable { get; set;}
    public LOLMyLinksCallouts.MyLinkData productManualData {get; set;}
    
    /*
     * Constructor
     */
    public LPDCR_CC_Products_Controller() {
        my_links_callout = new LOLMyLinksCallouts();
        currentFedId = my_links_callout.getFedId();
        productManualData = my_links_callout.GetSpecificMyLink(LOLMyLinksCallouts.PRODUCT_MANULAS, currentFedId);
        System.debug(productManualData+',,'+productManualData.myAppUrl);
        areProdManAvailable = true;
        if (productManualData == null || productManualData.myAppUrl == null || productManualData.myAppUrl.Length() == 0) {
            areProdManAvailable = false;
        }
    }
}