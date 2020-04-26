import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/EditEventServlet")
public class EditEventServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public EditEventServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String name = request.getParameter("name");
		String color = request.getParameter("color");
		String day = request.getParameter("day");
		String duration = request.getParameter("duration");
		String time = request.getParameter("time");
		String newname = request.getParameter("newname");
		String newcolor = request.getParameter("newcolor");
		String newduration = request.getParameter("newduration");
		String next = "/schedule.jsp";
		
		JDBCTest.editEvent(username, name, color, day, duration, time, newname, newcolor, newduration);
		
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(next);
		dispatch.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}