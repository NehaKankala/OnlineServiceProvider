<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    // Get the updated details from the form
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");

    // Database connection details
    String driver = "com.mysql.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha";
    String password = "neha1469";

    // Fetch the logged-in provider's ID from the session
    Integer providerId = (Integer) session.getAttribute("provider_id");
    if (providerId == null) {
        response.sendRedirect("login.html"); // Redirect to login page if not logged in
        return;
    }

    Connection connection = null;
    PreparedStatement stmt = null;

    try {
        // Connect to the database
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        // Query to update provider's account details
        String query = "UPDATE providers SET name = ?, email = ?, phone = ? WHERE provider_id = ?";
        stmt = connection.prepareStatement(query);
        stmt.setString(1, name);
        stmt.setString(2, email);
        stmt.setString(3, phone);
        stmt.setInt(4, providerId);

        // Execute the update
        int rowsUpdated = stmt.executeUpdate();

        if (rowsUpdated > 0) {
            response.sendRedirect("provider.jsp"); // Redirect back to the dashboard if update is successful
        } else {
            out.println("<h2>Error: Unable to update account details.</h2>");
        }
    } catch (Exception e) {
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        if (stmt != null) stmt.close();
        if (connection != null) connection.close();
    }
%>

