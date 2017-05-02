public without sharing class APTSMD_cartWrapper
{
    public string ProductId;
    public string ProductCode;
    public string ProductName;
    public string  Description;
    public string ImageUrl;
    public string ContentUrl;
    public boolean HasPrices;
    //public LIST<Apttus_CPQApi.CPQ.PriceDO> Prices;
    public integer Quantity;
    public String ancestorCategoryId;
    public String parentCategoryId;
    public String cat;
    public String subCat;
    public decimal dListPrice;
    public Apttus_Config2__PriceListItem__c PriceItem;
    public decimal dPrice;
    public string OrderId;
    public string CartId;
    public List<cartItems> cartLineItems = new List<cartItems>();
    public List<Apttus_CPQApi.CPQ.SelectedProductDO> lstProducts;
    public Boolean multipleShipment;

    public class cartItems
    {
        public String attachmentId;
        public string ProductId;
        public String ProductName;
        public Integer iQuantity;
        public decimal lineItemPrice;
        public decimal basePrice;
        public Id lineItemId;
        public String LeadTime;
        public String optName;
        public Decimal bundlePrice;
        public Decimal netPrice;
        public List<cartItems> optionLineItems;
        public APTSMD_AddressWrapper shippingDetails;
        public String UOM;
    }


}