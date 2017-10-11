/**
 * Created by User on 11.10.2017.
 */

public with sharing class AccessibleObjectSettings {

    //fields
    private String objectType { get; set; }
    private String childObjectType { get; set; }
    private String lookupField { get; set; }
    private String title { get; set; }
    private String icon { get; set; }
    private List<String> fields = new List<String>{};

    private ObjectDescription objDescribe { get; set; }
    private Boolean access = false;

    //constructor
    public AccessibleObjectSettings(Map<String, Object> settings) {
        this.objDescribe = new ObjectDescription(settings.get('objectType') + '');
        if (this.objDescribe.getObjectDescribe().isAccessible()) {
            this.access = true;
            this.objectType = settings.get('objectType') + '';
            this.childObjectType = settings.get('childObjectType') + '';
            this.lookupField = settings.get('lookupField') + '';
            this.title = settings.get('title') + '';
            this.icon = settings.get('icon') + '';

            for (Object field : (List<Object>) settings.get('fields')) {
                if (!this.objDescribe.getFieldDescribe(field + '').isAccessible()) {
                    continue;
                }
                this.fields.add(field + '');
            }
        }

    }

    //getters
    public Boolean isAccessible() {
        return this.access;
    }
    public String getObjectType() {
        return this.objectType;
    }
    public String getChildObjectType() {
        return this.childObjectType;
    }
    public String getLookupField() {
        return this.lookupField;
    }
    public String getTitle() {
        return this.title;
    }
    public String getIcon() {
        return this.icon;
    }
    public List<String> getFields() {
        return this.fields;
    }
}