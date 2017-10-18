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

        AccessChecker access = new AccessChecker(settings.objectType);

        //checking access to object
        if (!access.getObjectAccess()) {
            return '';
        }
        //getting ID of related record
        String gettingIdString = 'select ' + settings.lookupField
            + ' from ' + settings.childObjectType
            + ' where Id=' + '\'' + Id + '\'';
        system.debug('gettingIdString: ' + gettingIdString);
        List<SObject> recordsList = Database.query(gettingIdString);
        if (recordsList.isEmpty()) {
            return '';
        }
        if (recordsList.get(0).get(settings.lookupField) == null) {
            return '';
        }

        String relatedRecordId = (String) recordsList.get(0).get(settings.lookupField);

        if (relatedRecordId != null) {
            system.debug('relatedRecordId: ' + relatedRecordId);
        }

        //checking access to fields
        List<String> accessibleFields = access.getAccessibleFields(settings.fields);

        //creating query string
        String queryString = 'select ' + settings.title;
        for (String field : accessibleFields) {
            queryString += ', ' + field;
        }


        queryString += ' from ' + settings.objectType + ' where Id=' + '\'' + relatedRecordId + '\'';
        return queryString;
    }
}