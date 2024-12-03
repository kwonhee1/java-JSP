package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.MapService;

import java.io.IOException;

@WebServlet("/MainPage")
public class MainController extends HttpServlet {
<<<<<<< HEAD
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("mainpage get()");
=======
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("mainPage >> get >> return main Page");
>>>>>>> 895f2f47f9836178ad4886db241ccff65ddf2f3d
		request.getRequestDispatcher("Main/FirstScreen.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
