<%@ include file="CommonStuff.jsp" %>


<%! String sSignUpErr = ""; 
	String sFilename = "Statistics.jsp";
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
<title>Insert title here</title>
</head>
<body>
<%@ include file="Header.jsp" %>
<center>

Click <a href="UserStatistics.jsp">Here</a> for statistics about a user. <br>
Click <a href="BookStatistics.jsp">Here</a> for statistics about books. <br>

</body>
</html>