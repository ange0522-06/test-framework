// DANS LE DOSSIER FRAMEWORK
package core;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class RouterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupère le chemin demandé
        String path = request.getRequestURI().substring(request.getContextPath().length());

        // Essaye de trouver une ressource/servlet associée à ce chemin
        ServletContext context = getServletContext();
        RequestDispatcher dispatcher = context.getRequestDispatcher(path);

        if (dispatcher != null) {
            // 🔹 Il existe un mapping → on transfère la requête
            dispatcher.forward(request, response);
        } else {
            // 🔹 Aucune ressource trouvée → on renvoie un JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            String json = "{\"url\":\"" + jsonEscape(path) + "\",\"status\":\"not found\"}";

            response.getWriter().write(json);
        }
    }

    // Minimal JSON string escaper for values. Keeps dependency-free compilation.
    private static String jsonEscape(String s) {
        if (s == null) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\b': sb.append("\\b"); break;
                case '\f': sb.append("\\f"); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (c < 0x20 || c > 0x7E) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }
}
