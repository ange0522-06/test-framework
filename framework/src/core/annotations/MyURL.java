package core.annotations;


import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

// Le RetentionPolicy.RUNTIME est obligatoire pour que la réflexion (via getAnnotation()) fonctionne.

@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface MyURL {
	String value() default "";
	
}
