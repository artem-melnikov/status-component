/**
 * Created by User on 11.10.2017.
 */

public with sharing class ObjectDescription {

    //fields
    private static Map<String, ObjectDescription> ObjectsDescriptionMap = new Map<String, ObjectDescription>{
    };

    private Schema.DescribeSObjectResult objectDescribe { get; set; }
    private Map<String, Schema.SObjectField> fieldsDescribe { get; set; }

    //constructor
    public ObjectDescription(String apiObjectName) {

        Schema.SObjectType sot = ((SObject) Type.forName(apiObjectName).newInstance()).getSobjectType();

        if (sot != null) {
            this.objectDescribe = sot.newSObject().getSObjectType().getDescribe();
            this.fieldsDescribe = new Map<String, Schema.SObjectField>{
            };

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

        if (!this.fieldsDescribe.containsKey(fieldName)) {
            Map<String, Schema.SObjectField> fieldMap = this.objectDescribe.fields.getMap();
            if (fieldMap.get(fieldName) == null) {
                system.debug('unknown field');
                return null;
            }
            this.fieldsDescribe.put(fieldName, fieldMap.get(fieldName));
        }
        return this.fieldsDescribe.get(fieldName).getDescribe();
    }
}