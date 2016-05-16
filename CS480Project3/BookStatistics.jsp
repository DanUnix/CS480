<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Book Statistics</title>
</head>
<body>
<%@ include file="Header.jsp"%>
<center>

Show the sales of a book between two dates:
<table>
<form action="Sales.jsp" method="post">
<input type=hidden name="FormName" value="book_sales">
<tr>
<td>Book title</td>
<td><input type ="text" name="title"></td>
</tr>
<tr>
<td>From</td>
<td><input type ="text" name="year_from" value="type year here"></td>
<td><input type ="text" name="month_from" value="type month here"></td>
<td><input type ="text" name="day_from" value="type day here"></td>
</tr>
<td>To</td>
<td><input type ="text" name="year_to" value="type year here"></td>
<td><input type ="text" name="month_to" value="type month here"></td>
<td><input type ="text" name="day_to" value="type day here"></td>
</tr>
<tr>
<td><input type="submit" name = "submit" value="Search"></td>
</tr>
</form>
</table>

Show the sales of an author between two dates:
<table>
<form action="Sales.jsp" method="post">
<input type=hidden name="FormName" value="author_sales">
<tr>
<td>Author Name</td>
<td><input type ="text" name="author"></td>
</tr>
<tr>
<td>From</td>
<td><input type ="text" name="year_from" value="type year here"></td>
<td><input type ="text" name="month_from" value="type month here"></td>
<td><input type ="text" name="day_from" value="type day here"></td>
</tr>
<td>To</td>
<td><input type ="text" name="year_to" value="type year here"></td>
<td><input type ="text" name="month_to" value="type month here"></td>
<td><input type ="text" name="day_to" value="type day here"></td>
</tr>
<tr>
<td><input type="submit" name = "submit" value="Search"></td>
</tr>
</form>
</table>

Show the total sales between two dates:
<table>
<form action="Sales.jsp" method="post">
<input type=hidden name="FormName" value="total_sales">
<tr>
<td>From</td>
<td><input type ="text" name="year_from" value="type year here"></td>
<td><input type ="text" name="month_from" value="type month here"></td>
<td><input type ="text" name="day_from" value="type day here"></td>
</tr>
<td>To</td>
<td><input type ="text" name="year_to" value="type year here"></td>
<td><input type ="text" name="month_to" value="type month here"></td>
<td><input type ="text" name="day_to" value="type day here"></td>
</tr>
<tr>
<td><input type="submit" name = "submit" value="Search"></td>
</tr>
</form>
</table>

Show ranked sales between two dates:
<table>
<form action="Sales.jsp" method="post">
<input type=hidden name="FormName" value="ranked_sales">
<tr>
<td>From</td>
<td><input type ="text" name="year_from" value="type year here"></td>
<td><input type ="text" name="month_from" value="type month here"></td>
<td><input type ="text" name="day_from" value="type day here"></td>
</tr>
<td>To</td>
<td><input type ="text" name="year_to" value="type year here"></td>
<td><input type ="text" name="month_to" value="type month here"></td>
<td><input type ="text" name="day_to" value="type day here"></td>
</tr>
<tr>
<td><input type="submit" name = "submit" value="Search"></td>
</tr>
</form>
</table>

</body>
</html>
