import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public LoginServlet() {
		super();
	}
	
	public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String signinUser = request.getParameter("signin-username");
		String signinPass = request.getParameter("signin-password");
		
		String next = "/index.jsp";
		
		if (signinUser == "") {
			request.setAttribute("signinUserError", "Username was not filled in!");
		}
		
		if (signinPass == "") {
			request.setAttribute("signinPassError", "Password was not filled in!");
		}
		
		if (request.getAttribute("signinUserError") == null &&
			request.getAttribute("signinPassError") == null) {
			boolean isUser = JDBCTest.verifyUser(signinUser, signinPass);
			if (isUser)
				next = "/schedule.jsp";
			else
				request.setAttribute("signinError", "Unable to log in using those credentials!");
		}
		
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(next);
		dispatch.forward(request,  response);
	}
}