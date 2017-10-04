# Schema
[[/images/FrontBackSchema.png | SCHEMA]]

## Explanation:

### Provider 
does not contain any business logic. It takes parameters from frontend, call corresponding services, return wrapper or primitive. Also it contains attributes for
visualforce pages.

### Service 
contain all business logic. It takes parameters from controller/provider, call additional services, returns any. Does not return frontend wrappers.

### Wrapper 
representation of SObject for frontend. Contains logic that set properties in it.

## BaseProviderController.cls
```
global with sharing class BaseProviderController {
    
  public BaseProviderController() {
  }

  public BaseProviderController(ApexPages.StandardController controller) {
  }

  @AuraEnabled
  @RemoteAction
  global static IBaseResponse request(String requestString) {
    IBaseResponse result = new BaseRequest();

    try {
      BaseRequest request = (BaseRequest) JSON.deserialize(requestString, BaseRequest.class);

      System.Type classType = Type.forName(request.className);
      ProviderInterface classInstance = (ProviderInterface) classType.newInstance();
      
      result = classInstance.request(request);
    } catch (JSONException je) {
      result.status = 'BAD REQUEST';
      result.mesage = je.getMessage();
    } catch (AccessControlException ace) {
      // this excepthion type is for aura components
      // we need manually check FLS
      result.status = 'ACCESS DENIED';
      result.mesage = ace.getMessage();
    } catch (SomeAnotherException sae) {
      result.status = 'SOME STATUS';
      result.mesage = sae.getMessage();
    } catch (Exception e) {
      result.status = 'UNKNOWN EXCEPTION';
      result.mesage = sae.getMessage();
    }

    return result;
}

  public class BaseRequest {
    @AuraEnabled public String className;
    @AuraEnabled public String methodName;
    @AuraEnabled public String parameters;
  }

  public interface IBaseResponse {
    public String status;
    public String message;
    public Object result;
  }

  public class BaseResponse implements IBaseResponse {
    @AuraEnabled public String status;
    @AuraEnabled public String message;
    @AuraEnabled public Object result;

    public BaseResponse() {
      this.status = 'SUCCESS';
    }
  }
		
}
```

## ProviderInterface.cls
```
public interface ProviderInterface {

  //Define the method signature to be implemented in classes that implements the interface
  //Example method
  BaseProviderController.IBaseResponse request(BaseProviderController.BaseRequest request);
}
```

## TypicalProvider.cls
```
// class name could be TypicalProviderController or TypicalController
public with sharing class TypicalProvider implements ProviderInterface {

  private final String METHOD1_NAME = 'method1';
  private final String METHOD2_NAME = 'method2';
  private final String METHOD2_NAME = 'method3';
  private final TypicalService service;

  public TypicalProvider() {
    this.service = new TypicalService();
  }

  public BaseProviderController.IBaseResponse request(BaseProviderController.BaseRequest request) {
    TypicalProviderResponse result = null;

    if (action == METHOD1_NAME)
        result = this.method1(request.params);
    else if (action == METHOD2_NAME)
        result = this.method2(request.params);
    else if (action == METHOD3_NAME)
        result = this.method3(request.params);
    
    return result;
  }

  private TypicalProviderResponse method1(String parameters) {
    TypicalProviderResponse result = new TypicalProviderResponse();

    result.result = this.service.method1(parameters);

    return result;
  }

  private TypicalProviderResponse method2(String parameters) {
    TypicalProviderResponse result = new TypicalProviderResponse();

    Map<String, Object> serviceMap = (Map<String, Object>) JSON.deserializeUntyped(parameters);
    List<SObject> serviceResult = this.service.method2(serviceMap);

    // if we use wrapper for response
    // this logic should be implemented here
    result.result = new List<TypicalWrapper>();
    for (SObject sob : serviceResult) {
      result.result.add(new TypicalWrapper(sob));
    }

    return result;
  }

  private TypicalProviderResponse method3(String parameters) {
    TypicalProviderResponse result = new TypicalProviderResponse();

    TypicalService.ServiceRequest serviceWrapper = (TypicalService.ServiceRequest) JSON.deserializeUntyped(parameters);
    result.result = this.service.method2(serviceWrapper);

    return result;
  }

  public class TypicalProviderResponse extends BaseProviderController.BaseResponse implements BaseProviderController.IBaseResponse {
    @AuraEnabled public Boolean isAdditionalField;

    public TypicalProviderResponse() {
      super();
    }
  }

}
```

