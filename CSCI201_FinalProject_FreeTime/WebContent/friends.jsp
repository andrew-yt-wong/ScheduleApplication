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
		PreparedStatement ps1 = null;
		ResultSet rs1 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			ps = conn.prepareStatement("SELECT username FROM Users");
			rs = ps.executeQuery();
			ps1 = conn.prepareStatement("SELECT myusers.username, myfriends.username AS friendsname " +
					"FROM User_Has_Friend_Requests " +
					"JOIN Users myusers " +
						"ON User_Has_Friend_Requests.user_id = myusers.user_id " +
					"JOIN Users myfriends " +
						"ON User_Has_Friend_Requests.friend_id = myfriends.user_id");
			rs1 = ps1.executeQuery();
			ps2 = conn.prepareStatement("SELECT myusers.username, myfriends.username AS friendsname " +
					"FROM User_Has_Friends " +
					"JOIN Users myusers " +
						"ON User_Has_Friends.user_id = myusers.user_id " +
					"JOIN Users myfriends " +
						"ON User_Has_Friends.friend_id = myfriends.user_id");
			rs2 = ps2.executeQuery();
	%>
</head>
<link rel="stylesheet" type="text/css" href="css/friends.css">
<body>
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
							<li class="nav-item active">
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
		<div class="row friendpage">
			<div class="col friends">
				<h3>My Friends</h3>
				<hr style="border-color: white;margin: 20px;"/>
				<% while (rs2.next()) {
						if (rs2.getString("username").equals(username)) {%>
					<div style="margin-bottom: 15px;" class="row">
						<div style="margin-top: 7px;margin-left: 40px;text-align: left;"class="col"><%= rs2.getString("friendsname") %></div>
						<div class="col">
							<form action="RemoveFriendRequestServlet" method="POST">
								<input style="display: none;" name="user" value="<%= username %>">
								<input style="display: none;" name="frienduser" value="<%= rs2.getString("friendsname") %>">
								<button type="submit" class="btn btn-danger">Remove Friend</button>
							</form>
						</div>
					</div>
				<% 		
						}
				   }
				%>
			</div>
			<div class="col friends">
				<h3>Find Users</h3>
				<hr style="border-color: white;margin: 20px;"/>
				<input style="margin-bottom: 15px;" type="text" name="search-users" class="form-control" id="search-users" placeholder="Search Users">
				<div id="user-list">
				<% while (rs.next()) { %>
					<div class="auser">
						<div style="margin-bottom: 15px;" class="row">
							<div style="margin-top: 7px;margin-left: 40px;text-align: left;"class="col user-name"><%= rs.getString("username") %></div>
							<div class="col">
								<form action="SendFriendRequestServlet" method="POST">
									<input style="display: none;" name="user" value="<%= username %>">
									<input style="display: none;" name="frienduser" value="<%= rs.getString("username") %>">
									<button type="submit" class="btn btn-primary">Send Request</button>
								</form>
							</div>
						</div>
					</div>
				<% } %>
				</div>
			</div>
			<div class="col friends">
				<h3>Friend Requests</h3>
				<hr style="border-color: white;margin: 20px;"/>
				<% while (rs1.next()) {
						if (rs1.getString("username").equals(username)) {%>
					<div style="margin-bottom: 15px;" class="row">
						<div style="margin-top: 7px;margin-left: 40px;text-align: left;"class="col"><%= rs1.getString("friendsname") %></div>
						<div class="col">
							<form action="AcceptFriendRequestServlet" method="POST">
								<input style="display: none;" name="user" value="<%= username %>">
								<input style="display: none;" name="frienduser" value="<%= rs1.getString("friendsname") %>">
								<button type="submit" class="btn btn-warning">Add Friend</button>
							</form>
						</div>
					</div>
				<% 		
						}
				   }
				%>
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
				if (rs1 != null) {
					rs1.close();
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
				if (ps1 != null) {
					ps1.close();
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
	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>

	<script>
		$("#search-users").on("keyup", function() {
			$("#user-list").children(".auser").each(function() {
				if ((this.children[0].children[0].innerHTML).includes($("#search-users").val()))
					$(this).css("display", "block");
				else
					$(this).css("display", "none");
			});
		}); 
	</script>
</body>
</html>