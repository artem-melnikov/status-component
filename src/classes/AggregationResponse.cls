/**
 * Created by User on 16.10.2017.
 */

public with sharing class AggregationResponse {
    public String label { get; set; }
    public String value { get; set; }

    public AggregationResponse(AggregationSetting settings, AggregateResult record) {
        this.label = settings.label;
        this.value = record.get('expr0') + '';
    }
}