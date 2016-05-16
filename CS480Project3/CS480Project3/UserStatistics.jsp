<%@ include file="CommonStuff.jsp" %>


<%! String sSignUpErr = ""; 
	String sFilename = "UserStatistics.jsp";
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
<title>User Statistics</title>
</head>
<body>
<%@ include file="Header.jsp" %>
<center>

<%
String sForm = request.getParameter("FormName");
if(sForm==null) //it will be null if we get to UserStatistics from some other page
	sForm=""; //it will be search if we get to UserStatistics from the Search form.
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
if(sForm.equals("searchUserOrders"))
	sErr=doSearch(request,  response, session, out, sForm, conn, stat);
else 
	showQueryTable(out);
%>

<%! 
String doSearch(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, javax.servlet.http.HttpSession session, javax.servlet.jsp.JspWriter out, String sForm, java.sql.Connection conn, java.sql.Statement stat) throws java.io.IOException {
	String sErr="";
	try {
		String username = request.getParameter("username");
		String year=request.getParameter("year");
		String month=request.getParameter("month");
		String day=request.getParameter("day");
		String datetime = year+"-"+month+"-"+day+" "+"00:00:00";
		String sqlQuery = "select title, order_history.ISBN, order_history.order_id, quantity, orderts, price " +
				"from order_history, users, books "+
				"where username='"+username+"' "+
				"and order_history.user_id=users.user_id "+		
				"and orderts > '"+datetime+"' "+
				"and order_history.ISBN=books.ISBN";
		java.sql.ResultSet rs = stat.executeQuery(sqlQuery);
		//this can return more than one users, if they have the same name.
		out.println("The orders of the user:<br>");
		out.println("    <table style=\"\" border=1>\n"+
		"<thead>\n"+
		"  <tr>\n"+
		"	<td>Order ID</td>\n"+
		"	<td>Title</td>\n"+
		"	<td>ISBN</td>\n"+
		"	<td>Time</td>\n"+
		"	<td>Quantity</td>\n"+
		"	<td>Total</td>\n"+
		"  </tr>\n"+
		"</thead>\n");
	    while(rs.next()) {
			String title=rs.getString("title");
			String ISBN=rs.getString("ISBN");
			String order_id=rs.getString("order_id");
			int quantity=rs.getInt("quantity");
			String orderts=rs.getString("orderts");
			double price=rs.getDouble("price");
			double total=(double) quantity * price;
			String totalStr = String.format("%.2f", total);
			out.println("<tr>\n"+
			"   <td>"+order_id+"</td>"+
			"   <td>"+title+"</td>"+
			"   <td>"+ISBN+"</td>"+ 
			"   <td>"+orderts+"</td>"+ 
			"   <td>"+quantity+"</td>"+ 
			"   <td>"+totalStr+"</td>"+ 
			"</tr>"); 
		}
		out.println("</table>");
		java.sql.Statement stat1 =  conn.createStatement();
		sqlQuery = "select title, orders.ISBN, orders.order_id, quantity, price " +
				"from orders, users, books "+
				"where username='"+username+"' "+
				"and orders.user_id=users.user_id "+		
				"and orders.ISBN=books.ISBN";
		out.println("<br><br> Shopping Cart <br>");
		out.println("    <table style=\"\" border=1>\n"+
				"<thead>\n"+
				"  <tr>\n"+
				"	<td>Order ID</td>\n"+
				"	<td>Title</td>\n"+
				"	<td>ISBN</td>\n"+
				"	<td>Quantity</td>\n"+
				"	<td>Total</td>\n"+
				"  </tr>\n"+
				"</thead>\n");
		java.sql.ResultSet rs1 = stat1.executeQuery(sqlQuery);
		while(rs1.next()) {
			String title=rs1.getString("title");
			String ISBN=rs1.getString("ISBN");
			String order_id=rs1.getString("order_id");
			int quantity=rs1.getInt("quantity");
			double price=rs1.getDouble("price");
			double total=(double) quantity * price;
			String totalStr = String.format("%.2f", total);
			out.println("<tr>\n"+
			"   <td>"+order_id+"</td>"+
			"   <td>"+title+"</td>"+
			"   <td>"+ISBN+"</td>"+ 
			"   <td>"+quantity+"</td>"+ 
			"   <td>"+totalStr+"</td>"+ 
			"</tr>"); 
		}
		out.println("</table>");
		out.println("Click <a href=\"Statistics.jsp\"> here</a> to go back to the main menu.");
	}
	catch(Exception e) {
		out.print(e.toString());
	}
	return sErr;
}

void showQueryTable(javax.servlet.jsp.JspWriter out) throws java.io.IOException { //search by user name. Search by name. Search by credit card.
	try {
		out.println("Search for a user's orders. Insert the username and a date YYYY-MM-DD HH:mm:ss");
		out.println("    <table style=\"\" border=1>");
	    out.println("     <tr>\n      <td style=\"background-color: #336699; text-align: Center; border-style: outset; border-width: 1\" colspan=\"2\"><font style=\"font-size: 12pt; color: #FFFFFF; font-weight: bold\">Enter login and password</font></td>\n     </tr>");

		  out.println("     <form action=\""+sFilename+"\" method=\"POST\">");
		  out.println("     <input type=\"hidden\" name=\"FormName\" value=\"searchUserOrders\">");
		  out.println(" <tr>\n"+      
		            "<td>Username</td>"+
		            "<td><input type=\"text\" name=\"username\" maxlength=\"50\"></td>\n"+
		            "</tr>");
		    out.println(" <tr>\n"+      
		            "<td>Year </td>"+
		            "<td><input type=\"text\" name=\"year\" maxlength=\"4\"></td>\n"+
		            "</tr>");
		    out.println(" <tr>\n"+      
		            "<td>Month </td>"+
		            "<td><input type=\"text\" name=\"month\" maxlength=\"2\"></td>\n"+
		            "</tr>");
		    out.println(" <tr>\n"+      
		            "<td>Day </td>"+
		            "<td><input type=\"text\" name=\"day\" maxlength=\"2\"></td>\n"+
		            "</tr>");
		    out.print(" <tr>\n"+
                    "<td><input type=\"submit\" value=\"Search\"></td>"+
                  "</form>"+
             "</tr></table>");
			}
			catch(Exception e) {
				out.print(e.toString());
			}
		
}

%>

</body>
</html>