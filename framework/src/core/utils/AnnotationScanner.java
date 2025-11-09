package core.utils;

import java.io.File;
import java.lang.reflect.Method;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import core.annotations.Controller;

public class AnnotationScanner {

    public static List<Class<?>> getAnnotatedClasses(String packageName) {
        List<Class<?>> classes = new ArrayList<>();
        String path = packageName.replace('.', '/');
        URL root = Thread.currentThread().getContextClassLoader().getResource(path);

        if (root == null) {
            System.out.println("Package introuvable : " + packageName);
            return classes;
        }

        File[] files = new File(root.getFile()).listFiles();
        if (files == null) return classes;

        for (File file : files) {
            if (file.getName().endsWith(".class")) {
                String className = packageName + "." + file.getName().replace(".class", "");
                try {
                    Class<?> cls = Class.forName(className);
                    if (cls.isAnnotationPresent(Controller.class)) {
                        classes.add(cls);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        return classes;
    }

    public static void printAnnotatedMethods(Class<?> cls) {
        System.out.println("Classe : " + cls.getName());
        for (Method method : cls.getDeclaredMethods()) {
            if (method.getAnnotations().length > 0) {
                System.out.println("   → Méthode annotée : " + method.getName());
            }
        }
    }
}
