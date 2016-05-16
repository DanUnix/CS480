<%@ include file="CommonStuff.jsp" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
    
 <%

boolean bDebug = false;

//we can get to Login.jsp in two ways. Either by typing in the URL in the browser's address bar or by 
//submitting the form to log in. In the first case, there are no HTTP parameters being sent. In the second case there are. FormName is used to distinguish between these two cases.
String sForm = request.getParameter("FormName"); 
if(sForm==null) //it will be null if we get to Login.jsp by typing the url in the address bar.
  sForm="";

java.sql.Connection conn = null;
java.sql.Statement stat = null;
String sErr = loadDriver();
conn = connectToDB();
if ( ! sErr.equals("") ) {
 try {
   out.println(sErr);
 }
 catch (Exception e) {}
}
stat = conn.createStatement();
%>        
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Account Information</title>
</head>
<body>
<center>



<% 

String username = (String) session.getAttribute("username");
String password = request.getParameter("password");
String name = request.getParameter("name"); 
String address = request.getParameter("address");
String credit = request.getParameter("credit_card");

out.println("Updated information for user: " + username + "<br />");
out.println("New Password:" + password + "<br />");
out.println("New Name:" + name + "<br />");
out.println("New Address:" + address + "<br />");
out.println("New Credit Card:" + credit + "<br />");

try {
	   // insert selected data into db'
	    String sqlQuery = "UPDATE `bookstore`.`users` SET `password`='" + password + "' WHERE `username`='" + username + "'";
	   stat.executeUpdate(sqlQuery);;
	   sqlQuery = "UPDATE `bookstore`.`users` SET `name`='" + name + "' WHERE `username`='" + username + "'";
	   stat.executeUpdate(sqlQuery);;
	   sqlQuery = "UPDATE `bookstore`.`users` SET `address`='" + address + "' WHERE `username`='" + username + "'";
	   stat.executeUpdate(sqlQuery);;
	   sqlQuery = "UPDATE `bookstore`.`users` SET `credit_card`='" + credit + "' WHERE `username`='" + username + "'";
	   stat.executeUpdate(sqlQuery);;
	   
	          try {
	               if ( stat != null ) stat.close();
	              if ( conn != null ) conn.close();
	          }
	          catch ( java.sql.SQLException ignore ) {}
	    }
	  catch (Exception e) { out.println(e.toString()); }



%>

<form method="post" action="Admin.jsp">
   <input type="submit" id="ad" value="Return to Admin">
 </form>

<form method="post" action="Login.jsp">
   <input type="submit" id="ok" value="Log out">
 </form>
</body>
</html>
