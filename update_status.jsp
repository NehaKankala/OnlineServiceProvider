<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    // Database connection details
    String driver = "com.mysql.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha";
    String password = "neha1469";

    // Get order_id and status from the form
    String orderIdStr = request.getParameter("order_id");
    String status = request.getParameter("status");

    if (orderIdStr == null || status == null) {
        out.println("<h2>Error: Missing order ID or status!</h2>");
        return;
    }

    int orderId = Integer.parseInt(orderIdStr);

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        // Connect to the database
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        // Update order status query
        String updateQuery = "UPDATE orders SET status = ? WHERE order_id = ?";
        preparedStatement = connection.prepareStatement(updateQuery);
        preparedStatement.setString(1, status);
        preparedStatement.setInt(2, orderId);

        int rowsUpdated = preparedStatement.executeUpdate();

        if (rowsUpdated > 0) {
            out.println("<h2>Order status updated successfully to: " + status + "</h2>");
        } else {
            out.println("<h2>Error: Could not update order status!</h2>");
        }

        // Redirect back to the provider dashboard
        response.sendRedirect("provider.jsp");
    } catch (Exception e) {
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    }
%>

