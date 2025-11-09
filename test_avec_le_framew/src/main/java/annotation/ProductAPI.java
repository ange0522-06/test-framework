// Exemple 2: Classe avec @RestAPI
package annotation;
import core.annotations.MyURL;
import core.annotations.Get;

// @Get("/api/product")
class ProductAPI {
    
    // @MyURL("/all")
    public void getAllProducts() {}

    // @MyURL("/add")
    public void addProduct() {}
}