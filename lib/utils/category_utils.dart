class CategoryUtils {

  static String generateCategoryText(String value) {
    String categoryText;

    switch(value) {
      case "electronics":
        categoryText = "Electronics";
        break;
      case "jewelery":
        categoryText = "Jewelery";
        break;
      case "men's clothing":
        categoryText = "Men's Clothing";
        break;
      case "women's clothing":
        categoryText = "Women's Clothing";
        break;
      default:
        categoryText = "Category";
        break;
    }
    return categoryText;
  }
}
