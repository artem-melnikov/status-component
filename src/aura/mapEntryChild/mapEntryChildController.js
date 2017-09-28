/**
 * Created by User on 28.09.2017.
 */
({
    doInit: function(component, event, helper) {
        var map = component.get("v.map");
        var key = component.get("v.key");

        component.set("v.value", map[key]);
    }
})