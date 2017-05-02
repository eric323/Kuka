public without sharing class APTSMD_categoryWrapperClass
{
    public String Level1CategoryId;
    public String level1categoryName;
    public Boolean Hassubcat;
    public List<childCategories> lstChildCategories;
    public List<APTSMD_categoryWrapperClass> childcat;
    public Boolean expandsubcategory = false;
    
    public class childCategories
    {
        public String strCategoryId;
        public String strCategoryName;
        
    }
}