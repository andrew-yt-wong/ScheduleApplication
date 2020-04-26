<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>FreeTime</title>
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">

	<link href="https://fonts.googleapis.com/css2?family=Unica+One&display=swap" rel="stylesheet">

	<link rel="stylesheet" type="text/css" href="css/style.css">
	
	<%@page import="java.sql.DriverManager"%>
	<%@page import="java.sql.ResultSet"%>
	<%@page import="java.sql.Statement"%>
	<%@page import="java.sql.Connection"%>
	<%@page import="java.sql.PreparedStatement"%>
	<%@page import="java.sql.SQLException"%>
	<%@page import="javax.servlet.http.Cookie"%>
	<%
		Boolean loggedin = false;
		String username = "";
		Cookie c[] = request.getCookies();
		for(int i = 0; i < c.length; i++)
		{  
		    if (c[i].getName().equals("username"))
		    {
		        loggedin = true;
		        username = c[i].getValue();
		    }
		}
		if (!loggedin)
		{
	%>
			<script>location = "index.jsp";</script>
	<%
		}
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			ps = conn.prepareStatement("SELECT * FROM Events");
	%>
</head>
<link rel="stylesheet" type="text/css" href="css/schedule.css">
<body>
	<div style="display: none;" id="myusername"><%= username %></div>
	<div class="overlay">
		<div id="editevent">
			<h3>Edit Event</h3>
			<input style="margin: 10px auto;width: 80%;" type="text" name="edit-event-title" class="form-control" id="edit-event-name" placeholder="Event Name">
			<input style="margin: 10px auto;width: 80%;" type="text" name="edit-event-length" class="form-control" id="edit-event-length" placeholder="1.5 Hours">
			<div>
				<button id="edit-button" class="btn btn-warning">Edit Event</button>
				<button id="delete-button" class="btn btn-danger">Delete Event</button>
			</div>
		</div>
	</div>
	<div class="container-fluid">
		<div class="row">
			<div class="header">
				<nav class="navbar navbar-expand-md navbar-dark">
					<a class="navbar-brand" id="logo" href="schedule.jsp">FreeTime</a>
					<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>

					<div class="collapse navbar-collapse" id="navbarSupportedContent">
						<ul class="navbar-nav ml-auto mynavbar">
							<li class="nav-item active">
								<a class="nav-link" href="schedule.jsp">Schedule</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="friends.jsp">Friends</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="combine.jsp">Combine</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="LogoutServlet">Logout</a>
							</li>
						</ul>
					</div>
				</nav>
			</div>
		</div>
		<hr style="border-color: white;margin: 20px;"/>
		<div class="row" id="schedule">
			<div class="col">
				<div class="new-event">
					<h3>Add New Event</h3>
					<div class="row">
						<input style="margin: 10px;" type="text" name="event-title" class="form-control" id="event-name" placeholder="Event Name">
					</div>
					<div class="row">
						<div class="dropdown">
							<button type="button" style="display: flex;align-items: center;background-color: #D3E1F1;" class="btn form-control dropdown-toggle" id="dropdownMenu1" data-toggle="dropdown">
								<div id="color"></div>
								<span class="caret" style="margin-left: 10px;"></span>
							</button>

							<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
								<li class="colorpicker">
									<div class="color" style="background-color: #CE8483;"></div>&nbsp;&nbsp;Pink<font style="display: none;">#CE8483</font>
								</li>
								<li class="colorpicker">
									<div class="color" style="background-color: red;"></div>&nbsp;&nbsp;Red<font style="display: none;">red</font>
								</li>
								<li class="colorpicker">
									<div class="color" style="background-color: #FF6666;"></div>&nbsp;&nbsp;Sunset<font style="display: none;">#FF6666</font>
								</li>
								<li class="colorpicker">
									<div class="color" style="background-color: orange;"></div>&nbsp;&nbsp;Orange<font style="display: none;">orange</font>
								</li>
								<li class="colorpicker">
									<div class="color" style="background-color: yellow;"></div>&nbsp;&nbsp;Yellow<font style="display: none;">yellow</font>
								</li>
								<li class="colorpicker">
									<div class="color" style="background-color: green;"></div>&nbsp;&nbsp;Green<font style="display: none;">green</font>
								</li>
								<li class="colorpicker">
									<div class="color" style="background-color: #138496;"></div>&nbsp;&nbsp;Aquamarine<font style="display: none;">#138496</font>
								</li>
								<li class="colorpicker">
									<div class="color" style="background-color: #007BFF;"></div>&nbsp;&nbsp;Blue<font style="display: none;">#007BFF</font>
								</li>
							</ul>
						</div>

						<div class="event-time">
							<input type="text" name="event-length" class="form-control" id="event-length" placeholder="1.5 Hours">
						</div>
					</div>
				</div>
			</div>
			<div class="col times">
				<div class="row label">
					<div class="word">Time</div>
				</div>
			</div>
			<div class="col day" id="Sunday">
				<div class="row label">
					<div class="word">Sunday</div>
				</div>
				<div class="row box 5AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
			</div>
			<div class="col day" id="Monday">
				<div class="row label">
					<div class="word">Monday</div>
				</div>
				<div class="row box 5AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
			</div>
			<div class="col day" id="Tuesday">
				<div class="row label">
					<div class="word">Tuesday</div>
				</div><div class="row box 5AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
			</div>
			<div class="col day" id="Wednesday">
				<div class="row label">
					<div class="word">Wednesday</div>
				</div>
				<div class="row box 5AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
			</div>
			<div class="col day" id="Thursday">
				<div class="row label">
					<div class="word">Thursday</div>
				</div>
				<div class="row box 5AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
			</div>
			<div class="col day" id="Friday">
				<div class="row label">
					<div class="word">Friday</div>
				</div>
				<div class="row box 5AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
			</div>
			<div class="col day" id="Saturday">
				<div class="row label">
					<div class="word">Saturday</div>
				</div>
				<div class="row box 5AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery();
					while(rs.next()) {
						if (rs.getString("username").equals(username) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event"><%= rs.getString("name") %></div>
				<%
						}
					}
				%></div>
			</div>
			<div class="col-2">
				<h3>FAQ</h3>
				<h4>Welcome to FreeTime!</h4>
				<ul>
					<hr style="border-color: white;"/>
					<li>To add an event, fill in the event form and click a time block.</li>
					<hr style="border-color: white;"/>
					<li>To edit or remove an event, click on the event to display a pop-up.</li>
					<hr style="border-color: white;"/>
					<li>Events can only start at full hour intervals.</li>
					<hr style="border-color: white;"/>
					<li>When combining schedules, all events will be labeled as busy, if multiple events overlap the block will just say busy.</li>
					<hr style="border-color: white;"/>
					<li>Combined schedules refresh when you change pages, that session will be erased if you leave the page.</li>
					<hr style="border-color: white;"/>
					<li>You can search for other users on the friend page, if nothing is typed all users will be shown.</li>
					<hr style="border-color: white;"/>
					<li>You must be friends with another user in order to combine with their schedule.</li>
					<hr style="border-color: white;"/>
					<li>By default, the combine schedule page will only show your schedule until you combine.</li>
					<hr style="border-color: white;"/>
				</ul>
			</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.4.1.min.js" integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous"></script>

	<script type="text/javascript">
		let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		let hours = ["5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM", "12 AM", "1 AM", "2 AM", "3 AM", "4 AM"];
		function startUpInitialization() {
			for (let i = 0; i < 24; ++i) {
				/*let empty = document.createElement("div");
				empty.classList.add("row");
				empty.classList.add("box");
				let hourtrim = hours[i].replace(" ", "");
				empty.classList.add(hourtrim);
				$(".day").append(empty);*/

				let hour = document.createElement("div");
				hour.classList.add("row");
				hour.classList.add("label");
				let word = document.createElement("div");
				word.classList.add("word");
				word.innerHTML = hours[i];
				hour.appendChild(word);
				document.querySelector(".times").appendChild(hour);
			}
		}
		startUpInitialization();
		let $currentEvent = null;
		let currentEvent = null; 
		$(".box").on("mouseenter", function() {
			$(this).css("background", "grey");
			$(this).css("border-radius", "7px");
		});
		$(".box").on("mouseleave", function() {
			$(this).css("background", "#2D3047");
		});
		$(".box").on("click", function() {
			if (!this.hasChildNodes()) {
				let newEvent = document.createElement("div");
				if ($("#event-name").val() == "")
					newEvent.innerHTML = "Untitled Event";
				else
					newEvent.innerHTML = $("#event-name").val();
				newEvent.style.backgroundColor = $("#color").css("backgroundColor");
				newEvent.style.width = "100%";
				newEvent.style.height = (100 * parseFloat($("#event-length").val())).toString() + "%";
				newEvent.style.borderRadius = "7px";
				newEvent.style.border = "1px solid #2D3047";
				newEvent.style.textAlign = "center";
				newEvent.classList.add("event");
				this.appendChild(newEvent);
				
				let username = $("#myusername").html();
				
				let xhttp = new XMLHttpRequest();
		        xhttp.open("GET", "NewEventServlet?username=" + username + "&name=" + newEvent.innerHTML + "&color=" + $("#color").css("backgroundColor") + "&duration=" + $(newEvent).css("height").toString() + "&day=" + $(this).parent().attr("id") + "&time=" + this.classList[2], false);
		        xhttp.send();
			}
		});
		$(".colorpicker").on("click", function() {
			$("#color").css("background-color", $(".colorpicker font").eq($(".colorpicker").index(this)).html());
		});
		$("#editevent").on("click", ".edit-colorpicker", function() {
			$("#edit-color").css("background-color", $(".edit-colorpicker font").eq($(".edit-colorpicker").index(this)).html());
		});
		$("#schedule").on("click", ".event", function() {
			while (document.querySelector("#editevent").hasChildNodes())
				document.querySelector("#editevent").removeChild(document.querySelector("#editevent").firstChild);
			$("#editevent").append(
					"<h3>Edit Event</h3>" + 
					"<input style=\"margin: 10px auto;width: 80%;\" type=\"text\" name=\"edit-event-title\" class=\"form-control\" id=\"edit-event-name\" placeholder=\"Event Name\">" + 
					"<div style=\"margin: 10px auto;width: 80%;\" class=\"row\">" +
						"<div class=\"dropdown\" style=\"margin-left: 0;width: 15%;margin-right: 3%;\">" +
							"<button type=\"button\" style=\"display: flex;align-items: center;background-color: #D3E1F1;\" class=\"btn form-control dropdown-toggle\" id=\"edit-dropdownMenu1\" data-toggle=\"dropdown\">" +
								"<div id=\"edit-color\"></div>" +
								"<span class=\"caret\" style=\"margin-left: 10px;\"></span>" +
							"</button>" +
							"<ul class=\"dropdown-menu\" role=\"menu\" aria-labelledby=\"edit-dropdownMenu1\">" +
								"<li class=\"edit-colorpicker\">" +
									"<div class=\"color\" style=\"background-color: #CE8483;\"></div>&nbsp;&nbsp;Pink<font style=\"display: none;\">#CE8483</font>" +
								"</li>" +
								"<li class=\"edit-colorpicker\">" +
									"<div class=\"color\" style=\"background-color: red;\"></div>&nbsp;&nbsp;Red<font style=\"display: none;\">red</font>" +
								"</li>" +
								"<li class=\"edit-colorpicker\">" +
									"<div class=\"color\" style=\"background-color: #FF6666;\"></div>&nbsp;&nbsp;Sunset<font style=\"display: none;\">#FF6666</font>" +
								"</li>" +
								"<li class=\"edit-colorpicker\">" +
									"<div class=\"color\" style=\"background-color: orange;\"></div>&nbsp;&nbsp;Orange<font style=\"display: none;\">orange</font>" +
								"</li>" +
								"<li class=\"edit-colorpicker\">" +
									"<div class=\"color\" style=\"background-color: yellow;\"></div>&nbsp;&nbsp;Yellow<font style=\"display: none;\">yellow</font>" +
								"</li>" +
								"<li class=\"edit-colorpicker\">" +
									"<div class=\"color\" style=\"background-color: green;\"></div>&nbsp;&nbsp;Green<font style=\"display: none;\">green</font>" +
								"</li>" +
								"<li class=\"edit-colorpicker\">" +
									"<div class=\"color\" style=\"background-color: #138496;\"></div>&nbsp;&nbsp;Aquamarine<font style=\"display: none;\">#138496</font>" +
								"</li>" +
								"<li class=\"edit-colorpicker\">" +
									"<div class=\"color\" style=\"background-color: #007BFF;\"></div>&nbsp;&nbsp;Blue<font style=\"display: none;\">#007BFF</font>" +
								"</li>" +
							"</ul>" +
						"</div>" +
						"<input style=\"width: 82%;\" type=\"text\" name=\"edit-event-length\" class=\"form-control\" id=\"edit-event-length\" placeholder=\"1.5 Hours\">" + 
					"</div>" +
					"<div>" + 
						"<button id=\"edit-button\" class=\"btn btn-warning\">Edit Event</button>" + 
						"<button id=\"delete-button\" class=\"btn btn-danger\">Delete Event</button>" + 
					"</div>");
			$currentEvent = $(this);
			currentEvent = this;
			$(".overlay").css("display", "block");
			$("#edit-event-name").attr("value", $(this).html());
			$("#edit-event-length").attr("value", (parseFloat($(this).css("height")) / 50).toString() + " Hours");
		});
		$("#editevent").on("click", "#edit-button", function() {
			let username = $("#myusername").html();
			let xhttp = new XMLHttpRequest();
	        xhttp.open("GET", "EditEventServlet?username=" + username + "&name=" + currentEvent.innerHTML + "&color=" + $currentEvent.css("backgroundColor") + "&duration=" + $currentEvent.css("height").toString() + "&day=" + $currentEvent.parent().parent().attr("id") + "&time=" + currentEvent.parentNode.classList[2] + "&newname=" + $("#edit-event-name").val() + "&newcolor=" + $("#edit-color").css("backgroundColor") + "&newduration=" + ((parseFloat($("#edit-event-length").val()) * 50).toString() + "px"), false);
	        xhttp.send();
			
			$currentEvent.html($("#edit-event-name").val());
			$currentEvent.css("height", (100 * parseFloat($("#edit-event-length").val())).toString() + "%");
			$currentEvent.css("background-color", $("#edit-color").css("backgroundColor"));
			$(".overlay").css("display", "none");
		});
		$("#editevent").on("click", "#delete-button", function() {
			let username = $("#myusername").html();
			let xhttp = new XMLHttpRequest();
	        xhttp.open("GET", "DeleteEventServlet?username=" + username + "&name=" + currentEvent.innerHTML + "&color=" + $currentEvent.css("backgroundColor") + "&duration=" + $currentEvent.css("height").toString() + "&day=" + $currentEvent.parent().parent().attr("id") + "&time=" + currentEvent.parentNode.classList[2], false);
	        xhttp.send();
	        
	        currentEvent.parentNode.removeChild(currentEvent);
			$(".overlay").css("display", "none");
		});
	</script>
	
	<%
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (Exception e) {
			System.out.println("Driver Exception: " + e.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
	%>

	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</body>
</html>