import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
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
		String signinUserError = "";
		String signinPassError = "";
		String signinError = "";
		
		String next = "/index.jsp";
		
		if (signinUser == "") {
			signinUserError = "Username was not filled in!";
		}
		
		if (signinPass == "") {
			signinPassError = "Password was not filled in!";
		}
		
		if (signinUserError.equals("") &&
			signinPassError.equals("")) {
			boolean isUser = JDBCTest.verifyUser(signinUser, signinPass);
			if (isUser)
			{
				next = "/schedule.jsp";
				Cookie c = new Cookie("username", signinUser);
				c.setMaxAge(1800);
				response.addCookie(c);
			}
			else
				signinError = "Unable to log in using those credentials!";
		}
		
		response.sendRedirect(request.getContextPath() + next + "?signin-username=" + signinUser + "&signin-password=" + signinPass + "&signinUserError=" + signinUserError + "&signinPassError=" + signinPassError + "&signinError=" + signinError);
	}
}