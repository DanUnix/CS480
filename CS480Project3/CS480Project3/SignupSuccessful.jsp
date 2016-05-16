<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Signup Successful</title>
</head>
<body>
<p>
Welcome to our bookstore 
<%out.print(session.getAttribute("username")); %>
<p>Click <a href="ShowBooks.jsp">here</a> to view our books.
</body>
</html>