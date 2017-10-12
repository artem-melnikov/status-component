/**
 * Created by User on 11.10.2017.
 */

public with sharing class DynamicQuery {

    //fields
    private ObjectSetting settings { get; set; }
    private String Id { get; set; }

    //constructor
    public DynamicQuery(ObjectSetting settings, String Id) {
        this.settings = settings;
        this.Id = Id;
    }

    //methods
    public String getQueryString() {

        //checking access to object
        ObjectDescription currentObjectDescription = new ObjectDescription(settings.objectType);
        if (!currentObjectDescription.getObjectDescribe().isAccessible()) {
            return '';
        }

        //getting ID of related record
        List<SObject> recordsList = Database.query('select ' + settings.lookupField
            + ' from ' + settings.childObjectType
            + ' where Id=' + '\'' + this.Id + '\'');

        String relatedRecordId = (String) recordsList.get(0).get(settings.lookupField);

        if (relatedRecordId != null) {
            system.debug('relatedRecordId: ' + relatedRecordId);
        }

        //creating query string
        String queryString = 'select ' + settings.title;
        //adding fields to which have access
        for (String field : settings.fields) {
            if (!currentObjectDescription.getFieldDescribe(field).isAccessible()) {
                continue;
            }
            queryString += ', ' + field;
        }
        queryString += ' from ' + settings.objectType + ' where Id=' + '\'' + relatedRecordId + '\'';
        return queryString;
    }
}