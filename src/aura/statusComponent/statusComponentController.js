/**
 * Created by User on 26.09.2017.
 */
({
    doInit: function(component, event, helper) {

        var action = component.get("c.getFields");
        var recordId = component.get("v.recordId");
        action.setParams({
            "objectId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('response: ',response.getReturnValue());
                component.set("v.fields", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
})