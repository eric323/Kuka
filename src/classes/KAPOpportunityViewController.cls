/**********************************************************************
Name:  KAPOpportunityViewController
======================================================
Purpose: Controller for KAPOpportunityView page
======================================================
History
-------
Date        AUTHOR                          DETAIL
22/07/2016  Andreas Meyer                   INITIAL
25/07/2016  Wolfram von Reitzenstein        CHANGES1
07/11/2016  Andreas Meyer                   DC-721
*********************************************************************/

public class KAPOpportunityViewController {

      public List<Opportunity> listResultOpportunities { get; set; }
      public ID accId {get; set;}
      private KeyAccountPlan__c obj;
      public boolean novalues {get;set;} 
      public string noOppsAvailable{get;set;}
      
      //Variables for Pagination
      public KAPPaginate paginater {get;set;} 
      public List<Opportunity> listOpportunitiesByPage{get;set;} 
      public List<List<Opportunity>> listOfListsOppsByPage{get;set;} 
      public Map<String,String> mapReferenceNameFields{get;set;} 

      public KAPOpportunityViewController(ApexPages.StandardController controller){
      
          // Sets flag initially to true --> if later Opps are found is has to be set to false
          novalues = true;
          
          //Recieves Error label to display if no Opportunities are found
          noOppsAvailable = System.Label.No_Opps_for_Account_Hierarchy;
           
          // add custom Filed Account ID to Controller
          if (false == Test.isRunningTest()){
            controller.addFields(new List<String>{'AccountID__c'});  
          }
           
          // get the current KeyAccountPlan object
          this.obj = (KeyAccountPlan__c) controller.getRecord();
          accId = this.obj.AccountID__c;
           
          //Call function to get all Accounts below the Key Account
          Set<ID> accountIDs = KAPHelperFunctions.getAllAccountIDsForKeyAccount(accId);

          System.debug('set accountIDs, size: ' + accountIDs.size());
         
          //Call method to search Opportunities for Account list
          this.fillOpportunitiesList(controller, accountIDs);
          
          //initialize Pagination
          this.initilizePagination();
           
      }
      
      private void fillOpportunitiesList(ApexPages.StandardController controller, Set<ID> accountIDs ){
          
          mapReferenceNameFields = new Map<String,String>();
          //Prepare columns for Opportunities according to Field Set
          
          //ID and Name are always included for link on ID with label Name
          String queryFields = 'Id ,Name ';
          
          //Get remaining fields according to FieldSet KAPFieldDetails on Opportunity
          for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.KAPFieldDetails.getFields()) {
              String hStr = f.getFieldPath().toLowerCase();
              if ('id' != hStr && 'name' != hStr){
                  if(queryFields.length() > 0) {
                      queryFields += ', ';
                  }
                  queryFields += f.getFieldPath();
                  // andreas.meyer@salesforce.com 07.11.2016 DC-721 add extra fields for references
                  if (Schema.DisplayType.Reference == f.getType()){
                    Map<String, Schema.SObjectField> fieldMap = Schema.sObjectType.Opportunity.fields.getMap();                    
                    Schema.DescribeFieldResult field = fieldMap.get(f.getFieldPath()).getDescribe();
                    String hNameField = field.getRelationshipName() + '.Name';
                    queryFields += ', ';
                    queryFields += hNameField; 
                    mapReferenceNameFields.put(f.getFieldPath(), hNameField);
                  }                    
              }
          }
          
          //Construct Query String for query Opportunity records by AccountID
          String oppQuery = 
              'SELECT ' + queryFields + 
              ' FROM Opportunity WHERE AccountId IN :accountIDs';

          System.debug('oppQuery:  ' + oppQuery);
              
          //Temporary Opportunity List object
          List<Opportunity> listOpportunity = new List<Opportunity>();
          listOpportunity = Database.query(oppQuery);
          
          //Return values if Temporary Opportunity List object is not empty
          if (false == listOpportunity.isEmpty()){
              this.listResultOpportunities = listOpportunity;
              System.debug('listResultOpportunities size: ' + listResultOpportunities.size());
          }
          else{
            System.debug('listResultOpportunities is empty ');
          }  
    }  
    
    public void initilizePagination(){  
        
        //Get the data we need to paginate 
        List<Opportunity> resultsList = this.listResultOpportunities; 
        
        //Set the page size 
        Integer pageSize = 6; 
        
        //These lists hold the data 
        this.listOfListsOppsByPage = new List<List<Opportunity>>(); 
        this.listOpportunitiesByPage = new List<Opportunity>(); 
        
        if(resultsList != null) { 
    
        //Break out the full list into a list of lists 
            if(resultsList.size() > 0){ 
            
                //Create a new instance of Paginate passing in the overall size of 
                //the list of data and the page size you want 
                this.paginater = new KAPPaginate(resultsList.size(), pageSize); 
            
                List<Opportunity> tempCC = new List<Opportunity>(); 
                Integer i = 0; 
                for(Opportunity cc : resultsList){ 
                    tempCC.add(cc); 
                    i++; 
                    if(i == pageSize){ 
                        this.listOfListsOppsByPage.add(tempCC); 
                        tempCC = new List<Opportunity>(); 
                        i = 0; 
                    } 
                 } 
                 if(!tempCC.isEmpty()){ 
                     this.listOfListsOppsByPage.add(tempCC); 
                 } 
                 
                 // Sets no values flag to false as there are Opportunities to display
                 novalues = false;
                 
                 //Gets the correct list of data to show on the page 
                 this.listOpportunitiesByPage = this.listOfListsOppsByPage.get(this.paginater.index); 
            } 
        } 
    } 
    
    //Call paginater for previous page
    public PageReference previousPage(){ 
        System.debug('previousPage');
        this.paginater.decrement(); 
        return changeData(); 
    } 
    
    //Call paginater for next page
    public PageReference nextPage(){ 
        System.debug('nextPage');
        this.paginater.increment(); 
        return changeData(); 
    } 
    
    //Call paginater for page update
    public PageReference updatePage(){ 
        System.debug('updatePage');
        this.paginater.updateNumbers(); 
        return changeData(); 
    } 
    
    //Call paginater for data change
    public PageReference changeData(){ 
        System.debug('changeData');
        this.listOpportunitiesByPage = this.listOfListsOppsByPage.get(this.paginater.index); 
        return null; 
    } 
}