package annotation;

import java.lang.reflect.Method;

import core.annotations.MyURL;


public class Main {
    public static void main(String[] args) {
        Class<?> clazz = Teste.class;
        for (Method m : clazz.getDeclaredMethods()) {
            if (m.isAnnotationPresent(MyURL.class)) {
                MyURL ann = m.getAnnotation(MyURL.class);
                System.out.println(ann.value());
            }
        }
    }
}