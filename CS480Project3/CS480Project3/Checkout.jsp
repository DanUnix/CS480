<%@ include file="CommonStuff.jsp" %>
<%@ page import="java.util.Date, java.text.DateFormat, java.text.SimpleDateFormat" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%@ include file="Header.jsp"%>

<%
//create connection
//Assuming the user is already logged in. (Redirection to login page if user is not logged in in the next assignment.)
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
Checkout(stat, conn, out, session, request);
%>


<%! //get parameters and send the insert query to the database.
void Checkout(java.sql.Statement stat, java.sql.Connection conn, javax.servlet.jsp.JspWriter out, javax.servlet.http.HttpSession session,javax.servlet.http.HttpServletRequest request) throws java.io.IOException {
	try {
		//The checkout must remove the orders related to this user from the orders table and insert them in an OrderHistory table, together with the checkout timestamp.
		String user_id = (String)session.getAttribute("user_id");
		DateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); //the MYSQL datetime format
       Date date = new Date(); //current datetime
       String datetime = dateformat.format(date);
       //out.println(datetime);

       //insert
       java.sql.Statement stat1=conn.createStatement();
       String sqlQuery="select * from orders where user_id='"+user_id+"'";
       java.sql.ResultSet rs = stat.executeQuery(sqlQuery);
       while(rs.next()) {
       		String order_id=rs.getString("order_id");
       		String ISBN = rs.getString("ISBN");
       		int quantity = rs.getInt("quantity");
       		//now insert this row into order_history
       		String insertQuery="insert into order_history values('"+order_id+"',  '"+ISBN+"', '"+user_id+ "', "+quantity+", '"+datetime+"');";
       		int count = stat1.executeUpdate(insertQuery);
       	}

       	//delete from orders

       	String deleteQuery="delete from orders where user_id='"+user_id+"';";
       	java.sql.Statement stat2=conn.createStatement();
       	int count = stat2.executeUpdate(deleteQuery);
       	stat.close();
       	stat1.close();
       	stat2.close();
		printSuccessfulMessage(conn, out, session);
	}
	catch(Exception e) {
		out.println(e.toString());
	}
 }

 void printSuccessfulMessage(java.sql.Connection conn, javax.servlet.jsp.JspWriter out, javax.servlet.http.HttpSession session) throws java.io.IOException {
	String username=(String)session.getAttribute("username");//this was set at Login
	out.println("<p align = \"center\">Great Buy " +username+"</p>");
 	out.println("Click <a href=\"ShowBooks.jsp\">here</a> to buy more books");

 }


 %>
			
</body>
</html>