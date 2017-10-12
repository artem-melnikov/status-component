/**
 * Created by User on 12.10.2017.
 */

public with sharing class ResponseWrapper {
    public String title { get; set; }
    public String icon { get; set; }
    public Map<String, String> fields = new Map<String, String>{
    };

    public ResponseWrapper(ObjectSetting settings, SObject record) {
        this.title = (String) record.get(settings.title);
        this.icon = settings.icon;

        for (String field : settings.fields) {
            if (record.get(field) == null) {
                continue;
            }
            String fieldLabel = ObjectDescription.ObjectsDescriptionMap.get(settings.objectType).getFieldDescribe(field).getLabel();
            fields.put(fieldLabel, (String) record.get(field));
        }
    }
}