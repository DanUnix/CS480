<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Home</title>
</head>
<body>
<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String driverName = "com.mysql.jdbc.Driver";
String url = "jdbc:mysql://localhost:3306/store";
String user = "root";
String password = "linux321";

String sqlQuery = "SELECT name FROM Users";
%>

<%
try {
Class.forName(driverName);
con = DriverManager.getConnection(url, user, password);
ps = con.prepareStatement(sqlQuery);
rs = ps.executeQuery();
%>
<%
while(rs.next()){
    String username = rs.getString("name");    
%>
<% session.invalidate(); %>
<option value=<%=username%>><%=username%></option>
<p>You have been successfully Logged out</p>
<%
}
}catch(SQLException sqe){
    out.println("home"+sqe);
}
%>
</body>
</html>
