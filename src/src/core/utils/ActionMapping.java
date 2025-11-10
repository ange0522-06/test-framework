package core.utils;

import java.lang.reflect.Method;

public class ActionMapping {
    private String theClassName;
    private Method theMethod;

    public ActionMapping(String theClassName, Method theMethod) {
        this.theClassName = theClassName;
        this.theMethod = theMethod;
    }

    public String getTheClassName() {
        return this.theClassName;
    }

    public void setTheClassName(String theClassName) {
        this.theClassName = theClassName;
    }

    public Method getTheMethod() {
        return this.theMethod;
    }

    public void setTheMethod(Method theMethod) {
        this.theMethod = theMethod;
    }
}
