<%@ include file="CommonStuff.jsp" %>
<%@ page import="java.sql.*" %>


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
<title>ManageUsers</title>
</head>
<body>
<%@ include file="Header.jsp" %>
<center>

<%
String sForm = request.getParameter("FormName");
if(sForm==null) //it will be null if we get to ManageUsers.jsp from some other page
	sForm=""; //it will be search if we get to ManageUsers from the Search form.
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
if(sForm.equals("searchUsers"))
	sErr=doSearch(request,  response, session, out, sForm, conn, stat);
else if(sForm.equals(""))
	showQueryTable(out);
else if(sForm.equals("modifyUser"))
	sErr=doModify(request,  response, session, out, sForm, conn, stat);
%>

<%! 
//this implementation has the drawback that it is rewriting values to the database that
//may have not been changed. However, it is simple. 
String doModify(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, javax.servlet.http.HttpSession session, javax.servlet.jsp.JspWriter out, String sForm, java.sql.Connection conn, java.sql.Statement stat) throws java.io.IOException {
	String sErr="";
	try {
		String user_id=request.getParameter("user_id");
		String delete_user=request.getParameter("delete_user");
		if(delete_user!=null) {
            String sqlQuery = "DELETE FROM users WHERE user_id=?";
		    PreparedStatement myps = null;
            myps = conn.prepareStatement(sqlQuery);	
            myps.setString(1,"user_id");
            ResultSet myrs = myps.executeQuery();
            //int count = stat.executeUpdate(sqlQuery);
			session.setAttribute("user_deleted", user_id);
			response.sendRedirect("UpdateSuccessful.jsp");
			sErr="delete";
		}
		String sqlQuery = "update users set ";
		String whereClause = "where user_id='" + user_id+ "'";
		String ccno = request.getParameter("ccno");
		if(ccno!=null) {
			sqlQuery+=" credit_card='"+ccno+"', ";
		}
		String address= request.getParameter("address");
		if(address!=null) {
			sqlQuery+=" address='"+address+"', ";
		}
		String password= request.getParameter("password");
		if(password!=null) {
			sqlQuery+=" password='"+password+"', ";
		}
		String userlevel=request.getParameter("userlevel");
		String level="1";
		if(userlevel.equals("yes"))
			level="2";
		if(password!=null) {
			sqlQuery+=" level='"+level+"' "+ whereClause;
			out.println(sqlQuery);
			int count = stat.executeUpdate(sqlQuery);
			session.setAttribute("user_updated", user_id);
			response.sendRedirect("UpdateSuccessful.jsp");
		}
		
	}
	catch(Exception e) {
		out.println(e.toString());
	}
	return sErr;
}

String doSearch(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, javax.servlet.http.HttpSession session, javax.servlet.jsp.JspWriter out, String sForm, java.sql.Connection conn, java.sql.Statement stat) throws java.io.IOException {
	try {
		String name = request.getParameter("name");
		String username= request.getParameter("username");
		String ccno = request.getParameter("ccno");
        String sqlQuery = "SELECT user_id, name, password, address, credit_card, level FROM users WHERE name=? OR username=? OR credit_card=?";
        PreparedStatement ps2 = null;
        ps2 = conn.prepareStatement(sqlQuery);
        ps2.setString(1,name); 
        ps2.setString(2,username);
        ps2.setString(3,ccno);
		ResultSet rs = ps2.executeQuery();
		//this can return more than one users, if they have the same name.
		out.println("    <table style=\"\" border=1>\n");
	    while(rs.next()) {
			out.println("<tr>\n  <td>\n");
			//for every user, print a table and a form.
			out.println("  <table>");
			String name1=rs.getString("name");
			String user_id1=rs.getString("user_id");
			String password1=rs.getString("password");
			String address1=rs.getString("password");
			String ccno1=rs.getString("credit_card");
			String level1=rs.getString("level");
			String radioInputCheckedlevel1="";
			String radioInputCheckedlevel2="";
			if(level1.equals("1"))
				radioInputCheckedlevel1="checked";
			else if(level1.equals("2"))
				radioInputCheckedlevel2="checked";
			out.println("The current values for the user are shown in the text fields<br>");
			out.println("Change them to new values and click on submit");
			out.println("<form action=\"ManageUsers.jsp\" method=\"post\">\n"+
						"<input type=\"hidden\" name=\"FormName\" value=\"modifyUser\">\n"+
						"<input type=\"hidden\" name=\"user_id\" value=\""+user_id1+"\">\n"+
					"<tr>\n"+
					"   <td> Change the user's password </td>"+ 
						"<td><input type=\"text\" name=\"password\" value=\""+password1+"\">\n"+
					"</tr>\n"+
					"<tr>\n"+
					"   <td> Change the user's address </td>"+ 
						"<td><input type=\"text\" name=\"address\" value=\""+address1+"\">\n"+
					"</tr>\n"+
					"<tr>\n"+
					"   <td> Change the user's CC No </td>"+ 
						"<td><input type=\"text\" name=\"ccno\" value=\""+ccno1+"\">\n"+
					"</tr>\n"+
					"<tr>\n"+
					"   <td> Set as Admin? </td>"+ 
					"<td><input type=\"radio\" name=\"userlevel\" value=\"yes\""+radioInputCheckedlevel2+">Yes\n"+
					"<td><input type=\"radio\" name=\"userlevel\" value=\"no\""+radioInputCheckedlevel1+">No\n"+
					"</tr>\n"+
					"   <td> Check Box to Delete User </td>"+ 
					"<td><input type=\"checkbox\" name=\"delete_user\" value=\"Delete\">\n"+
					"</tr>\n"+
					"<tr>\n"+
					"<td>Click to submit changes</td>"+
					"<td><input type=\"submit\" value=\"Submit\"></td>"+
					"</tr>"+
					
					"</form>\n");
			out.println("  </table>");
			out.println("  </td>\n</tr>\n");
			
		}
		out.println("</table>");
	}
	catch(Exception e) {
		out.print(e.toString());
	}
	String sErr="";
	out.println("Search Done");
	return sErr;
}

void showQueryTable(javax.servlet.jsp.JspWriter out) throws java.io.IOException { //search by user name. Search by name. Search by credit card.
	try {
		out.println("Search for a user by name, username, or credit card number");
		out.println("    <table style=\"\" border=1>");
	    out.println("     <tr>\n      <td style=\"background-color: #336699; text-align: Center; border-style: outset; border-width: 1\" colspan=\"2\"><font style=\"font-size: 12pt; color: #FFFFFF; font-weight: bold\">Enter login and password</font></td>\n     </tr>");

		  out.println("     <form action=\""+sFilename+"\" method=\"POST\">");
		  out.println("     <input type=\"hidden\" name=\"FormName\" value=\"searchUsers\">");
		  out.println(" <tr>\n"+      
		                    "<td>Name </td>"+
		                    "<td><input type=\"text\" name=\"name\" maxlength=\"50\"></td>\n"+         "</tr>");
		    out.println(" <tr>\n"+      
		            "<td>Username</td>"+
		            "<td><input type=\"text\" name=\"username\" maxlength=\"50\"></td>\n"+         "</tr>");
		    out.println(" <tr>\n"+      
		            "<td>Credit Card</td>"+
		            "<td><input type=\"text\" name=\"ccno\" maxlength=\"16\"></td>\n"+         "</tr>");
		    out.print("   <tr>\n"+
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
