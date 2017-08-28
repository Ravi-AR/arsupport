/**
*   @Author:    Heena Tanna
*   @Date:      05.04.2017
*   @Jira:      LPDCR-1987
*   @Purpose:   Controller behind Carousel component on homepage
*/
public with sharing class LPDCR_BLCarousel extends LPDCR_ContentCalloutResponse {
    
    public List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions> carouselDataList { get; set; }
    public Boolean init{
        get{
            loadCarouselImages();
            return false;
        }
    }
    public LPDCR_ContentServiceUtil content_service
    {
        get
        {
            if( content_service == null )
            {
                content_service = new LPDCR_ContentServiceUtil();
            }
            return content_service;
        }
        set;
    }

    public LPDCR_BLCarousel(){
     //Constructor 
    }
    
    public List<LPDCR_BLPromotions.PurinaBusinessLink_Promotions> loadCarouselImages(){
        /*LPDCR_ContentServiceUtil contentServiceCtrl = new LPDCR_ContentServiceUtil();
        carouselDataList = contentServiceCtrl.getCarouselPromotions();
        System.debug('Carousellist-------'+ carouselDataList);
        if(carouselDataList != null){
            carouselDataList = LPDCR_BLPromotions.updatePromotionList(carouselDataList);
        }*/
        
        if(carouselDataList == null){
            carouselDataList= content_service.getCarouselPromotions().getPromotionsList();
        }
        return null;
    }
    
}