## TypicalService.cls
```
public with sharing class TypicalService {

  public TypicalService() {}

  public List<String> method1(String parameters) {
    // some business logic
    // could be called method from other services
  }

  public List<SObject> method2(Map<String, Object> someMap) {
    // some business logic
    // could be called method from other services
  }

  public class ServiceRequest {
    String param1;
    String param2;
    Boolean param3;
  }
  public List<String> method3(ServiceRequest request) {
    // some business logic
    // could be called method from other services
  }


  // private business logic
  private Boolean someInternalMethod1() {

  }

}
```

## BaseWrapper.cls
```
public virtual class BaseWrapper {
  protected final transient SObject record;
  private final transient Map<String, Object> populatedFieldsAsMa;

  public BaseWrapper(SObject record) {
    this.record = record;
    if (this.record != null)
      this.populatedFieldsAsMap = record.getPopulatedFieldsAsMap();
    else 
      this.populatedFieldsAsMap = new Map<String, Object>();
  }

  public virtual Object getValue(String fieldName) {

    if (this.populatedFieldsAsMap.containsKey(fieldName))
      return this.populatedFieldsAsMap.get(fieldName);

    return null;
  }
}
```

## IWrapper.cls
```
public interface IWrapper {
  public SObject transformToSObject();
}
```

## TypicalWrapper.cls
```
// please notice that Wrapper postfix should be added only for standard objects
// such as Contact, Account etc.
public class TypicalWrapper extends BaseWrapper implements IWrapper {
    @AuraEnabled public String prop1;
    @AuraEnabled public String prop2;
    @AuraEnabled public Boolean prop3;
    @AuraEnabled public Integer prop4;
    @AuraEnabled public AnotherTypicalWrapper prop5;


    public TypicalWrapper(SObject record) {
      super(record);
                                 // TODO: replace with DescribeCache class
      String fieldName         = ObjectName1.Name.getDescribe().getName();
      this.prop1               = (String) super.getValue(fieldName);

                                 // TODO: replace with DescribeCache class
      fieldName                = ObjectName1.Id.getDescribe().getName();
      this.prop2               = (String) super.getValue(fieldName);

                                 // TODO: replace with DescribeCache class
      fieldName                = ObjectName1.Field1__c.getDescribe().getName();
      this.prop3               = (Boolean) super.getValue(fieldName);

                                 // TODO: replace with DescribeCache class
      fieldName                = ObjectName1.Field2__c.getDescribe().getName();
      this.prop4               = (Integer) super.getValue(fieldName);

                                 // TODO: replace with DescribeCache class
      String objectName        = ObjectName1.Lookup1__c.getDescribe().getRelationshipName();
      if (super.getValue(objectName) != null)
	this.prop5 = new AnotherTypicalWrapper(record.getSObject(objectName));
    }

    public Custom_Object1__c transformToSObject() {
      if (super.record != null) return super.record;
      // this method takes wrapper properties and transofm it
      // to corresponding SObject
      Custom_Object2__c result = new Custom_Object2__c(
        Name = this.prop1,
        Field1__c = this.prop3,
        Field2__c = this.prop4
      );

      if (String.isNotBlank(this.prop2)) {
        result.Id = this.prop2;
      }

      return result;
    }
}
```

## AnotherTypicalWrapper.cls
```
public with sharing class AnotherTypicalWrapper extends BaseWrapper implements IWrapper {
    @AuraEnabled public String prop1;


    public AnotherTypicalWrapper(SObject record) {
      super(record);
                                 // TODO: replace with DescribeCache class
      String fieldName         = ObjectName2.Name.getDescribe().getName();
      this.prop1               = (String) super.getValue(fieldName);
    }

    public Custom_Object2__c transformToSObject() {
      if (super.record != null) return super.record;
      // this method takes wrapper properties and transofm it
      // to corresponding SObject
      Custom_Object2__c result = new Custom_Object2__c(
        Name = this.prop1
      );

      return result;
    }
}
```
