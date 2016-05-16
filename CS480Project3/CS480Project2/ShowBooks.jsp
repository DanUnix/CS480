<%@ include file="CommonStuff.jsp" %>

<%
//create connection
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
ShowBooksTable(stat, conn, session, out);
%>
<html>
<head>
<meta charset="UTF-8">
<title>BookStore</title>
</head>
<body>
<%!//Draw table. Send query to database and for every result add a row to the table.
void ShowBooksTable(java.sql.Statement stat, java.sql.Connection conn, javax.servlet.http.HttpSession session, javax.servlet.jsp.JspWriter out) throws java.io.IOException {
	try {
		out.print("<table>\n"+
				"<thead>\n"+
				"  <tr>\n"+
				"	<td style=\"width: 200px;\">Book Title</td>\n"+
				"	<td style=\"width: 200px;\">Authors</td>\n"+
				"	<td style=\"width: 200px;\">Description</td>\n"+
				"	<td style=\"width: 200px;\">Price</td>\n"+
				"	<td style=\"width: 200px;\">Quantity</td>\n"+
				"  </tr>\n"+
				"</thead>\n");
		String sqlQuery = "select image, name, price, description, books.ISBN, count(books.ISBN) as NoAuthors from authors, books, booksAndAuthors where books.ISBN=booksAndAuthors.ISBN AND booksAndAuthors.id=authors.id group by image, price,ISBN;";
		java.sql.ResultSet rs = stat.executeQuery(sqlQuery);;
	      while( rs.next() ) {
	           printOneTableRow(rs, conn, session, out);
	      }
	      out.println("</table>");
	}
	catch(Exception e) {
		out.println(e.toString());
	}
 }

void printOneTableRow(java.sql.ResultSet rs, java.sql.Connection conn, javax.servlet.http.HttpSession session, javax.servlet.jsp.JspWriter out) throws java.io.IOException {
	try {
		String image_url = rs.getString("image");
		String description = rs.getString("description");
		float price = rs.getFloat("price");
		String ISBN = rs.getString("ISBN");
		int noAuthors = rs.getInt("NoAuthors");
		String author=rs.getString("name");
		//a book may have more than one author. We can't reuse the statement from before, since it would close the current ResultSet
		if(noAuthors>1) {
			java.sql.Statement stat = conn.createStatement();
			String sqlQuery = "Select name from authors, booksAndAuthors where booksAndAuthors.id=authors.id AND booksAndAuthors.ISBN=\'"+ISBN+"\';";
			java.sql.ResultSet rsAuthors=stat.executeQuery(sqlQuery);
			rsAuthors.next();
			author=rsAuthors.getString("name");
			while(rsAuthors.next())
				author+=" & " + rsAuthors.getString("name");
		}		
		java.sql.Statement stat=conn.createStatement();
	    out.println("<form action=\"InsertOrder.jsp\" method=\"post\">\n"+
				"<tr>\n"+
					"<td><img src=\""+image_url+"\" style=\"height: 318px; width: 197px; \"></td>\n"+
					"<td>"+author+"</td>\n"+
					"<td>"+description+"</td>\n"+
					"<td>"+price+"</td>\n"+
					"<td>\n"+
					    "<input type=\"text\" name=\"quantity\" value=\"\">\n"+
					"</td>\n"+
					    "<input type=\"hidden\" name=\"ISBN\" value=\""+ISBN+"\">\n"+
					"<td>\n"+
					 "   <input type=\"submit\" value=\"Order\">\n"+
					"</td>\n"+
				"</tr>\n"+
				"</form>\n");
		stat.close();
	}
	catch(Exception e) {out.println(e.toString());}
}
%>
			
</body>
</html>
