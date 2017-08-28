/* 
----------------------------------------------------------------------------------------------------------------------
Author                                      Date                                           Description
----------------------------------------------------------------------------------------------------------------------
Rajesh W                                10/25/2016                                   US:OO-325 Show Lead tim on Product detils 
Piyali Mukherjee                        01/03/2017                                   US:OO-517 - JDE API Integration
Saloni Kale                             02/09/2017                                   US:OO-2036 - Contact Us CSR 
 */
 
public class cc_oo_HelperController{ 
    
    public static final string CLASS_NAME = 'cc_oo_HelperController';
    
    public static final Map<String, String> countryMap = new Map<String, String>{
        'Afghanistan'                                           =>'AF',         
        'Albania'                                               =>'AL',     
        'Algeria'                                               =>'DZ',     
        'American Samoa'                                        =>'AS',             
        'Andorra'                                               =>'AD',     
        'Angola'                                                =>'AO',     
        'Anguilla'                                              =>'AI',     
        'Antarctica'                                            =>'AQ',         
        'Antigua and Barbuda'                                   =>'AG',                 
        'Argentina'                                             =>'AR',     
        'Armenia'                                               =>'AM',     
        'Aruba'                                                 =>'AW', 
        'Australia'                                             =>'AU',     
        'Austria'                                               =>'AT',     
        'Azerbaijan'                                            =>'AZ',         
        'Bahamas'                                               =>'BS',     
        'Bahrain'                                               =>'BH',     
        'Bangladesh'                                            =>'BD',         
        'Barbados'                                              =>'BB',     
        'Belarus'                                               =>'BY',     
        'Belgium'                                               =>'BE',     
        'Belize'                                                =>'BZ',     
        'Benin'                                                 =>'BJ', 
        'Bermuda'                                               =>'BM',     
        'Bhutan'                                                =>'BT',     
        'Bolivia'                                               =>'BO',     
        'Bonaire'                                               =>'BQ',     
        'Bosnia and Herzegovina'                                =>'BA',                     
        'Botswana'                                              =>'BW',     
        'Bouvet Island'                                         =>'BV',         
        'Brazil'                                                =>'BR',     
        'British Indian Ocean Territory'                        =>'IO',                             
        'Brunei Darussalam'                                     =>'BN',             
        'Bulgaria'                                              =>'BG',     
        'Burkina Faso'                                          =>'BF',         
        'Burundi'                                               =>'BI',     
        'Cambodia'                                              =>'KH',     
        'Cameroon'                                              =>'CM',     
        'Canada'                                                =>'CA',     
        'Cape Verde'                                            =>'CV',         
        'Cayman Islands'                                        =>'KY',             
        'Central African Republic'                              =>'CF',                     
        'Chad'                                                  =>'TD', 
        'Chile'                                                 =>'CL', 
        'China'                                                 =>'CN', 
        'Christmas Island'                                      =>'CX',             
        'Cocos (Keeling) Islands'                               =>'CC',                     
        'Colombia'                                              =>'CO',     
        'Comoros'                                               =>'KM',     
        'Congo'                                                 =>'CG', 
        'Democratic Republic of the Congo'                      =>'CD',                             
        'Cook Islands'                                          =>'CK',         
        'Costa Rica'                                            =>'CR',         
        'Croatia'                                               =>'HR',     
        'Cuba'                                                  =>'CU', 
        'CuraÃ§ao'                                              =>'CW',     
        'Cyprus'                                                =>'CY',     
        'Czech Republic'                                        =>'CZ',             
        'CÃ´te d\'Ivoire'                                       =>'CI',             
        'Denmark'                                               =>'DK',     
        'Djibouti'                                              =>'DJ',     
        'Dominica'                                              =>'DM',     
        'Dominican Republic'                                    =>'DO',                 
        'Ecuador'                                               =>'EC',     
        'Egypt'                                                 =>'EG', 
        'El Salvador'                                           =>'SV',         
        'Equatorial Guinea'                                     =>'GQ',             
        'Eritrea'                                               =>'ER',     
        'Estonia'                                               =>'EE',     
        'Ethiopia'                                              =>'ET',     
        'Falkland Islands (Malvinas)'                           =>'FK',                         
        'Faroe Islands'                                         =>'FO',         
        'Fiji'                                                  =>'FJ', 
        'Finland'                                               =>'FI',     
        'France'                                                =>'FR',     
        'French Guiana'                                         =>'GF',         
        'French Polynesia'                                      =>'PF',             
        'French Southern Territories'                           =>'TF',                         
        'Gabon'                                                 =>'GA', 
        'Gambia'                                                =>'GM',     
        'Georgia'                                               =>'GE',     
        'Germany'                                               =>'DE',     
        'Ghana'                                                 =>'GH', 
        'Gibraltar'                                             =>'GI',     
        'Greece'                                                =>'GR',     
        'Greenland'                                             =>'GL',     
        'Grenada'                                               =>'GD',     
        'Guadeloupe'                                            =>'GP',         
        'Guam'                                                  =>'GU', 
        'Guatemala'                                             =>'GT',     
        'Guernsey'                                              =>'GG',     
        'Guinea'                                                =>'GN',     
        'Guinea-Bissau'                                         =>'GW',         
        'Guyana'                                                =>'GY',     
        'Haiti'                                                 =>'HT', 
        'Heard Island and McDonald Mcdonald Islands'            =>'HM',                                         
        'Holy See (Vatican City State)'                         =>'VA',                         
        'Honduras'                                              =>'HN',     
        'Hong Kong'                                             =>'HK',     
        'Hungary'                                               =>'HU',     
        'Iceland'                                               =>'IS',     
        'India'                                                 =>'IN', 
        'Indonesia'                                             =>'ID',     
        'Iran, Islamic Republic of'                             =>'IR',                     
        'Iraq'                                                  =>'IQ', 
        'Ireland'                                               =>'IE',     
        'Isle of Man'                                           =>'IM',         
        'Israel'                                                =>'IL',     
        'Italy'                                                 =>'IT', 
        'Jamaica'                                               =>'JM',     
        'Japan'                                                 =>'JP', 
        'Jersey'                                                =>'JE',     
        'Jordan'                                                =>'JO',     
        'Kazakhstan'                                            =>'KZ',         
        'Kenya'                                                 =>'KE', 
        'Kiribati'                                              =>'KI',     
        'Korea, Democratic People\'s Republic of'               =>'KP',                                     
        'Korea, Republic of'                                    =>'KR',                 
        'Kuwait'                                                =>'KW',     
        'Kyrgyzstan'                                            =>'KG',         
        'Lao People\'s Democratic Republic'                     =>'LA',                             
        'Latvia'                                                =>'LV',     
        'Lebanon'                                               =>'LB',     
        'Lesotho'                                               =>'LS',     
        'Liberia'                                               =>'LR',     
        'Libya'                                                 =>'LY', 
        'Liechtenstein'                                         =>'LI',         
        'Lithuania'                                             =>'LT',     
        'Luxembourg'                                            =>'LU',         
        'Macao'                                                 =>'MO', 
        'Macedonia, the Former Yugoslav Republic of'            =>'MK',                                         
        'Madagascar'                                            =>'MG',         
        'Malawi'                                                =>'MW',     
        'Malaysia'                                              =>'MY',     
        'Maldives'                                              =>'MV',     
        'Mali'                                                  =>'ML', 
        'Malta'                                                 =>'MT', 
        'Marshall Islands'                                      =>'MH',             
        'Martinique'                                            =>'MQ',         
        'Mauritania'                                            =>'MR',         
        'Mauritius'                                             =>'MU',     
        'Mayotte'                                               =>'YT',     
        'Mexico'                                                =>'MX',     
        'Micronesia, Federated States of'                       =>'FM',                             
        'Moldova, Republic of'                                  =>'MD',                 
        'Monaco'                                                =>'MC',     
        'Mongolia'                                              =>'MN',     
        'Montenegro'                                            =>'ME',         
        'Montserrat'                                            =>'MS',         
        'Morocco'                                               =>'MA',     
        'Mozambique'                                            =>'MZ',         
        'Myanmar'                                               =>'MM',     
        'Namibia'                                               =>'NA',     
        'Nauru'                                                 =>'NR', 
        'Nepal'                                                 =>'NP', 
        'Netherlands'                                           =>'NL',         
        'New Caledonia'                                         =>'NC',         
        'New Zealand'                                           =>'NZ',         
        'Nicaragua'                                             =>'NI',     
        'Niger'                                                 =>'NE', 
        'Nigeria'                                               =>'NG',     
        'Niue'                                                  =>'NU', 
        'Norfolk Island'                                        =>'NF',             
        'Northern Mariana Islands'                              =>'MP',                     
        'Norway'                                                =>'NO',     
        'Oman'                                                  =>'OM', 
        'Pakistan'                                              =>'PK',     
        'Palau'                                                 =>'PW', 
        'Palestine, State of'                                   =>'PS',                 
        'Panama'                                                =>'PA',     
        'Papua New Guinea'                                      =>'PG',             
        'Paraguay'                                              =>'PY',     
        'Peru'                                                  =>'PE', 
        'Philippines'                                           =>'PH',         
        'Pitcairn'                                              =>'PN',     
        'Poland'                                                =>'PL',     
        'Portugal'                                              =>'PT',     
        'Puerto Rico'                                           =>'PR',         
        'Qatar'                                                 =>'QA', 
        'Romania'                                               =>'RO',     
        'Russian Federation'                                    =>'RU',                 
        'Rwanda'                                                =>'RW',     
        'Reunion'                                               =>'RE',     
        'Saint Barthelemy'                                      =>'BL',             
        'Saint Helena'                                          =>'SH',         
        'Saint Kitts and Nevis'                                 =>'KN',                 
        'Saint Lucia'                                           =>'LC',         
        'Saint Martin (French part)'                            =>'MF',                         
        'Saint Pierre and Miquelon'                             =>'PM',                     
        'Saint Vincent and the Grenadines'                      =>'VC',                             
        'Samoa'                                                 =>'WS', 
        'San Marino'                                            =>'SM',         
        'Sao Tome and Principe'                                 =>'ST',                 
        'Saudi Arabia'                                          =>'SA',         
        'Senegal'                                               =>'SN',     
        'Serbia'                                                =>'RS',     
        'Seychelles'                                            =>'SC',         
        'Sierra Leone'                                          =>'SL',         
        'Singapore'                                             =>'SG',     
        'Sint Maarten (Dutch part)'                             =>'SX',                     
        'Slovakia'                                              =>'SK',     
        'Slovenia'                                              =>'SI',     
        'Solomon Islands'                                       =>'SB',             
        'Somalia'                                               =>'SO',     
        'South Africa'                                          =>'ZA',         
        'South Georgia and the South Sandwich Islands'          =>'GS',                                         
        'South Sudan'                                           =>'SS',         
        'Spain'                                                 =>'ES', 
        'Sri Lanka'                                             =>'LK',     
        'Sudan'                                                 =>'SD', 
        'Suriname'                                              =>'SR',     
        'Svalbard and Jan Mayen'                                =>'SJ',                     
        'Swaziland'                                             =>'SZ',     
        'Sweden'                                                =>'SE',     
        'Switzerland'                                           =>'CH',         
        'Syrian Arab Republic'                                  =>'SY',                 
        'Taiwan, Province of China'                             =>'TW',                     
        'Tajikistan'                                            =>'TJ',         
        'United Republic of Tanzania'                           =>'TZ',                         
        'Thailand'                                              =>'TH',     
        'Timor-Leste'                                           =>'TL',         
        'Togo'                                                  =>'TG', 
        'Tokelau'                                               =>'TK',     
        'Tonga'                                                 =>'TO', 
        'Trinidad and Tobago'                                   =>'TT',                 
        'Tunisia'                                               =>'TN',     
        'Turkey'                                                =>'TR',     
        'Turkmenistan'                                          =>'TM',         
        'Turks and Caicos Islands'                              =>'TC',                     
        'Tuvalu'                                                =>'TV',     
        'Uganda'                                                =>'UG',     
        'Ukraine'                                               =>'UA',     
        'United Arab Emirates'                                  =>'AE',                 
        'United Kingdom'                                        =>'GB',             
        'United States'                                         =>'US',         
        'United States Minor Outlying Islands'                  =>'UM',                                 
        'Uruguay'                                               =>'UY',     
        'Uzbekistan'                                            =>'UZ',         
        'Vanuatu'                                               =>'VU',     
        'Venezuela'                                             =>'VE',     
        'Viet Nam'                                              =>'VN',     
        'British Virgin Islands'                                =>'VG',                     
        'US Virgin Islands'                                     =>'VI',             
        'Wallis and Futuna'                                     =>'WF',             
        'Western Sahara'                                        =>'EH',             
        'Yemen'                                                 =>'YE',         
        'Zambia'                                                =>'ZM',     
        'Zimbabwe'                                              =>'ZW',     
        'Aland Islands'                                         =>'AX'              
    };
    
    public static final Map<String, String> stateMap = new Map<String, String>{
        'Alabama'               =>'AL', 
        'Alaska'                =>'AK', 
        'American Samoa'        =>'AS',         
        'Arizona'               =>'AZ', 
        'Arkansas'              =>'AR', 
        'California'            =>'CA',     
        'Colorado'              =>'CO', 
        'Connecticut'           =>'CT',     
        'Delaware'              =>'DE', 
        'Dist. of Columbia'     =>'DC',         
        'Florida'               =>'FL', 
        'Georgia'               =>'GA', 
        'Guam'                  =>'GU',
        'Hawaii'                =>'HI', 
        'Idaho'                 =>'ID',
        'Illinois'              =>'IL', 
        'Indiana'               =>'IN', 
        'Iowa'                  =>'IA',
        'Kansas'                =>'KS', 
        'Kentucky'              =>'KY', 
        'Louisiana'             =>'LA', 
        'Maine'                 =>'ME',
        'Maryland'              =>'MD', 
        'Marshall Islands'      =>'MH',         
        'Massachusetts'         =>'MA',     
        'Michigan'              =>'MI', 
        'Micronesia'            =>'FM',     
        'Minnesota'             =>'MN', 
        'Mississippi'           =>'MS',     
        'Missouri'              =>'MO', 
        'Montana'               =>'MT', 
        'Nebraska'              =>'NE', 
        'Nevada'                =>'NV', 
        'New Hampshire'         =>'NH',     
        'New Jersey'            =>'NJ',     
        'New Mexico'            =>'NM',     
        'New York'              =>'NY', 
        'North Carolina'        =>'NC',         
        'North Dakota'          =>'ND',     
        'Northern Marianas'     =>'MP',         
        'Ohio'                  =>'OH',
        'Oklahoma'              =>'OK', 
        'Oregon'                =>'OR', 
        'Palau'                 =>'PW',
        'Pennsylvania'          =>'PA',     
        'Puerto Rico'           =>'PR',     
        'Rhode Island'          =>'RI',     
        'South Carolina'        =>'SC',         
        'South Dakota'          =>'SD',     
        'Tennessee'             =>'TN', 
        'Texas'                 =>'TX',
        'Utah'                  =>'UT',
        'Vermont'               =>'VT', 
        'Virginia'              =>'VA', 
        'Virgin Islands'        =>'VI',         
        'Washington'            =>'WA',     
        'West Virginia'         =>'WV',     
        'Wisconsin'             =>'WI', 
        'Wyoming'               =>'WY'
    };
    
    public static final Map<String, String> timeZoneMap = new Map<String, String>{
        'EST'  => 'America/New_York',
        'CST'  => 'America/Chicago',
        'AKST' => 'America/Anchorage',
        'PST'  => 'America/Los_Angeles',
        'MST'  => 'America/Denver'
    };
    
    
    //Static method to access Lead time for single product from prduct details page.
    public static string GetLeadTime(String sku, string sellerId){
        String LeadTime                                 =    null;
        try{
            List<ccrz__E_ProductInventoryItem__c> prodInvItem =   [SELECT cc_oo_LeadTime__c FROM ccrz__E_ProductInventoryItem__c 
                                                            WHERE cc_oo_Seller__c =: sellerId and 
                                                            ccrz__ProductItem__c in                                                     
                                                            (SELECT c.id FROM ccrz__E_Product__c c WHERE  c.ccrz__SKU__c =:sku) LIMIT 1]; // '3001503-506') =:  LIMIT 1];
            
            if(!prodInvItem.isEmpty()) {
                if(!String.isBlank(prodInvItem[0].cc_oo_LeadTime__c)){
                  LeadTime  =   prodInvItem[0].cc_oo_LeadTime__c;
                }
            }
            return LeadTime;
        }
         catch(Exception ex){ 
            CreateErrorLog(ex, CLASS_NAME, 'GetLeadTime');   
        }
        return LeadTime;    
    }
        
