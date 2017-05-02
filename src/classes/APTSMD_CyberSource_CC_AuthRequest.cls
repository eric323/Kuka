public with sharing class APTSMD_CyberSource_CC_AuthRequest{
    

    public String firstName;
    public String lastName;
    public String street1;
    public String city;
    public String state;
    public String postalCode;
    public String country;
    //public String country;
    public String phoneNumber='';
    public String email;
    public String ipAddress='unknown';
    public String cardtype;
    public String creditCardType;
    public String currencyType='USD';
    public Double amount=0.00;

    public String accountNumber;
    public Integer expirationMonth;
    public Integer expirationYear;

    public String referenceCode='InvoicePayments';

    public String pocAccountNumber;
    public Integer opco;
    

    public APTSMD_CyberSource_CC_AuthRequest() {
        
    }
}