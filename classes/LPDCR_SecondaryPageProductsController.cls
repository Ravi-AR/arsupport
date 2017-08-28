/******************************************************************************
 * Controller for the LPDCR_SecondaryPageProductsBody component
 * @Author: Shruti
 * @Date: Apr 18, 2017 
 * @Jira: LPDCR-2792
 * @Update: 06/20/2017 : Changed to use a standard set controller to resolve SOQL Limit Exceptions
 */

public without sharing class 
LPDCR_SecondaryPageProductsController 
    extends LPDCR_ComponentBaseController 
{
    public String search_term
    {
        get;
        set
        {
                                                 // In case someone performs a
                                                 // search after navigating beyond
                                                 // the first page of the results,
                                                 // reset the results page to 1
            if( value != search_term )
            {
                this.current_page_number = 1;
            }
            search_term = value;
        }
    }
    
    public List<ccrz__E_Product__c> current_product_list { get; set; }
    
    public Integer total_products { get; set; }
    
    public Integer start_product_number { get; set; }
    public Integer end_product_number { get; set; }
    
    
    public List<String> static_species_filter { get; set; }
    public List<String> species_filter { get; set; }
    
    public String static_sort_filter { get; set; }
    public String sort_filter 
    {
        get
        {
            if( sort_filter == null || sort_filter =='' )
            {
                    sort_filter = 'Date DESC';
            }
            return sort_filter;
        } 
        set;
    }

    public Integer current_page_number 
    {
        get
        {
            if( current_page_number == null || current_page_number < 1 )
            {
                current_page_number = 1;
            }
            return current_page_number;
        } 
        set; 
    }
    public Integer products_per_page
    {
        get
        {
            if( products_per_page == null )
            {
                products_per_page = 25;
            }
            else if( products_per_page > 100 )
            {
                products_per_page = 100;
            }
            return products_per_page;
        } 
        set; 
    }
    
    private transient String product_query { get; set; }
    // private transient ApexPages.StandardSetController set_con { get; set; }
    
    private List<String> prodBrandlst
    {
        get
        {
            if( prodBrandlst == null )
            {
                prodBrandlst = new List<String>();
                
                for( Product_Brand__c l_prod_brand : [ SELECT Name, 
                                                              Company_Brand_Category__c,
                                                              Company_Brand_Description__c,
                                                              Show_or_Hide__c 
                                                       FROM Product_Brand__c 
                                                       WHERE Show_or_Hide__c = true ] )
                {
                    prodBrandlst.add( l_prod_brand.Company_Brand_Category__c ); 
                }// /END for( Product_Brand__c )
            }// /END if( prodBrandlst == null )
            System.debug( 'prodBrandlst = ' + prodBrandlst );
            return prodBrandlst;
        } 
        set; 
    }
    
/******************************************************************************
 * Constructor
 */
    public LPDCR_SecondaryPageProductsController()
    {
        System.debug( 'START: LPDCR_SecondaryPageProductsController.constructor()' );
        
        this.start_product_number = 0;
        this.end_product_number = 0;
        this.current_page_number = 1;
        this.products_per_page = 25;
        this.total_products = 0;
        this.current_product_list = new List<ccrz__E_Product__c>();
        
        //static_species_filter = new List<String>();
        static_species_filter = species_filter;
        static_sort_filter = sort_filter;
        
        System.debug( 'END: LPDCR_SecondaryPageProductsController.constructor()' );
    }

/******************************************************************************
 * Public method called from a VF action function when the page is loaded to
 * fetch all of the products and set the current_product_list variable that
 * is used to hold the current products records to be displayed
 */
    public
    void
    getProducts()
    {
        System.debug( 'START: LPDCR_SecondaryPageProductsController.getProducts()' );
        
        this.current_product_list = reQuery();
        
        this.total_products = getProductRecordCount();
        
        this.start_product_number = current_page_number * products_per_page - products_per_page + 1; 
        this.end_product_number = current_page_number * products_per_page;
        
        if( this.total_products < this.start_product_number )
        {
            this.start_product_number = this.total_products;
        }
        
        if( this.end_product_number > this.total_products )
        {
            this.end_product_number = this.total_products;
        }
        
                                                 // In case someone performs a
                                                 // search after navigating beyond
                                                 // the first page of the results,
                                                 // reset the 
        /*
        if( this.current_page_number > 1
            && this.total_products == this.end_product_number
            && this.start_product_number < products_per_page )
        {
            this.current_page_number = 1;
        }
        */
        
        System.debug( 'END: LPDCR_SecondaryPageProductsController.getProducts()' );
        
    }

/******************************************************************************
 * Private method to rerun the query to get the latest set of results, either
 * because the user has changed the page, the page size, the sort order, or modified
 * the selected species filters
 */
    private
    List<ccrz__E_Product__c>
    reQuery()
    {
        System.debug( 'START: LPDCR_SecondaryPageProductsController.reQuery()' );
        
        List<ccrz__E_Product__c> l_products_list;
        
        String l_query = buildQueryString();
        System.debug('search term value='+ search_term);
        System.debug('requery l_query '+ l_query );
        l_products_list = Database.query( l_query );
        
        /*
        set_con = new ApexPages.StandardSetController( Database.query( l_query ) );
        set_con.setPageSize( products_per_page );
        
        this.total_products = set_con.getResultSize();
          
        l_products_list = ( List<ccrz__E_Product__c> ) set_con.getRecords(); 
        */
        
        System.debug( 'Return: l_products_list = ' + l_products_list );
        System.debug( 'END: LPDCR_SecondaryPageProductsController.reQuery()' );
        
        return l_products_list;
        
    }
    
/******************************************************************************
 * Private method to get the total number of product records that match the
 * filter criteria
 */
    private
    Integer
    getProductRecordCount()
    {
        System.debug( 'START: LPDCR_SecondaryPageProductsController.getProductRecordCount()' );
        System.debug( 'Param: species_filter = ' + species_filter );
        
        Integer l_product_count;
        
        String l_query = 'SELECT COUNT(Id) '
                       + 'FROM ccrz__E_Product__c '
                       + 'WHERE ccrz__Storefront__c = \'PurinaMills\' '
                       + '  AND Custom_Product__c = false '
                       + '  AND cc_oo_CompanyBrandCat__c IN :prodBrandlst ';
         if(search_term != null && search_term != ''){
        
            l_query += 'AND NAME LIKE \'%' +search_term +'%\''  ;  
            
            
        }               
        
        if( species_filter != null && species_filter.size() > 0 )
        {
                                                 // Build the OR string to filter
                                                 // by ccrz__SpecValue__c species
            l_query += buildSpecieFilterString();
        }
        
        List<AggregateResult> l_result = Database.query( l_query );
        
        l_product_count = Integer.valueOf( l_result[ 0 ].get( 'expr0' ) );
        
        if( l_product_count > 2000 )
        {
            l_product_count = 2000; // Salesforce Limit when dealing with Offsets
        }

        System.debug( 'Return: l_product_count = ' + l_product_count );
        System.debug( 'END: LPDCR_SecondaryPageProductsController.getProductRecordCount()' );
        
        return l_product_count;
        
    }
        
/******************************************************************************
 * Private method to create the query string to retrieve the list of products
 */
    
    private
    String
    buildQueryString()
    {
        System.debug( 'START: LPDCR_SecondaryPageProductsController.buildQueryString()' );
        System.debug ('search_term===' + search_term);
        System.debug( 'species_filter = '  + species_filter );
        System.debug( 'sort_filter = '  + sort_filter );

                                                 // Build the query to get the list
                                                 // of products and their Specs related
                                                 // lists
        String l_product_query = 'SELECT Id, '
                               + 'ccrz__ShortDesc__c,  '
                               + 'ccrz__ProductId__c,  '
                               + 'ccrz__StartDate__c,  '
                               + 'cc_oo_CompanyBrandCat__c,  '
                               + 'ccrz__LongDesc__c,  '
                               + 'Name, '
                               + '( SELECT Id, '
                                    + 'ccrz__SpecValue__c, '
                                    + 'ccrz__Spec__r.ccrz__DisplayName__c '
                                  + 'FROM ccrz__Product_Specs__r '
                                  + 'ORDER BY ccrz__Spec__r.ccrz__DisplayName__c ), '
                               + '( SELECT Id, '
                                    + ' ccrz__MediaType__c, '
                                    + ' ccrz__URI__c, ' 
                                    + ' ccrz__AltMessage__c '
                                  + ' FROM ccrz__E_ProductMedias__r '
                                  + ' WHERE ccrz__StartDate__c <= TODAY '
                                    + ' AND ccrz__EndDate__c >= TODAY '
                                    + ' AND ccrz__Enabled__c = true '
                                    + ' AND ccrz__MediaType__c = \'Product Image\' '
                                  + ' ORDER BY LastModifiedDate DESC '
                                  + ' LIMIT 1 ) '
                               + 'FROM ccrz__E_Product__c '
                               + 'WHERE ccrz__Storefront__c = \'PurinaMills\' '
                               + '  AND Custom_Product__c = false '
                               + '  AND cc_oo_CompanyBrandCat__c IN :prodBrandlst ';
        if( species_filter != null && species_filter.size() > 0 )
        {
                                                 // Build the OR string to filter
                                                 // by ccrz__SpecValue__c species                                               
            l_product_query += buildSpecieFilterString();
        }
        if(search_term != null && search_term != ''){
        
            l_product_query += 'AND NAME LIKE \'%' +search_term +'%\''  ;  
            
            System.debug('search l_product_query '+ l_product_query );
        }
        
        if( sort_filter.equals( 'Date DESC' ))
        {
            l_product_query += ' ORDER BY LastModifiedDate DESC';
        }
        else if(sort_filter.equals( 'Date ASC' ))
        {
            l_product_query += ' ORDER BY LastModifiedDate ASC';
        }
        else if(sort_filter.equals( 'Name DESC' ))
        {
            l_product_query += ' ORDER BY Name DESC';
        }
        else
        {
            l_product_query += ' ORDER BY Name ASC';
        }
        System.debug('current_page_number ='+ current_page_number );        
        Integer l_offset = this.products_per_page * ( this.current_page_number - 1 );
        if( l_offset > 2000 )
        {
            l_offset = 2000; // SALESFORCE LIMIT
        }
        
        // If the sort by or species filter
                                                 // has changed, reset the page
                                                 // and start number to 1
         //THIS CODE TO RESET THE CURRENT PAGE TO 1                                                 
        System.debug( 'species_filter = ' + species_filter );
        System.debug( 'static_species_filter = ' + static_species_filter );
        System.debug( 'sort_filter = ' + sort_filter );
        System.debug( 'static_sort_filter = ' + static_sort_filter );
        if((species_filter !=null && species_filter.size()>0 && species_filter != static_species_filter) || (sort_filter !=null && sort_filter != static_sort_filter ) )
        {
            System.debug( 'Reset static_species_filter' );
            static_species_filter = species_filter;
            static_sort_filter = sort_filter;
            l_offset = 0;
            current_page_number = 1;
        }
        
        l_product_query += ' LIMIT ' 
                        + String.valueOf( products_per_page ) 
                        + ' OFFSET '
                        + String.valueOf( l_offset ); 
        
        System.debug( 'l_product_query = ' + l_product_query );
        System.debug ('l_offset =' + l_offset );
        System.debug( 'Return: l_product_query = '+ l_product_query);
        System.debug( 'END: LPDCR_SecondaryPageProductsController.buildQueryString()' );
            
        return l_product_query;
    }

/******************************************************************************
 * Private method to build the string to filter the products by Species
 */
    private
    String
    buildSpecieFilterString()
    {
        System.debug( 'START: LPDCR_SecondaryPageProductsController.buildSpecieFilterString()' );
        System.debug( 'Param: species_filter = '  + species_filter );
        
        String l_complete_string = ''; 
        String l_filter_string = ''; 
        
        Map<String,LPDCR_Species_Translation__c> l_translations_map = LPDCR_Species_Translation__c.getAll();
        List<String> l_species;
        
        if( species_filter != null && species_filter.size() > 0 )
        {
                                                 // Build the OR string to filter
                                                 // by ccrz__SpecValue__c species
            for( String l_specie : species_filter )
            {
                l_species = new List<String>();
                l_species.add( l_specie );
                                                 // If the specie has translated terms,
                                                 // create the list of terms to use 
                                                 // in place of the Kentico Specie name
                System.debug( 'l_specie = ' + l_specie );
                System.debug( 'l_translations_map.get( l_specie ) = ' + l_translations_map.get( l_specie ) );
                if( l_translations_map.get( l_specie ) != null )
                {
                    l_species.addAll( l_translations_map.get( l_specie ).Product_Specie_Terms__c.split( ',' ) );
                }
                                                 // Loop over the terms/species names
                                                 // to build the OR structure of the query
                for( String l_term : l_species )
                {
                    if( l_filter_string == '' )
	                {
	                    l_filter_string += '( ccrz__SpecValue__c LIKE \'%' + l_term.trim() + '%\' ';
	                }
	                else
	                {
	                    l_filter_string += ' OR ccrz__SpecValue__c LIKE \'%' + l_term.trim() + '%\' ';
	                }
                }// /END for( l_species )
            }
            l_filter_string += ' )';
           
            l_complete_string = 'AND Id IN ( SELECT ccrz__Product__c '
                                          +  'FROM ccrz__E_ProductSpec__c ' 
                                          +  'WHERE ccrz__Spec__r.ccrz__DisplayName__c = \'Species\' '
                                            +  'AND '
                                            + l_filter_string
                                            + ' ) ';
           
        }// /END for( species_filter )
        
        System.debug( 'Return: l_complete_string = ' + l_complete_string );
        System.debug( 'END: LPDCR_SecondaryPageProductsController.buildSpecieFilterString()' );
        
        return l_complete_string;
    }

    //Pagination code
    public 
    Boolean 
    hasNext 
    {
        get 
        {
            if( this.end_product_number >= this.total_products )
            {
                return false;
            }
            else
            {
                return true;    
            }
        }
        set;
    }
    
    public 
    Boolean 
    hasPrevious 
    {
        get 
        {
            if( this.current_page_number > 1 )
            {
                return true;
            }
            else
            {
                return false;    
            }
        }
        set;
    }
  
    public 
    void 
    first() 
    {
        this.current_page_number = 1;
        getProducts(); 
    }
  
    public 
    void 
    last() 
    {
        this.current_page_number = Integer.valueOf( Math.floor( Decimal.valueOf( this.total_products / this.products_per_page ) ) );
        getProducts(); 
    }
  
    public 
    void 
    previous() 
    {
        this.current_page_number--;
        getProducts(); 
    }
  
    public 
    void 
    next() 
    {
        this.current_page_number++;
        getProducts();
    }

    public 
    Integer 
    pageNumber 
    {
        get
        {
            return this.current_page_number;
        }
        set;
    }
    
   public void searchReset()
   {
       this.current_page_number = 1;
       if(search_term !=null  || search_term != '')
       {
           System.debug( 'Reset static_search_term' );
	       System.debug('search_term---'+ search_term);
	       search_term='';
	       getProducts();
        }
   }
} // /END Class/