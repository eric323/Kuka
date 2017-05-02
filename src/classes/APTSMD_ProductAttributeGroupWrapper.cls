//Code by Mayur- ProductAttributeGroupWrapper
public class APTSMD_ProductAttributeGroupWrapper{
    public String name{get;set;}
    public List<APTSMD_ProductAttributeWrapper> productAttributes{get;set;}
    
    public APTSMD_ProductAttributeGroupWrapper(String name, List<APTSMD_ProductAttributeWrapper> productAttributes){
        this.name = name;
        this.productAttributes = productAttributes;
    }
}