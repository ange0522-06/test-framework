package core.annotations;

import java.lang.annotation.*;

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE) // <-- sur les classes
public @interface Controller {
    String value() default "";
}

