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
		String combine = null;
		String[] combineList = new String[1];
		combineList[0] = "noname";
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
		
		combine = request.getParameter("frienduser");
		if (combine == null) {
			combine = "";
		}
		else {
			combineList = combine.split(",");
		}
		
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			ps = conn.prepareStatement("SELECT * FROM Events");
			ps2 = conn.prepareStatement("SELECT myusers.username, myfriends.username AS friendsname " +
					"FROM User_Has_Friends " +
					"JOIN Users myusers " +
						"ON User_Has_Friends.user_id = myusers.user_id " +
					"JOIN Users myfriends " +
						"ON User_Has_Friends.friend_id = myfriends.user_id");
			rs2 = ps2.executeQuery();
	%>
</head>
<link rel="stylesheet" type="text/css" href="css/schedule.css">
<body>
	<div style="display: none;" id="combine"><%= combine %></div>
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
							<li class="nav-item">
								<a class="nav-link" href="schedule.jsp">Schedule</a>
							</li>
							<li class="nav-item">
								<a class="nav-link" href="friends.jsp">Friends</a>
							</li>
							<li class="nav-item active">
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
		<div class="row">
			<div class="col-3">
				<h3>My Friends</h3>
				<hr style="border-color: white;margin: 20px;"/>
				<% while (rs2.next()) {
						if (rs2.getString("username").equals(username)) {%>
					<div style="margin-bottom: 15px;" class="row">
						<div style="margin-top: 7px;margin-left: 40px;text-align: left;"class="col"><%= rs2.getString("friendsname") %></div>
						<div class="col">
							<form action="CombineScheduleServlet" method="POST" class="combine-form">
								<input style="display: none;" name="user" value="<%= username %>">
								<input style="display: none;" name="frienduser" value="<%= rs2.getString("friendsname") + (combine.equals("") ? "" : ("," + combine)) %>">
								<button type="submit" class="btn btn-primary addsched">Add Schedule</button>
							</form>
						</div>
					</div>
				<% 		
						}
				   }
				%>
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
					rs = ps.executeQuery(); boolean test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Sunday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
			</div>
			<div class="col day" id="Monday">
				<div class="row label">
					<div class="word">Monday</div>
				</div>
				<div class="row box 5AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<%
						} if (test) break;
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Monday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
			</div>
			<div class="col day" id="Tuesday">
				<div class="row label">
					<div class="word">Tuesday</div>
				</div><div class="row box 5AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<%
						} if (test) break;
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<%
						} if (test) break;
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<%
						} if (test) break;
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Tuesday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
			</div>
			<div class="col day" id="Wednesday">
				<div class="row label">
					<div class="word">Wednesday</div>
				</div>
				<div class="row box 5AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Wednesday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
			</div>
			<div class="col day" id="Thursday">
				<div class="row label">
					<div class="word">Thursday</div>
				</div>
				<div class="row box 5AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<%
						} if (test) break;
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<%
						} if (test) break;
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<%
						} if (test) break;
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<%
						} if (test) break;
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<%
						} if (test) break;
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Thursday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
			</div>
			<div class="col day" id="Friday">
				<div class="row label">
					<div class="word">Friday</div>
				</div>
				<div class="row box 5AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Friday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
			</div>
			<div class="col day" id="Saturday">
				<div class="row label">
					<div class="word">Saturday</div>
				</div>
				<div class="row box 5AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("5AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("6AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("7AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("8AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("9AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("10AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("11AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("12PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("1PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("2PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("3PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("4PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 5PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("5PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 6PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("6PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 7PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("7PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 8PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("8PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 9PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("9PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 10PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("10PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 11PM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("11PM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 12AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("12AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 1AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("1AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 2AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("2AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 3AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("3AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
				<div class="row box 4AM"><% 
					rs = ps.executeQuery(); test = false;
					while(rs.next()) { for (int i = 0; i < combineList.length; ++i)
						if ((rs.getString("username").equals(username) || rs.getString("username").equals(combineList[i])) && rs.getString("day").equals("Saturday") && rs.getString("start_time").equals("4AM"))  {
				%>
					<div style="background-color: <%= rs.getString("color") %>;width: 100%;height: <%= rs.getString("duration") %>;border-radius: 7px;border: 1px solid #2D3047;text-align: center;" class="event">Busy</div>
				<% test = true; break;
						} if (test) break;
					}
				%></div>
			</div>
		</div>
	</div>
	
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
				if (rs2 != null) {
					rs2.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
	%>

	<script src="https://code.jquery.com/jquery-3.4.1.min.js" integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous"></script>

	<script type="text/javascript">
		let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		let hours = ["5 AM", "6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM", "12 AM", "1 AM", "2 AM", "3 AM", "4 AM"];
		function startUpInitialization() {
			for (let i = 0; i < 24; ++i) {
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
	</script>

	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</body>
</html>