package com.cousin.controller;

import com.framework.annotation.MonController;
import com.framework.model.ModelView;
import com.framework.annotation.MesRoutes;

@MonController
public class UserController {

    @MesRoutes("/user/list")
    public String list() {
        return "Voici la liste des utilisateurs";
    }

    @MesRoutes("/user/add")
    public String addUser() {
        return "add";
    }

    @MesRoutes("/user/profile")
    public ModelView userProfile() {
        ModelView mv = new ModelView("/WEB-INF/views/user/profil.jsp"); // Chemin complet depuis la racine
        mv.addAttribute("username", "John Doe");
        mv.addAttribute("email", "john@example.com");
        return mv;
    }

    @MesRoutes("/user/delete")
    public ModelView deleteUser() {
        ModelView mv = new ModelView("redirect:/user/list");
        mv.addAttribute("message", "Utilisateur supprimé avec succès");
        return mv;
    }
}
