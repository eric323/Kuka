public class APTSMD_EcommPromotion {

    public String ProductName {get;set;}
    public String ProductImage {get;set;}
    public String ProductDescription {get;set;}
    public String ProductId {get;set;}
    public Decimal ProductPrice {get;set;}
    
    public APTSMD_EcommPromotion(String productName, String productImage, String productDescription, String productId, Decimal ProductPrice) {
        this.productName = productName;
        this.productImage = productImage;
        this.productDescription = productDescription;
        this.productId = productId;
        this.ProductPrice = ProductPrice;
    }
}