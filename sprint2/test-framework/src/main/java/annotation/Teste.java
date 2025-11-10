package annotation;

import core.annotations.MyURL;


public class Teste {
    @MyURL("/hello")
    public void hello() {}

    @MyURL("/teste")
    public void about() {}

    @MyURL("/fefe")
    public void fenitra() {}

    @MyURL("/sa")
    public void sa() {}
}