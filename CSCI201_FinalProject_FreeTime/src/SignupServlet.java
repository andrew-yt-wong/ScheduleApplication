import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
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
		String usernameError = "";
		String passwordError = "";
		String confirmError = "";
		
		String next = "/index.jsp";
		
		if (username == "") {
			usernameError = "Username was not filled in!";
		}
		
		if (password == "") {
			passwordError = "Password was not filled in!";
		}
		else {
			if (!password.equals(cpassword)) {
				confirmError = "Passwords do not match!";
			}
		}
		
		if (usernameError.equals("") &&
			passwordError.equals("") &&
			confirmError.equals("")) {
			MessageDigest messageDigest = null;
			try {
				messageDigest = MessageDigest.getInstance("SHA-256");
			} catch (NoSuchAlgorithmException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        byte[] hash = messageDigest.digest(password.getBytes("UTF-8"));
	        StringBuffer hexString = new StringBuffer();
	        for (int i = 0; i < hash.length; i++) {
	            String hex = Integer.toHexString(0xff & hash[i]);
	            if(hex.length() == 1) hexString.append('0');
	            hexString.append(hex);
	        }
	        
			String encryptedString = hexString.toString();
			int result = JDBCTest.newUser(username, encryptedString);
			if (result == 0)
			{
				next = "/schedule.jsp";
				Cookie c = new Cookie("username", username);
				c.setMaxAge(1800);
				response.addCookie(c);
			}
			else
			{
				usernameError = "Please choose a different username.";
			}
		}
		
		response.sendRedirect(request.getContextPath() + next + "?username=" + username + "&password=" + password + "&cpassword=" + cpassword + "&usernameError=" + usernameError + "&passwordError=" + passwordError + "&confirmError=" + confirmError);
	}
}