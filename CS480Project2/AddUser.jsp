<%@ include file="CommonStuff.jsp" %>
<%!
static final String sFileName = "AddUser.jsp";
String sLoginErr="";
int counter = 0;
%>
<%
//create connection
//Assuming the user is already logged in. (Redirection to login page if user is not logged in in the next assignment.)
String sForm = request.getParameter("FormName"); 
 if(sForm==null)  sForm=""; //it will be null if we get to Login.jsp by typing the url in the address bar.

//input type=\"hidden\" name=\"FormName\" value=\"Login\">

java.sql.Connection conn = null;
java.sql.PreparedStatement stat = null;
//java.sql.ResultSet rs = null;
String sErr = loadDriver();
conn = connectToDB();
if ( ! sErr.equals("") ) {
 try {
   out.println(sErr);
 }
 catch (Exception e) {}
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Add User</title>
</head>
<body>

<center>
<table>
	<tr>
		<td valign="top">
		<%ShowUserAddPage(request,response,session,out,sLoginErr,sForm,conn,stat);%>	
		<%AddUser(request,response,session, out,conn,stat);%>
		</td>
	</tr>
</table>
<%! //get parameters and send the insert query to the database.
void AddUser(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response,javax.servlet.http.HttpSession session, javax.servlet.jsp.JspWriter out, java.sql.Connection conn, java.sql.PreparedStatement stat) throws java.io.IOException{
	String sqlQuery = "INSERT INTO users(user_id,username,password,name,address,credit_card,admin) VALUES(?,?,?,?,?,?,?);";	
    String uid = request.getParameter("user_id");
	String userName = request.getParameter("username");
	String pass = request.getParameter("password");
	String name = request.getParameter("newName");
	String address = request.getParameter("address");
	String credit = request.getParameter("credit_card");
    int isAdmin = 0;
	try{
		if((!(userName.equals(null) || userName.equals("")) && (!(pass.equals(null) || pass.equals("")) && !(name.equals(null) || name.equals("")) 
						&& !(address.equals(null) || address.equals("")) && !(credit.equals(null) || credit.equals(""))))){
			
			stat = conn.prepareStatement(sqlQuery);
            stat.setInt(1,++counter);
			stat.setString(2,userName);
			stat.setString(3,pass);
			stat.setString(4,name);
			stat.setString(5,address);
			stat.setString(6,credit);
            stat.setInt(7,isAdmin);

			int exe = stat.executeUpdate();
			try{
				if(conn != null)
					conn.close();
			}catch(java.sql.SQLException ignore){}
		response.sendRedirect("Login.jsp");
		}else{
			response.sendRedirect("AddUser.jsp");
			stat.close();
		}
	}catch(Exception e){
		out.println(e);
	}
}

void ShowUserAddPage(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response, javax.servlet.http.HttpSession session, javax.servlet.jsp.JspWriter out, String sLoginErr, String sForm, java.sql.Connection conn, java.sql.Statement stat) throws java.io.IOException {
	try{
		String sSQL="";
		String sPage = request.getParameter("ret_page");
		
		out.println("	<table style=\"\" border=1>");
		out.println("     <tr>\n      <td style=\"background-color: #336699; text-align: Center; border-style: outset; border-width: 1\" colspan=\"2\"><font style=\"font-size: 12pt; color: #FFFFFF; font-weight: bold\">Enter new User login info</font></td>\n     </tr>");	
		
		if ( sLoginErr.compareTo("") != 0 ) {
        out.println("     <tr>\n      <td colspan=\"2\" style=\"background-color: #FFFFFF; border-width: 1\"><font style=\"font-size: 10pt; color: #000000\">"+sLoginErr+"</font></td>\n     </tr>");

	}
	sLoginErr="";
      out.println("     <form action=\""+sFileName+"\" method=\"POST\">");
      out.println("     <input type=\"hidden\" name=\"FormName\" value=\"Login\">");
      if ( session.getAttribute("UserID") == null || ((String) session.getAttribute("UserID")).compareTo("") == 0 ) {
        // User did not login
        out.println(" <tr>\n"+
                        "<td>Username</td>"+
                        "<td><input type=\"text\" name=\"username\" maxlength=\"50\" value=\"\"></td>\n"+
                      "</tr>");
        out.println(" <tr>\n"+
                        "<td>Password</td>"+
                        "<td><input type=\"text\" name=\"password\" maxlength=\"50\"></td>\n"+         "</tr>");
		 out.println(" <tr>\n"+
                        "<td>Name</td>"+
                        "<td><input type=\"text\" name=\"newName\" maxlength=\"50\"></td>\n"+         "</tr>");
		 out.println(" <tr>\n"+
                        "<td>Address</td>"+
                        "<td><input type=\"text\" name=\"address\" maxlength=\"50\"></td>\n"+         "</tr>");
		 out.println(" <tr>\n"+
                        "<td>Credit Card</td>"+
                        "<td><input type=\"text\" name=\"credit_card\" maxlength=\"50\"></td>\n"+         "</tr>");

        out.print("   <tr>\n"+
                        "<td><input type=\"submit\" value=\"SignUp\"></td>"+
                      "</tr>");

     } else {
        // User logged in
        //String getUserID(java.sql.Statement stat, String table, String fName, String where)
        //String sUserID = dLookUp( stat, "members", "member_login", "member_id =" + session.getAttribute("UserID"));
        java.sql.Connection conn1 = null;
        java.sql.Statement stat1 = null;
         String userID ="";
        try {
          conn1 = java.sql.DriverManager.getConnection(strConn , DBusername, DBpassword);
          stat1 = conn1.createStatement();
          String sqlQ = "SELECT user_id FROM members WHERE user_id = " + session.getAttribute("user_id");
          java.sql.ResultSet rsLookUp = stat.executeQuery(sqlQ);

         // openrs( stat1, "SELECT " + fName + " FROM " + table + " WHERE " + where);
          if (! rsLookUp.next()) {
            rsLookUp.close();
            stat1.close();
            conn1.close();
        }
          userID = rsLookUp.getString(1);
          rsLookUp.close();
          stat1.close();
          conn1.close();
          
        }
        catch (Exception e) { 
           out.println(e.toString());
        }
      
        out.print(" <tr>"+
                      "<td>"+userID+"&nbsp;&nbsp;"+
                      "<input type=\"submit\" value=\"Logout\"/>");
        out.println("</td>\n     </form>\n     </tr>");
      }
      out.println("    </table>");


	}
	catch (Exception e) { out.println(e.toString()); }
}
%>
</body>
</html>
