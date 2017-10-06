/**
 * Created by User on 06.10.2017.
 */
({
    doInit: function(component, event, helper) {
            var map = component.get("v.fields");
            var key = component.get("v.key");

            component.set("v.value", map[key]);
        }
})