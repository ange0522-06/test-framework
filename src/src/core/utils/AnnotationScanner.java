package core.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.Method;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Properties;

import core.annotations.ControllerAnnotation;
import core.annotations.URLHandler;

public class AnnotationScanner {
    private static String BasePackage;

    static {
        initializeFromConfig();
    }

    private static void initializeFromConfig() {
        Properties props = new Properties();
        try {
            URL classesUrl = AnnotationScanner.class.getClassLoader().getResource("");
            if (classesUrl == null) {
                throw new IllegalStateException("Impossible de localiser WEB-INF/classes/");
            }

            File classesDir = new File(classesUrl.toURI());
            File webInfDir = classesDir.getParentFile(); 
            File configFile = new File(webInfDir, "resources/application.properties");

            if (!configFile.exists()) {
                throw new IllegalStateException("Fichier de config introuvable : " + configFile.getAbsolutePath());
            }

            try (FileInputStream fis = new FileInputStream(configFile)) {
                props.load(fis);
            }

            BasePackage = props.getProperty("base_package");

            if (BasePackage != null) {
                BasePackage = BasePackage.trim();

                if ((BasePackage.startsWith("\"") && BasePackage.endsWith("\"")) ||
                    (BasePackage.startsWith("'") && BasePackage.endsWith("'"))) {
                    BasePackage = BasePackage.substring(1, BasePackage.length() - 1).trim(); 
                }
            }

            if (BasePackage == null || BasePackage.isEmpty()) {
                throw new IllegalStateException("Propriete base_package manquante dans " + configFile.getAbsolutePath());
            }

            String path = BasePackage.replace('.', '/');
            URL packageUrl = Thread.currentThread().getContextClassLoader().getResource(path);
            if (packageUrl == null) {
                throw new IllegalStateException(
                    "Le package defini dans 'base_package' (" + BasePackage + 
                    ") n'existe pas dans le classpath. Veuillez verifier la configuration ou le nom de package."
                );
            }

        } catch (IOException | URISyntaxException e) {
            throw new RuntimeException("Erreur lors du chargement du fichier de configuration", e);
        }
    }


    public static HashMap<String, ActionMapping> getAllUrls() throws Exception {
        HashMap<String, ActionMapping> result = new HashMap<>();
        List<Class<?>> classesWithAnnotations = getClassesWithAnnotations();

        for (Class<?> clazz : classesWithAnnotations) {
            if (clazz.isAnnotationPresent(ControllerAnnotation.class)) {
                for(Method method : clazz.getDeclaredMethods()){
                    if(method.isAnnotationPresent(URLHandler.class)){
                        String url = method.getAnnotation(URLHandler.class).value();
                        ActionMapping c = new ActionMapping(clazz.getName(), method);
                        result.put(url, c);
                    }
                }
            }
        }
        return result;        
    }


    public static List<Class<?>> getClassesWithAnnotations() throws Exception {
        List<Class<?>> result = new ArrayList<>();
        String packageName = BasePackage; 
        List<Class<?>> classes = getClasses(packageName);
        for (Class<?> clazz : classes) {
            if (clazz.isAnnotationPresent(ControllerAnnotation.class)) {
                result.add(clazz);
                // ControllerAnnotation annotation = clazz.getAnnotation(ControllerAnnotation.class);
                // System.out.println("Classe: " + clazz.getName() + " | value = " + annotation.value());
            }
        }
        return result;
    }

    public static List<Class<?>> getClasses(String packageName) throws IOException, ClassNotFoundException {
        String path = packageName.replace('.', '/');
        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
        URL resource = classLoader.getResource(path);
        if (resource == null) return new ArrayList<>();

        File directory = new File(resource.getFile());
        return findClassesInDirectory(directory, packageName);
    }

    private static List<Class<?>> findClassesInDirectory(File directory, String packageName) throws ClassNotFoundException {
        List<Class<?>> classes = new ArrayList<>();
        if (!directory.exists()) return classes;

        for (File file : directory.listFiles()) {
            if (file.isDirectory()) {
                classes.addAll(findClassesInDirectory(file, packageName + "." + file.getName()));
            } else if (file.getName().endsWith(".class")) {
                String className = packageName + '.' + file.getName().replaceAll("\\.class$", "");
                classes.add(Class.forName(className)); 
            }
        }
        return classes;
    }
}
