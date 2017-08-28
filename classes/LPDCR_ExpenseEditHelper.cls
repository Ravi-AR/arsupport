/**
*   @Author:    Shruti Mishra
*   @Date:      30.09.2016
*   @Jira:      LPDCR-290
*   @Purpose:   Helper Class for LPDCR_ExpenseEditController
*/

public with sharing class LPDCR_ExpenseEditHelper {

    //Method to create Json object
    public static string createJsonObjects(Set<String> catList,String selectedCategory,List<String> subcategoryLst,String selectedSubCategory,
                                           Id subCategoryId,Decimal checkPointMul,String subCatDesc,Decimal maxReimburseAmt,String subCategoryName,
                                           Decimal reimbursePercg,String catName){
    //JSONGenerator object creation
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
        if(catList!=null){
      gen.writeObjectField('Categories', catList);      
    }
        else if(selectedCategory!=null && subcategoryLst!=null){
      gen.writeObjectField('category', selectedCategory);
      gen.writeObjectField('subCategories', subcategoryLst);
    }
        else if(selectedSubCategory!=null){       
      if(subCategoryId!=null)
        gen.writeObjectField('Id',subCategoryId);  
      if(checkPointMul!=null)
        gen.writeObjectField('CheckpointMultiplier',checkPointMul); 
      if(subCatDesc!=null)
        gen.writeObjectField('Description',subCatDesc);
      if(maxReimburseAmt!=null)
        gen.writeObjectField('MaxReimbursement',maxReimburseAmt); 
      if(subCategoryName!=null)
        gen.writeObjectField('Name',subCategoryName);  
      if(reimbursePercg!=null)
        gen.writeObjectField('ReimbursementPercentage',reimbursePercg);  
      if(catName!=null)
        gen.writeObjectField('Category',catName);
    }
        gen.writeEndObject();
    //Get the JSON string.
    String subCatDescJsonStr = gen.getAsString();
    return subCatDescJsonStr;
    }
    
}