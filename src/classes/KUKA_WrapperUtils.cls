/*
 * @author Arokia Suresh Kumar Joseph, KUKA
 * @date Apr 12, 2017
 * @description Wrapper class for Serialized license Interface
 * @log:
 *  -----------------------------------------------------------------------------
 *  Developer                       Date        Description
 *  -----------------------------------------------------------------------------
 *  Arokia SureshKumarJoseph       2017-04-12    Newly created 
 */
global  class KUKA_WrapperUtils {
	
	global KUKA_WrapperUtils(){}
	
	

	
	//Get Serialized Xpert License 
    global class SerializedXpertLicenseWrapper
    {   
       public String Status {get; set;}
       public LicenseOwner LicenseOwner;
       public String Message {get;set;}
       public String ErrorCode {get; set;}
    }
    
    global class License
    {   
        public string Article;
        public Id Id;
        public string Name;      
        public Date ActivationDate;
        public Date ExpirationDate;   
      
       
       
    } 
    
    global class LicenseOwner
    {
      	public User user;
    	
    }
    
    

 
    global class User
    {    	
      public string IdentityProvider;
      public Id Id;
      public List<Id> AccountIds;
      public string AccountName;
      public string Role;   
      public Domain Domain; 
      public List<License> Licenses {get;set;}
    	
    }
    
  
    global class Domain
    {
      public string IdentityProvider;
      public Id Id;
    }


    
}