<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*" %>
<%
String user_fname = request.getParameter("fname");
String user_email = request.getParameter("email");
String user_cadd = request.getParameter("cnum");
String user_address = request.getParameter("address");
String user_password = request.getParameter("pass");
Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/service_provider", "Neha", "neha1469");

    String query = "INSERT INTO users (name, phone, address, email, password) VALUES (?, ?, ?, ?, ?)";
    pstmt = conn.prepareStatement(query);
    pstmt.setString(1, user_fname);
    pstmt.setString(2, user_cadd);
    pstmt.setString(3, user_address);
    pstmt.setString(4, user_email);
    pstmt.setString(5, user_password);

    int i = pstmt.executeUpdate();

    if (i > 0) {
     response.sendRedirect("login.html");
    } else {
        out.println("<center><b>Failed to insert data!</b></center>");
    }
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
    out.print("<center><b>Error: " + e.getMessage() + "</b></center>");
} finally {
    try {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>

