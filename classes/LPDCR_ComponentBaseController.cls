/******************************************************************************
 * Base controller for the VF components displayed on the secondary pages that 
 * is meant to be extended. Follows the design pattern outlined here - 
 * https://developer.salesforce.com/page/Controller_Component_Communication -
 * to allow multiple components on the VF page to interact with each other 
 * 
 * @Author: Magnet 360
 * @Date: Mar 28, 2017 
 * @Jira: LPDCR-2230
 */

public with sharing virtual class 
LPDCR_ComponentBaseController 
{

    public String key 
    {
        get;
        set
        {
            if( value != null ){
                key = value;
                if( pageController != null ) {
                    pageController.setComponentControllerMap( key, this );
                }
            }
        }
    }
    
    public String componentName
    {
        get;
        set
        {
            if( value != null ){
                componentName = value;
                if( pageController != null ) {
                    pageController.setComponentControllerMap( componentName, this );
                }
            }
        }
    }

    public LPDCR_SecondaryPageBaseController pageController 
    { 
        get; 
        set
        {
            if( value != null ) {
                pageController = value;
                pageController.setComponentController( this );
            }
        }
    }

} // /END Class