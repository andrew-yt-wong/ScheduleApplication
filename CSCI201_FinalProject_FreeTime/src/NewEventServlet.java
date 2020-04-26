import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/NewEventServlet")
public class NewEventServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public NewEventServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String name = request.getParameter("name");
		String color = request.getParameter("color");
		String day = request.getParameter("day");
		String duration = request.getParameter("duration");
		String time = request.getParameter("time");
		String next = "/schedule.jsp";
		
		JDBCTest.newEvent(username, name, color, day, duration, time);
		
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(next);
		dispatch.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}