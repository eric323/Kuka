public without sharing class APTSMD_Utils {
    
    //  Public Static Variables:
    /***********************************************/
    
    public static final boolean IS_PRODUCTION = false;
    
    public final static Integer NUMBER_OF_ARTICLES_PER_ROW = 3;
    
    private final static string geoLocationWsUrl = 'http://www.freegeoip.net/json/'; //iNeoSettings__c.getValues('geoLocationWsUrl').Value__c;
    
    public static final map<string,string> COUNTRY_OBJ_CODE_TO_KNOWLEDGE_COUNTRY_CODE_MAP = new map<string,string>{'en_gb'=>'en_US','fr'=>'fr'};
    
    public static boolean isTestWithAdminUser = false; 
    
    public static String currentLanguage {
        get {
            if (currentLanguage == null){
                currentLanguage = ApexPages.currentPage().getParameters().get('langCode');
                if (currentLanguage==null){
                    currentLanguage='en_US';
                }
            }
            return currentLanguage;
        }
    }
    
    public static String currentCountry {
        get {
            if (currentCountry == null){
                currentCountry = ApexPages.currentPage().getParameters().get('countryCode');
                if (currentCountry==null){
                    
                    currentCountry='US';
                }
                
            }
            return currentCountry;
        }
    }
    
    public static string getOwnerId(){
        List<User> uList;
        uList = (system.Test.isRunningTest())?
                                    [Select id From User where id=:UserInfo.getuserID()]:
                                    [Select id From User where username=: String.valueOf(APTSMD_IneoSettings__c.getValues('UserNameOwner').APTSMD_Value__c)];
                                        
        return(uList.size()>0)? uList[0].id : null;
    }
    
    public static List<APTSMD_Country__c> getAvailableCountries(){
        return [select id, name, APTSMD_CountryCode__c, (select id, name, APTSMD_Language_Code__c from APTSMD_Languages__r) from APTSMD_Country__c where APTSMD_INeo_Available__c = true];
    }
   
    public static Map<string,APTSMD_Country__c> getCountrieMap(){
        map <string, APTSMD_Country__c> retMap = new map<string,APTSMD_Country__c>();
        
        for (APTSMD_Country__c c : getAvailableCountries()){
            retMap.put(c.APTSMD_CountryCode__c,c);
        }
        
        return retMap;
    }
    
    public static boolean isLoggedIn(){
        return UserInfo.getUserType() != 'Guest';
    }
   
    public static String getCountryCodeFromWebService(){
        string clientIp = GetUserIPAddress();
        if (clientIp != null) {
            CountryInfo ci = getCountryInfoFromIp(clientIp);
            if (ci != null){
                return ci.country_code;
            }
        }
        return null;
    }
    
    public static String getCookie(String cookieName) {
                Pagereference p =ApexPages.currentPage();
        if (p!=null && p.getCookies() !=null && p.getCookies().containsKey(cookieName)  &&  p.getCookies().get(cookieName) !=null){
            return p.getCookies().get(cookieName).getValue();
        }else{
            return null;
        }    
    }
    
    private static String GetUserIPAddress() {
        try {
            string strIp = ApexPages.currentPage().getHeaders().get('True-Client-IP');
            if (strIp == null || strIp == ''){
                // get IP address when no caching (sandbox, dev, secure urls)
                strIp = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
            }
           // APTSMD_Utils.log('USER IP ADDRESS: ' + strIp);
            return strIp;       
        }        
        catch (Exception ex) {
           // APTSMD_Utils.log('GetUserIPAddress', ex);
            return null;
        }
    }
    
    private static CountryInfo getCountryInfoFromIp(String ip){
        try {
            String hostName = geoLocationWsUrl + ip;
            String jsonResponse = sendHttpGet(hostName);
             
            if (jsonResponse != null)
                return (CountryInfo)JSON.deserialize(jsonResponse, CountryInfo.class);
            else
                return null;
        }
        catch (Exception ex) {
           // APTSMD_Utils.log('getCountryInfoFromIp', ex);
            return null;
        }
    }
    
    private static String sendHttpGet(string url) {
        try {
            HttpRequest req  = new HttpRequest();
        
            req.setTimeout(5000);
            req.setEndpoint(url);
            req.setMethod('GET'); 
            
            Http httpCall = new Http();
            
            HttpResponse resp = httpCall.send(req);

           // APTSMD_Utils.log('sendHttpGet response: ' + resp.getBody());
            return resp.getBody();
        }
        catch (Exception ex) {
           // APTSMD_Utils.log('sendHttpGet', ex);
            return null;
        }
    }
    
    public static string getCurrentContactID(){
        list <user> uList = [select ContactId from user where id=:UserInfo.getUserId() limit 1];
        log('user:' + uList);
        if (uList !=null && uList.size()>0)
            return uList[0].ContactId;
        
        return '';
    }
    
    public static string getContactID_SiteFallBack(){
        string conID = APTSMD_Utils.getCurrentContactID();
        APTSMD_Utils.log('conIDI @ getContact_SiteFallBack: ' + conID);
        if (APTSMD_Utils.isEmpty(conID)){
            conID = ApexPages.currentPage().getParameters().get('contactID');
        }
        APTSMD_Utils.log('conIDII @ getContact_SiteFallBack: ' + conID);
        return conID;
    }
     
    public Static string getCurrentAccountID(){
        list<user> uList  = [select AccountId,contact.AccountId from user where id=:UserInfo.getUserId() limit 1];
        if (isEmpty(uList) || isEmpty(uList[0].AccountId)){
            return '';
        }else{
            return isEmpty(uList[0].AccountId)?uList[0].contact.AccountId:uList[0].AccountId;
        }
    }
     
     public static List<SelectOption> getCountryList() {
        List<SelectOption> options = new List<SelectOption>();
        List<APTSMD_Country__c> countrylist = APTSMD_Utils.getAvailableCountries();
        //system.debug('countrylist: ' + countrylist);
        for(APTSMD_Country__c country : countrylist){
            options.add(new SelectOption(country.APTSMD_CountryCode__c, country.name));
        }
        
        return options;
    }
    
    public static List<SelectOption> getCountryList2() {
        Map<string,APTSMD_Country__c> countriesMap = getCountrieMap();
        List<SelectOption> options = new List<SelectOption>();
        //system.debug('countriesMap: ' + countriesMap);
        
        APTSMD_Country__c  country = countriesMap.get(currentCountry);
        
        if(country != null)
            options.add(new SelectOption(country.id, country.name));
        return options;
    }   
    
    
    public static List<SelectOption> getLanguagesList(string countryCode) {
        List<SelectOption> options = new List<SelectOption>();
        List<APTSMD_Country__c> countrylist = APTSMD_Utils.getAvailableCountries();
       // APTSMD_Utils.log('countrylist @ getLanguagesList:' + countrylist);
        for(APTSMD_Country__c country : countrylist){
            if(countryCode == country.APTSMD_countryCode__c && country.APTSMD_languages__r != null){
                for(APTSMD_language__c lang : country.APTSMD_languages__r){
                    APTSMD_Utils.log('lang @ getLanguagesList:'+lang);
                    options.add(new SelectOption(lang.APTSMD_Language_Code__c, lang.name));
                }
            }
        }
        return options;
    }
    
    public static List<SelectOption> getLanguagesList() {
        //APTSMD_Utils.log('currentCountry @ getLanguagesList:' + currentCountry);
        return getLanguagesList(currentCountry);
    }   
   
    
    
    /***************************************************************************/
    ////////////////////////////////////////////////////////////////////////////
    ////                Naore's General Helper Methods                      ////
    ////////////////////////////////////////////////////////////////////////////
    /**************************************************************************/
    
    
    public static void log(object name, Exception ex){
        log(name + ' Exception: ' + ex.getMessage() + '\n' + ex.getStackTraceString());
    }
    
    public static void log(object str){
        system.debug('\n\n\n' + str + '\n\n\n');
    }
    
    
    public static boolean createCookie(string name, string value) {
        // without expiration - send for session expiration (-1)
        return createCookie(name, value, -1);
    }
    
    public static boolean createCookie(string name, string value, Integer expirationSeconds) {
        try {
            ApexPages.currentPage().setCookies(new Cookie[]{new Cookie(name, value, null, expirationSeconds, false)});
           // APTSMD_Utils.log('createCookie ' + name + ': ' + value);
            return true;
        }
        catch (Exception ex) {
          //  APTSMD_Utils.log('createCookie', ex);
            return false;
        }
    }
    
    /*
    *   Retrives a map from values of a specific field in an sobject list to an SObject with that value.
    *   
    
            /// Warning!!! -- The following Use case will throw a silent exception (You won't see it in debug - it is runtime type check exception)
            
            Map<Id,Contact> conMap = (Map<Id,Contact>)getFieldValueMap(objList,fieldAPIName);
    
    *   ie: field obj.level1__r.level2__r.level3__c from a list of obj type will 
    *   return a set of values of this field from all the obj in the list.
    */
    public static map<String,Sobject> getFieldValueMap(list<Sobject> objList, string fieldAPIName){
        map<String,SObject> returnMap = new map<String,SObject>(); 
        
        //Returns only the first element that matches the value:
        map<String,list<SObject>> toListMap = getFieldValueMap2list(objList,fieldAPIName);
        for (String key:toListMap.keySet()){
            returnMap.put(key,toListMap.get(key)[0]);
        }

        return returnMap;
    }

    public static map<String,list<SObject>> getFieldValueMap2list(list<Sobject> objList, string fieldAPIName){
       // APTSMD_Utils.log('getFieldValueMap2list@@@objList:'+(objList));  
       // APTSMD_Utils.log('getFieldValueMap2list@@@fieldAPIName:'+(fieldAPIName));  


        map<String,list<SObject>> returnMap = new map<String,list<SObject>>(); 
        
        if (objList != null || objList.size()!=0){
            list <string> apiNames = new list<string>(fieldAPIName.split('\\.'));
            

           // APTSMD_Utils.log('getFieldValueMap2list@@@apiNames:'+apiNames);

            for (Sobject obj: objList){
    
                Sobject fieldValue = obj;
                list<string>tmpAPINames =apiNames.clone();
                
              //  APTSMD_Utils.log('getFieldValueMap2list@@@tmpAPINames:'+tmpAPINames);
                while (tmpAPINames!=null && tmpAPINames.size()>1){
                    APTSMD_Utils.log('getFieldValueMap2list@@@insideLoop:fieldValue:'+(fieldValue));                   
                    fieldValue = fieldValue.getSObject(tmpAPINames.remove(0));
                }
                
              //  APTSMD_Utils.log('getFieldValueMap2list@@@fieldValue:'+(fieldValue));                
                if (!returnMap.containsKey(string.ValueOf(fieldValue.get(tmpAPINames[0])))){
                    returnMap.put(string.ValueOf(fieldValue.get(tmpAPINames[0])), new list<Sobject>());
                }
                
                returnMap.get(string.ValueOf(fieldValue.get(tmpAPINames[0]))).add(obj);
            }
        }
        return returnMap;
    }
    
    
    
    
    /*  returns a Sorted selectOptionList with one field as a value and another as a label      */
    /*  i.e getSelectOptionList(oppList, 'ID','Name',True);                                     */
    
    public static List<SelectOption> getSelectOptionList(list <Sobject> sobjectList){
        return getSelectOptionList(sobjectList,false);
    }
    
    public static List<SelectOption> getSelectOptionList(list <Sobject> sobjectList,boolean AddOptionNone){
        return getSelectOptionList(sobjectList, 'ID','Name',AddOptionNone);
    }
    
    public static List<SelectOption> getSelectOptionList(list <Sobject> sobjectList,string APINameValue, string APINameLabel,boolean AddOptionNone){
        List<SelectOption> options = new List<SelectOption>();

        if (AddOptionNone){
            options.add(new SelectOption('None','None'));
        }
    
        for (SObject obj:sobjectList){
            options.add(new SelectOption(String.valueOf(obj.get(APINameValue)),String.valueOf(obj.get(APINameLabel))));
        }
        options.sort();
        return options;
    }
    
    
    
    public static boolean isEmpty(String obj){
         return obj==null || obj=='';
    }
    
    public static boolean isEmpty(object obj){
         return obj==null;
    }
    
    public static boolean isEmpty(Sobject obj){
         return obj==null;
    }
    
    public static boolean isEmpty(list<object> obj){
         return obj==null || obj.size()==0;
    }
    
    public static boolean isEmpty(set<String> obj){
         return obj==null || obj.size()==0;
    }
    
    public static boolean isEmpty(set<sobject> obj){
         return obj==null || obj.size()==0;
    }
    
    public static boolean isEmpty(set<object> obj){
         return obj==null || obj.size()==0;
    }
   
    public static boolean isEmpty(map<object,object> obj){
         return obj==null || obj.keySet().size()==0;
    }  
    
    
    private class CountryInfo {
        public string ip {get;set;}
        public string country_code {get;set;}
        public string country_name {get;set;}
        public string region_code {get;set;}
        public string region_name {get;set;}
        public string city {get;set;}
        public string zipcode {get;set;}
        public string latitude {get;set;}
        public string longitude {get;set;}
        public string metro_code {get;set;}
        public string areacode {get;set;}
    }
    
    public class Column{
        public string label                 {get; private set;}
        public string fieldAPIName          {get; private set;}
        public string sobjectName           {get; private set;}
        public string fullName              {get{
                                                return sobjectName+'.'+fieldAPIName;
                                            }}
        
        public boolean isNumeric            {get; private set;}
        public boolean isInput              {get; private set;}
        
    
    
    
    /**************************************************************/
    ///         Custom multi sobject table classes          ///////
    /**************************************************************/

    public Column(string label, string sobjectName, string fieldAPIName, boolean isNumeric, boolean isInput){
            this.label = label;
            this.fieldAPIName = fieldAPIName;
            this.isNumeric = isNumeric;
            this.isInput= isInput;
            this.sobjectName = sobjectName;
        }
    }
 
    public class SortParams{
        public string sobjectSortByName             {get; set;}
        public string fieldSortByName               {get; set;}
        public string sortDirection                 {get; set;}
        public Schema.DisplayType sortByFieldType   {get; set;}         
    } 
    /////////////////////////////////////////////////
    
      
}