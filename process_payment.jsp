<%@ page import="java.sql.*" %>
<%
    String driver = "com.mysql.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha";
    String password = "neha1469";

    // Get the parameters
    String orderIdParam = request.getParameter("order_id");
    String amountParam = request.getParameter("amount");
    String paymentMethod = request.getParameter("payment_method");

    if (orderIdParam == null || amountParam == null || paymentMethod == null) {
        out.println("<h2>Error: Missing Parameters!</h2>");
        return;
    }

    int orderId;
    double amount;

    try {
        orderId = Integer.parseInt(orderIdParam);
        amount = Double.parseDouble(amountParam);
    } catch (NumberFormatException e) {
        out.println("<h2>Error: Invalid Order or Amount Format!</h2>");
        return;
    }

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        String updateQuery = "UPDATE orders SET payment_status = 'Paid' WHERE order_id = ?";
        preparedStatement = connection.prepareStatement(updateQuery);
        preparedStatement.setInt(1, orderId);

        int rowsAffected = preparedStatement.executeUpdate();
        if (rowsAffected > 0) {
            // Redirect to the Thank You page with details
            String redirectUrl = "thank_you.jsp?order_id=" + orderId + "&amount=" + amount + "&payment_method=" + paymentMethod;
            response.sendRedirect(redirectUrl);
        } else {
            out.println("<h2>Error: Failed to Update Payment Status!</h2>");
        }
    } catch (Exception e) {
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    }
%>