    //Static method to access Lead time for all products listed on product list page..
    public static Map<String, String> GetLeadTimeforAllProducts( List<string> productIds , String sellerId){
        Map<String, String> dataMap=null;
        try{
            
            List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select p.ccrz__ProductItem__c, p.cc_oo_LeadTime__c , p.cc_oo_Seller__c 
            from ccrz__E_ProductInventoryItem__c p
            where p.cc_oo_Seller__c =: sellerId and p.ccrz__ProductItem__c IN:productIds];
            if(!inventoryItems.isEmpty()){ 
                dataMap = new Map<String, String>();
                for(ccrz__E_ProductInventoryItem__c inventoryItem : inventoryItems){  
                   dataMap.put(inventoryItem.ccrz__ProductItem__c,inventoryItem.cc_oo_LeadTime__c);
                } 
            }
            
        }
        catch(Exception ex){
            CreateErrorLog(ex, CLASS_NAME, 'GetLeadTimeforAllProducts');
        }
         return dataMap;
    }
    
    /***************************************************************************************************************************************
      Method Name : getVfdFlagAll
      Description : getVfdFlagAll is to get the vfd flag for corresponding products
      Parameter   : productIds 
                    productIds is the list of product Ids
      Return type : Returns Map<String,boolean>.
      UserStory   : OO-59 - vfd products shall be flagged.                                                              
                    
      *************************************************************************************************************************************/
    
    public static Map<String,boolean> getVfdFlagForAll( List<string> productIds){
        Map<String,boolean> dataMap=null;
        try{
            
            list<ccrz__E_Product__c> vfdFlag=[Select p.Id,p.ccrz__HazardousFlag__c From ccrz__E_Product__c p WHERE p.Id IN :productIds]; 
            if(!vfdFlag.isEmpty()){ 
                dataMap = new Map<String,boolean>();
                for(ccrz__E_Product__c prod1:vfdFlag)
                {
                    dataMap.put(prod1.Id,prod1.ccrz__HazardousFlag__c);
                }
             } 
        }
        catch(Exception ex){
            CreateErrorLog(ex, CLASS_NAME, 'getVfdFlagForAll');   
        }
         return dataMap;
    }
    
    public static String getKeyFromValue(Map<String,String> mp, String value) {
        for (String str : mp.keySet()) {
          if (mp.get(str).equals(value)) {
            return str;
          }
        }
        return value;
    }
        
    public static string getCountryCode(String countryString){
       
        
        if(countryMap.containsKey(countryString)){ 
            ccrz.ccLog.log(System.LoggingLevel.INFO,'INFO','---->countryString' + countryString);
            //system.debug('---->countrycode' + countryMap.get(countryString));
            return countryMap.get(countryString);
        }
        return countryString;
    }
    
    public static string getCountryText(String countryCode){
        return getKeyFromValue(countryMap, countryCode);
    }
    
    
        
    public static string getStateCode(String stateString){
        if(stateMap.containsKey(stateString)){
            return stateMap.get(stateString);
        }
        return stateString;
    }
    
    public static string getStateText(String stateCode){
        return getKeyFromValue(stateMap, stateCode);
    }
    
    public static string getTimeZone(String timeZone){
        if(timeZoneMap.containsKey(timeZone)){
            return timeZoneMap.get(timeZone);
        }
        return timeZone;
    }
    
    /***************************************************************************************************************************************
      Method Name : addNewCartRow
      Description : addNewCartRow is to update a new row in the cart
      Parameter   : skuId, quantity , cartGUID
      Return type : Returns Map<String,boolean>.
      UserStory   : OO-56 - pricing update for all products                                                              
                    
      *************************************************************************************************************************************/
    
    public static void addNewCartRow( String skuId, Integer quantity,String cartGUID){
        
        try{
           
            //Perform Add to Cart via CloudCraze Global API
                    ccrz.ccApiCart.LineData lineToAdd = new ccrz.ccApiCart.LineData();
                    lineToAdd.sku = skuId;
                    lineToAdd.quantity = quantity;
                    
                    //lineToAdd.seller = 'a2sW0000000Dc1O';
                    final List<ccrz.ccApiCart.LineData> linesToAdd = new List<ccrz.ccApiCart.LineData>{lineToAdd};
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','----> addToCartOO cartGUID'+cartGUID);
                    //System.debug('----> addToCartOO cartGUID'+cartGUID);
                    
                    //2: Perform add or create
                    Map<String,Object> addToCartResults;
                    if(!Test.isRunningTest()){
                        addToCartResults = ccrz.ccApiCart.addTo(
                            new Map<String,Object> {
                                ccrz.ccApi.API_VERSION => 1,
                                ccrz.ccApiCart.CART_ENCID => ((String.isBlank(cartGUID)) ? null : cartGUID),
                                ccrz.ccApiCart.LINE_DATA => linesToAdd
                            }
                        );
                        //3: pull up cart and set price
                       // cartGUID = (String)addToCartResults.get(ccrz.ccApiCart.CART_ENCID);
                    }
                    else{
                        addToCartResults = new Map<String, Object>{ccrz.ccApiCart.CART_ENCID => cartGUID};
                    }
                    ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','\n\n addToCartResults --->'+addToCartResults);                    
        }
        catch(Exception ex){
            CreateErrorLog(ex, CLASS_NAME, 'addNewCartRow');           
        }
    }
    
    /***************************************************************************************************************************************
      Method Name : addToCartMini
      Description : addToCartMini is to add a product to cart
      Parameter   : productDetailMap, skuQuantityMap , sellerId
      Return type : Returns Map<String,List<String>>.
      UserStory   : OO-56 - pricing update for all products                                                             
                    
      *************************************************************************************************************************************/
    
    public static Map<String,Object> addToCartMini( Map<string, string> productDetailMap, Map<string, string> skuQuantityMap,String sellerId){
        Map<String, Object> dataMap = new Map<String, Object>();
        try{
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','murtaza debug');
            //System.debug('murtaza debug');
           String cartGUID;
           String sid;
           String shipTo;
           if(productDetailMap != null && !productDetailMap.isEmpty()){           
                if(productDetailMap.containsKey('CartId')){
                    cartGUID= String.valueOf(productDetailMap.get('CartId'));
                } 
                
                if(productDetailMap.containsKey('sid')){
                    sid = String.valueOf(productDetailMap.get('sid'));
                } 
                
                if(productDetailMap.containsKey('shipTo')){
                    shipTo = String.valueOf(productDetailMap.get('shipTo'));
                }                    
            }
            
            if(cartGUID == null || cartGUID == '' || cartGUID == '{}' || cartGUID.toLowercase()  == 'undefined') {
                ccrz__E_Cart__c  cartReturn = cc_oo_HeaderController.mapToCart(sid ,shipTo,false );
                cartGUID  = String.valueOf(cartReturn.ccrz__EncryptedId__c);
            }
        
            List<String> skuIdList = new List<String>(); 
            
            If(skuQuantityMap != null && !skuQuantityMap.isEmpty()) {
                for (String sku : skuQuantityMap.keySet()){
                    skuIdList.add(sku);
                }
            }
            // to fetch the product type using the sku id
            List<ccrz__E_Product__c> productDetailList = [SELECT id, ccrz__SKU__c, cc_oo_TypeOfProduct__c FROM ccrz__E_Product__c WHERE ccrz__SKU__c IN :skuIdList];
            
            // Start - Implementation for OO- 49
            ccrz__E_Seller__c seller; 
            if(sellerId != null){
                seller = [select ccrz__SellerId__c from ccrz__E_Seller__c where id=:sellerId LIMIT 1];
            }
            String sellerCode = (seller != null) ? seller.ccrz__SellerId__c:'';
            List<ccrz__E_ProductInventoryItem__c> inventoryItems = [select cc_oo_MinQuantity__c,ccrz__ProductItem__r.ccrz__SKU__c,cc_oo_IsOnlyPalletProduct__c,cc_oo_PalletSize__c
                                                                    from ccrz__E_ProductInventoryItem__c
                                                                    where ccrz__ProductItem__c IN:productDetailList and cc_oo_Seller__c=:sellerId];
            String errorMsg = '';
             Decimal minQty;
            if(inventoryItems != null){
                for(ccrz__E_ProductInventoryItem__c invItem: inventoryItems){ 
                    minQty=invItem.cc_oo_IsOnlyPalletProduct__c?invItem.cc_oo_PalletSize__c:invItem.cc_oo_MinQuantity__c;
                    if(skuQuantityMap.get(invItem.ccrz__ProductItem__r.ccrz__SKU__c) != null && minQty > Decimal.valueof(skuQuantityMap.get(invItem.ccrz__ProductItem__r.ccrz__SKU__c))){
                        if(invItem.cc_oo_IsOnlyPalletProduct__c){
                            errorMsg +='A full pallet is required for this product-'+invItem.ccrz__ProductItem__r.ccrz__SKU__c + '<br/>';
                        }else {
                        errorMsg += 'A minimum of '+invItem.cc_oo_MinQuantity__c+' quantity is required for product-'+invItem.ccrz__ProductItem__r.ccrz__SKU__c + '<br/>';
                    }
                    }
            }}
            if(errorMsg != ''){
                dataMap.put('errorMsg',errorMsg);
                return dataMap; 
            } 
            // End - Implementation for OO- 49 
            // to fetch the current cart using the cartId
                ccrz__E_Cart__c cartDetails = [SELECT c.ccrz__EncryptedId__c, (SELECT Id, ccrz__Quantity__c, ccrz__Price__c, ccrz__SubAmount__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.cc_oo_TypeOfProduct__c FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c c WHERE c.ccrz__EncryptedId__c =:cartGUID][0];
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','cart-detail'+cartDetails);
                //System.debug('cart-detail'+cartDetails);
            Set<String> typeOfProductList = new Set<String>();
            Set<String> productNoList = new Set<String>();
            for(ccrz__E_CartItem__c cartItem : cartDetails.ccrz__E_CartItems__r){
                typeOfProductList.add(cartItem.ccrz__Product__r.cc_oo_TypeOfProduct__c);
                productNoList.add(cartItem.ccrz__Product__r.ccrz__SKU__c);      
            }
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','productNolist'+productNoList+'typeofproduct'+typeOfProductList);
            //System.debug('productNolist'+productNoList+'typeofproduct'+typeOfProductList);
            Set<String> filteredSkuList = new Set<String>();
            List<String> rejectedSkuList = new List<String>();
            
            if(!productDetailList.isEmpty()) {
                for(ccrz__E_Product__c productDetails : productDetailList) {
                       if(!(typeOfProductList.contains(productDetails.cc_oo_TypeOfProduct__c))&&(!typeOfProductList.isEmpty())) {
                           rejectedSkuList.add(productDetails.ccrz__SKU__c);
                       } else {
                           filteredSkuList.add(productDetails.ccrz__SKU__c);
                       }
                }
            }
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','filteredSkuList'+filteredSkuList);
            //System.debug('filteredSkuList'+filteredSkuList);
            if(!rejectedSkuList.isEmpty()) {
                dataMap.put('productType', typeOfProductList.iterator().next());
            }
            
            List<String>  filteredProduct = new List<String>();
            filteredProduct.addAll(filteredSkuList);        
            
            if(!filteredSkuList.isEmpty()) {
            
                List<String> addCartSkuList = new List<String>();
                Set<string> cartProduct = new Set<String>();
                
                for(String filter : filteredSkuList) {
                 if(!(cartDetails.ccrz__E_CartItems__r).isEmpty()){ 
                    for(ccrz__E_CartItem__c cartItem : cartDetails.ccrz__E_CartItems__r) {
                        if(filteredSkuList.contains(cartItem.ccrz__Product__r.ccrz__SKU__c)) {
                            cartProduct.add(cartItem.ccrz__Product__r.ccrz__SKU__c);
                            filteredSkuList.remove(cartItem.ccrz__Product__r.ccrz__SKU__c);
                        }
                      }
                   }       
                   if(!(cartProduct.contains(filter))){ 
                            addCartSkuList.add(filter);
                            filteredSkuList.remove(filter);
                        }
                   ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Piyali Filterlist' + filteredSkuList);
                   // System.debug('Piyali Filterlist' + filteredSkuList);
                }
                
                //System.debug('Piyali Filter' + cartProduct);
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCRPTION','Piyali Filter' + cartProduct);
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCRPTION','Piyali add' + addCartSkuList);
                //System.debug('Piyali add' + addCartSkuList);
                
                if(!(cartDetails.ccrz__E_CartItems__r).isEmpty()){  
                List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>();
                for(ccrz__E_CartItem__c cartItem : cartDetails.ccrz__E_CartItems__r){
                    for(String filterSkuId : cartProduct){
                        if((Integer.valueOf(skuQuantityMap.get(filterSkuId))) != 0) {
                            if(cartItem.ccrz__Product__r.ccrz__SKU__c.equals(filterSkuId)) {
                                cartItem.ccrz__Quantity__c += (Integer.valueOf(skuQuantityMap.get(filterSkuId)));
                                cartItem.ccrz__SubAmount__c += (cartItem.ccrz__Price__c * (Integer.valueOf(skuQuantityMap.get(filterSkuId))));
                                cartProduct.remove(filterSkuId);
                                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCRPTION','Piyali cartList' + filterSkuId);
                                //System.debug('Piyali cartList' + filterSkuId);
                                //update cartItem;
                                cartItemList.add(cartItem);
                            }
                        }
                     } 
                   }
                    update cartItemList;
                }
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Piyali cartList1' + addCartSkuList);
                //System.debug('Piyali cartList1' + addCartSkuList);
                
                if(!addCartSkuList.isEmpty()) {
                //Perform Add to Cart via CloudCraze Global API
                List<ccrz.ccApiCart.LineData> linesToAdd = new List<ccrz.ccApiCart.LineData>();
                
                for(String skuId : addCartSkuList) {
                    if((Integer.valueOf(skuQuantityMap.get(skuId))) != 0) {
                        ccrz.ccApiCart.LineData lineToAdd = new ccrz.ccApiCart.LineData();
                        lineToAdd.sku = skuId;
                        lineToAdd.quantity = Integer.valueOf(skuQuantityMap.get(skuId));
                        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','Quantity' + lineToAdd.quantity + 'SKU' + skuId);
                        //System.debug('Quantity' + lineToAdd.quantity + 'SKU' + skuId);
                        linesToAdd.add(lineToAdd);
                    }
                }
                
                //2: Perform add or create
                Map<String,Object> addToCartResults;
                if(!Test.isRunningTest()){
                    addToCartResults = ccrz.ccApiCart.addTo(
                        new Map<String,Object> {
                            ccrz.ccApi.API_VERSION => 1,
                            ccrz.ccApiCart.CART_ENCID => ((String.isBlank(cartGUID)) ? null : cartGUID),
                            ccrz.ccApiCart.LINE_DATA => linesToAdd
                        }
                    );
                    //3: pull up cart and set price
                    cartGUID = (String)addToCartResults.get(ccrz.ccApiCart.CART_ENCID);
                }
                else{
                    addToCartResults = new Map<String, Object>{ccrz.ccApiCart.CART_ENCID => cartGUID};
                }
                 ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','\n\n addToCartResults --->'+addToCartResults);
                //System.debug('\n\n addToCartResults --->'+addToCartResults);
             }   
           }
            dataMap.put('cartId', cartGUID);
            dataMap.put('filteredSkuList', filteredProduct);
            
        } catch(Exception ex){
            CreateErrorLog(ex, CLASS_NAME, 'addToCartMini');  
        }
         return dataMap;
    }
    
    /***************************************************************************************************************************************
      Method Name : getProducts
      Description : getProducts is to get the filtered products
      Parameter   : productIds 
                    productIds is the list of product Ids
      Return type : Returns List<String>.
                    
      *************************************************************************************************************************************/
    
     //Method to fetch the products for the given seller
     public static List<String> getProducts(List<String> skuIdList) {
        List<String> productSkuIdList = new List<String>();
        try{
            
         Map<String,String> pageParams  = ccrz.cc_CallContext.currPageParameters;
         List<ccrz__E_Cart__c> sellerShipCode=new List<ccrz__E_Cart__c>();
         String cartId;
         String sellerId = null;
         String orderType = null; 
         String orderId;
         String sellerCode;
         Decimal accountId;
         if(pageParams!=null){
            sellerId =pageParams.get('sid');
            cartId = pageParams.get('cartID')!=null?pageParams.get('cartID'):pageParams.get('cartId'); 
            orderType=pageParams.get('orderType');
            orderId = pageParams.get('o');
         }
        
         if(String.isEmpty(cartId) && !String.isEmpty(orderId)) {
            List<ccrz__E_Order__c> orders = [select Id,ccrz__EncryptedId__c, ccrz__RequestDate__c
                                                , cc_oo_ShipToAccount__r.AccountNumber
                                                , ccrz__OriginatedCart__r.ccrz__EncryptedId__c
                                                from ccrz__E_Order__c where ccrz__EncryptedId__c=:orderId LIMIT 1];
                                                
            sellerShipCode= [select cc_oo_Seller__r.ccrz__SellerId__c,cc_oo_ShipToAccount__r.AccountNumber from ccrz__E_Cart__c where ccrz__EncryptedId__c=:orders[0].ccrz__OriginatedCart__r.ccrz__EncryptedId__c LIMIT 1];
        } else {
            sellerShipCode= [select cc_oo_Seller__r.ccrz__SellerId__c,cc_oo_ShipToAccount__r.AccountNumber from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId LIMIT 1];
        }
        
        System.debug(sellerShipCode);
        if(!sellerShipCode.isEmpty()){
             sellerCode=sellerShipCode[0].cc_oo_Seller__r.ccrz__SellerId__c;
             accountId=Decimal.valueOf(sellerShipCode[0].cc_oo_ShipToAccount__r.AccountNumber);
        }
        Id accGroup = ccrz.cc_CallContext.currAccountGroup.Id;
        Id contactId = ccrz.cc_CallContext.currContact.Id;
        String shipToPricelistName;
        shipToPricelistName=String.valueOf(accountId) + '-'+sellerCode;
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',accGroup);
        //System.debug(accGroup);
        System.debug(shipToPricelistName);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',shipToPricelistName);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION',accountId);
        //System.debug(accountId);
        
        //OO-215 - Ship To Plant selection - end
        Date expireLimit = Date.today();
        List<ccrz__E_PriceListItem__c> PriceListItemList = new List<ccrz__E_PriceListItem__c>();
       // List<ccrz__E_PriceListItem__c> ItemList = new List<ccrz__E_PriceListItem__c>();
        
        if(orderType=='Prebook') {
            PriceListItemList=[SELECT ccrz__Product__r.ccrz__SKU__c,cc_oo_IsPreBook__c FROM ccrz__E_PriceListItem__c WHERE ccrz__Product__r.ccrz__SKU__c IN :skuIdList AND ccrz__Pricelist__c IN 
            (SELECT ccrz__Pricelist__c FROM ccrz__E_AccountGroupPriceList__c WHERE ccrz__Pricelist__r.ccrz__Seller__c=:sellerId and ccrz__Pricelist__r.ccrz__Enabled__c=true AND ccrz__AccountGroup__c=:accGroup ) AND cc_oo_IsPreBook__c=true];

        } else {
            PriceListItemList=[SELECT ccrz__Product__r.ccrz__SKU__c FROM ccrz__E_PriceListItem__c WHERE 
            ccrz__Product__r.ccrz__SKU__c IN :skuIdList AND 
            ccrz__Pricelist__c IN 
            (SELECT ccrz__Pricelist__c FROM ccrz__E_AccountGroupPriceList__c WHERE ccrz__Pricelist__r.ccrz__Seller__c=:sellerId and ccrz__Pricelist__r.ccrz__Enabled__c=true AND ccrz__AccountGroup__c=:accGroup  AND (ccrz__Pricelist__r.ccrz__PricelistId__c=:sellerCode OR ccrz__Pricelist__r.ccrz__PricelistId__c=:shipToPricelistName )AND (ccrz__Pricelist__r.cc_oo_ShipToNumber__c=NULL OR ccrz__Pricelist__r.cc_oo_ShipToNumber__c=:accountId )) AND cc_oo_IsPreBook__c=false AND ccrz__EndDate__c>=:expireLimit];
            if(PriceListItemList.isEmpty()){
            PriceListItemList= new List<ccrz__E_PriceListItem__c>();
            }
        } 
        if(!PriceListItemList.isEmpty()){
            Set<String> newSkuList= new Set<String>();
            for(ccrz__E_PriceListItem__c priceListItem: PriceListItemList) {
                newSkuList.add(priceListItem.ccrz__Product__r.ccrz__SKU__c);
            }
            productSkuIdList.addAll(newSkuList);
        }
        
    }catch(Exception ex){
        
        CreateErrorLog(ex, CLASS_NAME, 'getProducts'); 
    }
   
    ccrz.ccLog.log(System.LoggingLevel.INFO,'Product Ids',productSkuIdList);
   
    return productSkuIdList;

    }
    
    
    
    
    /***************************************************************************************************************************************
      Method Name : addNewCartItem
      Description : addNewCartItem is to add a new cartItem without using cart API
      Parameter   : skuId, quantity , Price, CartId
      Return type : Returns Boolean .
      UserStory   : OO-56 - pricing update for all products                                                              
                    
      *************************************************************************************************************************************/
    //2752
    public static void addNewCartItem( String skuId, Integer quantity,String cartGUID, Decimal price, 
                        Boolean isListPrice,Id contractId, String sId, String bagPrice, 
                        String palletPrice,String leadTime,Boolean IsfreightIncluded, ccrz__E_CartItem__c cloneCartItem){
        
        try{
            //OO-1772 -starts
            /*Integer highestCount = 0;
            List<ccrz__E_Cart__c> listCarts = [select id, cc_oo_AmendedCart__c, (select id, cc_oo_webLineNumber__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where Id =: cartGUID];
            if(listCarts.size() > 0){
                if(listCarts[0].cc_oo_AmendedCart__c == true){
                    for(ccrz__E_CartItem__c cartItem: listCarts[0].ccrz__E_CartItems__r){
                        if(highestCount < cartItem.cc_oo_webLineNumber__c){
                            highestCount = Integer.valueOf(cartItem.cc_oo_webLineNumber__c);
                            system.debug('1 highestCount---->' + highestCount);
                        }
                    }
                }
            }
            highestCount = highestCount + 1;
            system.debug('highestCount---->' + highestCount);*/
            //OO-1772 - Ends
            
            List<ccrz__E_Product__c> productCategory=[SELECT Id,ccrz__UnitOfMeasure__c
                                    , ccrz__ProductType__c,cc_oo_TypeOfProduct__c 
                                    FROM ccrz__E_Product__c WHERE ccrz__SKU__c =:skuId LIMIT 1]; 
            
            Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
            //String seller = ApexPages.currentPage().getParameters().get('sid');
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'pageparams'+pageParams.get('sid'));
            //system.debug('pageparams'+pageParams.get('sid'));
            String sellerId = sId;
            /*if(pageParams != null && !pageParams.isEmpty()){
                sellerId = pageParams.get('sid');
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'sellerid'+sellerId);
                //System.debug('sellerid'+sellerId);
            }*/
            
            Id accGroup = ccrz.cc_CallContext.currAccountGroup.Id;
            
           /* List<ccrz__E_PriceListItem__c> priceListItem=[SELECT ccrz__Product__r.ccrz__SKU__c FROM ccrz__E_PriceListItem__c WHERE 
            ccrz__Product__r.ccrz__SKU__c =:skuId AND 
            ccrz__Pricelist__c IN 
            (SELECT ccrz__Pricelist__c FROM ccrz__E_AccountGroupPriceList__c WHERE ccrz__Pricelist__r.ccrz__Seller__c=:sellerId and ccrz__Pricelist__r.ccrz__Enabled__c=true AND ccrz__AccountGroup__c=:accGroup) AND cc_oo_IsPreBook__c=false]; */
            String typeOfProduct=productCategory[0].cc_oo_TypeOfProduct__c;
            User user = ccrz.cc_CallContext.currUser;
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'Creating new Cart Item');
            //System.debug('Creating new Cart Item');
            ccrz__E_CartItem__c cartItem = new ccrz__E_CartItem__c();
            cartItem.ccrz__Cart__c = cartGUID;
            //cartItem.ccrz__Category__c = productCategory.ccrz__Category__c;
            cartItem.ccrz__StoreID__c = ccrz.cc_CallContext.storefront;
            cartItem.ccrz__Product__c = productCategory[0].Id;
           // if(!priceListItem.isEmpty()){
            cartItem.ccrz__Seller__c = sellerId;
            if(leadTime!=null){
                cartItem.cc_oo_isFreightIncluded__c=IsfreightIncluded;
                cartItem.cc_oo_leadtime__c=leadTime;
            }
           // }
            cartItem.ccrz__Quantity__c = quantity;
            cartItem.ccrz__Price__c = price;
            cartItem.cc_oo_UnitPrice__c = price;
            cartItem.cc_oo_IsListPrice__c = isListPrice;
            Integer tonToLb=Integer.valueOf(LOLSettings__c.getValues('cc_oo_TON_TO_LB').Value__c);
            if(typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('BULK')) || typeOfProduct.equalsIgnoreCase(ccrz.cc_CallContext.pageLabels.get('LIQUID'))){
                Decimal blkunitprice=price/tonToLb;
                cartItem.ccrz__SubAmount__c = blkunitprice * quantity;
            }else{
                 cartItem.ccrz__SubAmount__c = price * quantity;
            }
            //2752
            if(bagPrice != null) {
                cartItem.cc_oo_OriginalBagPrice__c = Decimal.valueOf(bagPrice);
            } 
            
            if(palletPrice != null) {
                cartItem.cc_oo_OriginalPalletPrice__c = Decimal.valueOf(palletPrice);
            }  
            //2752                    
            cartItem.ccrz__UnitOfMeasure__c = productCategory[0].ccrz__UnitOfMeasure__c;
            cartItem.ccrz__ProductType__c = productCategory[0].ccrz__ProductType__c;
            cartItem.ccrz__RequestDate__c = Date.today();
            cartItem.cc_oo_ContractPrice__c = contractId;
            
            if(cloneCartItem != null) {
                cartItem.cc_oo_JDELineNumber__c = cloneCartItem.cc_oo_JDELineNumber__c;
                cartItem.cc_oo_LineNumberId__c = cloneCartItem.cc_oo_LineNumberId__c;
                cartItem.cc_oo_OriginalCartItem__c = cloneCartItem.cc_oo_OriginalCartItem__c;
            }
            /*if(highestCount != 0){//OO-1772 -starts
                cartItem.cc_oo_webLineNumber__c = highestCount;
            }//OO-1772 -ends*/
            insert cartItem;
            
            
        }
        catch(Exception ex){            
            CreateErrorLog(ex, CLASS_NAME, 'addNewCartItem');   
        }
    }
    
        //OO-215 - Bean for the ShipTo
    public class cc_oo_ShipToBean {
        public String shipToId{get; set;}
        public String shipToStreet{get; set;}
        public String shipToCity{get; set;}
        public String shipToState{get; set;}
        public String shipToCountry{get; set;}
        public String shipToPostalCode{get; set;}
        //US - 143 - to implement filter
        public String consolidateShipto{get; set;}
    }
    
    //OO-215 - Bean for the ShipTo
    public class cc_oo_SellerBean {
        public String sellerSFId{get; set;}
        public String sellerId{get; set;}
        public String sellerName{get; set;}
        public String sellerShortDesc{get; set;}
        //OO-81 The address must be listed for each plant available in the plant selection screen.  
        public String sellerAddresLine1{get; set;}
        public String sellerAddresLine2{get; set;}
        public String sellerCity{get; set;}
        public String sellerState{get; set;}
        public String sellerPostalCode{get; set;}
        //US - 143 - to implement filter
        public String consolidateSeller{get; set;}
    }
    
    //OO-215 - Bean for the ShipTo
    public class cc_oo_ShipToSellerBean {
        public String sellerName{get; set;}
        public String shipToName{get; set;}
        public String shipToId{get; set;}
        public String sellerId{get; set;}
    }
    
    /***************************************************************************************************************************************
      Method Name : getSellersAll
      Description : getSellersAll is to add ship to and ship from in Cart page and My Orders page
      Parameter   : shipToCode
      Return type : Returns Boolean .
      UserStory   : OO-1447 - To show ship to and ship from in filter section of cart page and my orders page                                                              
                    
      *************************************************************************************************************************************/
    
    public static Map<String,boolean> getSellersAll(String shipToCode){
        integer shipToCodeNumber = Integer.valueOf(shipToCode);
        List<cc_oo_SellerBean> listSellers = new List<cc_oo_SellerBean>();  
   try{ 
        //OO-81 The address must be listed for each plant available in the plant selection screen.  
        map<string, CC_OO_Customer_Freight__c> mapUniqueFreights = new map<string,CC_OO_Customer_Freight__c>();
        for(CC_OO_Customer_Freight__c sellerFreight: [select id, name, Plant_Name__c, Plant_Name__r.id, Plant_Name__r.Name,
                            Plant_Name__r.ccrz__Storefront__c, Plant_Name__r.ccrz__SellerId__c, Plant_Name__r.ccrz__ShortDesc__c, 
                            Plant_Name__r.cc_oo_Address_Line_1__c,Plant_Name__r.cc_oo_Address_Line_2__c,Plant_Name__r.cc_oo_City__c,Plant_Name__r.cc_oo_State__c,Plant_Name__r.cc_oo_Zip__c
                            from CC_OO_Customer_Freight__c where ShipTo_Account_Number__c =: shipToCodeNumber and 
                            Plant_Name__r.ccrz__Storefront__c = 'PurinaMills' and Plant_Name__r.ccrz__Enabled__c = true]){                            
                                mapUniqueFreights.put(sellerFreight.Plant_Name__r.ccrz__SellerId__c,sellerFreight);
                            }  
        
        String EMPTY = '';   
        cc_oo_SellerBean newSeller;
        for(CC_OO_Customer_Freight__c sellerFreigtItem : mapUniqueFreights.values()){

            newSeller = new cc_oo_SellerBean(); 
            newSeller.sellerSFId = sellerFreigtItem.Plant_Name__r.id;
            newSeller.sellerId = sellerFreigtItem.Plant_Name__r.ccrz__SellerId__c;
            newSeller.sellerName = sellerFreigtItem.Plant_Name__r.Name;
            newSeller.sellerShortDesc = sellerFreigtItem.Plant_Name__r.ccrz__ShortDesc__c;
            //OO-81 The address must be listed for each plant available in the plant selection screen.  
            newSeller.sellerAddresLine1 = sellerFreigtItem.Plant_Name__r.cc_oo_Address_Line_1__c;
            newSeller.sellerAddresLine2 = sellerFreigtItem.Plant_Name__r.cc_oo_Address_Line_2__c;
            newSeller.sellerCity = sellerFreigtItem.Plant_Name__r.cc_oo_City__c;
            newSeller.sellerState = sellerFreigtItem.Plant_Name__r.cc_oo_State__c;
            newSeller.sellerPostalCode = sellerFreigtItem.Plant_Name__r.cc_oo_Zip__c;
            //US - 143 - to implement filter
            newSeller.consolidateSeller = (newSeller.sellerId == null ? EMPTY : newSeller.sellerId) +' ' + (newSeller.sellerName == null ? EMPTY : newSeller.sellerName) + ' ' ;
            newSeller.consolidateSeller += (newSeller.sellerAddresLine1 == null ? EMPTY : newSeller.sellerAddresLine1) + ',' + (newSeller.sellerAddresLine2 == null ? EMPTY : newSeller.sellerAddresLine2) + ',' + (newSeller.sellerCity == null ? EMPTY : newSeller.sellerCity) +',' + (newSeller.sellerState == null ? EMPTY : newSeller.sellerState) +',';
            newSeller.consolidateSeller += (newSeller.sellerPostalCode ==  null ? EMPTY : newSeller.sellerPostalCode);
            listSellers.add(newSeller);
        } 
        
        //OO-210 - Start - To prevent user from creating more than one prebook commitment for same ship-to
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'Shp to code-->' + shipToCode);        
        Id userId = ccrz.cc_CallContext.currUser.Id; 
        
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'Logged User-->' + userId);                  
        List<ccrz__E_Order__c> orderDetails = [SELECT Id, ccrz__OriginatedCart__c,ccrz__OriginatedCart__r.cc_oo_ShipToAccount__c,ccrz__ShipTo__c  from ccrz__E_Order__c WHERE ccrz__OriginatedCart__c IN (SELECT Id FROM ccrz__E_Cart__c WHERE cc_oo_ShipToAccount__r.AccountNumber =:shipToCode) AND ccrz__User__c =:userId ];
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'order Details-->' + orderDetails);
        
       if(!orderDetails.isEmpty()){
            Id activeCart = orderDetails[0].ccrz__OriginatedCart__c;
            Id shippingAccount = orderDetails[0].ccrz__OriginatedCart__r.cc_oo_ShipToAccount__c;
            List<ccrz__E_CartItem__c> listCartItemsToDelete = new List<ccrz__E_CartItem__c>();
            for(ccrz__E_Cart__c cartItem: [select id,(select id from ccrz__E_CartItems__r) from ccrz__E_Cart__c where id !=: activeCart and cc_oo_ShipToAccount__c =: shippingAccount and ccrz__CartStatus__c != 'Closed' 
                                                and cc_oo_CartType__c = 'Prebook'
                                                ]){
                listCartItemsToDelete.addAll(cartItem.ccrz__E_CartItems__r);
            }

            if(!listCartItemsToDelete.isEmpty()){
                delete listCartItemsToDelete;
            }
        }              
    
       }catch(exception ex){
            CreateErrorLog(ex, CLASS_NAME, 'getSellersAll'); 
        }       
                                    
       
       return null; 
    }
    
