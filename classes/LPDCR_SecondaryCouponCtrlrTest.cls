/**
*   @Author:    Heena Tanna
*   @Date:      19.05.2017
*   @Jira:      LPDCR-2032
*   @Purpose:   Test class behind LPDCR_SecondaryCouponController
*/

@isTest( SeeAllData=false )
private class LPDCR_SecondaryCouponCtrlrTest {
    
    
    static testMethod void test_Constructor() {
    
        Test.startTest();
        LPDCR_SecondaryCouponController controller = new LPDCR_SecondaryCouponController();
        
        Test.stopTest();
    }
    
    static testMethod void test_upsertCouponRequest(){
        //Integer rowIndex;
        User pu = LPDCR_TestUtil.getCommunityUser();
        System.RunAs(pu){
          
        Account up = new Account( Name = 'Ultimate Parent ');
        insert up;
        Account acc = new Account(  Name = 'TestAccount', 
                                    BusinessBuilderProgramStatus__c='Eligible', 
                                    Member_Type_catcode1__c = '010-Cooperative', 
                                    ParentId = up.Id,
                                    Business_Builder_Reimbursement_Approver__c=Userinfo.getUserId(),
                                    ASM_BB_Approver__c=userinfo.getUserId(), 
                                    Account_External_ID_JDE__c = '12345',
                                    AR_customer_group_JDE__C = 'RE',
                                    Business_Builder_Program_Tier__c='Certified Expert Dealer',
                                    ShippingStreet = 'Test Street',
                                    ShippingCity='Minneapolis',
                                    ShippingState='Minnesota',
                                    ShippingPostalCode='55426');        
        insert acc;
        ApexPages.currentPage().getParameters().put('selectedAccountId',acc.Id);   
        RecordType rt = [Select Id From RecordType  Where SobjectType = 'Coupon__c' and Name = 'Purina']; 
          
        Coupon__c coupon = new Coupon__c(Name = String.valueOf(LPDCR_TestUtil.getRandomNumber(99999)),
                                         Description__c ='Test Purina Description',
                                         Coupon_Value__c = Decimal.valueOf(LPDCR_TestUtil.getRandomNumber(99)),
                                         Postmark_Date__c =System.Today(),
                                         recordTypeId = rt.id
                                         );
        insert coupon;
        RecordType rt1 = [Select Id From RecordType  Where SobjectType = 'Coupon__c' and Name = 'PMI'];
        Coupon__c coupon1 = new Coupon__c(Name = String.valueOf(LPDCR_TestUtil.getRandomNumber(99999)),
                                         Description__c ='Test PMI Description',
                                         Coupon_Value__c = Decimal.valueOf(LPDCR_TestUtil.getRandomNumber(99)),
                                         Postmark_Date__c =System.Today().adddays(20),
                                         recordTypeId = rt1.id
                                         );  
        insert coupon1;    
        
        Coupon_Postage_Expense_Table__c couponPostage = new Coupon_Postage_Expense_Table__c(Name ='Test Coupon',
                                                                                            Maximum_of_Coupons__c=1,
                                                                                            Minimum_of_Coupons__c =1000,
                                                                                            Postage_Expense__c =Decimal.valueOf(LPDCR_TestUtil.getRandomNumber(99)),
                                                                                            Estimated_Weight_oz__c =Decimal.valueOf(LPDCR_TestUtil.getRandomNumber(99)));
         insert couponPostage;
        
         
         List<LPDCR_SecondaryCouponController.CouponRequestWrapper> wrapperList = new List<LPDCR_SecondaryCouponController.CouponRequestWrapper>();
         
         LPDCR_SecondaryCouponController.CouponRequestWrapper ob = new LPDCR_SecondaryCouponController.CouponRequestWrapper(1);
         ob.couponNumber =coupon.Name;
         ob.couponQuantity = 10;
         ob.couponValue =coupon.Coupon_Value__c;
         wrapperList.add(ob);
         
         LPDCR_SecondaryCouponController.CouponRequestWrapper ob2 = new LPDCR_SecondaryCouponController.CouponRequestWrapper(2);
         ob2.couponNumber =coupon1.Name;
         ob2.couponQuantity = 10;
         ob2.couponValue =coupon1.Coupon_Value__c;         
         wrapperList.add(ob2);
         
         LPDCR_SecondaryCouponController controller = new LPDCR_SecondaryCouponController();
         PageReference pageRef = Page.LPDCR_SecondaryCouponPage;
         Test.setCurrentPage(pageRef);
         //Positive Case
         ApexPages.currentPage().getparameters().put('couponName',coupon.Name);
         controller.getCouponNumber();
         
         ApexPages.currentPage().getparameters().put('couponName',coupon1.Name);
         controller.getCouponNumber();
         //Negative Case
         ApexPages.currentPage().getparameters().put('couponName','12345');
         controller.getCouponNumber();
         controller.upsertCouponRequest();
         controller.totalCouponCount = ob.couponQuantity + ob2.couponQuantity;
         controller.couponReqWrapperList=wrapperList; 
         controller.calculateTotal();
         controller.upsertCouponRequest();
         controller.indexToDelete =1;
           
         
         ApexPages.currentPage().getparameters().put('rowIndex','1');
         controller.deleteItems();       
                                                                                                                                                                                                                                
         }
        
    
    
    }
}