<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    // Database connection details
    String driver = "com.mysql.cj.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha";
    String password = "neha1469";

    // Get the parameters from the form
    String orderIdStr = request.getParameter("order_id");
    String providerIdStr = request.getParameter("provider_id");
    String userIdStr = request.getParameter("user_id");
    String messageText = request.getParameter("message_text");

    // Validate parameters
    if (orderIdStr == null || providerIdStr == null || userIdStr == null || messageText == null || messageText.trim().isEmpty()) {
        out.println("<h2>Error:  Please enter the message.</h2>");
        return;
    }

    // Convert parameters to integers
    Integer orderId = Integer.parseInt(orderIdStr);
    Integer providerId = Integer.parseInt(providerIdStr);
    Integer userId = Integer.parseInt(userIdStr);

    // Ensure the message text is not null or empty
    if (messageText == null || messageText.trim().isEmpty()) {
        out.println("<h2>Error: Message text cannot be empty.</h2>");
        return;
    }

    // Database connection and statement initialization
    Connection connection = null;
    PreparedStatement messageStmt = null;

    try {
        // Establish the database connection
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        // SQL query to insert the message into user_messages
        String insertMessageQuery = "INSERT INTO user_messages (order_id, user_id, provider_id, message_text) " +
                                    "VALUES (?, ?, ?, ?)";
        messageStmt = connection.prepareStatement(insertMessageQuery);
        messageStmt.setInt(1, orderId);
        messageStmt.setInt(2, userId); // Sender is the user
        messageStmt.setInt(3, providerId); // Receiver is the provider
        messageStmt.setString(4, messageText);

        // Execute the insert statement
        messageStmt.executeUpdate();

        // Redirect to the chat page
        response.sendRedirect("chat.jsp?order_id=" + orderId + "&provider_id=" + providerId + "&user_id=" + userId);

    } catch (SQLException e) {
        out.println("<h2>Database Error: " + e.getMessage() + "</h2>");
    } catch (NullPointerException e) {
        out.println("<h2>Null Pointer Error: " + e.getMessage() + "</h2>");
    } catch (Exception e) {
        out.println("<h2>General Error: " + e.getMessage() + "</h2>");
    } finally {
        if (messageStmt != null) messageStmt.close();
        if (connection != null) connection.close();
    }
%>

