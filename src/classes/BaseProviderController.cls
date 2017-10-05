global with sharing class BaseProviderController {

    public BaseProviderController() {
    }

    @AuraEnabled
    global static BaseResponse request(String requestString) {
        system.debug('BaseProvider');
        BaseResponse result = new BaseResponse();
        try{
            BaseRequest request = (BaseRequest) JSON.deserialize(requestString, BaseRequest.class);

            System.Type classType = Type.forName(request.className);
            ProviderInterface classInstance = (ProviderInterface) classType.newInstance();

            result = classInstance.request(request);
        } catch(JSONException je) {
            result.status = 'BAD REQUEST';
            result.message = je.getMessage();
        }
        system.debug('RESULT: '+result);
        return (result);
    }

    public class BaseRequest {
        public String className;
        public String methodName;
        public String parameters;
    }
    global class BaseResponse {
        public String status;
        public String message;
        public String result;

        public BaseResponse() {
            this.status = 'SUCCESS';
        }
    }
}