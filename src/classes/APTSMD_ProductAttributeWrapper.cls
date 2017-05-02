//Code by Mayur- ProductAttributeWrapper
public class APTSMD_ProductAttributeWrapper{
    public String name{get;set;}
    public String label{get;set;}
    public String selectedValue{get;set;}
    public  List<String> availableValues{get;set;} //in case of Picklist fields
    public String fieldType{get;set;}
    public String businessObject{get;set;}
    
    public APTSMD_ProductAttributeWrapper(String name,String businessObject){
        this.name = name;
        this.label = Schema.getGlobalDescribe().get(businessObject).getDescribe().fields.getMap().get(name).getDescribe().getLabel();
        this.selectedValue = selectedValue;
        this.fieldType = Schema.getGlobalDescribe().get(businessObject).getDescribe().fields.getMap().get(name).getDescribe().getType().name();
        this.businessObject = businessObject;
        if(this.fieldType.equalsIgnoreCase('picklist')){
            this.availableValues = getPickListEntries(name,businessObject);
        }
        if(this.fieldType.equalsIgnoreCase('PICKLIST')){ 
            this.selectedValue=this.availableValues[0];
        }else{
            this.selectedValue='10';
        }    
    }
    
    private List<String> getPickListEntries(String name,String objName){
        List<Schema.PicklistEntry> ple = Schema.getGlobalDescribe().get(businessObject).getDescribe().fields.getMap().get(name).getDescribe().getPicklistValues();
        List<String> retList = new List<String>();
        for( Schema.PicklistEntry f : ple)
        {
           retList.add(f.getLabel()+','+f.getValue());//(new selectListWrapper(f.getLabel(),f.getLabel()));
        }       
        return retList;
    }
    public class selectListWrapper{
        String name;
        String value;
        
        public selectListWrapper(String name,String value){
            this.name = name;
            this.value = value;        }
    }
    
}