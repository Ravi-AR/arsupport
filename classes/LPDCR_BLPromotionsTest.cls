/****************************************************************************
 * @Author:  Shruti Mishra
 * @Date:    Mar 29, 2017
 * @Jira:    LPDCR-2330 
 * @Purpose: Test class for the LPDCR_BLPromotions class
 */

@isTest( SeeAllData=false )
private class LPDCR_BLPromotionsTest 
{
/******************************************************************************
 * Setup any data and custom settings needed for the test class
 */    
    @testSetup
    public static 
    void 
    testSetup()
    {
        LPDCR_TestUtil.setCustomSettings();
    }
        
    static testMethod void testParse() 
    {
        String json = LPDCR_TestUtil.LPDCR_BLPromotionsTest_JSON;
        LPDCR_BLPromotions obj = LPDCR_BLPromotions.parse( json ); 
        
        List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions> l_promotions_list;
        List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions> l_filtered_promotions;
        
        LPDCR_BLPromotions controller = new LPDCR_BLPromotions();
        controller.PurinaBusinessLink_Promotions = obj.PurinaBusinessLink_Promotions;
        l_promotions_list = controller.getPromotionsList();
        
        LPDCR_BLPromotions.PurinaBusinessLink_Promotions l_promo_1 = new LPDCR_BLPromotions.PurinaBusinessLink_Promotions();
        LPDCR_BLPromotions.PurinaBusinessLink_Promotions l_promo_2 = new LPDCR_BLPromotions.PurinaBusinessLink_Promotions();
        l_promo_1.compareTo( l_promo_2 );
        
        LPDCR_BLPromotions.sortBy = 'Date DESC';
        l_promotions_list.sort();
        l_promo_1.compareTo( l_promo_2 );
        l_promo_1.StartDate = DateTime.now();
        l_promo_2.StartDate = DateTime.now().addDays( 1 );
        l_promo_1.compareTo( l_promo_2 );
        l_promo_2.StartDate = DateTime.now().addDays( -1 );
        l_promo_1.compareTo( l_promo_2 );
        
        LPDCR_BLPromotions.sortBy = 'Date ASC';
        l_promotions_list.sort();
        l_promo_1.compareTo( l_promo_2 );
        l_promo_1.StartDate = DateTime.now();
        l_promo_2.StartDate = DateTime.now().addDays( 1 );
        l_promo_1.compareTo( l_promo_2 );
        
        LPDCR_BLPromotions.sortBy = 'Name DESC';
        l_promotions_list.sort();
        l_promo_1.compareTo( l_promo_2 );
        l_promo_1.Headline = 'Headline';
        l_promo_2.Headline = 'Other Headline';
        l_promo_1.compareTo( l_promo_2 );
        
        LPDCR_BLPromotions.sortBy = 'Name ASC';
        l_promotions_list.sort();
        l_promo_1.compareTo( l_promo_1 );
        l_promo_1.Headline = 'Headline';
        l_promo_2.Headline = 'Other Headline';
        l_promo_1.compareTo( l_promo_2 );
        l_promo_2.Headline = 'Earlier Headline';
        l_promo_1.compareTo( l_promo_2 );
        
        List<String> l_species = new List<String>();
        l_species.add( 'Cattle' );
        l_filtered_promotions = LPDCR_BLPromotions.filterPromotions( l_promotions_list,
                                                                     l_species,
                                                                     false,
                                                                     'Name ASC' );    
        
        LPDCR_BLPromotions.PurinaBusinessLink_Promotions temp = new LPDCR_BLPromotions.PurinaBusinessLink_Promotions();
        temp.Species=null;
        temp.ItemOrder=null;
        temp.PromotionsGuid=null;
        temp.CarouselImage=null;
        temp.ShowOnHomePage=null;
        temp.Headline=null;
        temp.ShowInPromoImageCarousel=null;
        temp.PromotionsLastModified=null;
        temp.CarouselDocumentLink=null;
        temp.CarouselURLLink=null;
        temp.CarouselTextArea=null;
        temp.WYSIWYG=null;
        temp.CarouselButtonLink=null;
        temp.PromotionsID=null;
        temp.CarouselButtonText=null;
        temp.CarouselHeadline=null;
        temp.RelatedDocuments=null;
        temp.IsActive=null;
        temp.StartDate =null;
        temp.ExpirationDate=null;
        temp.DocumentType = null;
        
        LPDCR_BLPromotions.TotalRecords total= new LPDCR_BLPromotions.TotalRecords();
        
    }
    
    static testmethod void testException(){
        //Negative case
        String json = LPDCR_TestUtil.LPDCR_BLSpeciesTest_JSON;
        LPDCR_BLPromotions obj1 = LPDCR_BLPromotions.parse(json);
    }
    
}