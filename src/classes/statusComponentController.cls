/**
 * Created by User on 26.09.2017.
 */

public with sharing class statusComponentController {

    @AuraEnabled
    public static String getObjectTypeById(ID objectId) {
        Schema.SObjectType token = objectId.getSObjectType();
        Schema.DescribeSObjectResult objectDescribe = token.getDescribe();
        return objectDescribe.getName();
    }

    public static sObject getObjectSettings(String objectType) {
        String querySettings = 'select Field_1__c, Field_2__c, Field_3__c, Object_Type__c from Object_Settings__mdt where DeveloperName=' + '\'' + objectType + '_Settings' + '\'';
        sObject objectSettings = Database.query(querySettings).get(0);
        return objectSettings;
    }

    public static String getQueryString(sObject objectSettings, ID objectId) {
        String query = 'select ' + objectSettings.get('Field_1__c') + ', ' + objectSettings.get('Field_2__c') + ', ' + objectSettings.get('Field_3__c') + ' '
            + 'from ' + objectSettings.get('Object_Type__c')
            + ' where Id=' + '\'' + objectId + '\'';
        return query;
    }

    @AuraEnabled
    public static sObject getFields(ID objectId) {
        //узнаю тип объекта
        String objectType = getObjectTypeById(objectId);
        //получаю его настрйоки
        sObject settings = getObjectSettings(objectType);
        //формирую строку запроса
        String queryString = getQueryString(settings, objectId);

        sObject obj = Database.query(queryString).get(0);

        return obj;
    }
}