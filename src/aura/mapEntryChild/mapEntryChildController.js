/**
 * Created by User on 28.09.2017.
 */
({
    doInit: function(component, event, helper) {
        var map = component.get("v.map");
        var keys = Object.getOwnPropertyNames(map);
        console.log('keys: ', keys);
        component.set("v.keys", keys);
    }
})