/******************************************************************************
 * Controller for the LPDCR_CC_HomePage.page
 * 
 * @Author: Heena Tanna
 * @Date: 25-04-2017 
 * @Jira: LPDCR-1989
 */



public without sharing class LPDCR_CC_HomePageController {
   
   public Map<String,Boolean> permissionSetUserMap{get;set;}
   public String selectedAccountId{get;set;}
   public Account selectedAcc{get;set;}
   
   public Boolean bbm{get;set;}
   public Boolean oo{get;set;}
   public Boolean bb{get;set;}
   public Boolean pi{get;set;}
   public Boolean mm{get;set;}
   public Boolean ep{get;set;}
   public Boolean tt{get;set;}
   
   public String bbmBGColor { get { return getBackgroundColor(); } set; }
   public String ooBGColor { get { return getBackgroundColor(); } set; }
   public String bbBGColor { get { return getBackgroundColor(); } set; }
   public String piBGColor { get { return getBackgroundColor(); } set; }
   public String mmBGColor { get { return getBackgroundColor(); } set; }
   public String epBGColor { get { return getBackgroundColor(); } set; }
   public String ttBGColor { get { return getBackgroundColor(); } set; }
   public String carouselBGColor { get { return getBackgroundColor(); } set; }
   
   private Integer counter { get; set; }
   
   public Integer tile_counter { get; set; }
   public List<String> filler_tiles { get; set; }


/******************************************************************************
 * Constructor
 */  
    public LPDCR_CC_HomePageController(){
 
      //permissionSetUserMap = LPDCR_ContentServiceUtil.getcurrentUserPerSet();
    }
    
    public void checkPermissionSetAssigment(){
        
        filler_tiles = new List<String>();
                                                 // Internal users are granted access
                                                 // to see all of the tiles
       if( UserInfo.getUserType() == 'STANDARD' )
       {
           bbm = true;
           oo = true;
           bb = true;
           pi = true;
           mm = true;
           ep = true;
           tt = true;
           tile_counter = 9;
       }
       else
       {
           tile_counter = 0;
           
           permissionSetUserMap = LPDCR_ContentServiceUtil.getcurrentUserPerSet();
	       bbm= permissionSetUserMap.get(System.Label.LPDCR_Business_Management_Permission_Set);
	       oo= permissionSetUserMap.get(System.Label.LPDCR_Online_Order_Permission_Set);
	       bb= permissionSetUserMap.get(System.Label.LPDCR_Business_Builder_Permission_Set);
	       pi= permissionSetUserMap.get(System.Label.LPDCR_Product_Information_Permission_Set);
	       mm= permissionSetUserMap.get(System.Label.LPDCR_Marketing_Permission_Set);
	       ep= permissionSetUserMap.get(System.Label.LPDCR_Events_and_Planning_Permission_Set);
	       tt= permissionSetUserMap.get(System.Label.LPDCR_Training_Permission_Set);
	       
	       if( bbm ){ tile_counter++; }
	       if( oo ){ tile_counter++; } 
	       if( bb ){ tile_counter++; }
	       if( pi ){ tile_counter++; }
	       if( ep ){ tile_counter++; }
	       if( tt ){ tile_counter++; }
	       if( mm )
	       {
            
	                                             // Marketing access acccounts for
	                                             // 3 tiles
                tile_counter = tile_counter + 3; 
           }
           
           Integer l_tiles_needed = 0;
           if( Math.mod( tile_counter, 3 ) == 0 )
           {
               l_tiles_needed = 0;
           }
           else if( tile_counter < 3 )
           {
               l_tiles_needed = 3 - tile_counter;
           }
           else if( tile_counter < 6 && mm )
           {
                                                 // Account for the carousel
                                                 // taking up two spots
               l_tiles_needed = 1;
           }
           else if( tile_counter < 6 )
           {
               l_tiles_needed = 6 - tile_counter;
           }
           else if( tile_counter < 9 && mm )
           {
                                                 // Account for the carousel
                                                 // taking up two spots
                l_tiles_needed = 1;
           }
           else if( tile_counter < 9 )
           {
               l_tiles_needed = 9 - tile_counter;
           }
           
           String l_current_color = 'bg_gry';
           if( Math.mod( tile_counter, 2 ) == 0 )
           {
                l_current_color = 'bg_wht';
           }
           
           if( mm && tile_counter == 7 )
           {
               filler_tiles.add( 'bg_gry' );
           }
           else if( mm && tile_counter == 4 )
           {
               filler_tiles.add( 'bg_wht' );
           }
           else
           {
           
	           for( Integer l_x = 0; l_x < l_tiles_needed; l_x++ )
	           {
	               if( l_current_color == 'bg_wht' )
	               {
	                   l_current_color = 'bg_gry';
	               }
	               else
	               {
	                   l_current_color = 'bg_wht';
	               }
	               filler_tiles.add( l_current_color );
	             
	           }
           }
	       
       }// /END if( UserInfo.getUserType() == 'STANDARD' )
                                                 //Change Account Logic
       if(selectedAccountId != null){
           selectedAcc = [Select Id, ParentId,Name, Dealer_Category_catcode30__c, Member_Type_catcode1__c, AR_Customer_Group_JDE__c, BusinessBuilderProgramStatus__c,AccountNumber from Account where Id =: selectedAccountId];
           System.debug('selectedAcc--'+selectedAcc); 
       } 
       else{
           selectedAccountId = LPDCR_ChangeAccountController.getSelectedAccId();
       } 
    
    }

/******************************************************************************
 * Method called from the VF page to increment the "counter" variable for each
 * component that is rendered, and return the appropriate background color
 */ 
    private
    String
    getBackgroundColor()
    {
        System.debug( 'START: LPDCR_CC_HomePageController.getBackgroundColor()' );
        System.debug( 'Param: counter = ' + counter );
        
        String l_background_color;
        
        if( counter == null )
        {
            counter = 0;
        }

        if( Math.mod( counter, 2 ) == 0 )
        {
            l_background_color = 'bg_gry';
        }
        else
        {
            l_background_color = 'bg_wht';
        }

        counter++;
        
        System.debug( 'Return: l_background_color = ' + l_background_color );
        System.debug( 'END: LPDCR_CC_HomePageController.getBackgroundColor()' );
        
        return l_background_color;
    }

}