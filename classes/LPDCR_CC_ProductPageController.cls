/******************************************************************************
 * Controller for the LPDCR_CC_ProductPage VF page.
 * @Author: Shruti 
 * @Date: Apr 17, 2017 
 * @Jira: LPDCR-2479
 */

public with sharing class LPDCR_CC_ProductPageController extends LPDCR_SecondaryPageBaseController
{     
    public LPDCR_SecondaryPageFiltersController filterController
    {
        set;
        get{  
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPageFiltersController l_controller;
                l_controller = ( LPDCR_SecondaryPageFiltersController ) getComponentControllerMap().get( 'filtersComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }            
            return new LPDCR_SecondaryPageFiltersController(); 
        }
    }
    
    // Promotion Component Variable
    public LPDCR_SecondaryPageProductsController productController
    {
        set;
        get{            
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPageProductsController l_controller;
                l_controller = ( LPDCR_SecondaryPageProductsController ) getComponentControllerMap().get( 'productComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
            return new LPDCR_SecondaryPageProductsController(); 
        }
    }
    
    // Promotion Component Variable
    /*public LPDCR_CC_Products_Controller feedManualController
    {
        set;
        get{            
            if( getComponentControllerMap() != null ) {
                LPDCR_CC_Products_Controller l_controller;
                l_controller = ( LPDCR_CC_Products_Controller ) getComponentControllerMap().get( 'feedManualComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
            return new LPDCR_CC_Products_Controller(); 
        }
    }*/
    
    // Promotion Component Variable
    public LPDCR_SecondaryPageSalesSheetsController salesSheetsController
    {
        set;
        get{            
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPageSalesSheetsController l_controller;
                l_controller = ( LPDCR_SecondaryPageSalesSheetsController ) getComponentControllerMap().get( 'sellSheetComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
            return new LPDCR_SecondaryPageSalesSheetsController(); 
        }
    }
    
    // Promotion Component Variable
    public LPDCR_SecTechBulletinController techBulletinController
    {
        set;
        get{            
            if( getComponentControllerMap() != null ) {
                LPDCR_SecTechBulletinController l_controller;
                l_controller = ( LPDCR_SecTechBulletinController ) getComponentControllerMap().get( 'techBulletinComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
            return new LPDCR_SecTechBulletinController(); 
        }
    }
    
    // Promotion Component Variable
    public LPDCR_SecondaryPagePromotionsController promotionsController
    {
        set;
        get{            
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondaryPagePromotionsController l_controller;
                l_controller = ( LPDCR_SecondaryPagePromotionsController ) getComponentControllerMap().get( 'promotionsComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
            return new LPDCR_SecondaryPagePromotionsController(); 
        }
    }
    
    // Sales Tools Component Variable
    public LPDCR_SecondarySalesToolController salesToolsController
    {
        set;
        get{            
            if( getComponentControllerMap() != null ) {
                LPDCR_SecondarySalesToolController l_controller;
                l_controller = ( LPDCR_SecondarySalesToolController ) getComponentControllerMap().get( 'salesToolsComponent' );
                if( l_controller != null ) {
                    return l_controller;
                }
            }
            return new LPDCR_SecondarySalesToolController(); 
        }
    }
    
    private Set<String> pageSpecieList;
    private Set<String> pageFileFilterList;
    private Boolean internalUserOnly;
    private String sortFilter;
    public String search_term { get; set; }    
    public String page_title { get; set; }
    public String selected_title { get; set; }
    
/******************************************************************************
 * Constructor
 */
  public LPDCR_CC_ProductPageController()
  {
    System.debug( 'START: LPDCR_CC_ProductPageController.constructor()' );
    
    String l_subtab = ApexPages.currentPage().getParameters().get( 'subtab' );
    if( l_subtab == null )
    {
        page_title = Label.LPDCR_Promotions_Subtab_Name;
    }
    else
    {
        selected_title = l_subtab;
    }
    LPDCR_SecondaryPageFiltersController filterController = new LPDCR_SecondaryPageFiltersController();
    filterController.resetFilters();
    setPageTitle();
        
    System.debug( 'END: LPDCR_CC_ProductPageController.constructor()' );
  }


/******************************************************************************
 * Method to pass the search term into the component to filter the results returned 
 */
    public void doSearch()
    {
        System.debug( 'search_term = ' + search_term );
    }
    
/******************************************************************************
 * Getter method to return the sort_filter from the filterComponent variable
 */
    public String getSortBy()
    {
        sortFilter = filterController.sort_filter;
        System.debug('sortFilter---'+sortFilter);
        return sortFilter;
    } 
    
    // To check salesContent files
    public Boolean getInternalUserCheck(){
        internalUserOnly = filterController.internalOnly;
        return internalUserOnly;
    }

/******************************************************************************
 * Getter method to return the species_filter from the filterComponent variable
 */
    public List<String> getSpecieList()
    {
        pageSpecieList = filterController.species_filter;
        return new List<String>( pageSpecieList );
    }
 /******************************************************************************
 * Getter method to return the file_type_filter from the filterComponent 
 * variable
 */
    public
    List<String>
    getFileTypeFilter()
    {
        pageFileFilterList = filterController.file_type_filter;
        return new List<String>( pageFileFilterList );
    }
/******************************************************************************
 * Setter method to update the page_title when a subtab is selected. The page
 * title is set using a whitelist rather than directly from the URL parameter
 * for security, since the page_title is displayed directly on the page
 */
    public
    void
    setPageTitle()
    {
        System.debug( 'START: LPDCR_CC_ProductPageController.setPageTitle()' );
        System.debug( 'Param: selected_title = ' + selected_title );
        
        //Reset Filters
        /*productController.species_filter = new List<String>();
        //productController.internal_only = False;
        productController.sort_filter = '';
        
        salesSheetsController.species_filter = new List<String>();
        salesSheetsController.internal_only = False;
        salesSheetsController.sort_filter = '';
        
        techBulletinController.species_filter = new List<String>();
        techBulletinController.internal_only = False;
        techBulletinController.sort_filter = '';
        
        promotionsController.species_filter = new List<String>();
        promotionsController.internal_only = False;
        promotionsController.sort_filter = '';
        
        salesToolsController.species_filter = new List<String>();
        salesToolsController.internal_only = False;
        salesToolsController.sort_filter = '';*/
        
        //Set page titles
        if( selected_title == 'ProductDetail' || selected_title == null )
        {
            page_title = Label.LPDCR_Product_Detail_Subtab_Name;
        }
        else if( selected_title == 'FeedManual' )
        {
            page_title = Label.LPDCR_Feed_Manuals_Subtab_Name;
        }
        else if( selected_title == 'SalesSheets' )
        {
            page_title = Label.LPDCR_Sales_Sheets_Subtab_Name;
        }
        else if( selected_title == 'TechBulletins' )
        {
            page_title = Label.LPDCR_Tech_Bulletins_Subtab_Name;
        }
        else if( selected_title == 'Promotions' )
        {
            page_title = Label.LPDCR_Promotions_Subtab_Name;
        }
        else if( selected_title == 'ProductSales' )
        {
            page_title = Label.LPDCR_ProductSalesTools_Subtab_Name;
        }
        else
        {
            page_title = Label.LPDCR_Promotions_Subtab_Name;
        }
        
        System.debug( 'END: LPDCR_CC_ProductPageController.setPageTitle()' );
    }

} // /END Class