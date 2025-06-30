<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Database connection details
    String driver = "com.mysql.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha"; // Update with your MySQL username
    String password = "neha1469";  // Update with your MySQL password

    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;
    String message = null;

    try {
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);
        statement = connection.createStatement();

        // Check if a new service is being added
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String action = request.getParameter("action");

            if ("add".equals(action)) {
                String serviceName = request.getParameter("service_name");
                if (serviceName != null && !serviceName.isEmpty()) {
                    String insertQuery = "INSERT INTO services (service_name) VALUES ('" + serviceName + "')";
                    statement.executeUpdate(insertQuery);
                    message = "Service added successfully!";
                } else {
                    message = "Service name is required!";
                }
            } else if ("delete".equals(action)) {
                String serviceId = request.getParameter("service_id");
                if (serviceId != null) {
                    String deleteQuery = "DELETE FROM services WHERE service_id=" + serviceId;
                    statement.executeUpdate(deleteQuery);
                    message = "Service removed successfully!";
                }
            }
        }

        // Fetch all services
        String selectQuery = "SELECT * FROM services";
        resultSet = statement.executeQuery(selectQuery);

    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }
%>

<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        h1 { text-align: center; }
        .container { max-width: 800px; margin: auto; }
        .form-section, .list-section { margin-bottom: 30px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
        .btn { padding: 8px 15px; background-color: #28a745; color: white; border: none; cursor: pointer; }
        .btn-danger { background-color: #dc3545; }
        .btn:hover { opacity: 0.9; }
        .message { color: green; margin-bottom: 10px; }
    </style>
</head>
<body>
    <h1>Admin Dashboard</h1>
    <div class="container">

        <% if (message != null) { %>
            <div class="message"><%= message %></div>
        <% } %>

        <!-- Add Service Section -->
        <div class="form-section">
            <h2>Add New Service</h2>
            <form method="POST">
                <input type="hidden" name="action" value="add">
                <div>
                    <label for="service_name">Service Name:</label><br>
                    <input type="text" id="service_name" name="service_name" required>
                </div><br>
                <button type="submit" class="btn">Add Service</button>
            </form>
        </div>

        <!-- List Services Section -->
        <div class="list-section">
            <h2>Existing Services</h2>
            <table>
                <tr>
                    <th>Service ID</th>
                    <th>Service Name</th>
                    <th>Action</th>
                </tr>
                <%
                    try {
                        while (resultSet != null && resultSet.next()) {
                            int serviceId = resultSet.getInt("service_id");
                            String serviceName = resultSet.getString("service_name");
                %>
                            <tr>
                                <td><%= serviceId %></td>
                                <td><%= serviceName %></td>
                                <td>
                                    <form method="POST" style="display: inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="service_id" value="<%= serviceId %>">
                                        <button type="submit" class="btn btn-danger">Remove</button>
                                    </form>
                                </td>
                            </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='3'>Error fetching services: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if (resultSet != null) resultSet.close();
                        if (statement != null) statement.close();
                        if (connection != null) connection.close();
                    }
                %>
            </table>
        </div>
    </div>
</body>
</html>