/*public static ccrz__E_CartItem__c addNewCartListItem( String skuId, Integer quantity,String cartGUID, Decimal price){
         
        ccrz__E_CartItem__c cartItem; 
        ccrz__E_CartItem__c cartItemobj;
        try{
            List<ccrz__E_Product__c> productCategory=[SELECT Id,ccrz__UnitOfMeasure__c
                                    , ccrz__ProductType__c   
                                    FROM ccrz__E_Product__c WHERE ccrz__SKU__c =:skuId LIMIT 1]; 
            
            Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'pageparams'+pageParams.get('sid'));
            String sellerId = null;
            if(pageParams != null){
                sellerId = pageParams.get('sid');
                System.debug('sellerid'+sellerId);
            }
            Id accGroup = ccrz.cc_CallContext.currAccountGroup.Id;       
            User user = ccrz.cc_CallContext.currUser;
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'Creating new Cart Item');
            cartItem = new ccrz__E_CartItem__c();
            cartItem.ccrz__Cart__c = cartGUID;
            cartItem.ccrz__StoreID__c = ccrz.cc_CallContext.storefront;
            cartItem.ccrz__Product__c = productCategory[0].Id;
            cartItem.ccrz__Seller__c = sellerId;
            cartItem.ccrz__Quantity__c = quantity;
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'quantity------->'+quantity);
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'cartItem.ccrz__Quantity__c ------->'+cartItem.ccrz__Quantity__c);
            cartItem.ccrz__Price__c = price;
            cartItem.cc_oo_UnitPrice__c = price;
            cartItem.cc_oo_IsListPrice__c = true;
            cartItem.ccrz__SubAmount__c = price * quantity;
            cartItem.ccrz__UnitOfMeasure__c = productCategory[0].ccrz__UnitOfMeasure__c;
            cartItem.ccrz__ProductType__c = productCategory[0].ccrz__ProductType__c;
            cartItem.ccrz__RequestDate__c = Date.today();
            insert cartItem;
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'new cartItem ID ------->'+cartItem.id);
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'new cartItem ID  quantity------->'+cartItem.ccrz__Quantity__c);
            cartItemobj= [select id,ccrz__Product__r.name,ccrz__Product__r.Id,ccrz__Product__r.ccrz__SKU__c,ccrz__Quantity__c,cc_oo_IsListPrice__c,
                            ccrz__SubAmount__c,ccrz__UnitOfMeasure__c,ccrz__ProductType__c,ccrz__RequestDate__c,
                            ccrz__Product__c,ccrz__Category__c,ccrz__Cart__c,ccrz__StoreID__c,ccrz__Price__c,
                            cc_oo_UnitPrice__c from ccrz__E_CartItem__c where id =: cartItem.id];
        }
        catch(Exception ex){
            CreateErrorLog(ex, CLASS_NAME, 'addNewCartListItem');
        }
        
      return cartItemobj;
    }*/
    
    /***************************************************************************************************************************************
      Method Name : updateJDEOrderNumber
      Description : updateJDEOrderNumber is to update the JDE Order number
      Parameter   : orders 
                    orders is the Order object
      Return type : String.
                    
      *************************************************************************************************************************************/ 
   public static String updateJDEOrderNumber(ccrz__E_Order__c orders) {
    
            cc_oo_JDERetrieveNextOrderRequest.Params paramsReq = new cc_oo_JDERetrieveNextOrderRequest.Params(); 

            cc_oo_JDERetrieveNextOrderRequest.CallMethod callMethodReq = new cc_oo_JDERetrieveNextOrderRequest.CallMethod();
            callMethodReq.replacetokenapp = 'JDEXe';
            callMethodReq.replacetokenname = 'RetreiveNextOrderNumber';
            callMethodReq.params = paramsReq;
            
            cc_oo_JDERetrieveNextOrderRequest orderReq = new cc_oo_JDERetrieveNextOrderRequest();
            orderReq.replacetokentype = 'callmethod';
            orderReq.callMethod = callMethodReq;
           
            cc_oo_serviceResponse resp = cc_oo_ServiceRetrieveOrderCallOut.getNextOrderNumber(orderReq);
            cc_oo_JDERetrieveNextOrderResponse jdeResponse = null;
            String stringResp='';
            if(resp != null && resp.response != null) {
                stringResp = resp.response.getBody();
                if(String.isNotBlank(stringResp)) {
                    jdeResponse = cc_oo_JDERetrieveNextOrderResponse.parse(stringResp);
                }
            }
            if(jdeResponse != null){
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'Piyali debug' + String.valueof(jdeResponse.callMethod.Params.mnOrderNumber));
                //System.debug('Piyali debug' + String.valueof(resp.callMethod.Params.mnOrderNumber));
                return String.valueof(jdeResponse.callMethod.Params.mnOrderNumber);
            }else if(resp != null && String.isNotBlank(resp.errorMsg)){
                return null;
            } else {
                return null;
            }
   } 
   
   /***************************************************************************************************************************************
      Method Name : createCancelOrderRequest
      Description : createCancelOrderRequest is to create the request structure for the Cancel order API
      Parameter   : orders , orderItems
                    orders is the Order object
                    orderItems is the Individual order item of an order
      Return type : cc_oo_JDESyncOrderRequest - Order request structure.
                    
      *************************************************************************************************************************************/
    public static cc_oo_JDECancelOrderRequest createCancelOrderRequest(string jdeOrderNumber) {
        ccrz__E_Order__c orders = [select Id, Name, cc_oo_JDEDocumentID__c, cc_oo_JDEOrderNumber__c
                                                from ccrz__E_Order__c where cc_oo_JDEOrderNumber__c =: jdeOrderNumber and ccrz__OrderStatus__c != 'Amended'LIMIT 1];
        
        // Document Set Id----
        cc_oo_JDECancelOrderRequest.IDObj documentId = new cc_oo_JDECancelOrderRequest.IDObj();
        documentId.replacetokentypeCode = 'batchNumber';
        documentId.replaceDollar = String.valueOf(orders.Name);
        
        cc_oo_JDECancelOrderRequest.IDObj documentIdBatch = new cc_oo_JDECancelOrderRequest.IDObj();
        documentIdBatch.replacetokentypeCode = 'docNumber';
        //documentIdBatch.replaceDollar = String.valueOf(orders.cc_oo_JDEDocumentID__c);//Cancel Order DocNumber issue
        //Cancel Order DocNumber issue - creating new DocNumber
        if(LOLSettings__c.getValues('CancelOrderDocNumber') != null){
            Integer maskNumber = Integer.valueOf(LOLSettings__c.getValues('CancelOrderDocNumber').Value__c);
            Integer finalDocNumber = maskNumber - Integer.valueOf(orders.cc_oo_JDEDocumentID__c);
            documentIdBatch.replaceDollar = String.valueOf(finalDocNumber);
        }//Cancel Order DocNumber issue - creating new DocNumber   

        List<cc_oo_JDECancelOrderRequest.IDObj> documentIdList = new List<cc_oo_JDECancelOrderRequest.IDObj>();
        documentIdList.add(documentId);
        documentIdList.add(documentIdBatch);
        
        cc_oo_JDECancelOrderRequest.DocumentIDSet finaldocumentId = new cc_oo_JDECancelOrderRequest.DocumentIDSet();
        finaldocumentId.IDObj = documentIdList;
        
        List<cc_oo_JDECancelOrderRequest.DocumentIDSet> finaldocumentIdList = new List<cc_oo_JDECancelOrderRequest.DocumentIDSet>();
        finaldocumentIdList.add(finaldocumentId);
        
        //PurchaseOrderHeader ----
        cc_oo_JDECancelOrderRequest.PurchaseOrderHeader purchaseHeaderReq = new cc_oo_JDECancelOrderRequest.PurchaseOrderHeader();
        purchaseHeaderReq.DocumentIDSet = finaldocumentIdList;

        //Exprssion ----
        List<cc_oo_JDECancelOrderRequest.ActionExpression> actionExpressionList = new List<cc_oo_JDECancelOrderRequest.ActionExpression>();
        cc_oo_JDECancelOrderRequest.ActionExpression actionExpression = new cc_oo_JDECancelOrderRequest.ActionExpression();            
        string actionExpressionDollarHeader = LOLSettings__c.getValues('JDEAmendOdrerExpHeader').Value__c;                                  
        actionExpression.replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderDelete').value__c;//'Cancel';
        actionExpression.replaceDollar = actionExpressionDollarHeader;
        actionExpressionList.add(actionExpression);
        cc_oo_JDECancelOrderRequest.ActionCriteria actionCriteria = new cc_oo_JDECancelOrderRequest.ActionCriteria();
        actionCriteria.ActionExpression = actionExpressionList;
        
        //Sync changes ----
        cc_oo_JDECancelOrderRequest.Sync syncReq = new cc_oo_JDECancelOrderRequest.Sync();
        syncReq.ActionCriteria = new List<cc_oo_JDECancelOrderRequest.ActionCriteria>{actionCriteria};

        //PurchaseHeader ----
        cc_oo_JDECancelOrderRequest.PurchaseOrder purchaseOrderReq = new cc_oo_JDECancelOrderRequest.PurchaseOrder();
        purchaseOrderReq.replacetokentypeCode = cc_oo_ServiceData__c.getValues('orderCancel').cc_oo_Type__c;
        purchaseOrderReq.purchaseOrderHeader = purchaseHeaderReq;
        
        cc_oo_JDECancelOrderRequest.DataArea dataAreaReq = new cc_oo_JDECancelOrderRequest.DataArea();
        dataAreaReq.PurchaseOrder = new List<cc_oo_JDECancelOrderRequest.PurchaseOrder>{purchaseOrderReq};
        dataAreaReq.Sync = syncReq;
                        
        cc_oo_JDECancelOrderRequest cancelReq = new cc_oo_JDECancelOrderRequest();
        cancelReq.DataArea = dataAreaReq;
        
        return cancelReq;
    }
   
   /***************************************************************************************************************************************
      Method Name : syncOrderToJDE
      Description : syncOrderToJDE is to sync the JDE with the SFDC Order detail
      Parameter   : orders , orderItems
                    orders is the Order object
                    orderItems is the Individual order item of an order
      Return type : Boolean.
                    
      *************************************************************************************************************************************/
    public static Boolean syncOrderToJDE(ccrz__E_Order__c orders, List<ccrz__E_OrderItem__c> orderItems, String jdeOrderNumber, string portalUser) {             
        
        cc_oo_JDESyncOrderRequest syncReq = createRequest(orders, orderItems, jdeOrderNumber, portalUser);
        
        cc_oo_serviceResponse resp = cc_oo_ServiceSyncOrderCallOut.syncOrder(syncReq);
        cc_oo_JDESyncOrderResponse jdeResponse = null;
        String stringResp='';
        if(resp != null && resp.response != null) {
            stringResp = resp.response.getBody();
            if(String.isNotBlank(stringResp)) {
                jdeResponse = cc_oo_JDESyncOrderResponse.parse(stringResp);
            }
        }
        if(jdeResponse != null && jdeResponse.status == 'success'){
            return true;
        }else if(resp != null && String.isNotBlank(resp.errorMsg)){
            return false;
        } else {
            return false;
        }
   }
   
   /***************************************************************************************************************************************
      User Story  : 1772
      Method Name : modifyOrderToJDE
      Description : modifyOrderToJDE is to modify the JDE with the SFDC Order detail
      Parameter   : orders , orderItems
                    orders is the Order object
                    orderItems is the Individual order item of an order
      Return type : Boolean.
                    
      *************************************************************************************************************************************/
   public static Boolean modifyOrderToJDE(ccrz__E_Order__c orders, List<ccrz__E_OrderItem__c> orderItems, ccrz__E_Order__c oldOrder, String jdeOrderNumber, Id curentCartId, Id originalCartId) {
        cc_oo_JDEModifyOrderRequest modifyReq = createModifyOrderRequest(orders, orderItems, oldOrder, jdeOrderNumber, curentCartId, originalCartId);
        boolean status = cc_oo_ServiceModifyOrderCallOut.modifyOrder(modifyReq,jdeOrderNumber);

        if(status == true){
            return true;
        }
        return false;
   }  
   private static cc_oo_JDEModifyOrderRequest createModifyOrderRequest(ccrz__E_Order__c orders, List<ccrz__E_OrderItem__c> orderItems,ccrz__E_Order__c oldOrder, String jdeOrderNumber, Id curentCartId, Id originalCartId) {

    //Pull CartItem details from both current and Original carts
    Map<id,ccrz__E_CartItem__c> mapOldCartItems = new Map<id,ccrz__E_CartItem__c>();
    Map<id,Id> mapNewOldIds = new Map<id,Id>();
    Map<id,ccrz__E_CartItem__c> mapNewCartItems = new Map<id,ccrz__E_CartItem__c>();
    for(ccrz__E_CartItem__c cartItem : [select id, ccrz__Cart__c,Name, ccrz__cartItemType__c, ccrz__Comments__c, cc_oo_webLineNumber__c,cc_oo_JDELineNumber__c, cc_oo_OriginalCartItem__c, cc_oo_IsListPrice__c, cc_oo_TotalWieght__c, cc_oo_ContractPrice__c, ccrz__Product__c, ccrz__Product__r.ccrz__SKU__c,
                            cc_oo_ContractPrice__r.cc_oo_ContractNumber__c, cc_oo_UnitPrice__c,ccrz__Price__c, ccrz__Quantity__c, ccrz__UnitOfMeasure__c from ccrz__E_CartItem__c where ccrz__Cart__c =: curentCartId OR ccrz__Cart__c =: originalCartId]){
        if(originalCartId == cartItem.ccrz__Cart__c){
            mapOldCartItems.put(cartItem.Id, cartItem);
        }else if(curentCartId == cartItem.ccrz__Cart__c){
            mapNewCartItems.put(cartItem.Id, cartItem);
            mapNewOldIds.put(cartItem.Id, cartItem.cc_oo_OriginalCartItem__c);
        }
    }
    //Pull CartItem details from both current and Original carts - Ends     
    //Get user's FedertionID
    User csruser = new User();
    User dealerUser = new User();
    
    Id contactId = ccrz.cc_CallContext.currContact.Id;
    string portalUser = ccrz.cc_CallContext.currPageParameters.get('portalUser');
    dealerUser = [select id, FederationIdentifier,Email,Contact.FirstName, Contact.LastName from User where contactId =: contactId];//OO-4466
    if(portalUser != null){
        csruser = [select id, FederationIdentifier from User where Id =: UserInfo.getUserId()];
    }

    // Document Set Id
    cc_oo_JDEModifyOrderRequest.DocumentID documentId = new cc_oo_JDEModifyOrderRequest.DocumentID();
    documentId.replacetokentypeCode = 'batchNumber';
    documentId.replaceDollar = String.valueOf(orders.Name);
    
    cc_oo_JDEModifyOrderRequest.DocumentID documentIdBatch = new cc_oo_JDEModifyOrderRequest.DocumentID();
    documentIdBatch.replacetokentypeCode = 'docNumber';
    documentIdBatch.replaceDollar = String.valueOf(orders.cc_oo_JDEDocumentID__c);
    
    cc_oo_JDEModifyOrderRequest.DocumentID documentIdPONumber = new cc_oo_JDEModifyOrderRequest.DocumentID();
    documentIdPONumber.replacetokentypeCode = 'customerPONumber';
    if(String.isNotBlank(orders.ccrz__PONumber__c)) {
        documentIdPONumber.replaceDollar = String.valueOf(orders.ccrz__PONumber__c);
    } else {
        documentIdPONumber.replaceDollar = '';
    }

    List<cc_oo_JDEModifyOrderRequest.DocumentID> documentIdList = new List<cc_oo_JDEModifyOrderRequest.DocumentID>();
    documentIdList.add(documentId);
    documentIdList.add(documentIdBatch);
    documentIdList.add(documentIdPONumber);
    
    cc_oo_JDEModifyOrderRequest.DocumentIDSet finaldocumentId = new cc_oo_JDEModifyOrderRequest.DocumentIDSet();
    finaldocumentId.ID = documentIdList;
    
    List<cc_oo_JDEModifyOrderRequest.DocumentIDSet> finaldocumentIdList = new List<cc_oo_JDEModifyOrderRequest.DocumentIDSet>();
    finaldocumentIdList.add(finaldocumentId);


    //cc_oo_JDEModifyOrderRequest.Status status = new cc_oo_JDEModifyOrderRequest.Status();
    //status.Description = orders.ccrz__Note__c;//'1017190823';
    //status.EffectiveTimePeriod = effectiveTimePeriod; // Not required as part of Sync Order API
    
    cc_oo_JDEModifyOrderRequest.PersonName personName = new cc_oo_JDEModifyOrderRequest.PersonName();
    if(dealerUser.FederationIdentifier != null){
        personName.FormattedName = dealerUser.FederationIdentifier;//userInfo.getFirstName() + ' ' + userInfo.getLastName();
    }
    
    List<cc_oo_JDEModifyOrderRequest.PersonName> personNameList = new List<cc_oo_JDEModifyOrderRequest.PersonName>();
    personNameList.add(personName);
    
    cc_oo_JDEModifyOrderRequest.Contact contact = new cc_oo_JDEModifyOrderRequest.Contact();
    contact.PersonName = personNameList;
    
    List<cc_oo_JDEModifyOrderRequest.Contact> contactList = new List<cc_oo_JDEModifyOrderRequest.Contact>();
    contactList.add(contact);
    
    cc_oo_JDEModifyOrderRequest.LocationCustomer locationCustomer = new cc_oo_JDEModifyOrderRequest.LocationCustomer();
    locationCustomer.Contact = contactList;
    
    List<cc_oo_JDEModifyOrderRequest.LocationCustomer> locationCustomerList = new List<cc_oo_JDEModifyOrderRequest.LocationCustomer>();
    locationCustomerList.add(locationCustomer);
    
    cc_oo_JDEModifyOrderRequest.CustomerParty customerParty = new cc_oo_JDEModifyOrderRequest.CustomerParty();
    customerParty.Location = locationCustomerList;
    
    //Ship To Party Details - Starts
    cc_oo_JDEModifyOrderRequest.ShipToParty shipToReq = new cc_oo_JDEModifyOrderRequest.ShipToParty();
    //List<String> IDList = new List<String>();
    //IDList.add(orders.cc_oo_ShipToAccount__r.AccountNumber);
    
    /*cc_oo_JDEModifyOrderRequest.Location locationReq = new cc_oo_JDEModifyOrderRequest.Location();
    locationReq.ID = IDList;
    List<cc_oo_JDEModifyOrderRequest.Location> locationList = new List<cc_oo_JDEModifyOrderRequest.Location>();
    locationList.add(locationReq);*/
    
    shipToReq.ID = String.valueOf(orders.cc_oo_ShipToAccount__r.AccountNumber);//new List<String>{LoLSettings__c.getValues('JDEShipToPartyId').value__c};
    //shipToReq.location = locationList;
    //Ship To Party Details - Ends

    cc_oo_JDEModifyOrderRequest.BillToParty billToReq = new cc_oo_JDEModifyOrderRequest.BillToParty();
    List<String> BillIDList = new List<String>();
    if(orders.cc_oo_ShipToAccount__r.BillTo_Flag__c){
        BillIDList.add(orders.cc_oo_ShipToAccount__r.AccountNumber);
    } else {
        BillIDList.add(orders.cc_oo_ShipToAccount__r.BillTo_Account__r.AccountNumber);
    }       
    
    cc_oo_JDEModifyOrderRequest.BillToLocation billLocationReq = new cc_oo_JDEModifyOrderRequest.BillToLocation();
    billLocationReq.Note = new List<string>{ dealerUser.Email + ' | ' + dealerUser.Contact.FirstName + ' ' + dealerUser.Contact.LastName };//OO-4466 //BillIDList;
    List<cc_oo_JDEModifyOrderRequest.BillToLocation> billLocationList = new List<cc_oo_JDEModifyOrderRequest.BillToLocation>();
    billLocationList.add(billLocationReq);
    
    billToReq.ID = BillIDList;//new List<String>{LoLSettings__c.getValues('JDEShipToPartyId').value__c};//BillIDList;
    billToReq.Location = billLocationList;
    
    //Shipping Method - starts
    cc_oo_JDEModifyOrderRequest.TransportationTerm transportationTerm = new cc_oo_JDEModifyOrderRequest.TransportationTerm();
    if(orders.ccrz__ShipMethod__c != null && orders.ccrz__ShipMethod__c != '') {
        if(orders.ccrz__ShipMethod__c.contains(LOLSettings__c.getValues('Delivery').Value__c)){
            transportationTerm.replacetokentypeCode = LOLSettings__c.getValues('DeliveryFreigtCode').Value__c;
            //transportationTerm.FreightTermCode = 'M1';
        }else if(orders.ccrz__ShipMethod__c.contains(LOLSettings__c.getValues('Pickup').Value__c)){
            transportationTerm.replacetokentypeCode = LOLSettings__c.getValues('PickupFreigtCode').Value__c;
            //transportationTerm.FreightTermCode = 'M3';
        }
    }//Shipping Method - ends
    
    List<cc_oo_JDEModifyOrderRequest.TransportationTerm> transportationTermList = new List<cc_oo_JDEModifyOrderRequest.TransportationTerm>(); 
    transportationTermList.add(transportationTerm); 
    
    //Buyer Part details
    /*List<String> buyerPartyIDList = new List<String>();
    if(csruser.FederationIdentifier != null && portalUser != null && portalUser != ''){
        buyerPartyIDList.add(csruser.FederationIdentifier);
    }*/
    
    cc_oo_JDEModifyOrderRequest.BuyerParty buyerParty = new cc_oo_JDEModifyOrderRequest.BuyerParty(); 
    if(csruser.FederationIdentifier != null && portalUser != null && portalUser != ''){
        buyerParty.ID = csruser.FederationIdentifier;
    }   
    
    //Ship-From Party Details - Starts
    //List<string> listShipFrom = new List<string>();
    //listShipFrom.add(orders.cc_oo_Seller__r.ccrz__SellerId__c);
    cc_oo_JDEModifyOrderRequest.ShipFromParty shipFromParty = new cc_oo_JDEModifyOrderRequest.ShipFromParty(); 
    ShipFromParty.ID = LoLSettings__c.getValues('JDEShipFromPartyId').value__c;//listShipFrom;//OO-3959

    cc_oo_JDEModifyOrderRequest.Location locationReqShipFrom = new cc_oo_JDEModifyOrderRequest.Location();
    locationReqShipFrom.ID = String.valueOf(orders.cc_oo_Seller__r.ccrz__SellerId__c);
    List<cc_oo_JDEModifyOrderRequest.Location> locationListShipFrom = new List<cc_oo_JDEModifyOrderRequest.Location>();
    locationListShipFrom.add(locationReqShipFrom);
    ShipFromParty.Location = locationListShipFrom;
    
    List<cc_oo_JDEModifyOrderRequest.ShipFromParty> shipFromPartyList = new List<cc_oo_JDEModifyOrderRequest.ShipFromParty>();
    shipFromPartyList.add(shipFromParty);
    //Ship-From Party Details - Ends

    cc_oo_JDEModifyOrderRequest.SalesOrderReference salesOrderReference = new cc_oo_JDEModifyOrderRequest.SalesOrderReference(); 
    salesOrderReference.ID = new List<string>{jdeOrderNumber};

    cc_oo_JDEModifyOrderRequest.PurchaseOrderHeader purchaseHeaderReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrderHeader();
    purchaseHeaderReq.ID = jdeOrderNumber;
    purchaseHeaderReq.DocumentIDSet = finaldocumentIdList;
    purchaseHeaderReq.LastModificationDateTime = String.valueOf(orders.LastModifiedDate.Date());
    purchaseHeaderReq.Description = String.valueOf(orderItems[0].ccrz__Product__r.cc_oo_TypeOfProduct__c).toUpperCase();
    //purchaseHeaderReq.Status = status;
    purchaseHeaderReq.CustomerParty = customerParty;
    purchaseHeaderReq.ShipToParty = shipToReq;
    purchaseHeaderReq.BillToParty = billToReq;
    purchaseHeaderReq.TransportationTerm = transportationTermList;
    if(String.isNotBlank(orders.cc_oo_PickUpTime__c) && orders.cc_oo_PickUpTime__c != '{}') {
        purchaseHeaderReq.RequestedShipDateTime = String.valueOf(orders.ccrz__RequestDate__c) + ' ' + orders.cc_oo_PickUpTime__c;
    } else {
        String pickUpTime = '00:00';
        purchaseHeaderReq.RequestedShipDateTime = String.valueOf(orders.ccrz__RequestDate__c) + ' ' + pickUpTime;
    }
    
    purchaseHeaderReq.PaymentMethodCode = String.valueOf(orders.ccrz__PONumber__c);
    //string comments = '\n' + orders.ccrz__Note__c;//OO-4469
    //purchaseHeaderReq.ShippingInstructions = orders.cc_oo_ShipToAccount__r.Delivery_Instruction_1__c + comments;//OO-4469
    purchaseHeaderReq.ShippingInstructions = orders.cc_oo_ShipToAccount__r.Delivery_Instruction_1__c;//'ShippingInstructions Junemonth 1 WAREHOUS';
    purchaseHeaderReq.OrderDateTime = String.valueOf(orders.CreatedDate);
    purchaseHeaderReq.Note = orders.ccrz__Note__c;
    purchaseHeaderReq.BuyerParty = buyerParty;
    purchaseHeaderReq.ShipFromParty = shipFromPartyList;
    purchaseHeaderReq.SalesOrderReference = salesOrderReference;
    //purchaseHeaderReq.PickUpTime = String.valueOf(orders.cc_oo_PickUpTime__c);//US:1973
    List<cc_oo_JDEModifyOrderRequest.PurchaseOrderLine> purchaseLineList = new List<cc_oo_JDEModifyOrderRequest.PurchaseOrderLine>();
    string reasonCode = LOLSettings__c.getValues('ReasonCode').Value__c;
    set<Id> existingOldCartItems = new set<Id>();
    
    List<cc_oo_JDEModifyOrderRequest.ActionExpression> actionExpressionList = new List<cc_oo_JDEModifyOrderRequest.ActionExpression>();
    string actionExpressionDollarHeader = LOLSettings__c.getValues('JDEAmendOdrerExpHeader').Value__c;
    string actionExpressionDollarLine = LOLSettings__c.getValues('JDEAmendOdrerExpLine').Value__c;

    cc_oo_JDEModifyOrderRequest.ActionExpression actionExpressionHeader = new cc_oo_JDEModifyOrderRequest.ActionExpression(); 
    actionExpressionHeader.replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderChange').value__c;
    actionExpressionHeader.replaceDollar = actionExpressionDollarHeader;
    actionExpressionList.add(actionExpressionHeader);
    Map<string,integer> mapSkuActionCode = new Map<string,integer>();//OO-5228
    Integer i = 1;
        for(ccrz__E_CartItem__c orderItem : mapNewCartItems.values()){ 

            cc_oo_JDEModifyOrderRequest.PurchaseOrderLine purchaseLineReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrderLine();
            //purchaseLineReq.lineNumberID = '' ;
            
            cc_oo_JDEModifyOrderRequest.Item itemReq = new cc_oo_JDEModifyOrderRequest.Item();
            itemReq.ID = orderItem.ccrz__Product__r.ccrz__SKU__c;//orderItem.Name;
            itemReq.Note = orderItem.ccrz__Comments__c;
            
            List<cc_oo_JDEModifyOrderRequest.Item> itemList = new List<cc_oo_JDEModifyOrderRequest.Item>();
            itemList.add(itemReq);
            
            purchaseLineReq.item = itemList;
            
            cc_oo_JDEModifyOrderRequest.Quantity quantityref = new cc_oo_JDEModifyOrderRequest.Quantity();
            quantityref.replacetokenunitCode = orderItem.ccrz__UnitOfMeasure__c;
            quantityref.replaceDollar = String.valueOf(orderItem.ccrz__Quantity__c);
            
            List<cc_oo_JDEModifyOrderRequest.Quantity> quantityList = new List<cc_oo_JDEModifyOrderRequest.Quantity>();
            quantityList.add(quantityref);           
            purchaseLineReq.quantity = quantityList;
            
            cc_oo_JDEModifyOrderRequest.UnitPrice unitPriceReq = new cc_oo_JDEModifyOrderRequest.UnitPrice();
            //unitPriceReq.ID = orderItem.ccrz__UnitOfMeasure__c;
            unitPriceReq.chargeAmount = String.valueOf(orderItem.ccrz__Price__c);
            purchaseLineReq.unitPrice = unitPriceReq;
            
            cc_oo_JDEModifyOrderRequest.ContractReference contractReferenceReq = new cc_oo_JDEModifyOrderRequest.ContractReference();
            contractReferenceReq.ID = String.valueOf(orderItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c);
            purchaseLineReq.contractReference = contractReferenceReq;
            
            cc_oo_JDEModifyOrderRequest.AmountDiscount amountDiscountReq = new cc_oo_JDEModifyOrderRequest.AmountDiscount();
            List<String> idAmountList = new List<String>();
            amountDiscountReq.ID = idAmountList ;
            amountDiscountReq.percentage = '';
            amountDiscountReq.description = idAmountList ;
            
            cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine purchaseOrderSublineReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine();
            purchaseOrderSublineReq.amountDiscount = amountDiscountReq;
            
            List<cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine> purchaseSubLineList = new List<cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine>();
            purchaseSubLineList.add(purchaseOrderSublineReq);
            purchaseLineReq.purchaseOrderSubLine = purchaseSubLineList;         

            cc_oo_JDEModifyOrderRequest.ActionExpression actionExpression = new cc_oo_JDEModifyOrderRequest.ActionExpression();            
            //contractReferenceReq.ID = cartItem.cc_oo_ContractPrice__c;
            purchaseLineReq.contractReference = contractReferenceReq;                   
            actionExpression.replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderChange').value__c;//'Change';

            actionExpression.replaceDollar = actionExpressionDollarLine + '[' + i + ']';
            
            cc_oo_JDEModifyOrderRequest.Status statusLn = new cc_oo_JDEModifyOrderRequest.Status();
            if(orderItem.cc_oo_OriginalCartItem__c != null){
                if(mapOldCartItems.get(orderItem.cc_oo_OriginalCartItem__c) != null){
                    if(mapOldCartItems.get(orderItem.cc_oo_OriginalCartItem__c).ccrz__Quantity__c > orderItem.ccrz__Quantity__c){
                        statusLn.ReasonCode = reasonCode;
                        //actionExpression.replacetokenactionCode = 'modify';
                    }
                    /*if(mapOldCartItems.get(orderItem.cc_oo_OriginalCartItem__c).cc_oo_IsListPrice__c != orderItem.cc_oo_IsListPrice__c){//OO-5258
                        statusLn.ReasonCode = reasonCode;
                        //actionExpression.replacetokenactionCode = 'modify';
                    }*///OO-5258
                    if(mapOldCartItems.get(orderItem.cc_oo_OriginalCartItem__c).ccrz__Comments__c != null && orderItem.ccrz__Comments__c == null){
                        itemReq.Note = ' ';
                    }
                }
            }
            else{
                //statusLn.ReasonCode = reasonCode;
                actionExpression.replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderAdd').value__c;//'Add';
                if(orderItem.cc_oo_ContractPrice__c != null){//OO-5228
                    mapSkuActionCode.put(orderItem.ccrz__Product__r.ccrz__SKU__c + '_' + orderItem.cc_oo_ContractPrice__c, i);//OO-5228
                }else{
                    mapSkuActionCode.put(orderItem.ccrz__Product__r.ccrz__SKU__c, i);//OO-5228
                }
            }

            actionExpressionList.add(actionExpression);
            //purchaseLineReq.item = itemReq;
            purchaseLineReq.Status = statusLn;
            if(orderItem.cc_oo_JDELineNumber__c != null){
                purchaseLineReq.lineNumberID = string.valueof(orderItem.cc_oo_JDELineNumber__c);
            }else{
                purchaseLineReq.lineNumberID = string.valueof(orderItem.cc_oo_webLineNumber__c);
            }
            purchaseLineList.add(purchaseLineReq);
            System.debug('purchaseLineList--->' + purchaseLineList);
            existingOldCartItems.add(orderItem.cc_oo_OriginalCartItem__c);
            System.debug('purchaseLineList--->' + purchaseLineList);
            i++;
        }
        for(ccrz__E_CartItem__c orderItem : mapOldCartItems.values()){ 
            if(!existingOldCartItems.contains(orderItem.Id)){
                //OO-5228
                string key = orderItem.ccrz__Product__r.ccrz__SKU__c;
                if(orderItem.cc_oo_ContractPrice__c != null){
                    key = key + '_' + orderItem.cc_oo_ContractPrice__c;
                }
                if(mapSkuActionCode.get(key) != null){
                    
                    integer index = mapSkuActionCode.get(key);
                    system.debug('actionExpressionList[index].replacetokenactionCode--->' + actionExpressionList[index].replacetokenactionCode);
                    actionExpressionList[index].replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderChange').value__c;
                    system.debug('actionExpressionList[index].replacetokenactionCode--->' + actionExpressionList[index].replacetokenactionCode);
                }//OO-5228
                else{
                    cc_oo_JDEModifyOrderRequest.PurchaseOrderLine purchaseLineReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrderLine();
                    //purchaseLineReq.lineNumberID = '' ;
                    
                    cc_oo_JDEModifyOrderRequest.Item itemReq = new cc_oo_JDEModifyOrderRequest.Item();
                    itemReq.ID = orderItem.ccrz__Product__r.ccrz__SKU__c;//orderItem.Name;
                    itemReq.Note = orderItem.ccrz__Comments__c;
                    
                    List<cc_oo_JDEModifyOrderRequest.Item> itemList = new List<cc_oo_JDEModifyOrderRequest.Item>();
                    itemList.add(itemReq);
                    
                    purchaseLineReq.item = itemList;
                    
                    cc_oo_JDEModifyOrderRequest.Quantity quantityref = new cc_oo_JDEModifyOrderRequest.Quantity();
                    quantityref.replacetokenunitCode = orderItem.ccrz__UnitOfMeasure__c;
                    quantityref.replaceDollar = String.valueOf(orderItem.ccrz__Quantity__c);
                    
                    List<cc_oo_JDEModifyOrderRequest.Quantity> quantityList = new List<cc_oo_JDEModifyOrderRequest.Quantity>();
                    quantityList.add(quantityref);           
                    purchaseLineReq.quantity = quantityList;
                    
                    cc_oo_JDEModifyOrderRequest.UnitPrice unitPriceReq = new cc_oo_JDEModifyOrderRequest.UnitPrice();
                    //unitPriceReq.ID = orderItem.ccrz__UnitOfMeasure__c;
                    unitPriceReq.chargeAmount = String.valueOf(orderItem.ccrz__Price__c);
                    purchaseLineReq.unitPrice = unitPriceReq;
                    
                    cc_oo_JDEModifyOrderRequest.ContractReference contractReferenceReq = new cc_oo_JDEModifyOrderRequest.ContractReference();
                    contractReferenceReq.ID = String.valueOf(orderItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c);
                    purchaseLineReq.contractReference = contractReferenceReq;
                    
                    cc_oo_JDEModifyOrderRequest.AmountDiscount amountDiscountReq = new cc_oo_JDEModifyOrderRequest.AmountDiscount();
                    List<String> idAmountList = new List<String>();
                    amountDiscountReq.ID = idAmountList ;
                    amountDiscountReq.percentage = '';
                    amountDiscountReq.description = idAmountList ;
                    
                    cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine purchaseOrderSublineReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine();
                    purchaseOrderSublineReq.amountDiscount = amountDiscountReq;
                    
                    List<cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine> purchaseSubLineList = new List<cc_oo_JDEModifyOrderRequest.PurchaseOrderSubLine>();
                    purchaseSubLineList.add(purchaseOrderSublineReq);
                    purchaseLineReq.purchaseOrderSubLine = purchaseSubLineList;         

                cc_oo_JDEModifyOrderRequest.ActionExpression actionExpression = new cc_oo_JDEModifyOrderRequest.ActionExpression();            
                //contractReferenceReq.ID = cartItem.cc_oo_ContractPrice__c;
                purchaseLineReq.contractReference = contractReferenceReq;                   
                actionExpression.replacetokenactionCode = LolSettings__c.getValues('JDEAmendOrderCancel').value__c;//'Cancel';

                actionExpression.replaceDollar = actionExpressionDollarLine + '[' + i + ']';
                
                cc_oo_JDEModifyOrderRequest.Status statusLn = new cc_oo_JDEModifyOrderRequest.Status();
                statusLn.ReasonCode = reasonCode;

                actionExpressionList.add(actionExpression);
                //purchaseLineReq.item = itemReq;
                purchaseLineReq.Status = statusLn;
                if(orderItem.cc_oo_JDELineNumber__c != null){
                    purchaseLineReq.lineNumberID = string.valueof(orderItem.cc_oo_JDELineNumber__c);
                }else{
                    purchaseLineReq.lineNumberID = string.valueof(orderItem.cc_oo_webLineNumber__c);
                }
                purchaseLineList.add(purchaseLineReq);
                System.debug('purchaseLineList--->' + purchaseLineList);
                existingOldCartItems.add(orderItem.cc_oo_OriginalCartItem__c);
                System.debug('purchaseLineList--->' + purchaseLineList);

                    i++;
                }
            }
        }
        
        cc_oo_JDEModifyOrderRequest.PurchaseOrder purchaseOrderReq = new cc_oo_JDEModifyOrderRequest.PurchaseOrder();
        purchaseOrderReq.replacetokentypeCode = cc_oo_ServiceData__c.getValues('ModifyOrder').cc_oo_Type__c;
        purchaseOrderReq.purchaseOrderHeader = new List<cc_oo_JDEModifyOrderRequest.PurchaseOrderHeader>{purchaseHeaderReq};
        purchaseOrderReq.purchaseOrderLine = purchaseLineList;
        
        cc_oo_JDEModifyOrderRequest.ActionCriteria actionCriteria = new cc_oo_JDEModifyOrderRequest.ActionCriteria();
        actionCriteria.ActionExpression = actionExpressionList;
        
        List<cc_oo_JDEModifyOrderRequest.ActionCriteria> actionCriteriaList = new List<cc_oo_JDEModifyOrderRequest.ActionCriteria>();
        actionCriteriaList.add(actionCriteria);
        
        cc_oo_JDEModifyOrderRequest.Sync syncReq = new cc_oo_JDEModifyOrderRequest.Sync();
        syncReq.ActionCriteria = actionCriteriaList;
        
        cc_oo_JDEModifyOrderRequest.DataArea dataAreaReq = new cc_oo_JDEModifyOrderRequest.DataArea();
        dataAreaReq.PurchaseOrder = purchaseOrderReq;
        dataAreaReq.Sync = syncReq;
                        
        cc_oo_JDEModifyOrderRequest modifyReq = new cc_oo_JDEModifyOrderRequest();
        modifyReq.DataArea = dataAreaReq;
        
        return modifyReq;
        
    }
   
   
   
   /***************************************************************************************************************************************
      Method Name : createRequest
      Description : createRequest is to create the request structure for the sync order API
      Parameter   : orders , orderItems
                    orders is the Order object
                    orderItems is the Individual order item of an order
      Return type : cc_oo_JDESyncOrderRequest - Order request structure.
                    
      *************************************************************************************************************************************/
    private static cc_oo_JDESyncOrderRequest createRequest(ccrz__E_Order__c orders, List<ccrz__E_OrderItem__c> orderItems, String jdeOrderNumber
                                                            , string portalUser) {
                                                                
        cc_oo_JDESyncOrderRequest syncReq = new cc_oo_JDESyncOrderRequest();
        try{
            
        
               List<ccrz__E_Cart__c> primarycart = [SELECT ccrz__EncryptedId__c,ccrz__CartStatus__c, 
                                                            (SELECT Id, ccrz__SubAmount__c, ccrz__Price__c, ccrz__Quantity__c, cc_oo_webLineNumber__c,
                                                            ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.cc_oo_TypeOfProduct__c,
                                                            cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name,ccrz__Comments__c,ccrz__UnitOfMeasure__c,
                                                            cc_oo_UnitPrice__c, cc_oo_ContractPrice__r.cc_oo_ContractNumber__c FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c 
                                                            WHERE Id =:orders.ccrz__OriginatedCart__c LIMIT 1]; 
               
                //Get user's FedertionID
                User csruser = new User();
                User dealerUser = new User(); 
                if(portalUser != 'ApexJob'){
                    Id contactId = ccrz.cc_CallContext.currContact.Id;
                    dealerUser = [select id, FederationIdentifier,Email, contact.FirstName, contact.LastName from User where contactId =: contactId];//OO-4466
                }
                //Id contactId = ccrz.cc_CallContext.currContact.Id;
                //dealerUser = [select id, FederationIdentifier,Email from User where contactId =: contactId];
                if(portalUser != null){
                    csruser = [select id, FederationIdentifier from User where Id =: UserInfo.getUserId()];
                }
                
                cc_oo_JDESyncOrderRequest.DocumentID documentId = new cc_oo_JDESyncOrderRequest.DocumentID();
                documentId.replacetokentypeCode = 'batchNumber';
                documentId.replaceDollar = String.valueOf(orders.Name);
                
                cc_oo_JDESyncOrderRequest.DocumentID documentIdBatch = new cc_oo_JDESyncOrderRequest.DocumentID();
                documentIdBatch.replacetokentypeCode = 'docNumber';
                documentIdBatch.replaceDollar = String.valueOf(orders.cc_oo_JDEDocumentID__c);
                
                cc_oo_JDESyncOrderRequest.DocumentID documentIdPONumber = new cc_oo_JDESyncOrderRequest.DocumentID();
                documentIdPONumber.replacetokentypeCode = 'customerPONumber';
                if(String.isNotBlank(orders.ccrz__PONumber__c)) {
                    documentIdPONumber.replaceDollar = String.valueOf(orders.ccrz__PONumber__c);
                } else {
                    documentIdPONumber.replaceDollar = '';
                }
                
                
                List<cc_oo_JDESyncOrderRequest.DocumentID> documentIdList = new List<cc_oo_JDESyncOrderRequest.DocumentID>();
                documentIdList.add(documentId);
                documentIdList.add(documentIdBatch);
                documentIdList.add(documentIdPONumber);
                
                cc_oo_JDESyncOrderRequest.DocumentIDSet finaldocumentId = new cc_oo_JDESyncOrderRequest.DocumentIDSet();
                finaldocumentId.ID = documentIdList;
                
                List<cc_oo_JDESyncOrderRequest.DocumentIDSet> finaldocumentIdList = new List<cc_oo_JDESyncOrderRequest.DocumentIDSet>();
                finaldocumentIdList.add(finaldocumentId);
            
                /*cc_oo_JDESyncOrderRequest.EffectiveTimePeriod effectiveTimePeriod = new cc_oo_JDESyncOrderRequest.EffectiveTimePeriod();
                effectiveTimePeriod.StartDateTime = String.valueOf(orders.CreatedDate.date());*/ // Not required as part of Sync Order API
                
                cc_oo_JDESyncOrderRequest.Status status = new cc_oo_JDESyncOrderRequest.Status();
                status.Description = orders.ccrz__Note__c;//'1017190823';
                //status.EffectiveTimePeriod = effectiveTimePeriod; // Not required as part of Sync Order API
                
                cc_oo_JDESyncOrderRequest.PersonName personName = new cc_oo_JDESyncOrderRequest.PersonName();
                if(dealerUser.FederationIdentifier != null){
                    personName.FormattedName = dealerUser.FederationIdentifier;//userInfo.getFirstName() + ' ' + userInfo.getLastName();
                }
                
                List<cc_oo_JDESyncOrderRequest.PersonName> personNameList = new List<cc_oo_JDESyncOrderRequest.PersonName>();
                personNameList.add(personName);
                
                cc_oo_JDESyncOrderRequest.Contact contact = new cc_oo_JDESyncOrderRequest.Contact();
                contact.PersonName = personNameList;
                
                List<cc_oo_JDESyncOrderRequest.Contact> contactList = new List<cc_oo_JDESyncOrderRequest.Contact>();
                contactList.add(contact);
                
                cc_oo_JDESyncOrderRequest.LocationCustomer locationCustomer = new cc_oo_JDESyncOrderRequest.LocationCustomer();
                locationCustomer.Contact = contactList;
                
                List<cc_oo_JDESyncOrderRequest.LocationCustomer> locationCustomerList = new List<cc_oo_JDESyncOrderRequest.LocationCustomer>();
                locationCustomerList.add(locationCustomer);
                
                cc_oo_JDESyncOrderRequest.CustomerParty customerParty = new cc_oo_JDESyncOrderRequest.CustomerParty();
                customerParty.Location = locationCustomerList;
                
                //Ship To Party Details - Starts
                cc_oo_JDESyncOrderRequest.ShipToParty shipToReq = new cc_oo_JDESyncOrderRequest.ShipToParty();
                //List<String> IDList = new List<String>();
                //IDList.add(orders.cc_oo_ShipToAccount__r.AccountNumber);
                
                /*cc_oo_JDESyncOrderRequest.Location locationReq = new cc_oo_JDESyncOrderRequest.Location();
                locationReq.ID = IDList;
                List<cc_oo_JDESyncOrderRequest.Location> locationList = new List<cc_oo_JDESyncOrderRequest.Location>();
                locationList.add(locationReq);*/
                
                shipToReq.ID = String.valueOf(orders.cc_oo_ShipToAccount__r.AccountNumber);//new List<String>{LoLSettings__c.getValues('JDEShipToPartyId').value__c};
                //shipToReq.location = locationList;
                //Ship To Party Details - Ends
        
                cc_oo_JDESyncOrderRequest.BillToParty billToReq = new cc_oo_JDESyncOrderRequest.BillToParty();
                List<String> BillIDList = new List<String>();
                if(orders.cc_oo_ShipToAccount__r.BillTo_Flag__c){
                    BillIDList.add(orders.cc_oo_ShipToAccount__r.AccountNumber);
                } else {
                    BillIDList.add(orders.cc_oo_ShipToAccount__r.BillTo_Account__r.AccountNumber);
                }       
                
                cc_oo_JDESyncOrderRequest.BillToLocation billLocationReq = new cc_oo_JDESyncOrderRequest.BillToLocation();
                billLocationReq.Note = new List<string>{ dealerUser.Email + ' | ' + dealerUser.Contact.FirstName + ' ' + dealerUser.Contact.LastName };//OO-4466 //BillIDList;
                List<cc_oo_JDESyncOrderRequest.BillToLocation> billLocationList = new List<cc_oo_JDESyncOrderRequest.BillToLocation>();
                billLocationList.add(billLocationReq);
                
                billToReq.ID = BillIDList;//new List<String>{LoLSettings__c.getValues('JDEShipToPartyId').value__c};//BillIDList;
                billToReq.Location = billLocationList;
                
                //Shipping Method - starts
                cc_oo_JDESyncOrderRequest.TransportationTerm transportationTerm = new cc_oo_JDESyncOrderRequest.TransportationTerm();
                if(orders.ccrz__ShipMethod__c != null && orders.ccrz__ShipMethod__c != '') {
                    if(orders.ccrz__ShipMethod__c.contains(LOLSettings__c.getValues('Delivery').Value__c)){
                        transportationTerm.replacetokentypeCode = LOLSettings__c.getValues('DeliveryFreigtCode').Value__c;
                        transportationTerm.FreightTermCode = 'M3';
                    }else if(orders.ccrz__ShipMethod__c.contains(LOLSettings__c.getValues('Pickup').Value__c)){
                        transportationTerm.replacetokentypeCode = LOLSettings__c.getValues('PickupFreigtCode').Value__c;
                        transportationTerm.FreightTermCode = 'M1';
                    }
                }//Shipping Method - ends
                
                List<cc_oo_JDESyncOrderRequest.TransportationTerm> transportationTermList = new List<cc_oo_JDESyncOrderRequest.TransportationTerm>(); 
                transportationTermList.add(transportationTerm); 
                
                //Buyer Part details
                /*List<String> buyerPartyIDList = new List<String>();
                if(csruser.FederationIdentifier != null && portalUser != null && portalUser != ''){
                    buyerPartyIDList.add(csruser.FederationIdentifier);
                }*/
                
                cc_oo_JDESyncOrderRequest.BuyerParty buyerParty = new cc_oo_JDESyncOrderRequest.BuyerParty(); 
                if(csruser.FederationIdentifier != null && portalUser != null && portalUser != ''){
                    buyerParty.ID = csruser.FederationIdentifier;
                }   
                
                //Ship-From Party Details - Starts
                //List<string> listShipFrom = new List<string>();
                //listShipFrom.add(orders.cc_oo_Seller__r.ccrz__SellerId__c);
                cc_oo_JDESyncOrderRequest.ShipFromParty shipFromParty = new cc_oo_JDESyncOrderRequest.ShipFromParty(); 
                ShipFromParty.ID = new List<String>{LoLSettings__c.getValues('JDEShipFromPartyId').value__c};//listShipFrom;//OO-3959
        
                cc_oo_JDESyncOrderRequest.Location locationReqShipFrom = new cc_oo_JDESyncOrderRequest.Location();
                locationReqShipFrom.ID = String.valueOf(orders.cc_oo_Seller__r.ccrz__SellerId__c);
                List<cc_oo_JDESyncOrderRequest.Location> locationListShipFrom = new List<cc_oo_JDESyncOrderRequest.Location>();
                locationListShipFrom.add(locationReqShipFrom);
                ShipFromParty.Location = locationListShipFrom;
                
                List<cc_oo_JDESyncOrderRequest.ShipFromParty> shipFromPartyList = new List<cc_oo_JDESyncOrderRequest.ShipFromParty>();
                shipFromPartyList.add(shipFromParty);
                //Ship-From Party Details - Ends
        
                cc_oo_JDESyncOrderRequest.SalesOrderReference salesOrderReference = new cc_oo_JDESyncOrderRequest.SalesOrderReference(); 
                salesOrderReference.ID = new List<string>{jdeOrderNumber};
            
                cc_oo_JDESyncOrderRequest.PurchaseOrderHeader purchaseHeaderReq = new cc_oo_JDESyncOrderRequest.PurchaseOrderHeader();
                purchaseHeaderReq.ID = jdeOrderNumber;
                purchaseHeaderReq.DocumentIDSet = finaldocumentIdList;
                purchaseHeaderReq.LastModificationDateTime = String.valueOf(orders.LastModifiedDate.Date());
               
                purchaseHeaderReq.Description = String.valueOf(orderItems[0].ccrz__Product__r.cc_oo_TypeOfProduct__c).toUpperCase();
                purchaseHeaderReq.Status = status;
                purchaseHeaderReq.CustomerParty = customerParty;
                purchaseHeaderReq.ShipToParty = shipToReq;
                purchaseHeaderReq.BillToParty = billToReq;
                purchaseHeaderReq.TransportationTerm = transportationTermList;
                if(String.isNotBlank(orders.cc_oo_PickUpTime__c) && orders.cc_oo_PickUpTime__c != '{}') {
                    purchaseHeaderReq.RequestedShipDateTime = String.valueOf(orders.ccrz__RequestDate__c) + ' ' + orders.cc_oo_PickUpTime__c;
                } else {
                    String pickUpTime = '00:00';
                    purchaseHeaderReq.RequestedShipDateTime = String.valueOf(orders.ccrz__RequestDate__c) + ' ' + pickUpTime;
                }
                
                purchaseHeaderReq.PaymentMethodCode = String.valueOf(orders.ccrz__PONumber__c);
                //string comments = '\n' + orders.ccrz__Note__c;//OO-4469
                //purchaseHeaderReq.ShippingInstructions = orders.cc_oo_ShipToAccount__r.Delivery_Instruction_1__c + comments;//OO-4469
                purchaseHeaderReq.ShippingInstructions = orders.cc_oo_ShipToAccount__r.Delivery_Instruction_1__c;//'ShippingInstructions Junemonth 1 WAREHOUS';
                purchaseHeaderReq.OrderDateTime = String.valueOf(orders.CreatedDate);
                purchaseHeaderReq.Note = orders.ccrz__Note__c;
                purchaseHeaderReq.BuyerParty = buyerParty;
                purchaseHeaderReq.ShipFromParty = shipFromPartyList;
                purchaseHeaderReq.SalesOrderReference = salesOrderReference;
                //purchaseHeaderReq.PickUpTime = String.valueOf(orders.cc_oo_PickUpTime__c);//US:1973
                
                List<cc_oo_JDESyncOrderRequest.PurchaseOrderLine> purchaseLineList = new List<cc_oo_JDESyncOrderRequest.PurchaseOrderLine>();
                
                for(ccrz__E_CartItem__c orderItem : primarycart[0].ccrz__E_CartItems__r){ 
                    cc_oo_JDESyncOrderRequest.PurchaseOrderLine purchaseLineReq = new cc_oo_JDESyncOrderRequest.PurchaseOrderLine();
                    purchaseLineReq.lineNumberID = string.valueof(orderItem.cc_oo_webLineNumber__c);
                    
                    cc_oo_JDESyncOrderRequest.Item itemReq = new cc_oo_JDESyncOrderRequest.Item();
                    itemReq.ID = orderItem.ccrz__Product__r.ccrz__SKU__c;//orderItem.Name;
                    itemReq.Note = orderItem.ccrz__Comments__c;
                    
                    List<cc_oo_JDESyncOrderRequest.Item> itemList = new List<cc_oo_JDESyncOrderRequest.Item>();
                    itemList.add(itemReq);
                    
                    purchaseLineReq.item = itemList;
                    
                    cc_oo_JDESyncOrderRequest.Quantity quantityref = new cc_oo_JDESyncOrderRequest.Quantity();
                    quantityref.replacetokenunitCode = orderItem.ccrz__UnitOfMeasure__c;
                    quantityref.replaceDollar = String.valueOf(orderItem.ccrz__Quantity__c);
                    
                    List<cc_oo_JDESyncOrderRequest.Quantity> quantityList = new List<cc_oo_JDESyncOrderRequest.Quantity>();
                    quantityList.add(quantityref);           
                    purchaseLineReq.quantity = quantityList;
                    
                    cc_oo_JDESyncOrderRequest.UnitPrice unitPriceReq = new cc_oo_JDESyncOrderRequest.UnitPrice();
                    //unitPriceReq.ID = orderItem.ccrz__UnitOfMeasure__c;
                    unitPriceReq.chargeAmount = String.valueOf(orderItem.ccrz__Price__c);
                    purchaseLineReq.unitPrice = unitPriceReq;
                    
                    cc_oo_JDESyncOrderRequest.ContractReference contractReferenceReq = new cc_oo_JDESyncOrderRequest.ContractReference();
                    contractReferenceReq.ID = String.valueOf(orderItem.cc_oo_ContractPrice__r.cc_oo_ContractNumber__c);
                    purchaseLineReq.contractReference = contractReferenceReq;
                    
                    cc_oo_JDESyncOrderRequest.AmountDiscount amountDiscountReq = new cc_oo_JDESyncOrderRequest.AmountDiscount();
                    List<String> idAmountList = new List<String>();
                    amountDiscountReq.ID = idAmountList ;
                    amountDiscountReq.percentage = '';
                    amountDiscountReq.description = idAmountList ;
                    
                    cc_oo_JDESyncOrderRequest.PurchaseOrderSubLine purchaseOrderSublineReq = new cc_oo_JDESyncOrderRequest.PurchaseOrderSubLine();
                    purchaseOrderSublineReq.amountDiscount = amountDiscountReq;
                    
                    List<cc_oo_JDESyncOrderRequest.PurchaseOrderSubLine> purchaseSubLineList = new List<cc_oo_JDESyncOrderRequest.PurchaseOrderSubLine>();
                    purchaseSubLineList.add(purchaseOrderSublineReq);
                    purchaseLineReq.purchaseOrderSubLine = purchaseSubLineList;         
                    purchaseLineList.add(purchaseLineReq);
                }
                
                cc_oo_JDESyncOrderRequest.PurchaseOrder purchaseOrderReq = new cc_oo_JDESyncOrderRequest.PurchaseOrder();
                purchaseOrderReq.replacetokentypeCode = 'S6';
                purchaseOrderReq.purchaseOrderHeader = purchaseHeaderReq;
                purchaseOrderReq.purchaseOrderLine = purchaseLineList;
                 
                /*List<cc_oo_JDESyncOrderRequest.PurchaseOrder> purchaseOrderList = new List<cc_oo_JDESyncOrderRequest.PurchaseOrder>();
                purchaseOrderList.add(purchaseOrderReq);*/
                
                cc_oo_JDESyncOrderRequest.DataArea dataAreaReq = new cc_oo_JDESyncOrderRequest.DataArea();
                dataAreaReq.PurchaseOrder = purchaseOrderReq;
                
                //cc_oo_JDESyncOrderRequest syncReq = new cc_oo_JDESyncOrderRequest();
                syncReq.DataArea = dataAreaReq;
        }
        catch (Exception ex){
            CreateErrorLog(ex, CLASS_NAME, 'createRequest');
        }
        return syncReq;
    }
    
   public static String getRedirectUrl(String urlPage, String orderNo, String secondaryCartId, Boolean isSubscriber, String isBaseUrl) {
        
        Map<String,String> pageParams = ccrz.cc_CallContext.currPageParameters;
        String orderId = orderNo;
        String sellerId = null;
        String isSameShipTo = null;
        //String orderType = null;//OO-3252
        //String promotionCode = null;//OO-3252
        String cclcl = null;
        String returnBaseUrl = null;        
        String portalUser = '';
        if(pageParams != null){
            sellerId = pageParams.get('sid');
            isSameShipTo = pageParams.get('isSameShipto');
            //orderType = pageParams.get('orderType');//OO-3252
            //promotionCode = pageParams.get('promotionCode');//OO-3252
            cclcl = pageParams.get('cclcl');
            returnBaseUrl = pageParams.get('baseUrl');
            portalUser = pageParams.get('portalUser');
        }
        
        String pageUrl = ccrz.cc_CallContext.currURL;
        Map<String, String> csrParam = new Map<String,String>();
        csrParam = ccrz.cc_CallContext.currPageParameters;
        String baseUrl;
        if(isSubscriber) {
            System.debug('Page url' + pageUrl);
            if(returnBaseUrl != null && returnBaseUrl != '') {
                baseUrl = returnBaseUrl;
            }
        } else {
            System.debug('Page url' + pageUrl);
            String pathName = pageUrl.split('\\?')[0];
            List<String> path = pathName.split('\\/');
            baseUrl = path[0]+'//'+path[2]+'/'+path[3];
        }
        
        baseUrl += '/' + urlPage + 'o=' + orderId + '&cclcl=' + cclcl;//OO-3252 
        if(portalUser != 'null' && portalUser != null && portalUser != 'undefined' && portalUser != '')
        {
            baseUrl += '&portalUser=' + portalUser + '&isCSRFlow=true';
        }
        baseUrl += '&sid=' + sellerId + '&isSameShipto=' + isSameShipTo + '&cartID=' + secondaryCartId + '&baseUrl=' + isBaseUrl;
        System.debug('Piyali Url Helper' + baseUrl);
        return baseUrl;
    }
    
    /***************************************************************************************************************************************
      Method Name : shuffleCart
      Description : shuffleCart is to reshuffle cartItems when dates are modified
      Parameter   : cartId, shipDate
      Return type : Returns ccrz.cc_RemoteActionResult.
      UserStory   : OO-1719                                                             
      *************************************************************************************************************************************/
    public static Map<String,Object> shuffleCart(String cartId, String shipDate,String shippingMethod,boolean fromOrderInfo){
        boolean cartUpdated=false;
        String cutOffTime=null;
        Map<String,Object> dataMap=new Map<String,Object>();
        Map<String,Date> leadTimeMap=new Map<String,Date>();
        Map<String,Date> leadTimeMapSec=new Map<String,Date>();
        List<CC_OO_PlantHolidayCalendar__c> holidayCalendarList= new List<CC_OO_PlantHolidayCalendar__c>();
        Date dayToday = Date.today(); 
        try{
            List<ccrz__E_Cart__c> cartDetails = [SELECT c.ccrz__EncryptedId__c,c.Id,ccrz__RequestDate__c,ccrz__ActiveCart__c
                    ,cc_oo_SplitCartType__c,cc_oo_SplitCart__c,cc_oo_Seller__r.Id,ccrz__ShipTo__r.cc_oo_BillToShipToID__c,
                    cc_oo_AmendedCart__c,
                    (SELECT Id, ccrz__SubAmount__c, ccrz__Price__c,cc_oo_ContractPrice__r.Id,cc_oo_leadtime__c,cc_oo_isFreightIncluded__c
                    , ccrz__Quantity__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.cc_oo_TypeOfProduct__c
                    ,cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name, cc_oo_UnitPrice__c
                    ,ccrz__Cart__r.ccrz__EncryptedId__c,ccrz__Product__r.Id,cc_oo_JDELineNumber__c, cc_oo_LineNumberId__c, cc_oo_OriginalCartItem__c
                    FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c c WHERE c.ccrz__EncryptedId__c =:cartId LIMIT 1];
                    
            Set<Id> primaryProductId = new Set<Id>();
            
            if(!cartDetails.isEmpty()) {
                if(cartDetails[0].cc_oo_SplitCart__c != null) {
                    updateSecondaryCartDate(cartDetails[0].cc_oo_SplitCart__c, shippingMethod);
                }
                for(ccrz__E_CartItem__c cartItem : cartDetails[0].ccrz__E_CartItems__r) {
                    primaryProductId.add(cartItem.ccrz__Product__r.Id); 
                }
            }
            
            String shipping=null;
            if(String.isNotBlank(shippingMethod)){
                String[] splitShippingMethod=shippingMethod.split(' - ');
                if(splitShippingMethod.size() > 1) {
                    shipping=splitShippingMethod[1].deleteWhitespace().toUpperCase();
                } else {
                    shipping=splitShippingMethod[0].deleteWhitespace().toUpperCase();
                }              
            }
            
            // to fetch inventory item
            List<ccrz__E_ProductInventoryItem__c> primaryInventoryItems = [select cc_oo_LeadTime__c,ccrz__ProductItem__r.ccrz__SKU__c
                                                                        from ccrz__E_ProductInventoryItem__c
                                                                        where ccrz__ProductItem__c IN:primaryProductId 
                                                                        and cc_oo_Seller__c=:cartDetails[0].cc_oo_Seller__r.Id];
                        
            Map<String,Integer> primaryProductLead = new Map<String, Integer>();
            integer leadTimeInteger;
            boolean addLead;
            
            if(!(cartDetails[0].ccrz__E_CartItems__r).isEmpty()){
                String typeOfProduct=cartDetails[0].ccrz__E_CartItems__r[0].ccrz__Product__r.cc_oo_TypeOfProduct__c;
                addLead=getCurrentAndCutOffTime(typeOfProduct,cartDetails[0].cc_oo_Seller__r.Id,shipping);
                cutOffTime=getCutOffTime(typeOfProduct,cartDetails[0].cc_oo_Seller__r.Id,shipping);
            }
            //
            Date maxLeadTimeDate = Date.Today();
            if(!cartDetails.isEmpty()) {
                for(ccrz__E_ProductInventoryItem__c primaryInventory : primaryInventoryItems) {
                    
                    leadTimeInteger = Integer.valueOf(primaryInventory.cc_oo_LeadTime__c.split('\\s+')[0]);
                    if(addLead){
                        leadTimeMap.put(primaryInventory.ccrz__ProductItem__r.ccrz__SKU__c,Date.Today()+leadTimeInteger+1);
                        if(maxLeadTimeDate < Date.Today()+leadTimeInteger+1){
                            maxLeadTimeDate = Date.Today()+leadTimeInteger+1;   
                        }
                    }
                    else{
                        leadTimeMap.put(primaryInventory.ccrz__ProductItem__r.ccrz__SKU__c,Date.Today()+leadTimeInteger);
                        if(maxLeadTimeDate < Date.Today()+leadTimeInteger){
                            maxLeadTimeDate = Date.Today()+leadTimeInteger; 
                        }
                    }
                }
            

            Date futureHolidayListDate = dayToday.addMonths(5);
            holidayCalendarList= [Select Id,cc_oo_Holiday__c, cc_oo_Month__c,  cc_oo_Year__c from CC_OO_PlantHolidayCalendar__c 
                                    where cc_oo_Holiday__c >= :dayToday AND  cc_oo_Holiday__c <=:futureHolidayListDate 
                                    AND cc_oo_Plant__c = :cartDetails[0].cc_oo_Seller__r.Id ORDER BY cc_oo_Holiday__c ASC];
            
            //
            for(ccrz__E_ProductInventoryItem__c productInventory : primaryInventoryItems) {
                String[] splitLead = (productInventory.cc_oo_LeadTime__c).split('\\s+');
                Integer leadTime = Integer.valueOf(splitLead[0]);
                if(addLead){
                    primaryProductLead.put(productInventory.ccrz__ProductItem__r.ccrz__SKU__c, leadTime+1);  
                }
                else{
                    primaryProductLead.put(productInventory.ccrz__ProductItem__r.ccrz__SKU__c, leadTime);   
                }
            }
            } 
            Map<string, Date> mapFinalLeadDate = getPlantHolidayLeadDate(holidayCalendarList, leadTimeMap);
                     
            List<ccrz__E_Cart__c> secondaryCart = [select id,ccrz__EncryptedId__c, cc_oo_SplitCartType__c,ccrz__ActiveCart__c
                        , cc_oo_SplitCart__r.ccrz__EncryptedId__c,ccrz__RequestDate__c,cc_oo_Seller__r.Id,ccrz__ShipTo__r.cc_oo_BillToShipToID__c,
                        cc_oo_AmendedCart__c,
                        (SELECT Id, ccrz__SubAmount__c, ccrz__Price__c,cc_oo_ContractPrice__r.Id,cc_oo_leadtime__c,cc_oo_isFreightIncluded__c
                        , ccrz__Quantity__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.cc_oo_TypeOfProduct__c
                        ,cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name, cc_oo_UnitPrice__c, ccrz__Product__r.Id,
                        ccrz__Cart__r.ccrz__EncryptedId__c,cc_oo_JDELineNumber__c, cc_oo_LineNumberId__c, cc_oo_OriginalCartItem__c 
                        FROM ccrz__E_CartItems__r)
                        from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open'
                        AND ccrz__ActiveCart__c = false AND cc_oo_SplitCartType__c = 'Secondary' 
                        AND cc_oo_SplitCart__r.ccrz__EncryptedId__c = :cartId LIMIT 1];
            
            Set<Id> secondaryProductId = new Set<Id>();
            Map<String,Integer> secondaryProductLead = new Map<String, Integer>();
            
            if(!secondaryCart.isEmpty() && !(secondaryCart[0].ccrz__E_CartItems__r).isEmpty()) {
                for(ccrz__E_CartItem__c cartItem : secondaryCart[0].ccrz__E_CartItems__r) {
                    secondaryProductId.add(cartItem.ccrz__Product__r.Id);   
                }
                
                // to fetch inventory item
                List<ccrz__E_ProductInventoryItem__c> secondaryInventoryItems = [select cc_oo_LeadTime__c,ccrz__ProductItem__r.ccrz__SKU__c
                                                                        from ccrz__E_ProductInventoryItem__c
                                                                        where ccrz__ProductItem__c IN :secondaryProductId 
                                                                        and cc_oo_Seller__c=:secondaryCart[0].cc_oo_Seller__r.Id];
           String typeOfProductSecondary=secondaryCart[0].ccrz__E_CartItems__r[0].ccrz__Product__r.cc_oo_TypeOfProduct__c;
           addLead=false;
           addLead=getCurrentAndCutOffTime(typeOfProductSecondary,secondaryCart[0].cc_oo_Seller__r.Id,null);
           maxLeadTimeDate=Date.today();
            
                
                for(ccrz__E_ProductInventoryItem__c secProductInventory :secondaryInventoryItems){
                      
                    leadTimeInteger = Integer.valueOf(secProductInventory.cc_oo_LeadTime__c.split('\\s+')[0]);
                    if(addLead){
                        leadTimeMapSec.put(secProductInventory.ccrz__ProductItem__r.ccrz__SKU__c,Date.Today()+leadTimeInteger+1);
                        if(maxLeadTimeDate < Date.Today()+leadTimeInteger+1){
                            maxLeadTimeDate = Date.Today()+leadTimeInteger+1;   
                        }
                    }
                    else{
                        leadTimeMapSec.put(secProductInventory.ccrz__ProductItem__r.ccrz__SKU__c,Date.Today()+leadTimeInteger);
                        if(maxLeadTimeDate < Date.Today()+leadTimeInteger){
                            maxLeadTimeDate = Date.Today()+leadTimeInteger; 
                        }
                    }
                }
                
                
                Date futureSecondaryHolidayListDate = dayToday.addMonths(5);
                holidayCalendarList= [Select Id, cc_oo_Holiday__c, cc_oo_Month__c,  cc_oo_Year__c from CC_OO_PlantHolidayCalendar__c 
                                    where cc_oo_Holiday__c >= :dayToday AND cc_oo_Holiday__c <=:futureSecondaryHolidayListDate  
                                    AND cc_oo_Plant__c = :secondaryCart[0].cc_oo_Seller__r.Id ORDER BY cc_oo_Holiday__c ASC];
                
                
            }
            Map<string, Date> mapFinalLeadDateSecondary = getPlantHolidayLeadDate(holidayCalendarList, leadTimeMapSec);
            
                /*for(ccrz__E_ProductInventoryItem__c productInventory : secondaryInventoryItems) {
                    String[] splitLead = (productInventory.cc_oo_LeadTime__c).split('\\s+');
                    Integer leadTime = Integer.valueOf(splitLead[0]);
                    if(addLead){
                        secondaryProductLead.put(productInventory.ccrz__ProductItem__r.ccrz__SKU__c, leadTime+1); 
                    }
                    else{
                        secondaryProductLead.put(productInventory.ccrz__ProductItem__r.ccrz__SKU__c, leadTime); 
                    }                
                }*/
            
            
            
            if(fromOrderInfo){
                List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>();
                if(shippingMethod.contains('-')) {
                    cartDetails[0].ccrz__ShipMethod__c =shippingMethod;
                } else {
                    cartDetails[0].ccrz__ShipMethod__c ='null - '+shippingMethod;
                } 
                update cartDetails;
                for(ccrz__E_CartItem__c cartItem : cartDetails[0].ccrz__E_CartItems__r){
                    if(mapFinalLeadDate.size()>0) {
                        /*Date leadDate = Date.today();
                        leadDate = leadDate.addDays(primaryProductLead.get(cartItem.ccrz__Product__r.ccrz__SKU__c));
                        leadDate = getHolidayLeadDate(cartDetails[0].cc_oo_Seller__r.Id, leadDate);*/
                        Date leadDate = mapFinalLeadDate.get(cartItem.ccrz__Product__r.ccrz__SKU__c);
                        System.debug('<<<leadDate'+leadDate);
                        if(leadDate > date.parse(shipDate)) {
                            System.debug('if lead greater than shipDate');
                            cartItemList.add(cartItem);
                        }
                    }
                    //delete cartItem;
                }
                delete cartItemList;
                
                System.debug('cartItemList'+cartItemList);
                if(!secondaryCart.isEmpty()) {
                    if(!cartItemList.isEmpty()) {
                        for(ccrz__E_CartItem__c newSecondaryItem : cartItemList) {
                            cc_oo_HelperController.addNewCartItem(newSecondaryItem.ccrz__Product__r.ccrz__SKU__c
                                ,Integer.valueOf(newSecondaryItem.ccrz__Quantity__c), secondaryCart[0].Id
                                ,newSecondaryItem.ccrz__Price__c, newSecondaryItem.cc_oo_IsListPrice__c,
                                newSecondaryItem.cc_oo_ContractPrice__r.Id,secondaryCart[0].cc_oo_Seller__r.Id,null,null,newSecondaryItem.cc_oo_leadtime__c,newSecondaryItem.cc_oo_isFreightIncluded__c,newSecondaryItem);
                            //newSecondaryItem.ccrz__Cart__c = secondaryCart[0].Id;                   
                        }
                        //update cartItemList;
                      cartUpdated=true;  
                    }
                } else {
                    if(!cartItemList.isEmpty()) {
                    ccrz__E_Cart__c  cartReturn = cc_oo_HeaderController.mapToCart(cartDetails[0].cc_oo_Seller__r.Id ,cartDetails[0].ccrz__ShipTo__r.cc_oo_BillToShipToID__c, true);
                    for(ccrz__E_CartItem__c cartItem : cartItemList) {
                        if(mapFinalLeadDate.size()>0) {
                            /*Date leadDate = Date.today();
                            leadDate = leadDate.addDays(primaryProductLead.get(cartItem.ccrz__Product__r.ccrz__SKU__c));
                            leadDate = getHolidayLeadDate(cartDetails[0].cc_oo_Seller__r.Id, leadDate);*/
                            Date leadDate = mapFinalLeadDate.get(cartItem.ccrz__Product__r.ccrz__SKU__c);
                            if(leadDate > cartReturn.ccrz__RequestDate__c) {
                                cartReturn.ccrz__RequestDate__c = leadDate;
                            }
                        }
                    }
                    cartReturn.cc_oo_SplitCart__c = cartDetails[0].Id;
                    update cartReturn;
                    String secondaryCartId = String.valueOf(cartReturn.Id);
                    cartDetails[0].cc_oo_SplitCart__c = cartReturn.Id;
                    update cartDetails;
                    if(!cartItemList.isEmpty()) {
                        for(ccrz__E_CartItem__c newSecondaryItem : cartItemList) {
                            cc_oo_HelperController.addNewCartItem(newSecondaryItem.ccrz__Product__r.ccrz__SKU__c
                                ,Integer.valueOf(newSecondaryItem.ccrz__Quantity__c), secondaryCartId
                                ,newSecondaryItem.ccrz__Price__c, newSecondaryItem.cc_oo_IsListPrice__c,
                                newSecondaryItem.cc_oo_ContractPrice__r.Id,cartDetails[0].cc_oo_Seller__r.Id,null,null,newSecondaryItem.cc_oo_leadtime__c,newSecondaryItem.cc_oo_isFreightIncluded__c,newSecondaryItem);
                            //newSecondaryItem.ccrz__Cart__c = secondaryCartId;                  
                        }
                        //update cartItemList;
                        cartUpdated=true;
                    }
                }}
                
            }   else if(date.parse(shipDate) < cartDetails[0].ccrz__RequestDate__c || (cartDetails[0].cc_oo_AmendedCart__c && date.parse(shipDate) == cartDetails[0].ccrz__RequestDate__c)) {
                cartDetails[0].ccrz__RequestDate__c = date.parse(shipDate);
                update cartDetails;
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','you are in shuffle');
                //system.debug('you are in shuffle');
                List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>();
                for(ccrz__E_CartItem__c cartItem : cartDetails[0].ccrz__E_CartItems__r){
                    if(mapFinalLeadDate.size()>0) {
                        /*Date leadDate = Date.today();
                        leadDate = leadDate.addDays(primaryProductLead.get(cartItem.ccrz__Product__r.ccrz__SKU__c));
                        leadDate = getHolidayLeadDate(cartDetails[0].cc_oo_Seller__r.Id, leadDate);*/
                        Date leadDate = mapFinalLeadDate.get(cartItem.ccrz__Product__r.ccrz__SKU__c);
                        if(leadDate > date.parse(shipDate)) {
                            cartItemList.add(cartItem);
                        }
                    }
                    //delete cartItem;
                }
                delete cartItemList;
                        
                if(!secondaryCart.isEmpty()) {
                    if(secondaryCart[0].ccrz__RequestDate__c < date.parse(shipDate)) {
                        secondaryCart[0].ccrz__RequestDate__c = date.parse(shipDate);
                        for(ccrz__E_CartItem__c cartItem : cartItemList) {
                            if(primaryProductLead != null) {
                                Date leadDate = Date.today();
                                leadDate = leadDate.addDays(primaryProductLead.get(cartItem.ccrz__Product__r.ccrz__SKU__c));
                                if(leadDate > secondaryCart[0].ccrz__RequestDate__c) {
                                     secondaryCart[0].ccrz__RequestDate__c = leadDate;
                                }
                            }
                        }
                        update secondaryCart;
                    }
                    if(!cartItemList.isEmpty()) {
                        for(ccrz__E_CartItem__c newSecondaryItem : cartItemList) {
                            cc_oo_HelperController.addNewCartItem(newSecondaryItem.ccrz__Product__r.ccrz__SKU__c
                                ,Integer.valueOf(newSecondaryItem.ccrz__Quantity__c), secondaryCart[0].Id
                                ,newSecondaryItem.ccrz__Price__c, newSecondaryItem.cc_oo_IsListPrice__c,
                                newSecondaryItem.cc_oo_ContractPrice__r.Id,secondaryCart[0].cc_oo_Seller__r.Id,null,null,newSecondaryItem.cc_oo_leadtime__c,newSecondaryItem.cc_oo_isFreightIncluded__c,newSecondaryItem);
                            //newSecondaryItem.ccrz__Cart__c = secondaryCart[0].Id;                   
                        }
                        //update cartItemList;
                      cartUpdated=true;  
                    }
                } else {
                    ccrz__E_Cart__c  cartReturn = cc_oo_HeaderController.mapToCart(cartDetails[0].cc_oo_Seller__r.Id ,cartDetails[0].ccrz__ShipTo__r.cc_oo_BillToShipToID__c, true);
                    cartReturn.ccrz__RequestDate__c = date.parse(shipDate);
                    for(ccrz__E_CartItem__c cartItem : cartItemList) {
                        if(mapFinalLeadDate.size()>0) {
                            /*Date leadDate = Date.today();
                            leadDate = leadDate.addDays(primaryProductLead.get(cartItem.ccrz__Product__r.ccrz__SKU__c));
                            leadDate = getHolidayLeadDate(cartDetails[0].cc_oo_Seller__r.Id, leadDate);*/
                            Date leadDate = mapFinalLeadDate.get(cartItem.ccrz__Product__r.ccrz__SKU__c);
                            if(leadDate > cartReturn.ccrz__RequestDate__c) {
                                cartReturn.ccrz__RequestDate__c = leadDate;
                            }
                        }
                    }
                    cartReturn.cc_oo_SplitCart__c = cartDetails[0].Id;
                    update cartReturn;
                    String secondaryCartId = String.valueOf(cartReturn.Id);
                    cartDetails[0].cc_oo_SplitCart__c = cartReturn.Id;
                    update cartDetails;
                    if(!cartItemList.isEmpty()) {
                        for(ccrz__E_CartItem__c newSecondaryItem : cartItemList) {
                            cc_oo_HelperController.addNewCartItem(newSecondaryItem.ccrz__Product__r.ccrz__SKU__c
                                ,Integer.valueOf(newSecondaryItem.ccrz__Quantity__c), secondaryCartId
                                ,newSecondaryItem.ccrz__Price__c, newSecondaryItem.cc_oo_IsListPrice__c,
                                newSecondaryItem.cc_oo_ContractPrice__r.Id,cartDetails[0].cc_oo_Seller__r.Id,null,null,newSecondaryItem.cc_oo_leadtime__c,newSecondaryItem.cc_oo_isFreightIncluded__c,newSecondaryItem);
                            //newSecondaryItem.ccrz__Cart__c = secondaryCartId;                  
                        }
                        //update cartItemList;
                        cartUpdated=true;
                    }
                }           
            } else if(date.parse(shipDate) >= cartDetails[0].ccrz__RequestDate__c) {
                cartDetails[0].ccrz__RequestDate__c = date.parse(shipDate);
                update cartDetails;
                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'you are in shuffleeeeeeeeeeeeee');
                //system.debug('you are in shuffleeeeeeeeeeeeeeeeeeeeeeeeeee');
                List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>();
                
                // Bug - 5347- When date is equal, we can have products that will move from cart 1 to cart -2 - Start
                List<ccrz__E_CartItem__c> primaryCartItemList = new List<ccrz__E_CartItem__c>();
                for(ccrz__E_CartItem__c primaryCartItem : cartDetails[0].ccrz__E_CartItems__r){
                    if(mapFinalLeadDate.size()>0) {
                        Date leadDate = mapFinalLeadDate.get(primaryCartItem.ccrz__Product__r.ccrz__SKU__c);
                        if(leadDate > date.parse(shipDate)) {
                            primaryCartItemList.add(primaryCartItem);
                        }
                    }
                    //delete cartItem;
                }
                delete primaryCartItemList;
                // Bug - 5347 - End
                
                if(!secondaryCart.isEmpty()) {
                    for(ccrz__E_CartItem__c cartItem : secondaryCart[0].ccrz__E_CartItems__r){
                        if(mapFinalLeadDateSecondary.size()>0) {
                            /*Date leadDate = Date.today();
                            leadDate = leadDate.addDays(secondaryProductLead.get(cartItem.ccrz__Product__r.ccrz__SKU__c));
                            leadDate = getHolidayLeadDate(cartDetails[0].cc_oo_Seller__r.Id, leadDate);*/
                            Date leadDate = mapFinalLeadDateSecondary.get(cartItem.ccrz__Product__r.ccrz__SKU__c);
                            if(leadDate <= date.parse(shipDate)) {
                                cartItemList.add(cartItem);
                                ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','you are in shuffling2');
                               // system.debug('shuffling2');
                            }
                        }
                        //delete cartItem;
                    }
                    delete cartItemList;
                    
                    // 5347- Start
                        for(ccrz__E_CartItem__c primaryCartItem : primaryCartItemList) {
                            if(primaryProductLead != null) {
                                Date leadDate = Date.today();
                                leadDate = leadDate.addDays(primaryProductLead.get(primaryCartItem.ccrz__Product__r.ccrz__SKU__c));
                                if(leadDate > secondaryCart[0].ccrz__RequestDate__c) {
                                     secondaryCart[0].ccrz__RequestDate__c = leadDate;
                                }
                            }
                        }
                        update secondaryCart;
                    if(!primaryCartItemList.isEmpty()) {
                        for(ccrz__E_CartItem__c newSecondaryItem : primaryCartItemList) {
                            cc_oo_HelperController.addNewCartItem(newSecondaryItem.ccrz__Product__r.ccrz__SKU__c
                                ,Integer.valueOf(newSecondaryItem.ccrz__Quantity__c), secondaryCart[0].Id
                                ,newSecondaryItem.ccrz__Price__c, newSecondaryItem.cc_oo_IsListPrice__c,
                                newSecondaryItem.cc_oo_ContractPrice__r.Id,secondaryCart[0].cc_oo_Seller__r.Id,null,null,newSecondaryItem.cc_oo_leadtime__c,newSecondaryItem.cc_oo_isFreightIncluded__c,newSecondaryItem);
                            //newSecondaryItem.ccrz__Cart__c = secondaryCart[0].Id;                   
                        }
                        //update cartItemList;
                      cartUpdated=true;  
                    }
                    // 5347 - End
                } else { // 5347 - Start
                    ccrz__E_Cart__c  cartReturn = cc_oo_HeaderController.mapToCart(cartDetails[0].cc_oo_Seller__r.Id ,cartDetails[0].ccrz__ShipTo__r.cc_oo_BillToShipToID__c, true);
                    cartReturn.ccrz__RequestDate__c = date.parse(shipDate);
                    for(ccrz__E_CartItem__c cartItem : primaryCartItemList) {
                        if(mapFinalLeadDate.size()>0) {
                            Date leadDate = mapFinalLeadDate.get(cartItem.ccrz__Product__r.ccrz__SKU__c);
                            if(leadDate > cartReturn.ccrz__RequestDate__c) {
                                cartReturn.ccrz__RequestDate__c = leadDate;
                            }
                        }
                    }
                    cartReturn.cc_oo_SplitCart__c = cartDetails[0].Id;
                    update cartReturn;
                    String secondaryCartId = String.valueOf(cartReturn.Id);
                    cartDetails[0].cc_oo_SplitCart__c = cartReturn.Id;
                    update cartDetails;
                    if(!primaryCartItemList.isEmpty()) {
                        for(ccrz__E_CartItem__c newSecondaryItem : primaryCartItemList) {
                            cc_oo_HelperController.addNewCartItem(newSecondaryItem.ccrz__Product__r.ccrz__SKU__c
                                ,Integer.valueOf(newSecondaryItem.ccrz__Quantity__c), secondaryCartId
                                ,newSecondaryItem.ccrz__Price__c, newSecondaryItem.cc_oo_IsListPrice__c,
                                newSecondaryItem.cc_oo_ContractPrice__r.Id,cartDetails[0].cc_oo_Seller__r.Id,null,null,newSecondaryItem.cc_oo_leadtime__c,newSecondaryItem.cc_oo_isFreightIncluded__c,newSecondaryItem);
                            //newSecondaryItem.ccrz__Cart__c = secondaryCartId;                  
                        }
                        //update cartItemList;
                        cartUpdated=true;
                    }
                } // 5347- End
                
                if(!cartItemList.isEmpty()) {
                    for(ccrz__E_CartItem__c newPrimaryItem : cartItemList) {
                        cc_oo_HelperController.addNewCartItem(newPrimaryItem.ccrz__Product__r.ccrz__SKU__c
                                ,Integer.valueOf(newPrimaryItem.ccrz__Quantity__c), cartDetails[0].Id
                                ,newPrimaryItem.ccrz__Price__c, newPrimaryItem.cc_oo_IsListPrice__c,
                                newPrimaryItem.cc_oo_ContractPrice__r.Id,secondaryCart[0].cc_oo_Seller__r.Id,null,null,newPrimaryItem.cc_oo_leadtime__c,newPrimaryItem.cc_oo_isFreightIncluded__c,newPrimaryItem);
                        //newPrimaryItem.ccrz__Cart__c = cartDetails[0].Id;                   
                    }
                    //update cartItemList;
                  cartUpdated=true;  
                }   
            }
            dataMap.put('cartUpdated',cartUpdated);
            dataMap.put('cutOffTime',cutOffTime);
            dataMap.put('fromOrderInfo',fromOrderInfo);
        }catch(Exception ex){
            CreateErrorLog(ex, CLASS_NAME, 'shuffleCart');
        }
       return dataMap;
    }
    
    //@future//OO-4781
    public static void updateOrder(String urlOrderId , String jdeOrderNumber, Boolean isSyncOrder) {
    
        ccrz__E_Order__c orders = [select Id, Name, cc_oo_IsSyncOrder__c, ccrz__EncryptedId__c,ccrz__OrderStatus__c,cc_oo_IsJDENumberUpdate__c,cc_oo_JDEOrderNumber__c
                                                from ccrz__E_Order__c where ccrz__EncryptedId__c=:urlOrderId LIMIT 1];
        if(jdeOrderNumber != null){
            orders.cc_oo_JDEOrderNumber__c = jdeOrderNumber;
            orders.cc_oo_IsJDENumberUpdate__c = true;
            orders.cc_oo_IsSyncOrder__c = isSyncOrder;
            update orders;
        } else {
            orders.cc_oo_IsJDENumberUpdate__c = false;
            orders.cc_oo_IsSyncOrder__c = isSyncOrder;
            update orders;
        }
    }
    //OO-1772
    //@future//OO-4781
    public static void modifyOrderCheck(Id OrderId , Id oldOrderId, String jdeOrderNumber, Boolean isModifiedOrder) {

        List<ccrz__E_Order__c> listOrders = new List<ccrz__E_Order__c>();
        ccrz__E_Order__c order = new ccrz__E_Order__c();
        order.Id = OrderId;
        order.cc_oo_JDEOrderNumber__c = jdeOrderNumber;
        order.ccrz__OrderStatus__c = LOLSettings__c.getValues('PendingOrderStatus').Value__c;
        if(isModifiedOrder){
            order.cc_oo_IsSyncOrder__c = true;//OO-4462
        }else{
            order.cc_oo_IsSyncOrder__c = false;//OO-4462
        }
        listOrders.add(order);

        ccrz__E_Order__c oldOrder = new ccrz__E_Order__c();
        oldOrder.Id = oldOrderId;
        oldOrder.ccrz__OrderStatus__c = LOLSettings__c.getValues('AmendedOrderStatus').Value__c;
        listOrders.add(oldOrder);

        if(listOrders.size() > 0){
            update listOrders;
        }
    }
    
     //US-2008-common functionality for ProductInventoryItem__c
    public static List<ccrz__E_ProductInventoryItem__c> getProductInventoryItemDetails(List<String> prdlst,String SellerID){
        List<ccrz__E_ProductInventoryItem__c> prdInvItm=[select ccrz__AvailabilityMessage__c,ccrz__Status__c,ccrz__ProductItem__r.Id,ccrz__ProductItem__r.ccrz__SKU__c,ccrz__ProductItem__r.cc_oo_TypeOfProduct__c,cc_oo_MinQuantity__c,ccrz__ProductItem__c,cc_oo_IsOnlyPalletProduct__c,
                                                                ccrz__ProductItem__r.ccrz__ProductId__c,ccrz__ProductItem__r.cc_oo_UoMDesc__c,ccrz__ProductItem__r.ccrz__UnitOfMeasure__c,cc_oo_PalletSize__c
                                                                from ccrz__E_ProductInventoryItem__c
                                                                where ccrz__ProductItem__r.Id IN:prdlst and cc_oo_Seller__c=:sellerId];
                                                   
        return prdInvItm;
    }
    
    // User story: OO-2036 Contact US To send the email once the user clicks on send button 
    public void sendEmail(String ToEmail, String FromEmail, String subject, String message){
    String CSREmailAddress = LOLSettings__c.getAll().get('CSR_EmailAddress').Value__c;
     Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
     //mail.setToAddresses(new String[] {'southcentralcustomerservice@landolakes.com'});
     //mail.setToAddresses(new String[] {'sashokkale@deloitte.com'});
     mail.setToAddresses(new String[] {CSREmailAddress});
     mail.setReplyTo(FromEmail);
     //mail.setSenderDisplayName('CSR Contact US');
     //mail.setSubject('Thank you for Contacting us! Our Customer Service will get in touch with you shortly.');
     mail.setSubject(subject);
     mail.setBccSender(false);
     mail.setUseSignature(false);
     //mail.setPlainTextBody('This is a CSR Contact Us Email');
     mail.setPlainTextBody(message);
     System.debug('Message for the mail--->' +message);
     system.debug('@@@@ sendEmail - mail : ' + mail);
     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    //US - 2408 - lead time calculation excluding Holiday and weekend    
     public static Date getHolidayLeadDate(String sellerId, Date leadDate){
        Date dayToday = Date.today(); 
        Date futureDate = dayToday.addMonths(5);
        List<CC_OO_PlantHolidayCalendar__c> holidayCalendarList= [Select Id, cc_oo_Holiday__c, cc_oo_Month__c,  cc_oo_Year__c from CC_OO_PlantHolidayCalendar__c 
                                    where cc_oo_Holiday__c >= :dayToday AND  cc_oo_Holiday__c <=:futureDate
                                    AND cc_oo_Plant__c = :sellerId ORDER BY cc_oo_Holiday__c ASC];
        
        //Integer holiday = 0;
        if(!holidayCalendarList.isEmpty()) {
            for(CC_OO_PlantHolidayCalendar__c holiday : holidayCalendarList) {
                if(holiday.cc_oo_Holiday__c >= dayToday && holiday.cc_oo_Holiday__c <= leadDate) {
                    leadDate = leadDate.addDays(1);
                }           
            }   
        }   
        return leadDate;
     }
     
     /*public static Date calculateLeadTime(Date temporaryLeadTime){
            
            Integer nonWorkingDays = 0;
            Integer currentDay;
            for(Integer i=0; i <= leadTime.daysBetween(temporaryLeadTime); i++) {
                currentDay = Math.MOD(Date.newInstance(1990,1,7).daysBetween(leadTime.addDays(i)),7);
                if(currentDay == 6 || currentDay == 0) {
                    nonWorkingDays++;
                }
            }
            temporaryLeadTime = temporaryLeadTime.addDays(+nonWorkingDays);
            Datetime dt = DateTime.newInstance(temporaryLeadTime.year(), temporaryLeadTime.month(), temporaryLeadTime.day());
            if(dt.format('E') == 'Sat'){
                temporaryLeadTime = leadTime.adddays(+1);
            }
            else if(dt.format('E') == 'Sun'){
                temporaryLeadTime = leadTime.adddays(+2);
            }
            return temporaryLeadTime;
    }*/
     //US - 2408-End

    //US-2407- Get current time for the timezone
    public static boolean getCurrentAndCutOffTime(String typeOfProduct,String sid,String shippingMethod){
        DateTime dtGmt = system.now();
        String currentGmtTime=dtGmt.format('MM/dd/yyyy HH:mm');
        system.debug('=======This will return Current TimeZone time====='+currentGmtTime);
        String cutOffTime=getCutOffTime(typeOfProduct,sid,shippingMethod);
        boolean addLead=false;
        
        if(String.isNotBlank(cutOffTime) && cutOffTime != '' && cutOffTime.containsNone('/')) {
            Date currentGmtDate=dtGmt.date();
            String formattedDate=currentGmtDate.format();
            String[] cutTime=cutOffTime.split(' ');
            String cutOffDateTime=formattedDate+' '+cutTime[0]+' '+cutTime[1];//02/09/2017 06:14 AM
            DateTime cutOffTimeInGmt=DateTime.parse(cutOffDateTime);
            System.debug('cutOffTimeInGmt'+cutOffTimeInGmt);
            String timeZone=cc_oo_HelperController.getTimeZone(String.valueOf(cutTime[2]));
                    
            String currentTimezoneInCutOffTimezone=dtGmt.format('MM/dd/yyyy hh:mm a',timeZone);
            System.debug('<<<<<<currentTimezoneInCutOffTimezone>>>>>>'+currentTimezoneInCutOffTimezone);
            DateTime currentTimeInGmt=DateTime.parse(currentTimezoneInCutOffTimezone);
            System.debug('<<<<<<currentTimeInGmt>>>>>>'+currentTimeInGmt);
            
            if(currentTimeInGmt>cutOffTimeInGmt){
                addLead=true;
            }
        }
        
        
    return addLead;
    }
         
     public static String getCutOffTime(String typeOfProduct,String sid,String shippingMethod){
        
        String finalCutOffTime='';
        if(String.isNotBlank(shippingMethod)){
            List<CC_OO_PlantCutOff__c> plantCutOffList= [SELECT cc_oo_AMPM__c,cc_oo_PlantCutoffTime__c,CC_OO_TIMEZONE__C
                                                            FROM CC_OO_PlantCutOff__c WHERE cc_oo_ProductType__c=:typeOfProduct AND cc_oo_Seller__c=:sid AND cc_oo_ShippingMethod__c=:shippingMethod];
            if(!plantCutOffList.isEmpty()){
                finalCutOffTime=plantCutOffList[0].cc_oo_PlantCutoffTime__c+' '+plantCutOffList[0].cc_oo_AMPM__c+' '+plantCutOffList[0].CC_OO_TIMEZONE__C;
            }
        }
        else{
            List<CC_OO_PlantCutOff__c> plantCutOffList= [SELECT cc_oo_AMPM__c,cc_oo_PlantCutoffTime__c,CC_OO_TIMEZONE__C,cc_oo_ShippingMethod__c 
                                                            FROM CC_OO_PlantCutOff__c WHERE cc_oo_ProductType__c=:typeOfProduct AND cc_oo_Seller__c=:sid];
        
            if(!plantCutOffList.isEmpty() && plantCutOffList.size()>1){
                if((plantCutOffList[0].cc_oo_AMPM__c).equalsIgnoreCase(plantCutOffList[1].cc_oo_AMPM__c) && (plantCutOffList[0].cc_oo_PlantCutoffTime__c).equalsIgnoreCase(plantCutOffList[1].cc_oo_PlantCutoffTime__c)){
                    finalCutOffTime=plantCutOffList[0].cc_oo_PlantCutoffTime__c+' '+plantCutOffList[0].cc_oo_AMPM__c+' '+plantCutOffList[0].CC_OO_TIMEZONE__C;
                }
                else{
                    finalCutOffTime=plantCutOffList[0].cc_oo_PlantCutoffTime__c+' '+plantCutOffList[0].cc_oo_AMPM__c+' '+plantCutOffList[0].CC_OO_TIMEZONE__C+'-'+plantCutOffList[0].cc_oo_ShippingMethod__c+'/'+plantCutOffList[1].cc_oo_PlantCutoffTime__c+' '+plantCutOffList[1].cc_oo_AMPM__c+' '+plantCutOffList[1].CC_OO_TIMEZONE__C+'-'+plantCutOffList[1].cc_oo_ShippingMethod__c;
                }
            }
             else if(plantCutOffList.size()==1){
                    finalCutOffTime=plantCutOffList[0].cc_oo_PlantCutoffTime__c+' '+plantCutOffList[0].cc_oo_AMPM__c+' '+plantCutOffList[0].CC_OO_TIMEZONE__C;  
            }
        /*List<Time> plantCutOffTime= new List<Time>();
        Time t = Time.newInstance(12,00,0,0);
        String[] cutOffTime = null;
        String cutOfftimeZone = '';
        Map<Time,String> cutOffMap= new Map<Time,String>();
        if(!plantCutOffList.isEmpty()){
            for(CC_OO_PlantCutOff__c plantCutOff :plantCutOffList){
                cutOffTime=plantCutOff.cc_oo_PlantCutoffTime__c.split(':');
                Integer hours = integer.valueOf(cutOffTime[0]);
                Integer mins  = integer.valueOf(cutOffTime[1]);
                Time myCutOffTime = Time.newInstance(hours,mins,0,0);
                if(plantCutOff.cc_oo_AMPM__c=='PM' && myCutOffTime<=t){
                    myCutOffTime=myCutOffTime.addHours(12);
                }
                plantCutOffTime.add(myCutOffTime);  
                cutOfftimeZone=plantCutOff.CC_OO_TIMEZONE__C;   
                cutOffMap.put(myCutOffTime,plantCutOff.cc_oo_PlantCutoffTime__c+' '+plantCutOff.cc_oo_AMPM__c+' '+cutOfftimeZone);     
            } 
            Time newCutOffTime = plantCutOffTime[0];
            if(plantCutOffTime.size()>1){
                for(Time plantTime:plantCutOffTime){
                    if(plantTime>newCutOffTime){
                        newCutOffTime= plantTime;
                    }   
                }
            }
            
            if(cutOffMap != null && String.isNotBlank(cutOffMap.get(newCutOffTime))) {
                finalCutOffTime = cutOffMap.get(newCutOffTime);
            }
        }*/
        }
        return finalCutOffTime;
    }
    
    public static String getShippingMethod(String cartId){
        
        List<ccrz__E_Cart__c> cartDetails = [SELECT c.ccrz__EncryptedId__c,c.ccrz__ShipMethod__c FROM ccrz__E_Cart__c c WHERE c.ccrz__EncryptedId__c =:cartId LIMIT 1];
        
        String shippingMethod = '';
        if(!cartDetails.isEmpty()) {
            shippingMethod=cartDetails[0].ccrz__ShipMethod__c;
        }
        
        if(String.isNotBlank(shippingMethod)){
            String[] splitShippingMethod=shippingMethod.split(' - ');
            if(splitShippingMethod.size() > 1) {
                    shippingMethod=splitShippingMethod[1].deleteWhitespace().toUpperCase();
                } else {
                    shippingMethod=splitShippingMethod[0].deleteWhitespace().toUpperCase();
                }          
        }
        else{
            shippingMethod=null;    
        }
        return shippingMethod;
    }
    
    public static Map<String,Object> getFinalCutOff(String finalCutOffTime){
                    Map<String,Object> dataMap= new Map<String,Object>();
                    String pickUpCutOffTime=null;
                    String deliveryCutOffTime=null;
                    if(String.isNotBlank(finalCutOffTime) && finalCutOffTime.contains('/')){
                        String[] finalCutOff=finalCutOffTime.split('/');
                        String shipOne=finalCutOff[0];
                        String shipTwo=finalCutOff[1];
                        if(shipOne.contains('DELIVERY')){
                            String[] cutOff=shipOne.split('-');
                            deliveryCutOffTime=cutOff[0];
                        }
                        else{
                            String[] cutOff=shipOne.split('-');
                            pickUpCutOffTime=cutOff[0];
                        }
                        if(shipTwo.contains('DELIVERY')){
                            String[] cutOff=shipTwo.split('-');
                            deliveryCutOffTime=cutOff[0];
                        }
                        else{
                            String[] cutOff=shipTwo.split('-');
                            pickUpCutOffTime=cutOff[0];
                        }
                            dataMap.put('pickUpCutOffTime',pickUpCutOffTime);
                            dataMap.put('deliveryCutOffTime',deliveryCutOffTime);
                        }
                    return dataMap;
     }
     
     
     //US - 2495 - displaying primary and secondary carts    
     public static Map<String, Object> getCartDetails(String sellerId, String shipToId, 
                                    String cartId,boolean fromOrderInfo,Id accountId,Id contactId,Id userId, String shipDate){
                                        
        Map<String, Object> dataMap= new Map<String,Object>();
        String finalCutOffTime=null;
        String pickUpCutOffTime=null;
        String deliveryCutOffTime=null;
        // Creation of new Cart when cart is null
            if(cartId == null || cartId == '' || cartId == '{}' || cartId.toLowercase()  == 'undefined') {
                ccrz__E_Cart__c  cartReturn = cc_oo_HeaderController.mapToCart(sellerId ,shipToId,false );
                cartId  = String.valueOf(cartReturn.ccrz__EncryptedId__c);
            }
        
        try{
            List<ccrz__E_Cart__c> cartList = [SELECT id, cc_oo_isShipDateExtended__c,ccrz__EncryptedId__c,ccrz__RequestDate__c,ccrz__ShipMethod__c,
                    cc_oo_SplitCartType__c,ccrz__ActiveCart__c, cc_oo_SplitCart__c,cc_oo_SplitCart__r.ccrz__EncryptedId__c, ccrz__TotalAmount__c, (SELECT Id, ccrz__Product__c, ccrz__Product__r.Id
                    , ccrz__Product__r.cc_oo_TypeOfProduct__c FROM ccrz__E_CartItems__r) FROM 
                    ccrz__E_Cart__c WHERE /*ccrz__Account__c =: accountId AND ccrz__User__c =: userId AND  ccrz__Contact__c =: contactId AND
                    cc_oo_Seller__r.Id =: sellerId AND ccrz__ShipTo__r.cc_oo_BillToShipToID__c =: shipToId*/
                    (ccrz__EncryptedId__c =:cartId OR cc_oo_SplitCart__r.ccrz__EncryptedId__c =: cartId) AND ccrz__CartStatus__c = 'Open' Order by cc_oo_SplitCartType__c ASC];
            
            Map<String, Object> primaryCart= new Map<String,Object>();
            Map<String, Object> secondaryCart= new Map<String,Object>();
            Set<ID> products= new Set<ID>();
            String typeOfProduct='';
            String shippingMethod = '';
            datamap.put('tobeUpdatedCartList', null);
            List<ccrz__E_Cart__c> cartUpdateList = new List<ccrz__E_Cart__c>();
            if(cartList.size() != 0 || !cartList.isEmpty()) {
                for(ccrz__E_Cart__c cartInvolved : cartList) {
                    if(cartId.equals(cartInvolved.ccrz__EncryptedId__c)) {
                        shippingMethod=cartInvolved.ccrz__ShipMethod__c;
                    }
                    if(cartInvolved.cc_oo_isShipDateExtended__c && cartId == cartInvolved.ccrz__EncryptedId__c){
                        datamap.put('isShipDateExtended',true);
                        cartInvolved.cc_oo_isShipDateExtended__c=false;
                        cartUpdateList.add(cartInvolved);
                    } else {
                        datamap.put('isShipDateExtended',false);
                    }
                    
                }
                datamap.put('tobeUpdatedCartList', cartUpdateList);
               //update cartList;
            }
            
            if(String.isNotBlank(shippingMethod)){
                String[] splitShippingMethod=shippingMethod.split(' - ');
                if(splitShippingMethod.size() > 1) {
                    shippingMethod=splitShippingMethod[1].deleteWhitespace().toUpperCase();
                } else {
                    shippingMethod=splitShippingMethod[0].deleteWhitespace().toUpperCase();
                }
            }
            else{
                shippingMethod=null;    
            }
            List<ccrz__E_Cart__c> deleteCart = new List<ccrz__E_Cart__c>();    
            if(!cartList.isEmpty()) {
                for(ccrz__E_Cart__c cartDetail : cartList) {
                    if(cartDetail.cc_oo_SplitCartType__c == 'Primary' 
                            && (cartDetail.ccrz__EncryptedId__c.equals(cartId) || (cartDetail.cc_oo_SplitCart__r != null && cartDetail.cc_oo_SplitCart__r.ccrz__EncryptedId__c.equals(cartId)))) {
                         if(cartDetail.ccrz__RequestDate__c == null) {
                            cartDetail.ccrz__RequestDate__c =  Date.parse(shipDate);
                            update cartDetail;
                        }
                        if(!(cartDetail.ccrz__E_CartItems__r).isEmpty()){
                            typeOfProduct=cartDetail.ccrz__E_CartItems__r[0].ccrz__Product__r.cc_oo_TypeOfProduct__c;
                            String cutOffTime=cc_oo_HelperController.getCutOffTime(typeOfProduct,sellerId,null);
                            finalCutOffTime=cutOffTime;
                            Map<String,Object> newMap=cc_oo_HelperController.getFinalCutOff(finalCutOffTime);
                            dataMap.put('pickUpCutOffTime',newMap.get('pickUpCutOffTime'));
                            dataMap.put('deliveryCutOffTime',newMap.get('deliveryCutOffTime'));
                            dataMap.put('primaryCartItemsList',cartDetail.ccrz__E_CartItems__r);
                        }
                        List<AggregateResult> cartItemAggr  = [SELECT SUM(cc_oo_TotalWieght__c)TotalWeight FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__EncryptedId__c =:cartDetail.ccrz__EncryptedId__c ];
                        Decimal aggregateCartOrderWeight = 0;
                        if((Decimal)cartItemAggr[0].get('TotalWeight') != null){
                            aggregateCartOrderWeight = (Decimal)cartItemAggr[0].get('TotalWeight');
                        }
                        products= new Set<ID>();
                        Set<Id> primaryProductId = new Set<Id>();
                        for(ccrz__E_CartItem__c cartItem : cartDetail.ccrz__E_CartItems__r) {
                            products.add(cartItem.ccrz__Product__c);
                            primaryProductId.add(cartItem.ccrz__Product__r.Id);
                        }
            
                        List<ccrz__E_ProductInventoryItem__c> primaryInventoryItems = [select cc_oo_LeadTime__c 
                                                                        from ccrz__E_ProductInventoryItem__c
                                                                        where ccrz__ProductItem__c IN :primaryProductId 
                                                                        and cc_oo_Seller__c=:sellerId];
                        
                        Boolean primaryAddLeadDay = cc_oo_HelperController.getCurrentAndCutOffTime(typeOfProduct, sellerId,shippingMethod);
                        Date leadDate;
                        //US - 2408-start
                        if(primaryAddLeadDay) {
                            leadDate = Date.today().addDays(1);
                        } else {
                            leadDate = Date.today();
                        } 
                            Date finalLeadDate;
                            if(!primaryInventoryItems.isEmpty()) {
                            String[] splitLead = (primaryInventoryItems[0].cc_oo_LeadTime__c).split('\\s+');
                            Integer leadTime = Integer.valueOf(splitLead[0]);
                            leadDate = leadDate.addDays(leadTime); 
                                                                       
                            for(ccrz__E_ProductInventoryItem__c productInventory : primaryInventoryItems) {
                                String[] splitLeadAll = (productInventory.cc_oo_LeadTime__c).split('\\s+');
                                Integer leadTimeAll = Integer.valueOf(splitLeadAll[0]);
                                Date leadDateAll;
                                if(primaryAddLeadDay) {
                                    leadDateAll = Date.today().addDays(1);
                                }else {
                                    leadDateAll = Date.today();
                                } 
                                leadDateAll = leadDateAll.addDays(leadTimeAll);
                                if(leadDateAll < leadDate) {
                                    leadDate = leadDateAll;
                                }   
                            }
                        //US - 2408- Start
                            finalLeadDate = cc_oo_HelperController.getHolidayLeadDate(sellerId, leadDate);
                        }
                        String leastDate = '';
                        if(finalLeadDate != null) {
                            DateTime dt = datetime.newInstance(finalLeadDate.year(), finalLeadDate.month(), finalLeadDate.day()); 
                            leastDate = dt.format('MM/dd/YYYY');
                        } else {
                            Date newDate = Date.today().addDays(1); //US - 4739 Block today's date from selection
                            DateTime dt = datetime.newInstance(newDate.year(), newDate.month(), newDate.day()); 
                            leastDate = dt.format('MM/dd/YYYY');
                        }
                        
                        
                        primaryCart.put('cartId', cartDetail.ccrz__EncryptedId__c);
                        primaryCart.put('Sid', cartDetail.id);
                        primaryCart.put('noOfItems', products.size());
                        primaryCart.put('weight', aggregateCartOrderWeight);
                        primaryCart.put('date', cartDetail.ccrz__RequestDate__c == null ? '' : cartDetail.ccrz__RequestDate__c.format());
                        primaryCart.put('leastDate', leastDate);
                        //2495
                        primaryCart.put('price', String.valueOf(cartDetail.ccrz__TotalAmount__c.setscale(2)));
                        secondaryCart = null;   
                    } else if(cartDetail.cc_oo_SplitCartType__c == 'Secondary' 
                            && (cartDetail.ccrz__EncryptedId__c.equals(cartId) || (cartDetail.cc_oo_SplitCart__r != null && cartDetail.cc_oo_SplitCart__r.ccrz__EncryptedId__c.equals(cartId)))) {
                        if(!(cartDetail.ccrz__E_CartItems__r).isEmpty()){
                            typeOfProduct=cartDetail.ccrz__E_CartItems__r[0].ccrz__Product__r.cc_oo_TypeOfProduct__c;
                            String cutOffTime=cc_oo_HelperController.getCutOffTime(typeOfProduct,sellerId,null);
                            finalCutOffTime=cutOffTime;
                            Map<String,Object> newMap=cc_oo_HelperController.getFinalCutOff(finalCutOffTime);
                            dataMap.put('pickUpCutOffTime',newMap.get('pickUpCutOffTime'));
                            dataMap.put('deliveryCutOffTime',newMap.get('deliveryCutOffTime'));
                            dataMap.put('secondaryCartItemsList',cartDetail.ccrz__E_CartItems__r);
                        }
                        List<AggregateResult> cartItemAggr  = [SELECT SUM(cc_oo_TotalWieght__c)TotalWeight FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__EncryptedId__c =:cartDetail.ccrz__EncryptedId__c ];
                        Decimal aggregateCartOrderWeight = 0;
                        if((Decimal)cartItemAggr[0].get('TotalWeight') != null) {
                            aggregateCartOrderWeight = (Decimal)cartItemAggr[0].get('TotalWeight');
                        }
                        //US - 2408 - Start
                        if((cartDetail.ccrz__E_CartItems__r).isEmpty()) {
                            deleteCart.add(cartDetail);
                        } else {
                            // US - 2408
                            // fetch plant cutoff 
                            Boolean addLead = false;
                            Boolean fetchProductType = false;
                            //US - 2408-End
                            products= new Set<ID>();
                            Set<Id> secondaryProductId = new Set<Id>();
                            if(!fetchProductType) {
                                    addLead = cc_oo_HelperController.getCurrentAndCutOffTime(cartDetail.ccrz__E_CartItems__r[0].ccrz__Product__r.cc_oo_TypeOfProduct__c, sellerId, shippingMethod);
                                    fetchProductType = true;
                            }
                            for(ccrz__E_CartItem__c cartItem : cartDetail.ccrz__E_CartItems__r) {
                                // US - 2408-Start
                                
                                // US - 2408-End
                                products.add(cartItem.ccrz__Product__c);
                                secondaryProductId.add(cartItem.ccrz__Product__r.Id);
                            }
                            
                            List<ccrz__E_ProductInventoryItem__c> secondaryInventoryItems = [select cc_oo_LeadTime__c 
                                                                        from ccrz__E_ProductInventoryItem__c
                                                                        where ccrz__ProductItem__c IN :secondaryProductId 
                                                                        and cc_oo_Seller__c=:sellerId];
                            
                            Date leadDate;
                            //US - 2408-start
                            if(addLead) {
                                leadDate = Date.today().addDays(1);
                            } else {
                                leadDate = Date.today();
                            }
                            //US - 2408-end
                            if(!secondaryInventoryItems.isEmpty()) {  
                                String[] splitLead = (secondaryInventoryItems[0].cc_oo_LeadTime__c).split('\\s+');
                                Integer leadTime = Integer.valueOf(splitLead[0]);
                                leadDate = leadDate.addDays(leadTime);                                                
                                for(ccrz__E_ProductInventoryItem__c productInventory : secondaryInventoryItems) {
                                    String[] splitLeadAll = (productInventory.cc_oo_LeadTime__c).split('\\s+');
                                    Integer leadTimeAll = Integer.valueOf(splitLeadAll[0]);
                                    Date leadDateAll;
                                    if(addLead) {
                                        leadDateAll = Date.today().addDays(1);
                                    } else {
                                        leadDateAll = Date.today();
                                    }
                                    leadDateAll = leadDateAll.addDays(leadTimeAll);
                                    if(leadDate < leadDateAll) {
                                        leadDate = leadDateAll;
                                    }   
                                }
                                //US - 2408- Start
                                Date finalLeadDate = cc_oo_HelperController.getHolidayLeadDate(sellerId, leadDate);
                                
                                //Date finalLeadDate = cc_oo_HelperController.calculateLeadTime(holidayLeadDate);
                                
                                if(cartDetail.ccrz__RequestDate__c > finalLeadDate || cartDetail.ccrz__RequestDate__c < finalLeadDate
                                            || cartDetail.ccrz__RequestDate__c == null) {
                                    cartDetail.ccrz__RequestDate__c = finalLeadDate;
                                    update cartDetail;
                                }
                                //US - 2408-End
                            }
                            
                            secondaryCart= new Map<String,Object>();
                            secondaryCart.put('cartId', cartDetail.ccrz__EncryptedId__c);
                            secondaryCart.put('Sid', cartDetail.id);
                            secondaryCart.put('noOfItems', products.size());
                            secondaryCart.put('weight', aggregateCartOrderWeight);
                            secondaryCart.put('date', cartDetail.ccrz__RequestDate__c == null ? '' : cartDetail.ccrz__RequestDate__c.format()); 
                            //2495
                            secondaryCart.put('price', String.valueOf(cartDetail.ccrz__TotalAmount__c.setscale(2)));
                        } 
                        //US - 2408 - End                         
                    }   
                }
                //US - 2408-Start
                if(!deleteCart.isEmpty()) {
                    delete deleteCart;
                    Map<String,String> pageParams = new Map<String, String>();
                    pageParams.put('cartId', String.valueOf(primaryCart.get('cartId')));
                    ccrz.cc_CallContext.currPageParameters = pageParams;
                }
                //US - 2408-End
            }
             //Defect-5163
            if(primaryCart!=null && secondaryCart!=null && !primaryCart.isEmpty() && !secondaryCart.isEmpty()){
                if((primaryCart.get('noOfItems')==0)&& (secondaryCart.get('noOfItems')!=0)){
                secondaryCart.put('cartId',primaryCart.get('cartId'));
                }
            } 
             //Defect-5163
            dataMap.put('primaryCart', primaryCart);
            dataMap.put('secondaryCart', secondaryCart);
            dataMap.put('fromOrderInfo',fromOrderInfo);
            if(String.isNotBlank(finalCutOffTime)){
                dataMap.put('cutOffTime',finalCutOffTime);
            }
            
        }catch(Exception ex){
            CreateErrorLog(ex, CLASS_NAME, 'getCartDetails');
        }
        
        return dataMap;
     }
     
     //US - 1278 - common method to fetch Inventory details
     public static Map<String, Object> getProductStatus(Set<String> productIds, String sellerId){
        Map<String, Object> productInventoryMap = new Map<String, Object>();
        List<ccrz__E_ProductInventoryItem__c> InventoryList = [select ccrz__ProductItem__r.ccrz__SKU__c, ccrz__Status__c
                                                                from ccrz__E_ProductInventoryItem__c
                                                                where ccrz__ProductItem__r.ccrz__SKU__c IN:productIds and cc_oo_Seller__c=:sellerId];
        for(ccrz__E_ProductInventoryItem__c inventory :InventoryList){
            productInventoryMap.put(inventory.ccrz__ProductItem__r.ccrz__SKU__c, inventory);
        }
        
        return productInventoryMap;
     
     }
     
      public static Map<String, Object> getRelatedProducts(Set<String> productIds){
        Map<String, Object> relatedProductsMap = new Map<String, Object>();
        List<ccrz__E_RelatedProduct__c> relatedPrdType=[select ccrz__RelatedProductType__c,ccrz__RelatedProduct__r.ccrz__SKU__c
                                                                ,ccrz__Product__r.ccrz__SKU__c 
                                                                from ccrz__E_RelatedProduct__c where ccrz__Product__r.ccrz__SKU__c IN:productIds];
        for(ccrz__E_RelatedProduct__c relatedProducts :relatedPrdType){
            relatedProductsMap.put(relatedProducts.ccrz__Product__r.ccrz__SKU__c, relatedProducts);
        }
        
        return relatedProductsMap;
     
     }
     
     public static Map<String, Object> getProductMsg(Map<String, Object> productStatusMap, Map<String, Object> relatedProductsMap, String skuId, String cartItemId){
        Map<String, Object> datamap = new Map<String, Object>();
                    if(!productStatusMap.isEmpty()) {
                        ccrz__E_ProductInventoryItem__c inventoryProduct = (ccrz__E_ProductInventoryItem__c)productStatusMap.get(skuId);
                        String status = String.valueOf(inventoryProduct.ccrz__Status__c);
                        if(status.equals(String.valueOf(ccrz.cc_CallContext.pageLabels.get('Unavailable')))) {
                            datamap.put(cartItemId, String.valueOf(ccrz.cc_CallContext.pageLabels.get('ProductInventoryStatusError')));
                        }else if(status.equals(String.valueOf(ccrz.cc_CallContext.pageLabels.get('OutOfSeason')))) {
                            if(!relatedProductsMap.isEmpty() && relatedProductsMap.get(skuId) != null) {
                                ccrz__E_RelatedProduct__c relatedProduct = (ccrz__E_RelatedProduct__c)relatedProductsMap.get(skuId);
                                String formatted = ccrz.cc_CallContext.pageLabels.get('ProductInventoryOutofSeasonError');
                                List<String> fillers = new String[]{String.valueOf(relatedProduct.ccrz__RelatedProduct__r.ccrz__SKU__c)};
                                formatted = String.format(formatted, fillers );
                                datamap.put(cartItemId, formatted);
                            }
                        }else if(status.equals(String.valueOf(ccrz.cc_CallContext.pageLabels.get('Discontinued')))) {
                            if(!relatedProductsMap.isEmpty() && relatedProductsMap.get(skuId) != null) {
                                ccrz__E_RelatedProduct__c relatedProduct = (ccrz__E_RelatedProduct__c)relatedProductsMap.get(skuId);
                                String formatted = ccrz.cc_CallContext.pageLabels.get('ProductDiscontinuedSuggestedAlternatives');
                                List<String> fillers = new String[]{String.valueOf(relatedProduct.ccrz__RelatedProduct__r.ccrz__SKU__c)};
                                formatted = String.format(formatted, fillers );                                 
                                datamap.put(cartItemId, formatted);
                            } else {
                                datamap.put(cartItemId, String.valueOf(ccrz.cc_CallContext.pageLabels.get('ProductInventoryDiscountinuedErrorMsg')));
                            }
                        }else if(status.equals(String.valueOf(ccrz.cc_CallContext.pageLabels.get('Replaced')))) {
                            if(!relatedProductsMap.isEmpty() && relatedProductsMap.get(skuId) != null) {
                                ccrz__E_RelatedProduct__c relatedProduct = (ccrz__E_RelatedProduct__c)relatedProductsMap.get(skuId);
                                String formatted = ccrz.cc_CallContext.pageLabels.get('ProductInventoryReplacedErrorMsg');
                                List<String> fillers = new String[]{String.valueOf(relatedProduct.ccrz__RelatedProduct__r.ccrz__SKU__c)};
                                formatted = String.format(formatted, fillers );  
                                datamap.put(cartItemId, formatted);
                            }
                        }
                            
                    }
        return datamap;
     }
     
     
     //US - 1278 - End
     
        @future
        public static void createLog(string body, string name, string type, string className, string methodName){
        cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();
        errorLog.cc_oo_Description__c = body;
        errorLog.Name = name;
        errorLog.cc_oo_logtype__c = type;
        errorLog.cc_oo_ApexClass__c = className;
        errorLog.cc_oo_MethodName__c = methodName;
        insert errorLog;
    } 
    
    public static Map<String,Object> isCartUpdated(String cartId, String shipDate,String shippingMethod,boolean fromOrderInfo){
        boolean cartUpdated=false;
        String cutOffTime=null;
        Map<String,Object> dataMap=new Map<String,Object>();
        try{
            List<ccrz__E_Cart__c> cartDetails = [SELECT c.ccrz__EncryptedId__c,c.Id,ccrz__RequestDate__c,ccrz__ActiveCart__c
                    ,cc_oo_SplitCartType__c,cc_oo_SplitCart__c,cc_oo_Seller__r.Id,ccrz__ShipTo__r.cc_oo_BillToShipToID__c,
                    (SELECT Id, ccrz__SubAmount__c, ccrz__Price__c,cc_oo_ContractPrice__r.Id
                    , ccrz__Quantity__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.cc_oo_TypeOfProduct__c
                    ,cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name, cc_oo_UnitPrice__c
                    ,ccrz__Cart__r.ccrz__EncryptedId__c,ccrz__Product__r.Id 
                    FROM ccrz__E_CartItems__r) FROM ccrz__E_Cart__c c WHERE c.ccrz__EncryptedId__c =:cartId LIMIT 1];
                    
            Set<Id> primaryProductId = new Set<Id>();
            
            for(ccrz__E_CartItem__c cartItem : cartDetails[0].ccrz__E_CartItems__r) {
                primaryProductId.add(cartItem.ccrz__Product__r.Id); 
            }
            
            String shipping=null;
            if(String.isNotBlank(shippingMethod)){
                String[] splitShippingMethod=shippingMethod.split(' - ');
                if(splitShippingMethod.size() > 1) {
                    shipping=splitShippingMethod[1].deleteWhitespace().toUpperCase();
                } else {
                    shipping=splitShippingMethod[0].deleteWhitespace().toUpperCase();
                }              
            }
            
            // to fetch inventory item
            List<ccrz__E_ProductInventoryItem__c> primaryInventoryItems = [select cc_oo_LeadTime__c,ccrz__ProductItem__r.ccrz__SKU__c
                                                                        from ccrz__E_ProductInventoryItem__c
                                                                        where ccrz__ProductItem__c IN:primaryProductId 
                                                                        and cc_oo_Seller__c=:cartDetails[0].cc_oo_Seller__r.Id];
                        
            Map<String,Integer> primaryProductLead = new Map<String, Integer>();
            boolean addLead;
            
            if(!(cartDetails[0].ccrz__E_CartItems__r).isEmpty()){
                String typeOfProduct=cartDetails[0].ccrz__E_CartItems__r[0].ccrz__Product__r.cc_oo_TypeOfProduct__c;
                addLead=getCurrentAndCutOffTime(typeOfProduct,cartDetails[0].cc_oo_Seller__r.Id,shipping);
                cutOffTime=getCutOffTime(typeOfProduct,cartDetails[0].cc_oo_Seller__r.Id,shipping);
            }
            for(ccrz__E_ProductInventoryItem__c productInventory : primaryInventoryItems) {
                String[] splitLead = (productInventory.cc_oo_LeadTime__c).split('\\s+');
                Integer leadTime = Integer.valueOf(splitLead[0]);
                if(addLead){
                    primaryProductLead.put(productInventory.ccrz__ProductItem__r.ccrz__SKU__c, leadTime+1);  
                }
                else{
                    primaryProductLead.put(productInventory.ccrz__ProductItem__r.ccrz__SKU__c, leadTime);   
                }
            }
                        
            
            if(fromOrderInfo){
                List<ccrz__E_CartItem__c> cartItemList = new List<ccrz__E_CartItem__c>();
                
                for(ccrz__E_CartItem__c cartItem : cartDetails[0].ccrz__E_CartItems__r){
                    if(primaryProductLead != null) {
                        Date leadDate = Date.today();
                        leadDate = leadDate.addDays(primaryProductLead.get(cartItem.ccrz__Product__r.ccrz__SKU__c));
                        leadDate = getHolidayLeadDate(cartDetails[0].cc_oo_Seller__r.Id, leadDate);
                        System.debug('<<<leadDate'+leadDate);
                        if(leadDate > date.parse(shipDate)) {
                            System.debug('if lead greater than shipDate');
                            cartUpdated=true;
                        }
                    }
                }
            }
            dataMap.put('cartUpdated',cartUpdated);
            dataMap.put('cutOffTime',cutOffTime);
            dataMap.put('fromOrderInfo',fromOrderInfo);
        }catch(Exception ex){
            CreateErrorLog(ex, CLASS_NAME, 'isCartUpdated');
        }
       return dataMap;
    }
    
    public static Map<String,Date> getPlantHolidayLeadDate(List<CC_OO_PlantHolidayCalendar__c> holidayCalendarList, Map<String,Date> leadTimeMap){
        
        Map<String,Date> mapLeadDateWithHolidays = new Map<String, Date>(); 
        Date dayToday = Date.Today();
        //Integer holiday = 0;
        if(leadTimeMap.size() > 0){
            for(string productSKU: leadTimeMap.keySet()){
                Date eachLeadTimeDate = leadTimeMap.get(productSKU);
                for(CC_OO_PlantHolidayCalendar__c holiday : holidayCalendarList) {
                    if(holiday.cc_oo_Holiday__c >= dayToday && holiday.cc_oo_Holiday__c <= eachLeadTimeDate) {
                        eachLeadTimeDate = eachLeadTimeDate.addDays(1);
                    }           
                } 
                mapLeadDateWithHolidays.put(productSKU, eachLeadTimeDate);
            }  
        }
        return mapLeadDateWithHolidays;
     }
    
    public static void CreateErrorLog(Exception ex, string classname,string methodname){ 
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','--->' + ex);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG,'EXCEPTION','-----> '+ ex.getMessage());   
        cc_oo_ErrorLog__c errorLog = new cc_oo_ErrorLog__c();           
            errorLog.cc_oo_Description__c   = 'Exception type caught: ' + ex.getTypeName() + ' '
                                                 + 'Message: '          + ex.getMessage() + ' '
                                                 + 'Cause: '            + ex.getCause() + ' ' 
                                                 + 'Stack trace: '      + ex.getStackTraceString();
            errorLog.cc_oo_ApexClass__c     = classname;
            errorLog.cc_oo_MethodName__c    = methodname;
        insert errorLog;

            
    
}

    public static ccrz__E_CartItem__c addQuickOrderItem (Map<String, Object> cartItemMap) {
        ccrz__E_CartItem__c newCartItem = new ccrz__E_CartItem__c();
        if(cartItemMap.get('ccrz__Cart__c') != null){
            newCartItem.ccrz__Cart__c = String.valueOf(cartItemMap.get('ccrz__Cart__c'));
        }
        newCartItem.ccrz__Category__c = String.valueOf(cartItemMap.get('category'));
        newCartItem.ccrz__StoreID__c = String.valueOf(cartItemMap.get('storeID'));
        newCartItem.ccrz__Product__c = String.valueOf(cartItemMap.get('product'));
        if(cartItemMap.get('cc_oo_OriginalPalletPrice__c') != null) {
            newCartItem.cc_oo_OriginalPalletPrice__c = (Decimal)cartItemMap.get('cc_oo_OriginalPalletPrice__c');
        }
        newCartItem.ccrz__Seller__c = String.valueOf(cartItemMap.get('seller'));
        newCartItem.ccrz__Quantity__c = (Decimal)cartItemMap.get('quantity');
        newCartItem.ccrz__Price__c = (Decimal)cartItemMap.get('price');
        newCartItem.cc_oo_UnitPrice__c = (Decimal)cartItemMap.get('cc_oo_UnitPrice__c');            
        newCartItem.cc_oo_IsListPrice__c = (Boolean)cartItemMap.get('isListPrice');
        newCartItem.cc_oo_OriginalBagPrice__c = (Decimal)cartItemMap.get('cc_oo_OriginalBagPrice__c');
        newCartItem.ccrz__UnitOfMeasure__c = String.valueOf(cartItemMap.get('unitOfMeasure'));
        newCartItem.ccrz__ProductType__c = String.valueOf(cartItemMap.get('productType'));
        newCartItem.ccrz__RequestDate__c = (Date)cartItemMap.get('ccrz__RequestDate__c');
        newCartItem.cc_oo_isFreightIncluded__c=(Boolean)cartItemMap.get('isfreightincluded');
        newCartItem.ccrz__SubAmount__c = newCartItem.ccrz__Quantity__c * newCartItem.cc_oo_UnitPrice__c;
        newCartItem.cc_oo_leadtime__c=String.valueOf(cartItemMap.get('leadTime'));
        newCartItem.cc_oo_ContractPrice__c = String.valueOf(cartItemMap.get('contractId'));
        newCartItem.cc_oo_OriginalBagPrice__c = (Decimal)cartItemMap.get('cc_oo_OriginalBagPrice__c');
        newCartItem.Id = String.valueOf(cartItemMap.get('Id'));
        return newCartItem;
    } 
    
    /*
        @MethodName   : updateSecondaryCartDate
        @Params       : secondaryCartId, shippingMethod
        @returnType   : void
        @Description  : The method is to update the ship date of secondary cart based on cutoff 
                       and shipping method if selected at any point of the application. The method will be executed at 
                       different check points across the application to update the secondary cart ship date.
    
    */
    public static void updateSecondaryCartDate(String secondaryCartId, String shippingMethod) {
        try {
            List<ccrz__E_Cart__c> secondaryCart = [select id,ccrz__EncryptedId__c, cc_oo_SplitCartType__c,ccrz__ActiveCart__c
                            , cc_oo_SplitCart__r.ccrz__EncryptedId__c,ccrz__RequestDate__c,cc_oo_Seller__r.Id,ccrz__ShipTo__r.cc_oo_BillToShipToID__c,
                            cc_oo_AmendedCart__c,
                            (SELECT Id, ccrz__SubAmount__c, ccrz__Price__c,cc_oo_ContractPrice__r.Id,cc_oo_leadtime__c,cc_oo_isFreightIncluded__c
                            , ccrz__Quantity__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.cc_oo_TypeOfProduct__c
                            ,cc_oo_IsListPrice__c,cc_oo_ContractPrice__r.Name, cc_oo_UnitPrice__c, ccrz__Product__r.Id,
                            ccrz__Cart__r.ccrz__EncryptedId__c,cc_oo_JDELineNumber__c, cc_oo_LineNumberId__c, cc_oo_OriginalCartItem__c 
                            FROM ccrz__E_CartItems__r)
                            from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open'
                            AND ccrz__ActiveCart__c = false AND cc_oo_SplitCartType__c = 'Secondary' 
                            AND Id = :secondaryCartId LIMIT 1];
            
                Set<Id> secondaryProductId = new Set<Id>();
                
                if(!secondaryCart.isEmpty() && !(secondaryCart[0].ccrz__E_CartItems__r).isEmpty()) {
                    for(ccrz__E_CartItem__c cartItem : secondaryCart[0].ccrz__E_CartItems__r) {
                        secondaryProductId.add(cartItem.ccrz__Product__r.Id);   
                    }
                }
    
                List<ccrz__E_ProductInventoryItem__c> secondaryInventoryItems = [select cc_oo_LeadTime__c,ccrz__ProductItem__r.ccrz__SKU__c
                                                                            from ccrz__E_ProductInventoryItem__c
                                                                            where ccrz__ProductItem__c IN :secondaryProductId 
                                                                            and cc_oo_Seller__c=:secondaryCart[0].cc_oo_Seller__r.Id]; 
                                                                            
                String shipping=null;
                if(String.isNotBlank(shippingMethod)){
                    String[] splitShippingMethod=shippingMethod.split(' - ');
                    if(splitShippingMethod.size() > 1) {
                        shipping=splitShippingMethod[1].deleteWhitespace().toUpperCase();
                    } else {
                        shipping=splitShippingMethod[0].deleteWhitespace().toUpperCase();
                    }              
                }
                
               if (!secondaryCart.isEmpty() && !(secondaryCart[0].ccrz__E_CartItems__r).isEmpty()) {
                   String typeOfProductSecondary=secondaryCart[0].ccrz__E_CartItems__r[0].ccrz__Product__r.cc_oo_TypeOfProduct__c;
                   Boolean addLead=false;
                   addLead=getCurrentAndCutOffTime(typeOfProductSecondary,secondaryCart[0].cc_oo_Seller__r.Id,shipping);
                   
                   Date leadDate;
                   if(addLead) {
                    leadDate = Date.today().addDays(1);
                   } else {
                    leadDate = Date.today();
                   }
                   
                   if(!secondaryInventoryItems.isEmpty()) {  
                    String[] splitLead = (secondaryInventoryItems[0].cc_oo_LeadTime__c).split('\\s+');
                       Integer leadTime = Integer.valueOf(splitLead[0]);
                       leadDate = leadDate.addDays(leadTime);                                                
                       for(ccrz__E_ProductInventoryItem__c productInventory : secondaryInventoryItems) {
                           String[] splitLeadAll = (productInventory.cc_oo_LeadTime__c).split('\\s+');
                           Integer leadTimeAll = Integer.valueOf(splitLeadAll[0]);
                           Date leadDateAll;
                        if(addLead) {
                            leadDateAll = Date.today().addDays(1);
                        } else {
                            leadDateAll = Date.today();
                        }
                           leadDateAll = leadDateAll.addDays(leadTimeAll);
                           if(leadDate < leadDateAll) {
                               leadDate = leadDateAll;
                           }   
                       }
                       
                       Date finalLeadDate = cc_oo_HelperController.getHolidayLeadDate(secondaryCart[0].cc_oo_Seller__r.Id, leadDate);
                       
                       if(secondaryCart[0].ccrz__RequestDate__c > finalLeadDate || secondaryCart[0].ccrz__RequestDate__c < finalLeadDate
                                || secondaryCart[0].ccrz__RequestDate__c == null) {
                            secondaryCart[0].ccrz__RequestDate__c = finalLeadDate;
                            update secondaryCart[0];
                       }
                   }
               }                                                            
                   
        }catch(Exception ex){
            CreateErrorLog(ex, CLASS_NAME, 'updateSecondaryCartDate');
        }
    }
}