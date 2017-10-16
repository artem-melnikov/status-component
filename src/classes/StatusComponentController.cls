/**
 * Created by User on 26.09.2017.
 */

public with sharing class StatusComponentController implements ProviderInterface{
    private final String GET_RELATED_RECORDS = 'getRelatedRecords';
    private final String GET_AGGREGATION_RECORDS = 'getAggregationRecords';
    private final StatusComponentService service;

    public StatusComponentController(){
        this.service = new StatusComponentService();
    }

    public BaseProviderController.BaseResponse request(BaseProviderController.BaseRequest request) {
        system.debug('TypicalProvider');
        BaseProviderController.BaseResponse result = new BaseProviderController.BaseResponse();
        system.debug('request: '+request);
        if (request.methodName == GET_RELATED_RECORDS) {
            result.result = this.getRelatedRecords(request.parameters);
        }
        if (request.methodName == GET_AGGREGATION_RECORDS) {
            result.result = this.getAggregationRecords(request.parameters);
        }
        return result;
    }

    private Object getRelatedRecords(String Id) {
        system.debug('getRelatedRecords:'+Id);

        Object relatedRecords = this.service.getResponseJSON(Id);
        //wrapper logic

        return relatedRecords;
    }

    private Object getAggregationRecords(String Id){
        system.debug('getAggregationRecords: '+Id);

        Object aggregationRecords = this.service.getAggregationObject(Id);

        return aggregationRecords;
    }
}
