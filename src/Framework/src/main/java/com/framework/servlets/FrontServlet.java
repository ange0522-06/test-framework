package com.framework.servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

import com.framework.util.AnnotationScanner;
import com.framework.util.ActionMapping;

public class FrontServlet extends HttpServlet {

    private HashMap<String, ActionMapping> AllUrls = new HashMap<>();

    @Override 
    public void init() throws ServletException {
        try {
            AllUrls = AnnotationScanner.getAllUrls();    
        } catch(Exception e){
            throw new ServletException(e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        service(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        service(req, resp);
    }

    public Map.Entry<String, ActionMapping> checkUrl(String url) throws Exception {
        for (Map.Entry<String, ActionMapping> entry : AllUrls.entrySet()) {
            if (entry.getKey().equals(url)) {
                return Map.entry(url, entry.getValue());
            }
        }
        return null;
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String fullURI = req.getRequestURI();
        String context = req.getContextPath();
        String relativeURI = fullURI.substring(context.length());

        try {
            boolean resourceExists = getServletContext().getResource(relativeURI) != null;
            if (resourceExists) {
                dispatchToDefaultHandler(req, res);
            }
            else{
                try{
                    Map.Entry<String, ActionMapping> hasAnnotation = checkUrl(relativeURI);
                    if(hasAnnotation != null){
                        String className = hasAnnotation.getValue().getTheClassName();
                        Method m = hasAnnotation.getValue().getTheMethod();
                        Class<?> c = Class.forName(className);

                        res.setContentType("text/plain");
                        PrintWriter out = res.getWriter();
                        out.println("URL : " + hasAnnotation.getKey());
                        out.println("Classe correspondante : " + className);
                        out.println("Methode correspondante : " + m.getName());
                    }
                    else{
                        handleMissingResource(req, res);
                    }
                } catch(Exception e){
                    throw new ServletException(e.getMessage());
                }

            }
        } catch (ServletException | IOException e) {
            throw e;
        }
    }

    private void dispatchToDefaultHandler(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        RequestDispatcher defaultServlet = getServletContext().getNamedDispatcher("default");
        if (defaultServlet != null) {
            defaultServlet.forward(req, res);
            return;
        }
    }

    private void handleMissingResource(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try (PrintWriter out = res.getWriter()) {
            String uri = req.getRequestURI();
            String responseBody = """
                <html>
                    <head><title>Resource Not Found</title></head>
                    <body>
                        <h1>Unknown resource</h1>
                        <p>The requested URL was not found: <strong>%s</strong></p>
                    </body>
                </html>
                """.formatted(uri);

            res.setContentType("text/html;charset=UTF-8");
            out.println(responseBody);
        }
    }
}
