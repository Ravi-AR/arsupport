({
    doInit : function(component, event, helper) {
        
    },
    gotoURL : function(component, event, helper) {
        var event = $A.get("e.rcpana:Additional_MetaData");
        event.setParams({
            "navigate" : "true"
        });
        event.fire();  
    },

    showModal: function(component, event, helper) {
        component.set('v.isLabel',true);
    }
        
})