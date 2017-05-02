public without sharing  class APTSMD_ProductWrapperClass
{
    public string ProductId;
    public string ProductCode;
    public string ProductName;
    public string Description;

    //KUKA College fields
    public string family;
    public string target;
    public string objective;
    public string prereqs;
    public string contents;
    public string remarks;

    //KUKA Product eComm Descriptions
    public string eCommDesc1;
    public string eCommDesc2;
    public string eCommDesc3;
    public string eCommDesc4;
    public string eCommDesc5;

    public string ecommUOM;

    public string frequency;
    public string ImageUrl;
    public string nameUrl;
    public string ContentUrl;
    public string rating;
    public string availability;
    public boolean HasPrices;
    public string ratingURL;
    public string star5;
    public string star4;
    public string star3;
    public string star2;
    public string star1;
    public product2 productDetails {get;set;}
    public boolean isComparable{get;set;}
    public List<APTSMD_ProductWrapperClass> recommProds{get;set;}
    public string longDescription{get;set;}
    //public LIST<Apttus_CPQApi.CPQ.PriceDO> Prices;
    public integer Quantity;
    public String ancestorCategoryId;
    public String parentCategoryId;
    public String cat;
    public String subCat;
    public String ratingImageUrl;
    public String Level1CategoryImageURL;
    public String Level2CategoryImageURL;
    public String Level0CategoryImageURL;
    public boolean showProduct{get;set;}
    public String Refinesearchstring;
    public Apttus_Config2__PriceListItem__c PriceItem;
    public Apttus_Config2__PriceListItem__c PriceItem2;//if Contracted price is available this field will be secondary field
    public Boolean isContracted;
    public String SearchDescription;
    public List<APTSMD_Recommended_Product__c> recommProd;
    public List<customerAlsoBought> customerAlsoBoughts;
    public List<recommProd> rProd{get;set;}
    public List<APTSMD_Product_Review__c> reviews;
    public List<qNa> quesAnditsAnswers {get;set;}
    public Boolean isGuidedProd {get;set;} //By mayur
    public List<Apttus_Config2__ProductFeatureValue__c > features;
    public Boolean hasOptions{get;set;}
    public List<APTSMD_ProductOptionGroupWrapper> prodOptionGroups{get;set;}
    public Boolean hasAttributes{get;set;}
    public List<APTSMD_ProductAttributeGroupWrapper> prodAttributeGroups{get;set;}
    public Boolean mustConfigure{get;set;}
    public String loyalty{get;set;}
    public Decimal rebate{get;set;}
    public String promotions{get;set;}
    public Integer[] ratingCountArray{get;set;}// Array storing count of each rating star-1st element is no of 5 star rating and last one is count of 1 start
    public decimal dExchangeRate{get;set;}

    public decimal listPriceConverted{get;set;}

    public APTSMD_ProductWrapperClass(id productide){
        //recomProds =[select APTSMD_Recommended_Product__r.Name,APTSMD_Recommended_Product__r.APTSMD_Rating__c,APTSMD_Recommended_Product__r.APTSMD_product_image_url__c,APTSMD_Recommended_Product__r.APTSMD_product_rating_indicator_src__c,APTSMD_Recommended_Product__r.ProductCode,APTSMD_Recommended_Product__r.APTSMD_Rating_Indicator__c,APTSMD_Recommended_Product__r.Description,APTSMD_Recommended_Product__r.Apttus_Config2__Icon__c from APTSMD_Recommended_Product__c where APTSMD_Product__r.id=:productide];
    }
    public class qNa{
        public APTSMD_Question__c eachquestions {get;set;}
        public List<APTSMD_Answer__c> answers {get;set;}
    }
    public class customerAlsoBought{
        public APTSMD_Recommended_Product__c recomProd {get;set;}
        public Apttus_Config2__PriceListItem__c PriceItem {get;set;}
    }
    public class recommProd{
        public APTSMD_Recommended_Product__c recomProd {get;set;}
        public Apttus_Config2__PriceListItem__c PriceItem {get;set;}
        public APTSMD_ProductWrapperClass recomWrapper {get;set;}
    }

}