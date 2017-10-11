/**
 * Created by User on 11.10.2017.
 */

public with sharing class ObjectDescription {

    //fields
    public static Map<String, ObjectDescription> ObjectsDescriptionMap = new Map<String, ObjectDescription>{
    };

    private Schema.DescribeSObjectResult objectDescribe { get; set; }
    private Map<String, Schema.SObjectField> fieldsDescribe { get; set; }

    //constructor
    public ObjectDescription(String apiObjectName) {

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(apiObjectName);
        if (targetType != null) {
            this.objectDescribe = targetType.newSObject().getSObjectType().getDescribe();
            this.fieldsDescribe = this.objectDescribe.fields.getMap();

            if (!ObjectDescription.ObjectsDescriptionMap.containsKey(apiObjectName)) {
                ObjectDescription.ObjectsDescriptionMap.put(apiObjectName, this);
            }

        } else {
            system.debug('unknown object type');
        }

    }

    //methods
    public Schema.DescribeSObjectResult getObjectDescribe() {
        return this.objectDescribe;
    }
    public DescribeFieldResult getFieldDescribe(String fieldName) {
        DescribeFieldResult fieldDescription = this.fieldsDescribe.get(fieldName).getDescribe();
        if (fieldDescription == null) {
            system.debug('unknown field');
            return null;
        }
        return fieldDescription;
    }
}