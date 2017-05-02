public class APTSMD_FeatureData implements Comparable{
	public String productId;
         public String FeatureValue;
        
        public APTSMD_FeatureData(String productId,String FeatureValue){
            this.productId = productId;
            this.FeatureValue = FeatureValue;
        }
        
        public Integer compareTo(Object otherObj){
            APTSMD_FeatureData otherFratureData = (APTSMD_FeatureData)otherObj;
            return productId.compareTo(otherFratureData.productId);
       }
    
}