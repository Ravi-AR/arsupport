global without sharing class cc_oo_MenuHookController extends ccrz.cc_hk_Menu {
    global override Map<String,Object> fetch(Map<String,Object> inputData){
        List<ccrz.cc_bean_MenuItem> menus = new List<ccrz.cc_bean_MenuItem>();
        Map<string, ccrz.cc_bean_MenuItem> mapMenus = new Map<string, ccrz.cc_bean_MenuItem>();
        if(!Test.isRunningTest()){
            menus.addAll((List<ccrz.cc_bean_MenuItem>)super.fetch(inputData).get(ccrz.cc_hk_Menu.PARAM_MENU));
            for(ccrz.cc_bean_MenuItem menuItem: menus){
                mapMenus.put(menuItem.menuId,menuItem);
            }
        }else {
            List<ccrz.cc_bean_MenuItem> menuList = new List<ccrz.cc_bean_MenuItem>();
           ccrz.cc_bean_MenuItem menuQuickOrder = new ccrz.cc_bean_MenuItem ();
           ccrz.cc_bean_MenuItem menuMyAccounts = new ccrz.cc_bean_MenuItem ();
           ccrz.cc_bean_MenuItem menuMyOrders = new ccrz.cc_bean_MenuItem ();
           
           menuQuickOrder.displayName=  'QuickOrder';
           menuQuickOrder.menuId        =   'QuickOrder';
           menuMyAccounts.displayName=  'MyAccount';
           menuMyAccounts.menuId        =   'MyAccount';
           menuMyOrders.displayName=  'MyOrders';
           menuMyOrders.menuId        =   'MyOrders';
           menuList.add(menuQuickOrder);
           menuList.add(menuMyOrders);
           menuList.add(menuMyAccounts);
           
           
           ccrz.cc_bean_MenuItem menuQuickOrderCSR = new ccrz.cc_bean_MenuItem();
           ccrz.cc_bean_MenuItem menuMyAccountsCSR = new ccrz.cc_bean_MenuItem ();
           ccrz.cc_bean_MenuItem menuMyOrdersCSR = new ccrz.cc_bean_MenuItem ();
           menuQuickOrderCSR.displayName=   'QuickOrderCSR';
           //ccrz__StoreID__c   =   'PurinaMills',
           menuQuickOrderCSR.menuId     =   'QuickOrderCSR';
           menuMyAccountsCSR.displayName=  'MyAccountCSR';
           menuMyAccountsCSR.menuId        =   'MyAccountCSR';
           menuMyOrdersCSR.displayName=  'MyOrdersCSR';
           menuMyOrdersCSR.menuId        =   'MyOrdersCSR';
           menuList.add(menuQuickOrderCSR);
           menuList.add(menuMyOrdersCSR);
           menuList.add(menuMyAccountsCSR);
           
           menus.addAll(menuList);
           
            for(ccrz.cc_bean_MenuItem menuItem: menus){
                mapMenus.put(menuItem.menuId,menuItem);
            }
        }        
        String portalUser = ccrz.cc_CallContext.currPageParameters.get('portalUser');
                
        
        if(!menus.isEmpty()){
        
            Integer j = 0;
            integer menuSize = menus.size();
            for(j=0; j< menuSize;j++)
            {
              if((menus.get(j).menuId == 'QuickOrder' || menus.get(j).menuId == 'MyAccount' || menus.get(j).menuId == 'MyOrders') && portalUser != null && portalUser !='' && portalUser != 'undefined')
              {
                mapMenus.remove(menus.get(j).menuId);
              }else if ((menus.get(j).menuId == 'MyOrdersCSR' || menus.get(j).menuId == 'QuickOrderCSR' || menus.get(j).menuId == 'MyAccountCSR') && !(portalUser != null && portalUser !='' && portalUser != 'undefined'))
              {
                mapMenus.remove(menus.get(j).menuId);
              }
            }
        }

        return
            new Map<String,Object>{
                ccrz.cc_hk_Menu.PARAM_MENU =>  mapMenus.values()
            };
    }
}