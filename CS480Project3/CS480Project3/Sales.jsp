<%@ include file="CommonStuff.jsp" %>
<%@ page import="java.sql.*" %>


<%! String sSignUpErr = ""; 
	String sFilename = "BookSales.jsp";
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
if(sForm==null) //it will be null if we get to BookSales from some other page other than BookStatistics
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
if(sForm.equals("book_sales"))
	sErr=doSearchBookSales(request,  response, session, out, sForm, conn, stat);
else if(sForm.equals("author_sales"))
	sErr=doSearchAuthorSales(request,  response, session, out, sForm, conn, stat);
else if(sForm.equals("total_sales"))
	sErr=doSearchTotalSales(request,  response, session, out, sForm, conn, stat);
else if(sForm.equals("ranked_sales"))
	sErr=doSearchRankedSales(request,  response, session, out, sForm, conn, stat);
else 
	response.sendRedirect("BookStatistics.jsp");
%>

<%! 
String doSearchRankedSales(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, javax.servlet.http.HttpSession session, javax.servlet.jsp.JspWriter out, String sForm, java.sql.Connection conn, java.sql.Statement stat) throws java.io.IOException {
	String sErr="";
	try {
		String from_year=request.getParameter("year_from");
		String from_month=request.getParameter("month_from");
		String from_day=request.getParameter("day_from");
		String to_year=request.getParameter("year_to");
		String to_month=request.getParameter("month_to");
		String to_day=request.getParameter("day_to");
		String datetime_from=from_year+"-"+from_month+"-"+from_day+" 00:00:00";
		String datetime_to=to_year+"-"+to_month+"-"+to_day+" 00:00:00";
		String sqlQuery = "select books.ISBN, title, sum(quantity*price) as sumSales "+
						  "from order_history, books "+
						  "where order_history.ISBN=books.ISBN and "+
						  "order_history.orderts between '"+datetime_from+"' and '"+
						  datetime_to+"' "+
						  "group by books.ISBN, title order by sumSales desc";
		//out.println(sqlQuery);
		java.sql.ResultSet rs = stat.executeQuery(sqlQuery);
		out.println("<br><br> Books by Sum of Sales <br>");
		out.println("    <table style=\"\" border=1>\n"+
				"<thead>\n"+
				"  <tr>\n"+
				"	<td>ISBN</td>\n"+
				"	<td>Title</td>\n"+
				"	<td>Sales</td>\n"+
				"  </tr>\n"+
				"</thead>\n");
		while(rs.next()) {
			String ISBN = rs.getString(1);
			String title= rs.getString(2);
			double sumSales=rs.getDouble(3);
			out.println("<tr>\n"+
					"   <td>"+ISBN+"</td>"+
					"   <td>"+title+"</td>"+
					"   <td>"+sumSales+"</td>"+ 
					"</tr>");
		}
		out.println("</table><br><br>");
		
		out.println("By Number of Sales<br>");
		
		String sqlQuery1 = "select books.ISBN, title, count(*) as noOrders "+
				  "from order_history, books "+
				  "where order_history.ISBN=books.ISBN and "+
				  "order_history.orderts between '"+datetime_from+"' and '"+
				  datetime_to+"' "+
				  "group by books.ISBN, title order by noOrders desc";

		//out.println(sqlQuery1);
		
		java.sql.ResultSet rs1 = stat.executeQuery(sqlQuery1);
		out.println("    <table style=\"\" border=1>\n"+
				"<thead>\n"+
				"  <tr>\n"+
				"	<td>ISBN</td>\n"+
				"	<td>Title</td>\n"+
				"	<td>No Orders</td>\n"+
				"  </tr>\n"+
				"</thead>\n");
		while(rs1.next()) {
			String ISBN = rs1.getString(1);
			String title= rs1.getString(2);
			int noOrders=rs1.getInt(3);
			out.println("<tr>\n"+
					"   <td>"+ISBN+"</td>"+
					"   <td>"+title+"</td>"+
					"   <td>"+noOrders+"</td>"+ 
					"</tr>");
		}
		
		out.println("</table><br><br>");
		
		out.println("Click <a href=\"Statistics.jsp\"> here</a> to go back to the main menu.");
		
	}
	catch(Exception e) {
		out.print(e.toString());
	}
	return sErr;
}

String doSearchTotalSales(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, javax.servlet.http.HttpSession session, javax.servlet.jsp.JspWriter out, String sForm, java.sql.Connection conn, java.sql.Statement stat) throws java.io.IOException {
	String sErr="";
	try {
		String from_year=request.getParameter("year_from");
		String from_month=request.getParameter("month_from");
		String from_day=request.getParameter("day_from");
		String to_year=request.getParameter("year_to");
		String to_month=request.getParameter("month_to");
		String to_day=request.getParameter("day_to");
		String datetime_from=from_year+"-"+from_month+"-"+from_day+" 00:00:00";
		String datetime_to=to_year+"-"+to_month+"-"+to_day+" 00:00:00";
		String sqlQuery = "select count(*) from order_history "+
				"where order_history.orderts between '"+datetime_from+"' and '"+
						  datetime_to+"'";
		java.sql.ResultSet rs = stat.executeQuery(sqlQuery);
		rs.next();
		String noOrders = rs.getString(1);
		sqlQuery = "select sum(price*quantity) from order_history, books "+
				"where order_history.ISBN=books.ISBN and "+
				" order_history.orderts between '"+datetime_from+"' and '"+
						  datetime_to+"'";
		//out.println(sqlQuery);
		
		java.sql.ResultSet rs1 = stat.executeQuery(sqlQuery);
		rs1.next();
		double total_sales = rs1.getDouble(1);
		
		out.println("<table>");
		out.println("<tr>"+
					 "<td> No Orders: </td>"+
					 "<td>"+noOrders+"</td>"+
					 "<tr>"+
					 "<td> Total Sales: </td>"+
					 "<td>"+total_sales+"</td>" +
					 "</tr>");
		out.println("</table>");
		out.println("Click <a href=\"Statistics.jsp\"> here</a> to go back to the main menu.");
		
	}
	catch(Exception e) {
		out.print(e.toString());
	}
	return sErr;
}


