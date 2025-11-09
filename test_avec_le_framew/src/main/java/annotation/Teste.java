// DANS LE DOSSIER TEST-FRAMEWORK
package annotation;

import core.annotations.MyURL;


public class Teste {
    @MyURL("/hello")
    public void hello() {}

    @MyURL("/teste")
    public void about() {}

    @MyURL("/coucou")
    public void fenitra() {}

    @MyURL("/sa")
    public void sa() {}
}