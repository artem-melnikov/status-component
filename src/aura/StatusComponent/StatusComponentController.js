/**
   * Created by User on 26.09.2017.
   */
  ({
      doInit: function(component, event, helper) {
          console.log('updated4');
          var action = component.get("c.request");
          var json = {
                className: 'StatusComponentController',
                methodName: 'getRelatedRecords',
                parameters: component.get("v.recordId").toString()
          };
          var jsonString = JSON.stringify(json);
          console.log('jsonString: ', jsonString)
          action.setParams({
              "requestString": jsonString
           });
          action.setCallback(this, function(response) {
              var state = response.getState();
              if (state === "SUCCESS") {
                  //объект полей
                  var responseJSON = JSON.parse(response.getReturnValue());
                  console.log('responseJSON', responseJSON.result);
                  component.set('v.response', responseJSON.result);
              }
              else {
                  console.log("Failed with state: " + state);
              }
          });
          $A.enqueueAction(action);
      }
  })