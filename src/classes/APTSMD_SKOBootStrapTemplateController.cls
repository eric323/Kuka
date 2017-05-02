global without sharing class APTSMD_SKOBootStrapTemplateController {

    public List<SelectOption> countryList {get;set;}
    public List<SelectOption> getLanguageList(){
        List<SelectOption> defaultLang = new List<SelectOption>();

        if(APTSMD_Utils.getLanguagesList().size() > 0){
            return APTSMD_Utils.getLanguagesList();
        }else{
            defaultLang.add(new SelectOption('en_US','English'));
            return defaultLang;  
        }
        
    }
    public String countryName {get; private set;}
    
    public String isValidUser {get;set;}
    public string countryCode {get;set;} 
    public String languageName {get;set;} 
    
    public boolean isLoggedIn {get;set;} 
    public boolean successNewsletter {get;set;}
    public string loginUser {get;set;}
    public string loginPassword {get;set;}
    
    public string loginMessage {get;set;}
    public string title {get;set;}
    public string emailNewsletter{get;set;}
    public String GOOGLE_ANALYTICS_ID {get { 
                                                return '';//iNeoSettings__c.getValues('GoogleAnalyticsID').Value__c ;
                                            }   
                                        }
    // This is a string which holds the user name as it is used in the dropdown menu.
    // There are rules on shortening it
    public String displayUserName {get{
                                        Integer MAX_USERNAME_LENGTH = 28;
                                        String retVal = UserInfo.getFirstName()+ ' ' + UserInfo.getLastName();
                                        if (retVal.length()>MAX_USERNAME_LENGTH){
                                            retVal = retVal.substring(0,MAX_USERNAME_LENGTH) + '...';
                                        }
                                        return retVal; 
                                        }
                                    }
    
    public String prettyUserProfileName {get;private set;}
    //public String userPhotoUrl {get; private set;}
    public String SESSION_TIMEOUT_MINUTES   {get{ 
                                                    return '';//iNeoSettings__c.getValues('portalTimeOutMinutes').Value__c ;
                                                }   
                                            }
    private final string token = '' ;//= iNeoSettings__c.getValues('token').Value__c;
    private final string CURRENT_PAGE_URL = ApexPages.currentPage().getUrl();
    
    public String logoUrl {get;set;}
    public APTSMD_Store__c store {get;set;}
    public String partnerLoginURL{get;set;}
    //public list<zqu__ZProduct__c> allApps {get;set;}
    
    public APTSMD_SKOBootStrapTemplateController() {
 //       Utils.log('Session ID= ' + Userinfo.getSessionId());
//        Utils.log('Instance= ' + System.URL.getSalesforceBaseUrl().getHost().remove('-api' ));
 //       Utils.log('Page URL @ VFC01_iNeoTemplate: ' + ApexPages.currentPage().getUrl());
        
        // ++ DMA 18/11/2014 : prevent user with IE to use compatibility view mode
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=Edge');        
        isValidUser = UserInfo.getUserType() == 'Guest' ? 'false' : 'true';
        
        successNewsletter = false;
        loginMessage = '';
        countryList = APTSMD_Utils.getCountryList();
        isLoggedIn = APTSMD_Utils.isLoggedIn();
        
        String strurl = ApexPages.currentPage().getUrl().toLowerCase();
        /*if (strurl.contains('vfp03_ineohome'))
            title = Label.Template_Title_Home;
        else if (strurl.contains('vfp04_ineoapps'))
            title = Label.Template_Title_Apps;
        else 
            title = strurl.split('apex/')[1];
            */
        countryName = APTSMD_Utils.currentCountry; 
        
        String communityId = Network.getNetworkId();
        String communityUrl = 'https://'+ApexPages.currentPage().getHeaders().get('Host');   //apttuscommunity-151a45e547a.force.com';// 'https://apttuscommunity-14f1600abf5.force.com';
        System.Debug(communityId);
        Network net = [Select Id, Name, UrlPathPrefix  from Network where Id =: communityId];
        
        String pathPrefix = net.UrlPathPrefix != null ? net.UrlPathPrefix : '';
        String siteUrl = communityUrl+'/'+pathPrefix ;
        
        System.debug('-------------siteUrl='+siteUrl);
         String storeId = apexpages.currentpage().getparameters().get('storeId');
        if(storeId != null){
        store = [Select APTSMD_Sub_Header_1__c,APTSMD_Sub_Header_2__c,APTSMD_Sub_Header_3__c,APTSMD_Sub_Header_Detail_1__c,APTSMD_Sub_Header_Detail_2__c,APTSMD_Sub_Header_Detail_3__c,APTSMD_Default_Currency__c, APTSMD_Default_Language__c, APTSMD_Description__c, APTSMD_Layout__c, APTSMD_Price_List__c, APTSMD_Site_Label__c, APTSMD_Site_URL__c, APTSMD_Store_Logo__c, APTSMD_Store_Manager__c, APTSMD_Store_Title__c from APTSMD_Store__c where id=:storeId limit 1];
        logoUrl = 'servlet/servlet.FileDownload?file='+store.APTSMD_Store_Logo__c;
        }
        //Document doc = [Select Id from Document where Name =: store.APTSMD_Store_Logo__c];
        //logoUrl = '/servlet/servlet.ImageServer?id='+doc.id+'&oid=00D61000000HpsP';
        
       // populatePartnerURL();
       
    }
    
    public void populatePartnerURL(){
        //get the community url prefix from presales ecomm custom setting, if blank use bps
        String prefix='';
        Apttus_Presales_eCommerce_Settings__c config = Apttus_Presales_eCommerce_Settings__c.getValues('System Properties');
        if(config != null && !String.isBlank(config.APTSMD_PartnerCommunityPrefix__c)){
            prefix = config.APTSMD_PartnerCommunityPrefix__c;
        }else{
            prefix = 'bps';
        }
        ConnectApi.CommunityPage comPage = ConnectApi.Communities.getCommunities();
        for(ConnectApi.Community com : comPage.communities){
            if(com.urlPathPrefix.equalsIgnoreCase(prefix)){
                partnerLoginURL = com.loginUrl;
            }
        }    
    }
    
    public PageReference putCookieCountry(){
        Integer expirationSeconds = 10 * 365 * 24 *60 * 60;
        Cookie deleteCountry = new Cookie('country','1',null,-1,false);
        Cookie deleteLanguage = new Cookie('language','1',null,-1 ,false);
        ApexPages.currentPage().setCookies(new Cookie[]{deleteCountry, deleteLanguage});
        
        
       // Utils.log('countryCode @ putCookieCountry: '+countryCode);
        Cookie cookieCountry = new Cookie('country',countryCode, null, expirationSeconds,false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookieCountry});
      //  Utils.log('cookieCountry @ putCookieCountry: '+cookieCountry);
        List<SelectOption> languagesCountry = APTSMD_Utils.getLanguagesList();
      //  APTSMD_Utils.log('languagesCountry @ putCookieCountry: '+languagesCountry);
        Cookie cookieLanguage = new Cookie('language',languagesCountry[0].getValue(),null, expirationSeconds,false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookieLanguage});
      //  Utils.log('cookieLanguage @ putCookieCountry: '+cookieLanguage);
        return null;
    }
    
    public PageReference init() {
        
        try {
            
            if (!isValidEntrance()) {
                // redirect to the unavailable page
                PageReference ref = Page.APTSMD_VFP07_INeoUnavailable;          
                ref.setRedirect(true);
                return ref;
            }

            countryCode = APTSMD_Utils.currentCountry;
            
            // if country code from cookie does not exist or not supported - get country name from outside web service according to IP
            if (countryCode == null) 
                countryCode = APTSMD_Utils.getCountryCodeFromWebService();
            
            Map<string,APTSMD_Country__c> countryMap = APTSMD_Utils.getCountrieMap();
            APTSMD_Country__c country = countryMap.get(countryCode);
            
            languageName = APTSMD_Utils.currentLanguage;
            
            
            if (languageName == null || languageName == '')
                // get default language for this country 
                languageName = country.APTSMD_languages__r[0].APTSMD_language_code__c;
            
            // write the cookies anyway
            Integer expirationSeconds = 10 * 365 * 24 *60 * 60; // ten years in seconds
          //  Utils.createCookie('country', countryCode, expirationSeconds);
          //  Utils.createCookie('language', languageName, expirationSeconds);
            //allApps = Utils.getAppsByLangAndCountry(languageName,countryCode);
                
                
            prettyUserProfileName = [select name from Profile where id =: Userinfo.getProfileId() limit 1][0].name.containsIgnoreCase('admin')?
                                    'Administrator':
                                    'User';
            
            //userPhotoUrl = [select FullPhotoUrl from User where id =: Userinfo.getUserId() limit 1][0].FullPhotoUrl;
            
            return null;
        }
        catch (Exception ex) {
            //Utils.log('init', ex);
            return null;
        }
    }
    
        
    public PageReference login() {
        try {
            system.debug('My Login Is called');
         //   Utils.log('login with user: *' + loginUser + '*, password: *' + 'Commented for security reason'+'*');
            //PageReference newPage = Site.login(loginUser, loginPassword,CURRENT_PAGE_URL);
            // TODO: implement dynamic login from different pages.
            String guestId = userInfo.getUserId();
            PageReference newPage = Site.login(loginUser, loginPassword,'/APTSMD_SKOECommCatalog?storeId='+store.Id);
         //   Utils.log('CURRENT_PAGE_URL @ login: '+ CURRENT_PAGE_URL);

         //   Utils.log('newPage @ login: '+newPage);
            if(!String.isBlank(guestId) && newPage !=null ) {
                  
                  List<User> newLoginUser = [SELECT ID,NAme FROM User WHERE Username=:loginUser];
                  String newUser = newLoginUser[0].id;
                  System.debug('>> New User : '+newUser);
                  
                  List<Apttus_Config2__Order__c> lstOrderHistory = [select id,Apttus_Config2__Status__c,Apttus_Config2__PriceListId__c, CreatedDate from Apttus_Config2__Order__c where OwnerId=: guestId and Apttus_Config2__Status__c =: 'New' order by CreatedDate desc];
                  System.debug('>>> Guest User Order ID : '+lstOrderHistory);
                  if(!lstOrderHistory.isEmpty()){
                      for(Apttus_Config2__Order__c obj: lstOrderHistory ){
                          obj.OwnerId = newUser;
                      }
                      update lstOrderHistory;
                  }
            }  
            if (newPage == null) {
                loginMessage = 'Invalid username Or password.';//Label.Error_Login;
            }
                
         //   Utils.log('newPage @ newPage: ' + newPage);
         //   Utils.log('loginMessage @ newPage: ' + loginMessage);       
            return newPage;
        }
        catch (Exception ex) {
            loginMessage =  ex.getMessage();
            //Utils.log('login', ex);
            return null;
        }
    }
    
    public PageReference goNewsletter() {
       // Utils.log('goNewsletter" ' + emailNewsletter);
        list<Contact> contacts = [select id, email from Contact where email=: emailNewsletter];
       // Utils.log('contacts: ' + contacts);
        if(contacts != null && contacts.size() > 0){
            //contacts[0].Newsletter__c = true;
            try{
                update contacts[0];
            }
            catch(Exception ex){
                //Utils.log('goNewsletter', ex);
                return null;
            }
        }
        else{
            list<Lead> leads = [select id, email  from Lead where email=: emailNewsletter limit 1];
        //    Utils.log('leads: ' + leads);
            if(leads != null && leads.size() > 0){
                //leads[0].Newsletter__c = true;
                try{
                    update leads[0];
                }
                catch(Exception ex){
                    //Utils.log('goNewsletter', ex);
                    return null;
                }
            }
            else{
                Lead newLead;
                
                APTSMD_Country__c c =[select APTSMD_CountryCode__c, id,Name from APTSMD_Country__c where APTSMD_CountryCode__c=:APTSMD_Utils.currentCountry limit 1];
                try{
                    String recordTypeName =  '%' + String.ValueOf(c.Name).deleteWhitespace();
                    //newLead = new Lead(RecordTypeId =[SELECT Id FROM RecordType WHERE DeveloperName LIKE :recordTypeName limit 1].Id,company = emailNewsletter, email = emailNewsletter, lastname = emailNewsletter, Newsletter__c = true);
                }catch (Exception e){
                    //newLead = new Lead(RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Standard_Lead'].Id,company = emailNewsletter, email = emailNewsletter, lastname = emailNewsletter, Newsletter__c = true);
                }
                
                if(c != null){
                    newLead.Country = c.name;
                    //newLead.Opco__c=c.Name;
                    //newLead.ProductInterest__c = Label.LeadProductIntrestContactUs;
                    newLead.LeadSource='Portal';
                }
                string googleID = APTSMD_Utils.getCookie('googleAdID');
                if (googleID!=null || System.Test.isRunningTest()){
                    //newLead.Online_marketing_ad_ID__c = googleID;
                    //newLead.Online_marketing_ad_Source__c='Google Ad';
                }

                //Utils.log('newLead: ' + newLead);
                try{
                    insert newLead;
                }
                catch(Exception ex){
                    //Utils.log('goNewsletter', ex);
                    return null;
                }
            }
        }
        successNewsletter = true;
        return null;
    }
    
    @remoteAction
    //newCase.iNeo_application__c Description Subject
    global static string refuseTermsAndAgreementCaseCreation (String serializedCase){
     //   Utils.log('serializedCase @ getArticlePageID:' +serializedCase);
        
        if (APTSMD_Utils.isLoggedIn()){
            Case newCase = (Case) JSON.deserialize(serializedCase, Sobject.class);
            //newCase.Category__c = 'Question';
            newCase.Type ='Query';
            //newCase.RecordTypeId = [Select Id From RecordType where SobjectType='Case' AND DeveloperName='myNeopost' limit 1][0].id;
            newCase.Origin = 'myNeopost';
            newCase.Priority = 'Medium';
            //newCase.myNeopost__c = true;
            newCase.Status = '0-ASSIGNED';
            newCase.AccountId = APTSMD_Utils.getCurrentAccountID();
            newCase.ContactId = APTSMD_Utils.getCurrentContactID();
            newCase.Subject='Terms of use';
            
            Database.DMLOptions dmlOptions = new Database.DMLOptions();
            dmlOptions.assignmentRuleHeader.useDefaultRule= true;
            newCase.setOptions(dmlOptions);
            upsert newCase; //changed from insert to upsert
    
     //       Utils.log('newCase AfterInsert @ getRelativeArticleURL' + newCase);
        }else{
            return 'Why U try Hack Me?';
        }
        
        return 'OK';
    }
    
    
    @remoteAction
    global static string getRelativeArticleURL (String articleID,String langCode){
    //    Utils.log('articleID @ getArticlePageID:' +articleID);
    //    Utils.log('langCode @ getArticlePageID:' +langCode);
        
        langCode = APTSMD_Utils.COUNTRY_OBJ_CODE_TO_KNOWLEDGE_COUNTRY_CODE_MAP.containsKey(langCode.toLowerCase())? APTSMD_Utils.COUNTRY_OBJ_CODE_TO_KNOWLEDGE_COUNTRY_CODE_MAP.get(langCode.toLowerCase()):'en_US';
        
        String articleType = ''+ ((ID) articleID).getSObjectType();
     //   Utils.log('articleType @ getArticlePageID:' +articleType);
        
        Sobject articleKav;
        if (articleType.endsWith('ka')){
            //articleKav = Utils.getArticlesByParentIdSet(new set<string>{articleID},langCode)[0];
            articleType+='v';
        }else if (articleType.endsWith('kav')){
            //articleKav = Utils.getArticlesByIdSet(new set<string>{articleID},langCode)[0];
        }
        
        String categoryNameQuery =  ' select ParentId, DataCategoryName From '+ articleType.split('ka')[0] + 'DataCategorySelection where ParentId = \'' + articleKav.id +'\'';

     //   Utils.log('getRelativeArticleURL@@categoryNameQuery:'+categoryNameQuery);
        

        String categoryName = String.valueOf(database.query(categoryNameQuery)[0].get('DataCategoryName'));
        
        return EncodingUtil.urlEncode ('Support&Resources/'+articleType.split('__ka')[0]+'/'+categoryName+'/' +articleKav.get('UrlName'),'UTF-8');
    }
    
    // Terms and conditions section
    @remoteAction
    global static String getTermsAndConditionsBody (String param,String langCode){
        //return APTSMD_Utils.getCurrentTermsNAgreement(param,langCode).Description__c;
        return null;
    }

    
    private boolean isValidEntrance() {
        return true;
    }
    
 }