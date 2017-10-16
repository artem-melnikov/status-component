/**
 * Created by User on 16.10.2017.
 */

public with sharing class AggregationSetting {
    public String label { get; set; }
    public String function { get; set; }
    public String fieldName { get; set; }
    public String childObjectType ='';

    public AggregationSetting(Aggregation_Setting__mdt settings) {
        this.label = settings.Label__c;
        this.function = settings.Function__c;
        this.fieldName = settings.Field_Name__c;
        this.childObjectType = settings.Child_Object_Type__c;
    }
}