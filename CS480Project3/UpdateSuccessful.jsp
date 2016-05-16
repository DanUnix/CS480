<%@ include file="CommonStuff.jsp" %>


<%! String sSignUpErr = ""; 
	String sFilename = "ManageUsers.jsp";
%>

<%
//check for permissions
String userlevel = (String)session.getAttribute("level");
if(userlevel.equals("1")) {//send 401.
	response.sendError(401, "You are not authorized to see this page");
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Update Successful</title>
</head>
<body>
 <%@ include file="Header.jsp"%>
<%
if(session.getAttribute("user_deleted")!=null) {
	out.println("User "+session.getAttribute("user_deleted")+" has been deleted <br>");
	session.setAttribute("user_deleted",null);
}
if(session.getAttribute("user_updated")!=null) {
	out.println("Infor for user "+session.getAttribute("user_updated")+" has been updated <br>");
	session.setAttribute("user_updated",null);
}

out.println(session.getAttribute("user_updated")); %> modified successfully

Click <a href="MainMenu.jsp">here</a>  to go to the main menu.
</body>
</html>