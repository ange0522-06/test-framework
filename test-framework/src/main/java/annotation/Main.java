// DANS LE DOSSIER TEST-FRAMEWORK
package annotation;

import java.lang.reflect.Method;
import core.annotations.MyURL;
import core.annotations.Controller;
import core.annotations.RestAPI;

public class Main {
    public static void main(String[] args) {
        // Liste des classes à scanner
        Class<?>[] classesToScan = {
            Teste.class,
            UserController.class,
            ProductAPI.class
        };

        System.out.println("=== SCAN DES ANNOTATIONS ===\n");

        for (Class<?> clazz : classesToScan) {
            scanClass(clazz);
        }
    }

    private static void scanClass(Class<?> clazz) {
        System.out.println("Classe: " + clazz.getSimpleName());

        // Scanner les annotations de classe
        String basePath = "";
        if (clazz.isAnnotationPresent(Controller.class)) {
            Controller ctrl = clazz.getAnnotation(Controller.class);
            System.out.println("   [CONTROLLER] " + ctrl.value());
            basePath = ctrl.value();
        } else if (clazz.isAnnotationPresent(RestAPI.class)) {
            RestAPI api = clazz.getAnnotation(RestAPI.class);
            System.out.println("   [REST API] " + api.value());
            basePath = api.value();
        } else {
            System.out.println("   [NO CLASS ANNOTATION]");
        }

        // Scanner les méthodes annotées
        System.out.println("   Methodes @MyURL:");
        boolean hasAnnotatedMethods = false;
        
        for (Method method : clazz.getDeclaredMethods()) {
            if (method.isAnnotationPresent(MyURL.class)) {
                MyURL url = method.getAnnotation(MyURL.class);
                String fullPath = basePath.isEmpty() ? url.value() : basePath + url.value();
                
                System.out.println("      - " + method.getName() + "()");
                System.out.println("        URL: " + url.value());
                System.out.println("        Full URL: " + fullPath);
                
                hasAnnotatedMethods = true;
            }
        }

        if (!hasAnnotatedMethods) {
            System.out.println("      (aucune)");
        }

        System.out.println();
    }
}