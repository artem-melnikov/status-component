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
                //объект полей
                var resObject = response.getReturnValue();
                console.log('response:',resObject);
                //создаю массив ключей
                //без поля Name и ID
                var keys = Object.getOwnPropertyNames(resObject);
                keys.pop();
                var title = resObject[keys[0]];
                keys = keys.slice(1);
                console.log('keys:', keys);
                console.log('cardTitle:', title);

                component.set("v.fields", resObject);
                component.set("v.keys", keys);
                component.set("v.cardTitle", title);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);

        action = component.get("c.getObjectTypeById")
        action.setParams({
                    "objectId": recordId
                });
        action.setCallback(this, function(response){
            var objectType = response.getReturnValue().toLowerCase();
            console.log('objectType:', objectType);

            component.set("v.objectType", objectType);
        });
        $A.enqueueAction(action);
    }
})