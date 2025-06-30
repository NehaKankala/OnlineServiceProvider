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
    Integer orderId = Integer.parseInt(request.getParameter("order_id"));
    Integer providerId = Integer.parseInt(request.getParameter("provider_id"));
    Integer userId = Integer.parseInt(request.getParameter("user_id"));
    String messageText = request.getParameter("message_text");

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

        // SQL query to insert the message into provider_messages
        String insertMessageQuery = "INSERT INTO provider_messages (order_id, provider_id, user_id, message_text) " +
                                    "VALUES (?, ?, ?, ?)";
        messageStmt = connection.prepareStatement(insertMessageQuery);
        messageStmt.setInt(1, orderId);
        messageStmt.setInt(2, providerId); // Sender is the provider
        messageStmt.setInt(3, userId); // Receiver is the user
        messageStmt.setString(4, messageText);

        // Execute the insert statement
        messageStmt.executeUpdate();

        // Redirect to the chat page
        response.sendRedirect("chatp.jsp?order_id=" + orderId + "&provider_id=" + providerId + "&user_id=" + userId);

    } catch (SQLException e) {
        out.println("<h2>Database Error: " + e.getMessage() + "</h2>");
    } catch (Exception e) {
        out.println("<h2>General Error: " + e.getMessage() + "</h2>");
    } finally {
        if (messageStmt != null) messageStmt.close();
        if (connection != null) connection.close();
    }
%>

