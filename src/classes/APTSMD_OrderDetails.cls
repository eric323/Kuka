public without sharing class APTSMD_OrderDetails
{
    public String BillTo_Account_Id{get;set;}
    public String ShipTo_Account_Id{get;set;}
    public String accLocation_Id{get;set;}
    public Decimal dOrderAmount{get;set;}
    public Decimal dTaxAmount{get;set;}
    public Decimal dShippingCharges{get;set;}
    public String Shipping_Method{get;set;}
    public String Shipping_Method_Value{get;set;}
    public String FullName{get;set;}
    public String Shipto_Name{get;set;}
    public String ShipTo_Phone{get;set;}
    public String ShipTo_Address{get;set;}
    public String Product_Code{get;set;}
    public String Order_Status{get;set;}
    public Decimal Promotion {get;set;}
    public String cartId{get;set;}
    
    public String Order_Number{get;set;}
    public String Order_ID{get;set;}
    public String Bank_ID{get;set;}
    public String Shipto_Address1{get;set;}
    public String Shipto_Address2{get;set;}
    public String Shipto_City{get;set;}
    public String Shipto_State{get;set;}
    public String Shipto_Country{get;set;}
    public String Shipto_Zip{get;set;}
    public DateTime Order_Date{get;set;}
    public String Shipping_Instructions{get;set;}
    public String Card_Type{get;set;}
    public String Cart_ID{get;set;}
    public String Credit_Card_Number{get;set;}
    public APTSMD_CyberSource_CC_AuthRequest ccDetails{get;set;}
    public APTSMD_eCom_CallOutResult cyberSourceResponse{get;set;}
    public List<LineItems> line_Items = new List<LineItems>();
    public String PocAcctNumber{get;set;}
    public string Payment_Type{get;set;}
    public String poNumber{get;set;}
    public Boolean multipleShipment{get;set;}
    public String owner;
    
    
    public String GuestShipTo_Street {get;set;}
    public String GuestShipTo_City {get;set;}
    public String GuestShipTo_State {get;set;}
    public String GuestShipTo_Country {get;set;}
    public String GuestShipTo_Code{get;set;}
    
    public class LineItems{

        public String Item_Name{get;set;}
        public String Item_Desc{get;set;}
        public String UOM{get;set;}
        public Decimal Quantity{get;set;}
        public String PartNumber{get;set;}
        public decimal Unit_Price{get;set;}
        public decimal Total_Price{get;set;}
        public decimal lineItemPrice {get;set;}
        public String lineType{get;set;}


    }

}