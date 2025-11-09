package annotation;

import core.annotations.MyURL;
import core.annotations.Controller;
import core.annotations.Get;

@Controller
public class UserController {

    @MyURL("/hello")
    public void sayHello() {
        System.out.println("Hello depuis Teste !");
    }
    @MyURL("/hi")
    public void Annotated() {
        // rien ici
    }
}

