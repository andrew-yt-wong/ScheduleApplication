<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="ISO-8859-1">
	<meta charset="utf-8">
	<title>FreeTime</title>
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<link rel="stylesheet" type="text/css" href="css/style.css">

	<link href="https://fonts.googleapis.com/css2?family=Unica+One&display=swap" rel="stylesheet">

	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
	
	<%
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String cpassword = request.getParameter("cpassword");
		String signinUser = request.getParameter("signin-username");
		String signinPass = request.getParameter("signin-password");
		if (username == null) username = "";
		if (password == null) password = "";
		if (cpassword == null) cpassword = "";
		if (signinUser == null) signinUser = "";
		if (signinPass == null) signinPass = "";
		String usernameError = null;
		String passwordError = null;
		String confirmError = null;
		String signinUserError = null;
		String signinPassError = null;
		String signinError = null;
		if (request.getParameter("usernameError") != null && !request.getParameter("usernameError").equals("null"))
			usernameError = request.getParameter("usernameError");
		if (request.getParameter("passwordError") != null && !request.getParameter("passwordError").equals("null"))
			passwordError = request.getParameter("passwordError");
		if (request.getParameter("confirmError") != null && !request.getParameter("confirmError").equals("null"))
			confirmError = request.getParameter("confirmError");
		if (request.getParameter("signinUserError") != null && !request.getParameter("signinUserError").equals("null"))
			signinUserError = request.getParameter("signinUserError");
		if (request.getParameter("signinPassError") != null && !request.getParameter("signinPassError").equals("null"))
			signinPassError = request.getParameter("signinPassError");
		if (request.getParameter("signinError") != null && !request.getParameter("signinError").equals("null"))
			signinError = request.getParameter("signinError");
	%>
</head>
<link rel="stylesheet" type="text/css" href="css/index.css">
<body>
	<div class="container intro">
		<div class="row">
			<div class="col-12 title">F·r·e·e·T·i·m·e</div>
		</div> <!-- .row -->
		<div class="row">
			<h2 class="col-12">Welcome to FreeTime</h2>
		</div> <!-- .row -->
		<div class="row">
			<h3 class="col-12">An all-inclusive tool to help you and your scheduling needs.</h3>
		</div> <!-- .row -->
		<div class="row">
			<div class="col">
				<form action="LoginServlet" method="POST" id="signin">
					Already have an account? Sign In!
					<input type="text" name="signin-username" placeholder="Username" id="signin-username" class="form-control" value="<%= signinUser %>"/> <span class="text-danger font-italic"><%= (signinUserError != null) ? signinUserError : "" %></span>
					<input type="password" name="signin-password" placeholder="Password" id="signin-password" class="form-control" value="<%= signinPass %>"/> <span class="text-danger font-italic"><%= (signinPassError != null) ? signinPassError : "" %></span>
					<input type="submit" value="Login" class="form-control"/> <span class="text-danger font-italic"><%= (signinError != null) ? signinError : "" %></span>
				</form>
			</div> <!-- .col -->
			<div class="col">
				<form action="SignupServlet" method="POST" id="signup">
					New User? Sign Up!
					<input type="text" name="username" placeholder="Username" id="username" class="form-control" value="<%= username %>"/> <span class="text-danger font-italic"><%= (usernameError != null) ? usernameError : "" %></span>
					<input type="password" name="password" placeholder="Password" id="password" class="form-control" value="<%= password %>"/> <span class="text-danger font-italic"><%= (passwordError != null) ? passwordError : "" %></span>
					<input type="password" name="cpassword" placeholder="Confirm Password" id="cpassword" class="form-control" value="<%= cpassword %>"/> <span class="text-danger font-italic"><%= (confirmError != null) ? confirmError : "" %></span>
					<input type="submit" value="Sign Up" class="form-control"/>
				</form>
			</div> <!-- .col -->
		</div> <!-- .row -->
	</div> <!-- .container -->
	
	<script src="https://code.jquery.com/jquery-3.4.1.min.js" integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous"></script>

	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</body>
</html>