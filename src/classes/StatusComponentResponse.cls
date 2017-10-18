/**
 * Created by User on 12.10.2017.
 */

public with sharing class StatusComponentResponse {
    public String title { get; set; }
    public String icon { get; set; }
    public Map<String, String> fields = new Map<String, String>{
    };

    public StatusComponentResponse(ObjectSetting settings, SObject record) {
        this.title = (String) record.get(settings.title);
        this.icon = settings.icon;

        AccessChecker access = new AccessChecker(settings.objectType);

        for (String field : settings.fields) {
            if (!access.getFieldAccess(field) || record.get(field) == null) {
                continue;
            }
            ObjectDescription descriptionOfObject = new ObjectDescription(settings.objectType);
            String fieldLabel = descriptionOfObject.getFieldDescribe(field).getLabel();
            System.debug('fields');
            fields.put(fieldLabel, String.valueOf(record.get(field)));
        }
    }
}