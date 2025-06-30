<%@ page import="java.sql.*" %>
<%
    String driver = "com.mysql.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha";
    String password = "neha1469";

    String orderId = request.getParameter("order_id");
    String providerId = request.getParameter("provider_id");
    String reviewText = request.getParameter("review_text");
    String ratingStr = request.getParameter("rating");
    Integer userId = (Integer) session.getAttribute("user_id");

    if (orderId == null || providerId == null || reviewText == null || ratingStr == null || userId == null) {
        out.println("<h2>Error: Missing parameters!</h2>");
        return;
    }

    int rating = Integer.parseInt(ratingStr);

    Connection connection = null;
    PreparedStatement preparedStatement = null;

    try {
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        String query = "INSERT INTO reviews (order_id, user_id, provider_id, rating, review_text) VALUES (?, ?, ?, ?, ?)";
        preparedStatement = connection.prepareStatement(query);
        preparedStatement.setInt(1, Integer.parseInt(orderId));
        preparedStatement.setInt(2, userId);
        preparedStatement.setInt(3, Integer.parseInt(providerId));
        preparedStatement.setInt(4, rating);
        preparedStatement.setString(5, reviewText);

        int rows = preparedStatement.executeUpdate();
        if (rows > 0) {
            out.println("<h2>Review submitted successfully!</h2>");
            response.sendRedirect("orders.jsp");
        } else {
            out.println("<h2>Error: Unable to submit review!</h2>");
        }
    } catch (Exception e) {
        out.println("<h2>Error:</h2> " + e.getMessage());
    } finally {
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    }
%>

