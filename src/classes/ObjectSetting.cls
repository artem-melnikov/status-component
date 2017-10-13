/**
 * Created by User on 12.10.2017.
 */

public with sharing class ObjectSetting {
    //fields
    public String objectType { get; set; }
    public String childObjectType { get; set; }
    public String lookupField { get; set; }
    public String title { get; set; }
    public String icon { get; set; }
    public List<String> fields = new List<String>{
    };

    //constructor
    public ObjectSetting(Object_Setting__mdt settings) {
        Map<String, Object> m =
            (Map<String, Object>)
                JSON.deserializeUntyped(settings.Fields_Definition__c);
        this.objectType = m.get('objectType') + '';
        this.childObjectType = m.get('childObjectType') + '';
        this.lookupField = m.get('lookupField') + '';
        this.title = m.get('title') + '';
        this.icon = m.get('icon') + '';
        for (Object field : (List<Object>) m.get('fields')) {
            this.fields.add(field + '');
        }
    }
}