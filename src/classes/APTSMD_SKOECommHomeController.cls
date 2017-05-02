public  without sharing  class APTSMD_SKOECommHomeController {
    // Temp URL guest login **Dev Only ** : https://devr1-devr1sdbx-ineo.cs17.force.com/vfp03_iNeoHome?token=e96a0b87d6edb50f8f1cf66444c5a3b2
    //public List<zqu__ZProduct__c> zproducts {get;set;}
    //public List<zqu__ZProduct__c> promotions {get;set;}
    public String pageTitle {get;set;}
    public String langageName {get;set;}
    public String countryName {get;set;}  
    public map<string, boolean> mapSubscribed {get;set;}
    public map<string,boolean> IsAccountRegistered2AppMap {get;private set;}
    public map<string,boolean> isFreeTrialSubscriptionMap {get;private set;}
    public map<string,string> appSubscriptionStatusMap {get;private set;}
    public map<string,boolean> IsAppUpgradeableAppMap           {get; private set;}
   
    public boolean isLoggedIn {get;set;}
    public boolean isPortalAdmin {get;private set;}
   
    public string appToRequestAccessTo{get;set;}
    
    public APTSMD_Store__c store {get;set;}
   
    private string langCode;
    private string contactId;
   
    public APTSMD_SKOECommHomeController(){
       System.debug('a');
        countryName = APTSMD_Utils.currentCountry;
        langageName = APTSMD_Utils.currentLanguage;
        langCode = langageName.containsIgnoreCase('fr')?'fr':'en_US';
        
        isLoggedIn = APTSMD_Utils.isLoggedIn();
        System.debug('b');
        if(isLoggedIn){
            string userId = Userinfo.getUserId();
            User currentUser = [Select ContactId,profile.name From User Where User.Id =: userId Limit 1];
            contactId  = currentUser.ContactId;
            isPortalAdmin = String.valueOf(currentUser.Profile.name) == 'iNeo Community Admin';
            //list<Contact_App__c> contactAppProducts = [Select CA_Product__c From Contact_App__c Where CA_Contact__r.Id =: contactId];
           
            //mapSubscribed = Utils.getContactToAppMap().get(contactId);
            //IsAccountRegistered2AppMap = Utils.isAccountRegisteredToAppMap();
           
            /* generating isFreeTrialSubscriptionMap */
            isFreeTrialSubscriptionMap = new map<string,boolean>();
            String AccountID = [select accountID from contact where id=:contactId][0].accountID;
            // builds a map from subscription to a list of
            
        }else{ //If not logged in
        }
       
       
        System.debug('c');
        String communityId = Network.getNetworkId();
        String communityUrl = 'https://'+ApexPages.currentPage().getHeaders().get('Host'); //apttuscommunity-151a45e547a.force.com';//'https://apttuscommunity-14f1600abf5.force.com';
        
        Network net = [Select Id, Name, UrlPathPrefix  from Network where Id =: communityId];
        
        String pathPrefix = net.UrlPathPrefix != null ? net.UrlPathPrefix : '';
        String siteUrl = communityUrl+'/'+pathPrefix ;
        
        System.debug('-------------siteUrl='+siteUrl);
         String storeId = apexpages.currentpage().getparameters().get('storeId');
        if(storeId != null){
        store = [Select APTSMD_Sub_Header_1__c,APTSMD_Sub_Header_2__c,APTSMD_Sub_Header_3__c,APTSMD_Sub_Header_Detail_1__c,APTSMD_Sub_Header_Detail_2__c,APTSMD_Sub_Header_Detail_3__c,APTSMD_Header_Content__c,APTSMD_Page_Title__c, APTSMD_Sub_Header_Content__c, APTSMD_Body_Content__c, APTSMD_Default_Currency__c, APTSMD_Default_Language__c, APTSMD_Description__c, APTSMD_Layout__c, APTSMD_Price_List__c, APTSMD_Site_Label__c, APTSMD_Site_URL__c, APTSMD_Store_Logo__c, APTSMD_Store_Manager__c, APTSMD_Store_Title__c from APTSMD_Store__c where id=:storeId limit 1];
        
            pageTitle=store.APTSMD_Page_Title__c;
        }
    }
    
    @TestVisible
    private string getEnchryptedURL(string url){
        if (url==null || url.contains('https')){
            return url;
        }else if (url.contains('http')){
            return url.replace('http','https');
        }else{
            return 'https://' + url;
        }
    }
   
}