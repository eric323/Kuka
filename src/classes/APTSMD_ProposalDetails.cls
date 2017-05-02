public without sharing class APTSMD_ProposalDetails{
    public String proposalID{get;set;}
    public String proposalNumber{get;set;}
    public String name{get;set;}
    public Decimal totalAmount{get;set;}
    public String cartId{get;set;}
    public List<proposalLineItems> lineItems{get;set;}
    
    public class proposalLineItems{
        public String itemName{get;set;}
        public String itemDesc{get;set;}
        public String UOM{get;set;}
        public Decimal quantity{get;set;}
        public String productCode{get;set;}
        public decimal listPrice{get;set;}
        public decimal netPrice{get;set;}
        public String lineType{get;set;}
    }
    
    
}