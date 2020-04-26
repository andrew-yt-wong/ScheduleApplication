import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SendFriendRequestServlet")
public class SendFriendRequestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public SendFriendRequestServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String user = request.getParameter("user");
		String frienduser = request.getParameter("frienduser");
		String next = "/friends.jsp";
		int result = JDBCTest.sendFriendRequest(user, frienduser);
		if (result == 0)
		{
			request.setAttribute("friendRequestStatus", "Request successfully sent.");
		}
		else if (result == 1)
		{
			request.setAttribute("friendRequestStatus", "You cannot send a friend request to yourself.");
		}
		else if (result == 2)
		{
			request.setAttribute("friendRequestStatus", "You have already sent this person a friend request.");
		}
		else if (result == 3)
		{
			request.setAttribute("friendRequestStatus", "This person has already sent a friend request to you.");
		}
		else {
			request.setAttribute("friendRequestStatus", "This person is already your friend.");
		}
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(next);
		dispatch.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}