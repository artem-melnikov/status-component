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
    //related records
    private Object getStatusComponentResponse(List<String> jsonSettings, String Id) {

        List<StatusComponentResponse> responseList = new List<StatusComponentResponse>{
        };

        for (String str : jsonSettings) {
            ObjectSetting obj = (ObjectSetting) JSON.deserialize(str, ObjectSetting.class);
            DynamicQuery query = new DynamicQuery(obj, Id);
            String queryString = query.getQueryString();
            if (queryString == '') {
                continue;
            }
            system.debug('dynamicQuery: ' + queryString);
            List<SObject> records = Database.query(query.getQueryString());

            if (records.isEmpty()) {
                system.debug('No records');
            }
            //creating response
            StatusComponentResponse response = new StatusComponentResponse(obj, records.get(0));

            responseList.add(response);
        }
        return (responseList);
    }

    public Object getResponseJSON(String objectId) {
        //getting object type
        String objectType = getApiNameById((Id) objectId);
        //getting his object settings
        String querySettings = 'select Fields_Definition__c from Object_Setting__mdt where Object__r.DeveloperName=' + '\'' + objectType.replace('__c', '') + '\'';
        system.debug('queryString: ' + querySettings);
        List<Object_Setting__mdt> settings = Database.query(querySettings);
        List<String> jsonSettings = new List<String>();

        for (Object_Setting__mdt setting : settings) {
            jsonSettings.add(setting.Fields_Definition__c);
        }
        Object response = getStatusComponentResponse(jsonSettings, objectId);

        return response;
    }

    //aggregation records
    public Object getAggregationObject(String objectId) {
        //getting object type
        String objectType = getApiNameById((Id) objectId);
        //getting his aggregation settings
        String querySettings = 'select Child_Object_Type__c, function__c, Field_Name__c, Label__c from	Aggregation_Setting__mdt where Object__r.DeveloperName=' + '\'' + objectType.replace('__c', '') + '\'';
        system.debug(querySettings);
        List<Aggregation_Setting__mdt> settings = Database.query(querySettings);
        system.debug(settings);
        if (settings.isEmpty()) {
            return null;
        }
        List<AggregationSetting> aggSettings = new List<AggregationSetting>{
        };
        for (Aggregation_Setting__mdt setting : settings) {
            aggSettings.add(new AggregationSetting(setting));
        }
        Object response = getAggregationResponse(aggSettings, objectType, objectId);
        system.debug(response);
        return response;
    }

    private Object getAggregationResponse(List<AggregationSetting> settings, String objectType, String Id) {
        List<AggregationResponse> responseList = new List<AggregationResponse>{
        };
        for (AggregationSetting setting : settings) {
            String queryString = 'select ' + setting.function + '(' + setting.fieldName + ') from ';
            if (setting.function == 'COUNT') {
                queryString += setting.childObjectType + ' where ' + objectType.replace('__c', '__r') + '.Id=' + '\'' + Id + '\'';
            } else {
                queryString += objectType;
            }
            system.debug('query: ' + queryString);
            AggregateResult[] agr = Database.query(queryString);
            if (agr.isEmpty()) {
                continue;
            }
            responseList.add(new AggregationResponse(setting, agr[0]));
        }
        return responseList;
    }
}