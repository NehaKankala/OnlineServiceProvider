<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    // Database connection details
    String driver = "com.mysql.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha";
    String password = "neha1469";

    // Fetch the logged-in provider's ID from the session
    Integer providerId = (Integer) session.getAttribute("provider_id");
    if (providerId == null) {
        response.sendRedirect("serlog.html"); // Redirect to login page if not logged in
        return;
    }

    Connection connection = null;
    PreparedStatement orderStmt = null, countStmt = null, reviewStmt = null;
    ResultSet orderResult = null, countResult = null, reviewResult = null;

    // Variables to hold counts
    int pendingCount = 0, acceptedCount = 0, completedCount = 0, rejectedCount = 0;

    try {
        // Connect to the database
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        // Query to fetch orders for the provider
        String orderQuery = "SELECT o.order_id, o.user_id, o.service_date, o.status, u.name AS customer_name, u.phone AS customer_phone, u.email AS customer_email " +
                            "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                            "WHERE o.provider_id = ? ORDER BY o.service_date ASC";
        orderStmt = connection.prepareStatement(orderQuery);
        orderStmt.setInt(1, providerId);
        orderResult = orderStmt.executeQuery();

        // Query to get counts of orders by status
        String countQuery = "SELECT status, COUNT(*) AS count FROM orders WHERE provider_id = ? GROUP BY status";
        countStmt = connection.prepareStatement(countQuery);
        countStmt.setInt(1, providerId);
        countResult = countStmt.executeQuery();

        // Process counts
        while (countResult.next()) {
            String status = countResult.getString("status");
            int count = countResult.getInt("count");
            switch (status) {
                case "Pending": pendingCount = count; break;
                case "Accepted": acceptedCount = count; break;
                case "Completed": completedCount = count; break;
                case "Rejected": rejectedCount = count; break;
            }
        }

        // Query to fetch reviews for the provider
        String reviewQuery = "SELECT r.rating, r.review_text, u.name AS user_name, r.timestamp " +
                             "FROM reviews r JOIN users u ON r.user_id = u.user_id " +
                             "WHERE r.provider_id = ? ORDER BY r.timestamp DESC";
        reviewStmt = connection.prepareStatement(reviewQuery);
        reviewStmt.setInt(1, providerId);
        reviewResult = reviewStmt.executeQuery();
    } catch (Exception e) {
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    }
%>

<html>
<head>
    <title>Provider Dashboard</title>
    <style>
        /* Styles for the dashboard */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }

        .container {
            width: 90%;
            margin: 20px auto;
        }

        h1, h2 {
            text-align: center;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #0056b3;
            color: white;
        }

        .action-buttons form {
            display: inline-block;
        }

        .accept-button, .reject-button, .completed-button {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }

        .reject-button {
            background-color: #dc3545;
        }

        .completed-button {
            background-color: #17a2b8;
        }

        .accept-button:hover {
            background-color: #218838;
        }

        .reject-button:hover {
            background-color: #c82333;
        }

        .completed-button:hover {
            background-color: #138496;
        }

        .summary {
            margin-top: 30px;
            font-size: 18px;
        }

        .logout-button, .edit-button, .delete-button {
            background-color: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
        }

        .logout-button:hover, .edit-button:hover, .delete-button:hover {
            background-color: #0056b3;
        }

        .reviews-section {
            margin-top: 30px;
            padding: 20px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 10px;
        }

        .review {
            padding: 15px;
            margin-bottom: 10px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .review strong {
            font-size: 14px;
            color: #0056b3;
        }

        .review p {
            margin: 5px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Your Dashboard</h1>
        <div>
            <a href="logout.jsp" class="logout-button">Logout</a>
            <a href="edit_account.jsp" class="edit-button">Edit Account</a>
           
        </div>
        
        <h2>Your Orders</h2>
        <table>
            <tr>
                <th>Order ID</th>
                <th>Customer Name</th>
                <th>Contact</th>
                <th>Service Date</th>
                <th>Status</th>
                <th>Actions</th>
                <th>Chat</th>
            </tr>
            <%
                try {
                    while (orderResult != null && orderResult.next()) {
                        int orderId = orderResult.getInt("order_id");
                        String customerName = orderResult.getString("customer_name");
                        String customerPhone = orderResult.getString("customer_phone");
                        String customerEmail = orderResult.getString("customer_email");
                        String serviceDate = orderResult.getString("service_date");
                        String status = orderResult.getString("status");
            %>
            <tr>
                <td><%= orderId %></td>
                <td><%= customerName %></td>
                <td>
                    Phone: <%= customerPhone %><br>
                    Email: <%= customerEmail %>
                </td>
                <td><%= serviceDate %></td>
                <td><%= status %></td>
                <td class="action-buttons">
                    <form action="update_status.jsp" method="POST">
                        <input type="hidden" name="order_id" value="<%= orderId %>">
                        <input type="hidden" name="status" value="Accepted">
                        <input type="submit" value="Accept" class="accept-button">
                    </form>
                    <form action="update_status.jsp" method="POST">
                        <input type="hidden" name="order_id" value="<%= orderId %>">
                        <input type="hidden" name="status" value="Rejected">
                        <input type="submit" value="Reject" class="reject-button">
                    </form>
                    <form action="update_status.jsp" method="POST">
                        <input type="hidden" name="order_id" value="<%= orderId %>">
                        <input type="hidden" name="status" value="Completed">
                        <input type="submit" value="Completed" class="completed-button">
                    </form>
                </td>
                <td>
                    <a href="chatp.jsp?order_id=<%= orderId %>&provider_id=<%= providerId %>&user_id=<%= orderResult.getInt("user_id") %>" class="logout-button">Chat</a>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<h2>Error: " + e.getMessage() + "</h2>");
                }
            %>
        </table>

        <div class="summary">
            <p>Pending Orders: <%= pendingCount %></p>
            <p>Accepted Orders: <%= acceptedCount %></p>
            <p>Completed Orders: <%= completedCount %></p>
            <p>Rejected Orders: <%= rejectedCount %></p>
        </div>

        <div class="reviews-section">
            <h2>Reviews</h2>
            <%
                try {
                    while (reviewResult != null && reviewResult.next()) {
                        String userName = reviewResult.getString("user_name");
                        int rating = reviewResult.getInt("rating");
                        String reviewText = reviewResult.getString("review_text");
                        Timestamp timestamp = reviewResult.getTimestamp("timestamp");
            %>
            <div class="review">
                <p><strong>User:</strong> <%= userName %></p>
                <p><strong>Rating:</strong> <%= rating %> / 5</p>
                <p><strong>Review:</strong> <%= reviewText %></p>
                <p><strong>Date:</strong> <%= timestamp %></p>
            </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("<h2>Error: " + e.getMessage() + "</h2>");
                }
            %>
        </div>
    </div>
</body>
</html>

<%
    try {
        if (reviewResult != null) reviewResult.close();
        if (orderResult != null) orderResult.close();
        if (countResult != null) countResult.close();
        if (orderStmt != null) orderStmt.close();
        if (countStmt != null) countStmt.close();
        if (reviewStmt != null) reviewStmt.close();
        if (connection != null) connection.close();
    } catch (Exception ex) {
        out.println("<h2>Error closing resources: " + ex.getMessage() + "</h2>");
    }
%>

