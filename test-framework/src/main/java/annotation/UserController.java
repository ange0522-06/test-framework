// DANS LE DOSSIER TEST-FRAMEWORK
package annotation;

import core.annotations.Controller;
import core.annotations.RestAPI;
import core.annotations.MyURL;

// Exemple 1: Classe avec @Controller
@Controller("/user")
class UserController {
    
    @MyURL("/list")
    public void listUsers() {}

    @MyURL("/create")
    public void createUser() {}

    @MyURL("/delete")
    public void deleteUser() {}
}
