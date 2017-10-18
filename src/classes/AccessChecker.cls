/**
 * Created by User on 13.10.2017.
 */

public with sharing class AccessChecker {
    //fields
    private ObjectDescription descriptionOfObject { get; set; }

    //constructor
    public AccessChecker(String objectApiName) {
        this.descriptionOfObject = new ObjectDescription(objectApiName);
    }

    //methods
    public Boolean getObjectAccess() {
        return this.descriptionOfObject.getObjectDescribe().isAccessible();
    }
    public Boolean getFieldAccess(String fieldName){
        return this.descriptionOfObject.getFieldDescribe(fieldName).isAccessible();
    }
    public List<String> getAccessibleFields(List<String> fields) {
        List<String> returnedList = new List<String>{
        };

        for (String field : fields) {
            if (this.descriptionOfObject.getFieldDescribe(field).isAccessible()) {
                returnedList.add(field);
            }
        }
        return returnedList;
    }
}
