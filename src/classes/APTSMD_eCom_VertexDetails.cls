public without sharing class APTSMD_eCom_VertexDetails
{
    public string sellerCode;
    public string physicalOrigin_country;
    public string destination_customerCode;
    public string destination_streetAddress;
    public string destination_City;
    public string destination_mainDiv;
    public string destination_subDiv;
    public string destination_postalcode;
    public string destination_country;
    public List<APTSMD_productDetailsForTaxCalc>  lst_Prods;
    
    public APTSMD_ecom_VertexDetails() 
    {
        sellerCode='';
        physicalOrigin_country='';
        destination_customerCode = '';
        destination_streetAddress = '';
        destination_City='';
        destination_mainDiv='';
        destination_subDiv='';
        destination_postalcode='';
        destination_country='';
        lst_Prods = new List<APTSMD_productDetailsForTaxCalc>();
    }
}