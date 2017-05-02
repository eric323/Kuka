/**********************************************************************
Name:  customSSOJITHandler
======================================================
Purpose:

Utilitly class used as a custom JIT handler for SSO setup
======================================================
History
-------
Date            AUTHOR                      DETAIL
01.07.2016      Andreas Meyer               INITAL CREATION
04.07.2016      Andreas Meyer               remove mobilephone and add user activation
05.07.2016      Andreas Meyer               query optimization
05.07.2016      Benjamin Zimmermann         Hard-Coded the ProfileID, so make the creation of Users work
                                            (only intermediate till the custom Setting ist implemented)
05.07.2016      Andreas Meyer               get profile name from custom settings   
05.07.2016      Andreas Meyer               fix out-of-bound error for alias
05.07.2016      Andreas Meyer               remove manager if managerSID ist not present or blank
07.07.2016      Andreas Meyer               assign default role via custom setting  
07.07.2016      Andreas Meyer               add orgID to username on creation
01.09.2016      Benjamin Zimmermann         Trim the Title to 80 Char, and Use base64-encoded StreetAddress
10.10.2016      Andreas Meyer               add Kuka_ExternalUserID to replicate the FederationID
02.11.2016      Andreas Meyer               DC-787 add exception handler for wrong country/state combo
08.11.2016      Andreas Meyer               lookup of statecode via state name
*********************************************************************/
global class customSSOJITHandler implements Auth.SamlJitHandler{
    private class JitException extends Exception{}

    // andreas.meyer@salesforce.com 02.11.2016 DC-787 get valid country/state values
    private Set<String> setValidCountries;
    private Set<String> setValidStates;
    private Map<String,String> mapValidStateNamesToCodes;
    private Map<String,String> mapValidStateCodesToCodes;

    private void getValidCountryStateValues(){

        setValidCountries = new Set<String>();
        setValidStates = new Set<String>();
        mapValidStateNamesToCodes = new Map<String,String>();
        mapValidStateCodesToCodes = new Map<String,String>();
        // handle countries
        Schema.DescribeFieldResult fieldResultCountry = User.Countrycode.getDescribe();
        List<Schema.PicklistEntry> pleCountry = fieldResultCountry.getPicklistValues();

        for( Schema.PicklistEntry f : pleCountry){
            setValidCountries.add(f.getValue());
        }  

        // handle States
        Schema.DescribeFieldResult fieldResultState = User.statecode.getDescribe();
        List<Schema.PicklistEntry> pleState = fieldResultState.getPicklistValues();
        for( Schema.PicklistEntry f : pleState){
            setValidStates.add(f.getValue());
            // fill map with lowercase, trimmed names
            mapValidStateNamesToCodes.put(f.getLabel().toLowerCase().trim(), f.getValue());
            mapValidStateCodesToCodes.put(f.getValue().toLowerCase().trim(), f.getValue());

        }           

    }

    private String getStateCodeFromStateName(String statename){
        if (true == String.isBlank(statename)){
            return '';
        }
        if (true == mapValidStateNamesToCodes.isEmpty()){
            getValidCountryStateValues();
            if (true == mapValidStateNamesToCodes.isEmpty()){
                return '';
            }
        }
        String hstatename = statename.toLowerCase().trim();
        if (true == mapValidStateNamesToCodes.containsKey(hstatename)){
            return mapValidStateNamesToCodes.get(hstatename);
        }
        // fallback strategy: see if we already have a statecode
        if (true == mapValidStateCodesToCodes.containsKey(hstatename)){
            return mapValidStateCodesToCodes.get(hstatename);
        }

        return '';

    }

    private Boolean isValidCountry(String strcountry){
        if (true == String.isBlank(strcountry)){
            return true;
        }
        if (true == setValidCountries.contains(strcountry)){
            return true;
        }       
        return false;
    }

    private Boolean isValidState(String strstate){
        if (true == String.isBlank(strstate)){
            return true;
        }
        if (true == setValidStates.contains(strstate)){
            return true;
        }
        return false;
    }
    // END OF andreas.meyer@salesforce.com 02.11.2016 DC-787 get valid country/state values


    private String generateUsername(String emailaddress){
        String ret = '';

        // get custom setting
        String filterTerm = '';
        String filterAddon = '';
        customJITHandlerFilter__c filter_swisslog = customJITHandlerFilter__c.getInstance('swisslog');
        if(filter_swisslog.id == null) {
            filterTerm = '@swisslog';
            filterAddon = '.kuka.corp';    
        }
        else{
            // read values
            filterTerm = filter_swisslog.filterterm__c;
            filterAddon = filter_swisslog.filteraddon__c;           
        }


        if (true == String.isBlank(emailaddress)){
            return ret;
        }

        // add emailaddress
        ret = emailaddress;
        if ( true == emailaddress.contains(filterTerm)){
            ret = ret + filterAddon;
            // truncate username to 80 chars
            if (ret.length() >= 80){
                ret = ret.substring(0,80);
            }
        }

        return ret;

    }


    private void handleUser(boolean create, User u, Map<String, String> attributes,String federationIdentifier, Boolean updateFedID){

        System.Debug(LoggingLevel.Debug, 'Start Handler: handleUser');

        getValidCountryStateValues();
        //new record - create initial user with required fields


        // get defaults from Org
        Organization myOrg = [Select    o.LanguageLocaleKey,
                                        o.DefaultLocaleSidKey,
                                        o.IsSandbox,
                                        o.Id   
                                        From Organization o];  

        if(attributes.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress')) {
            String helperEmail = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress');
            // auto generate username first:
            
            u.Email = helperEmail;

            // add OrgID to username if we are in a sandbox
            if (true == myOrg.IsSandbox){
                // only autogenerate usersname in Sandboxes on creation time .. and add OrgID
                if(true == create){
                    u.Username = generateUsername(helperEmail);
                    u.Username = u.Username + myOrg.Id;
                }
            }
            else{
                // if in PROD Orgs always generate a new username
                u.Username = generateUsername(helperEmail);
            }
            // only update CommunityNickname is username was set
            if (false == String.isBlank(u.Username)){
                // set/update CommunityNickname
                //u.CommunityNickname = u.FirstName + ' ' + u.LastName;
                if (u.Username.length() >= 40){
                    u.CommunityNickname = u.Username.substring(0,40);
                }
                else{
                    u.CommunityNickname = u.Username;   
                }               
            }


        }
        if(attributes.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname')) {
            u.FirstName = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname');
        }
        if(attributes.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname')) {
            u.LastName = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname');
        }
        if(attributes.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone')) {
            u.Phone = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/homephone');
        }
        /*
        if(attributes.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/mobilephone')) {
            u.MobilePhone = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/mobilephone');
        }
        */
        if(attributes.containsKey('http://sts.kuka.com/kuka/claims/title')) {
            //the Title-Field is limited to 80 char
            string title = attributes.get('http://sts.kuka.com/kuka/claims/title');
            if(title.length()>= 80){
                u.Title = attributes.get('http://sts.kuka.com/kuka/claims/title').substring(0, 80);
            }else{
                u.Title = title;
            }
        }
        if(attributes.containsKey('http://sts.kuka.com/kuka/claims/company')) {
            u.CompanyName = attributes.get('http://sts.kuka.com/kuka/claims/company');
        }
        if(attributes.containsKey('http://sts.kuka.com/kuka/claims/departmentshort')) {
            u.Department = attributes.get('http://sts.kuka.com/kuka/claims/departmentshort');
        }
        if(attributes.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country')) {
            // andreas.meyer@salesforce.com 02.11.2016 DC-787 get valid country/state values
            if (true == isValidCountry(attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country'))){
                //u.Country = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country');  
                u.CountryCode = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/country');    
            }
        }
        if(attributes.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality')) {
            u.City = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/locality');
        }
        if(attributes.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress')) {
            u.Street = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/streetaddress');
        }
        if(attributes.containsKey('http://sts.kuka.com/kuka/Base64Claim/streetAddress')){
            String streetEncoded = attributes.get('http://sts.kuka.com/kuka/Base64Claim/streetAddress');
            u.Street = EncodingUtil.base64Decode(streetEncoded).toString();           
            
        }
        if(attributes.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode')) {
            u.PostalCode = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/postalcode');
        }
         if(attributes.containsKey('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince')) {
            // andreas.meyer@salesforce.com 02.11.2016 DC-787 get valid country/state values
            String hState = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince');
            String hStateCode = getStateCodeFromStateName(hState);
            //if (true == isValidState(attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince'))){
            if (true == isValidState(hStateCode)){
                //u.State = attributes.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/stateorprovince');    
                u.StateCode = hStateCode;   
            }                       
        }  
        /*
        if(attributes.containsKey('http://sts.kuka.com/kuka/claims/sIDHistory')) {
            u.Division = attributes.get('http://sts.kuka.com/kuka/claims/sIDHistory');
        } 
        */

        // set/update alias
        String alias = '';
        if(u.FirstName == null) {
            alias = u.LastName;
        } else {
            if ( false == String.isBlank(u.Firstname) &&  u.LastName.length() >= 6){
                alias = u.FirstName.substring(0, 1) + u.LastName.substring(0, 6);
            }
            else{
                if ( false == String.isBlank(u.Firstname)){
                    alias = u.FirstName.substring(0, 1) + u.LastName;   
                }
                else{
                    alias = u.LastName;
                }   
            }
            alias = alias.toLowerCase();
        }
        u.Alias = alias;        
        System.Debug(LoggingLevel.Debug, 'Alias set to ' + alias);


        // set/update FederationIdentifier
        if(true == create){
            u.FederationIdentifier = federationIdentifier;
            // 10.10.2016 andreas.meyer@salesforce.com: set Kuka_ExternalUserID as well
            u.Kuka_ExternalUserID__c = federationIdentifier;            
            System.Debug(LoggingLevel.Debug, 'Set FederationIdentifiers and Kuka_ExternalUserID to ' + federationIdentifier);
        }
        else{
            // 10.10.2016 andreas.meyer@salesforce.com: handle Kuka_ExternalUserID for all users since it is a new fields
            if (true == String.isBlank(u.Kuka_ExternalUserID__c)){
                u.Kuka_ExternalUserID__c = federationIdentifier;
                System.Debug(LoggingLevel.Debug, 'Inital set Kuka_ExternalUserID__c to ' + federationIdentifier);
            }

            if (true == updateFedID){
                u.FederationIdentifier = federationIdentifier;  
                // 10.10.2016 andreas.meyer@salesforce.com: update Kuka_ExternalUserID as well
                u.Kuka_ExternalUserID__c = federationIdentifier;
                System.Debug(LoggingLevel.Debug, 'Update Kuka_ExternalUserID__c to ' + federationIdentifier);
                System.Debug(LoggingLevel.Debug, 'Update FederationIdentifiers to ' + federationIdentifier);
                // activate user if needed
                if (false == u.IsActive){
                    u.IsActive = true;
                }
            }
        }

   

        // set/update manager
        if(attributes.containsKey('http://sts.kuka.com/kuka/claims/ManagerSID')) {
            String managerFederationIdentifier = attributes.get('http://sts.kuka.com/kuka/claims/ManagerSID');
            // query for manager
            if (false == String.isBlank(managerFederationIdentifier)){
                List<User> managers = new List<User>([SELECT Id FROM User WHERE FederationIdentifier =:managerFederationIdentifier]);   
                //List<User> managers = [SELECT Id FROM User WHERE FederationIdentifier =:managerFederationIdentifier];
                if(false == managers.isEmpty()  && managerFederationIdentifier != u.FederationIdentifier){
                //if (null != uManager && managerFederationIdentifier != u.FederationIdentifier){
                    //u.ManagerId = uManager.Id;
                    u.ManagerId = managers[0].Id;
                }   
                else{
                    // remove manager cause no user for manager found
                    u.ManagerId = null;
                }                           
            }
            else{
                // remove manager cause managerFederationIdentifier is present but empty
                u.ManagerId = null;
            }
        }
        else{
            // remove manager cause managerFederationIdentifier is not present
            u.ManagerId = null;
        }               

        // set org defaults on create, set profile id
        if(true == create){

            List<User> listSysUser = new List<User>([SELECT ID, TimeZoneSidKey FROM User WHERE ID = :UserInfo.getUserId() LIMIT 1]);
            //User sysuser = [SELECT ID, TimeZoneSidKey FROM User WHERE ID = :UserInfo.getUserId() LIMIT 1];
      
            if (null != myOrg && false == listSysUser.isEmpty()){
                //u.CurrencyIsoCode = 'EUR';
                u.TimeZoneSidKey = listSysUser[0].TimeZoneSidKey;
                u.LanguageLocaleKey = myOrg.LanguageLocaleKey;
                u.LocaleSidKey = myOrg.DefaultLocaleSidKey;
                u.EmailEncodingKey = 'UTF-8';

            } 


            // get profile id
            /*
            if(attributes.containsKey('http://sts.kuka.com/kuka/claims/ProfileId')) {
                String profileId = attributes.get('http://sts.kuka.com/kuka/claims/ProfileId');
                Profile p = [SELECT Id FROM Profile WHERE Name =:profileId];
                u.ProfileId = p.Id;
                system.debug(' ProfileId: '+u.ProfileId);  
            }
            */
            //ToDo: replace this with an custom Setting. 
            //String profileId = 'KUKA Force.com';
            // read profileID from custom settings
            String profileId = '';
            customJITHandlerSettings__c settings = customJITHandlerSettings__c.getInstance('DefaultProfile');
            if(settings.id == null) {
                profileId = 'KUKA Force.com';    
            }
            else{
                // read values
                profileId = settings.value__c;       
            }            

            List<Profile> listProfiles = new List<Profile>([SELECT Id FROM Profile WHERE Name =:profileId]);
            if (false == listProfiles.isEmpty()){
                Profile p = listProfiles[0];
                u.ProfileId = p.Id;
                system.debug(' ProfileId: '+u.ProfileId);               
            }

            // read role name from custom settings
            String roleName = '';
            customJITHandlerSettings__c settings_role = customJITHandlerSettings__c.getInstance('DefaultRole');
            if(settings_role.id == null) {
                roleName = 'Chatter_Users';    
            }
            else{
                // read values
                roleName = settings_role.value__c;       
            }            

            List<UserRole> listRoles = new List<UserRole>([SELECT Id FROM UserRole WHERE DeveloperName =:roleName]);
            if (false == listRoles.isEmpty()){
                UserRole r = listRoles[0];
                u.UserRoleId = r.Id;
                system.debug(' UserRoleId: '+u.UserRoleId);             
            }
        }       

               
        if(!create) {
            update(u);
            
        }
        
       
    }

    

    private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion, Boolean updateFedID) {
            
        handleUser(create, u, attributes, federationIdentifier, updateFedID);

    }

    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
        
        System.Debug(LoggingLevel.Debug, 'CreateUser fired');
        System.Debug(LoggingLevel.Debug, 'Identifier: ' + federationIdentifier);
        System.Debug(LoggingLevel.Debug, 'Assertation: ' + assertion);
        System.Debug(LoggingLevel.Debug, 'samlSSoProvider: ' + samlSsoProviderId);
        for(String key : attributes.keySet()){
                 System.Debug(LoggingLevel.Debug, key+ ': ' + attributes.get(key));
        }

        User u; 
        // check for sIDHistory
        if(attributes.containsKey('http://sts.kuka.com/kuka/claims/sIDHistory')) {
            String oldFederationIdentifier = attributes.get('http://sts.kuka.com/kuka/claims/sIDHistory');
            // query for user           
            List<User> listUsers = new List<User>([SELECT Id, FirstName, ContactId FROM User WHERE FederationIdentifier =:oldFederationIdentifier]);    
            if (false == listUsers.isEmpty()){
                u = listUsers[0];
                System.Debug(LoggingLevel.Debug, 'Update existing user, sIDHistory (old FederationIdentifier) found');
                handleJit(false, u, samlSsoProviderId, communityId, portalId,federationIdentifier, attributes, assertion, true);
                System.Debug(LoggingLevel.Debug, 'Existing User updated , sIDHistory (old FederationIdentifier) found ' + u.Username + ' | '+ u.FederationIdentifier +' | ' + u.Alias); 
            }
            else{
                u = new User(); 
                System.Debug(LoggingLevel.Debug, 'Create new user, sIDHistory (old FederationIdentifier) not found');
                handleJit(true, u, samlSsoProviderId, communityId, portalId,federationIdentifier, attributes, assertion, false);
                System.Debug(LoggingLevel.Debug, 'New User created , sIDHistory (old FederationIdentifier) not found ' + u.Username + ' | '+ u.FederationIdentifier +' | ' + u.Alias);
            }
        }
        else{
            u = new User(); 
            System.Debug(LoggingLevel.Debug, 'Create new user');
            handleJit(true, u, samlSsoProviderId, communityId, portalId,federationIdentifier, attributes, assertion, false);
            System.Debug(LoggingLevel.Debug, 'New User created ' + u.Username + ' | '+ u.FederationIdentifier +' | ' + u.Alias);            
        }
            
        return u;
    }

    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
         System.Debug(LoggingLevel.Debug, 'UpdateUser fired');
         System.Debug(LoggingLevel.Debug, 'Identifier: ' + federationIdentifier);
         System.Debug(LoggingLevel.Debug, 'Assertation: ' + assertion);
         System.Debug(LoggingLevel.Debug, 'UserID: ' + userID);
         System.Debug(LoggingLevel.Debug, 'samlSSoProvider: ' + samlSsoProviderId);
        for(String key : attributes.keySet()){
             System.Debug(LoggingLevel.Debug, key+ ': ' + attributes.get(key));
        }
        List<User> listUsers = new List<User>([SELECT Id, FirstName, ContactId FROM User WHERE Id=:userId]);
        if (false == listUsers.isEmpty()){
            User u = listUsers[0];
            handleJit(false, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion,false);
        }
    }
}