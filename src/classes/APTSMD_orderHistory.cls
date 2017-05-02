public  without sharing class APTSMD_orderHistory
{
    
    public string OrderNumber;
    public string UserName;
    public datetime OrderDate;
    public string OrderStatus;
    public string OrderId;
    public List<orderlineitem> orderline = new List<orderlineitem>();
    public class orderlineitem{

        public String ProdName{get;set;}
        public Decimal Quantity{get;set;}
        
        public decimal Netprice{get;set;}
        public decimal lineItemPrice{get;set;}
       


    }
}