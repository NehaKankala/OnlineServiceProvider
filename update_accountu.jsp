<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    // Database connection details
    String driver = "com.mysql.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha";
    String dbPassword = "neha1469";

    // Check if the session contains the user_id
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("index.html");
        return;
    }

    // Fetch form parameters
    String userName = request.getParameter("name");
    String userEmail = request.getParameter("email");
    String userPassword = request.getParameter("password");
    String userPhone = request.getParameter("phone");
    String userAddress = request.getParameter("address");

    Connection connection = null;
    PreparedStatement updateStmt = null;

    try {
        // Connect to the database
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, dbPassword);

        // Update query
        String updateQuery = "UPDATE users SET name = ?, email = ?, phone = ?, address = ?" + 
                             (userPassword != null && !userPassword.isEmpty() ? ", password = ?" : "") + 
                             " WHERE user_id = ?";
        updateStmt = connection.prepareStatement(updateQuery);
        updateStmt.setString(1, userName);
        updateStmt.setString(2, userEmail);
        updateStmt.setString(3, userPhone);
        updateStmt.setString(4, userAddress);
        if (userPassword != null && !userPassword.isEmpty()) {
            updateStmt.setString(5, userPassword);
            updateStmt.setInt(6, userId);
        } else {
            updateStmt.setInt(5, userId);
        }
        updateStmt.executeUpdate();

        // Redirect back to the account page with a success message
        response.sendRedirect("services.jsp?success=1");

    } catch (Exception e) {
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        if (updateStmt != null) try { updateStmt.close(); } catch (Exception ignored) {}
        if (connection != null) try { connection.close(); } catch (Exception ignored) {}
    }
%>

