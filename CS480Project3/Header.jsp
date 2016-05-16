<%
if(session.getAttribute("user_id")!=null){
	//user is logged in, so display the logout button.
	out.println(session.getAttribute("username"));
	out.println(" <form action=\"Logout.jsp\">\n"+
				"	  <input type=\"submit\" value=\"logout\">\n"+
			    "</form>");
//else user is not logged in, so don't show anything, there is no else.
}

%>