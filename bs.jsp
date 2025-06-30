<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    // Database connection details
    String driver = "com.mysql.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha";
    String password = "neha1469";

    // Get form data
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        // If no user is logged in, redirect to the login page
        response.sendRedirect("index.html");
        return;
    }

    String providerId = request.getParameter("provider_id");
    String serviceId = request.getParameter("service_id");
    String address = request.getParameter("address");
    String phone = request.getParameter("phone");
    String serviceDate = request.getParameter("date");

    if (serviceId == null || address == null || phone == null || serviceDate == null) {
        out.println("<h2>Error: Missing required fields!</h2>");
        return;
    }

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        // SQL query to insert a new order into the orders table
        String insertOrderSQL = "INSERT INTO orders (user_id, service_id, provider_id, address, phone, service_date, status) " +
                                "VALUES (?, ?, ?, ?, ?, ?, 'Pending')";

        preparedStatement = connection.prepareStatement(insertOrderSQL);
        preparedStatement.setInt(1, userId);
        preparedStatement.setInt(2, Integer.parseInt(serviceId));
        preparedStatement.setInt(3, Integer.parseInt(providerId));
        preparedStatement.setString(4, address);
        preparedStatement.setString(5, phone);
        preparedStatement.setDate(6, Date.valueOf(serviceDate));

        int rowsAffected = preparedStatement.executeUpdate();

        if (rowsAffected > 0) {
            // Redirect to the Thank You page after a successful order
            response.sendRedirect("ThankYou.html");
        } else {
            out.println("<h2>Error placing order. Please try again.</h2>");
        }

    } catch (Exception e) {
        out.println("<h2>Error:</h2> " + e.getMessage());
    } finally {
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    }
%>

