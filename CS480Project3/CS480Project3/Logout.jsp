<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>

<%
if(session.getAttribute("user_id")!=null || session.getAttribute("user_id")!=""){
	session.invalidate();
	out.println(" You have been logged out. \n"+
			"Click <a href=\"Login.jsp\"> here </a> to go back to the login page.");
//else user is not logged in, so don't show anything, there is no else.
}

%>



</body>
</html>