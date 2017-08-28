({
  myAction : function(component, event, helper) {
    
  },
    
  auraInit: function(comp) {        
    var objectName = comp.get("v.objectName");
    var fkName = comp.get("v.relationshipName");
    var fkValue = comp.get("v.recordId");
    var viewId = comp.get("v.viewID");
    var isDebug = false;
    var ns = "CRMC_PP";
    var vfUrl = "/apex/";
    if (!isDebug && ns) {
      // Add namespace
      vfUrl += ns + "__";
    }
    vfUrl += "CRMC_Grid?sf1=1&object=" + encodeURIComponent(objectName);
    if (fkName && fkValue) {
        vfUrl += "&fkname=" + encodeURIComponent(fkName);
        vfUrl += "&fkvalue=" + encodeURIComponent(fkValue);
    }
    if (viewId) {
        vfUrl += "&viewid=" + encodeURIComponent(viewId);
    }
    comp.set("v.vfUrl", vfUrl);
    
    // listen to iframe messages
    addEventListener("message", function(e) {
      if (e.data && e.data.type) {
        switch (e.data.type.toLowerCase()) {
        // iframe passed us a lightning event to pass along
        case "event":
          var eventName = "e." + e.data.eventName;
          var eventArgs = e.data.eventArgs;
          var event = $A.get(eventName);
          if (event) {
              event.setParams(eventArgs);
              event.fire();
          }
          break;
        }
      }
    }, false);
  },

})