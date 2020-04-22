import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public SignupServlet() {
		super();
	}
	
	public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String cpassword = request.getParameter("cpassword");
		
		String next = "/index.jsp";
		
		if (username == "") {
			request.setAttribute("usernameError", "Username was not filled in!");
		}
		
		if (password == "") {
			request.setAttribute("passwordError", "Password was not filled in!");
		}
		else {
			if (!password.equals(cpassword)) {
				request.setAttribute("confirmError", "Passwords do not match!");
			}
		}
		
		if (request.getAttribute("usernameError") == null &&
			request.getAttribute("passwordError") == null &&
			request.getAttribute("confirmError") == null ) {
			JDBCTest.newUser(username, password);
			next = "/schedule.jsp";
		}
		
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(next);
		dispatch.forward(request,  response);
	}
}