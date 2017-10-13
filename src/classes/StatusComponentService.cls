/**
 * Created by User on 04.10.2017.
 */

public with sharing class StatusComponentService {
    public StatusComponentService() {
    }

    private String getApiNameById(Id objectId) {
        Schema.SObjectType token = objectId.getSObjectType();
        Schema.DescribeSObjectResult objectDescribe = token.getDescribe();
        return objectDescribe.getName();
    }

    private Object getStatusComponentResponse(List<String> jsonSettings, String Id) {

        List<StatusComponentResponse> responseList = new List<StatusComponentResponse>{
        };

        for (String str : jsonSettings) {
            system.debug('Object settings');
            ObjectSetting obj = (ObjectSetting) JSON.deserialize(str, ObjectSetting.class);
            system.debug('Dynamic query');
            DynamicQuery query = new DynamicQuery(obj, Id);
            String queryString = query.getQueryString();
            if (queryString == '') {
                continue;
            }
            system.debug(queryString);
            system.debug('getting records');
            List<SObject> records = Database.query(query.getQueryString());

            if (records.isEmpty()) {
                system.debug('No records');
            }
            system.debug('creating response');
            //creating response
            StatusComponentResponse response = new StatusComponentResponse(obj, records.get(0));

            system.debug('response: ' + response);
            responseList.add(response);
            system.debug('loop end');
        }

        system.debug('responseList: ' + JSON.serialize(responseList));
        system.debug('END');
        return (responseList);
    }

    public Object getResponseJSON(String objectId) {
        system.debug('Service');
        //узнаю тип объекта
        String objectType = getApiNameById((Id) objectId);
        //получаю его настрйоки
        String querySettings = 'select Fields_Definition__c from Object_Setting__mdt where Object__r.DeveloperName=' + '\'' + objectType + '\'';
        List<Object_Setting__mdt> settings = Database.query(querySettings);
        List<String> jsonSettings = new List<String>();

        for (Object_Setting__mdt setting : settings) {
            jsonSettings.add(setting.Fields_Definition__c);
        }
        Object response = getStatusComponentResponse(jsonSettings, objectId);

        return response;
    }
}