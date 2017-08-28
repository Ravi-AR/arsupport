/**
*   @Author:    Heena Tanna
*   @Date:      05.04.2017
*   @Jira:      LPDCR-1987
*   @Purpose:   Test class behind LPDCR_BLCarousel controller
*/


@isTest(SeeAllData =false)
public class LPDCR_BLCarouselTest {
    
        String json = LPDCR_TestUtil.LPDCR_BLPromotionsTest_JSON;
        //String json = '';
        LPDCR_BLPromotions obj = LPDCR_BLPromotions.parse( json );
        
        //System.assert( obj != null );
        
      static testmethod void testloadCarousel(){
          
          Test.startTest();
          LPDCR_BLCarousel controller = new LPDCR_BLCarousel();
          controller.loadCarouselImages();
          Boolean init = controller.init;
          System.assert( controller != null );
          Test.stopTest();
      
      }  
    
}