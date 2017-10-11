/**
 * Created by User on 11.10.2017.
 */

public with sharing class DynamicQuery {

    //fields
    private AccessibleObjectSettings settings { get; set; }
    private String Id { get; set; }

    //constructor
    public DynamicQuery(AccessibleObjectSettings obj, String Id) {
        this.settings = obj;
        this.Id = Id;
    }

    //methods
    public String getResponse() {
        //checking access to object
        if (!settings.isAccessible()) {
            return '';
        }

        List<SObject> relatedObjIdList = Database.query('select ' + settings.getLookupField()
            + ' from ' + settings.getChildObjectType()
            + ' where Id=' + '\'' + Id + '\'');
        system.debug('list: ' + relatedObjIdList);

        //get records
        String query = 'select ' + settings.getTitle();
        for (Object field : settings.getFields()) {
            query = query + ', ' + field;
        }
        if (!(relatedObjIdList.get(0).get(settings.getLookupField()) == null)) {

            query = query + ' from ' + settings.getObjectType() + ' where Id=' + '\'' + relatedObjIdList.get(0).get(settings.getLookupField()) + '\'';
            List<SObject> records = Database.query(query);
            system.debug('record: ' + records.get(0).get(settings.getTitle() + ''));

            //check records
            if (records.isEmpty()) {
                return '';
            }
            SObject record = records.get(0);

            //creating correct response
            Map<String, Object> currMap = new Map<String, Object>{
            };
            currMap.put('title', record.get(settings.getTitle()));
            currMap.put('icon', settings.getIcon());

            //creating map of fields
            Map<String, String> fieldsMap = new Map<String, String>{
            };
            for (String field : settings.getFields()) {
                if (record.get(field) != null) {
                    fieldsMap.put(ObjectDescription.ObjectsDescriptionMap.get(settings.getObjectType()).getFieldDescribe(field).getLabel(), record.get(field) + '');
                }
            }
            currMap.put('fields', fieldsMap);
            system.debug('currMap:' + currMap);

            return JSON.serialize(currMap);
        }
        return '';

    }
}