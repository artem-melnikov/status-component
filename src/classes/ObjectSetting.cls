/**
 * Created by User on 12.10.2017.
 */

public with sharing class ObjectSetting {
    //fields
    public String objectType { get; set; }
    public String childObjectType { get; set; }
    public String lookupField { get; set; }
    public String title { get; set; }
    public String icon { get; set; }
    public List<String> fields = new List<String>{
    };

    //constructor
    public ObjectSetting() {

    }
}