String doSearchBookSales(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, javax.servlet.http.HttpSession session, javax.servlet.jsp.JspWriter out, String sForm, java.sql.Connection conn, java.sql.Statement stat) throws java.io.IOException {
	String sErr="";
	try {
		String from_year=request.getParameter("year_from");
		String from_month=request.getParameter("month_from");
		String from_day=request.getParameter("day_from");
		String to_year=request.getParameter("year_to");
		String to_month=request.getParameter("month_to");
		String to_day=request.getParameter("day_to");
		String datetime_from=from_year+"-"+from_month+"-"+from_day+" 00:00:00";
		String datetime_to=to_year+"-"+to_month+"-"+to_day+" 00:00:00";
		String title = request.getParameter("title");
		String sqlQuery = "select order_id, order_history.ISBN, username, quantity, orderts "+
						  "from order_history, books, users " +
						  "where books.title='"+title+"' and "+
						  "books.ISBN=order_history.ISBN and "+
						  "users.user_id=order_history.user_id "+
						  "and order_history.orderts between '"+datetime_from+"' and '"+
						  datetime_to+"'";
		java.sql.ResultSet rs = stat.executeQuery(sqlQuery);
		out.println("<br><br> Results <br>");
		out.println("    <table style=\"\" border=1>\n"+
				"<thead>\n"+
				"  <tr>\n"+
				"	<td>Username</td>\n"+
				"	<td>Order ID</td>\n"+
				"	<td>ISBN</td>\n"+
				"	<td>Quantity</td>\n"+
				"   <td>Date</td>"+
				"  </tr>\n"+
				"</thead>\n");
		while(rs.next()) {
			String username=rs.getString("username");
			String order_id=rs.getString("order_id");
			String ISBN=rs.getString("ISBN");
			int quantity=rs.getInt("quantity");
			String date = rs.getString("orderts");
			out.println("<tr>\n"+
			"   <td>"+username+"</td>"+
			"   <td>"+order_id+"</td>"+
			"   <td>"+ISBN+"</td>"+ 
			"   <td>"+quantity+"</td>"+ 
			"   <td>"+date+"</td>"+ 
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

String doSearchAuthorSales(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, javax.servlet.http.HttpSession session, javax.servlet.jsp.JspWriter out, String sForm, java.sql.Connection conn, java.sql.Statement stat) throws java.io.IOException {
	String sErr="";
	try {
		String from_year=request.getParameter("year_from");
		String from_month=request.getParameter("month_from");
		String from_day=request.getParameter("day_from");
		String to_year=request.getParameter("year_to");
		String to_month=request.getParameter("month_to");
		String to_day=request.getParameter("day_to");
		String datetime_from=from_year+"-"+from_month+"-"+from_day+" 00:00:00";
		String datetime_to=to_year+"-"+to_month+"-"+to_day+" 00:00:00";
		String author = request.getParameter("author");
		String sqlQuery = "select order_id, order_history.ISBN, username, quantity, orderts "+
						  "from order_history, users, authors, booksAndAuthors " +
						  "where authors.name='"+author+"' and "+
						  "authors.id=booksAndAuthors.id and "+
						  "booksAndAuthors.ISBN=order_history.ISBN and "+
						  "booksAndAuthors.ISBN=order_history.ISBN and "+
						  "order_history.user_id=users.user_id and "+
						  "order_history.orderts between '"+datetime_from+"' and '"+
						  datetime_to+"'";
		//out.println(sqlQuery);
		java.sql.ResultSet rs = stat.executeQuery(sqlQuery);
		out.println("<br><br> Results <br>");
		out.println("    <table style=\"\" border=1>\n"+
				"<thead>\n"+
				"  <tr>\n"+
				"	<td>Username</td>\n"+
				"	<td>Order ID</td>\n"+
				"	<td>ISBN</td>\n"+
				"	<td>Quantity</td>\n"+
				"   <td>Date</td>"+
				"  </tr>\n"+
				"</thead>\n");
		while(rs.next()) {
			String username=rs.getString("username");
			String order_id=rs.getString("order_id");
			String ISBN=rs.getString("ISBN");
			int quantity=rs.getInt("quantity");
			String date = rs.getString("orderts");
			out.println("<tr>\n"+
			"   <td>"+username+"</td>"+
			"   <td>"+order_id+"</td>"+
			"   <td>"+ISBN+"</td>"+ 
			"   <td>"+quantity+"</td>"+ 
			"   <td>"+date+"</td>"+ 
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
%>

</body>
</html>
