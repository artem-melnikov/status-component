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

    private Object getObjectsJSON(List<String> jsonSettings, String Id) {
        List<Map<String, Object>> finishedMapList = new List<Map<String, Object>>{
        };

        for (String str : jsonSettings) {
            Map<String, Object> m =
                (Map<String, Object>)
                    JSON.deserializeUntyped(str);
            system.debug('map: ' + m);
            //имена полей которые надо вытащить
            List<Object> fieldsList = (List<Object>) m.get('fields');
            system.debug('fields: ' + fieldsList);
            //вытаскиваем id записей
            List<SObject> l = Database.query('select ' + m.get('lookupField') + ' from ' + m.get('childObjectType') + ' where Id=' + '\'' + Id + '\'');
            system.debug('list: ' + l);
            //вытаскиваем эти записи
            for (SObject obj : l) {
                String query = 'select ' + m.get('title');
                for (Object field : fieldsList) {
                    query = query + ', ' + field;
                }
                if ((obj.get(m.get('lookupField') + '') != null)) {
                    query = query + ' from ' + m.get('objectType') + ' where Id=' + '\'' + obj.get(m.get('lookupField') + '') + '\'';
                    List<SObject> records = Database.query(query);
                    system.debug('records: ' + records.get(0).get(m.get('title') + ''));
                    //записываем все в нужной нам форме
                    if (!records.isEmpty()) {
                        Map<String, Object> currMap = new Map<String, Object>{
                        };
                        SObject record = records.get(0);

                        if(!record.getSObjectType().getDescribe().isAccessible()){
                            system.debug('No Access');
                            continue;
                        }
                        system.debug('Have Access');
                        Map<String,Schema.SObjectField> fieldsDescriptionMap = record.getSObjectType().getDescribe().fields.getMap();


                        currMap.put('title', record.get(m.get('title') + ''));
                        currMap.put('objectType', (m.get('objectType') + '').toLowerCase());
                        currMap.put('icon', m.get('icon')+'');


                        Map<String, String> fieldsMap = new Map<String, String>{};

                        for (Object field : fieldsList) {
                            if(!fieldsDescriptionMap.get(field + '').getDescribe().isAccessible()){
                                system.debug('FieldAccess: false');
                                continue;
                            }
                            if (record.get(field + '') != null) {
                                system.debug('FieldAccess: '+fieldsDescriptionMap.get(field + '').getDescribe().isAccessible());
                                fieldsMap.put(field + '', record.get(field + '') + '');
                            }
                        }
                        currMap.put('fields', fieldsMap);
                        system.debug('currMap:' + currMap);
                        finishedMapList.add(currMap);
                    }
                }
            }
        }
        system.debug('finishedMapList: ' + JSON.serialize(finishedMapList));
        return (finishedMapList);
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
        Object responseJSON = getObjectsJSON(jsonSettings, objectId);

        return responseJSON;
    }
}