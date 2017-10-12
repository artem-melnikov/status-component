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
    public ObjectSetting(String ot, String cot, String lf, String t, String i, List<String> f) {
        this.objectType = ot;
        this.childObjectType = cot;
        this.lookupField = lf;
        this.title = t;
        this.icon = i;
        this.fields = f;
    }
}