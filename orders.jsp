<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    // Database connection details
    String driver = "com.mysql.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha";
    String password = "neha1469";

    // Get the user ID from the session
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        // If no user is logged in, redirect to the login page
        response.sendRedirect("index.html");
        return;
    }

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    try {
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        // Query to fetch orders for the logged-in user, including payment status
        String query = "SELECT o.order_id, o.service_id, o.address, o.phone, o.service_date, o.status, o.payment_status, " +
                       "       s.service_name, p.name AS provider_name, p.provider_id " +
                       "FROM orders o " +
                       "JOIN services s ON o.service_id = s.service_id " +
                       "JOIN providers p ON o.provider_id = p.provider_id " +
                       "WHERE o.user_id = ?";

        preparedStatement = connection.prepareStatement(query);
        preparedStatement.setInt(1, userId);
        resultSet = preparedStatement.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: url('8.jpg') no-repeat center center fixed;
            background-size: cover;
            color: #333;
            position: relative;
        }
        body::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5); /* Dark overlay for readability */
            z-index: -1;
        }
        h1 {
            text-align: center;
            color: #fff;
            margin: 20px 0;
            font-size: 36px;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.7);
        }
        .orders-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
            padding: 20px;
        }
        .order-card {
            width: 30%;
            background-color: rgba(255, 255, 255, 0.9); /* Slightly transparent background */
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            border-radius: 10px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .order-card:hover {
            transform: translateY(-5px); /* Lift effect */
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3);
        }
        .order-header {
            font-weight: bold;
            font-size: 20px;
            color: #4CAF50;
        }
        .order-details {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .order-details span {
            font-size: 16px;
            color: #333;
        }
        .status {
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: bold;
        }
        .status.pending {
            background-color: #ffeb3b;
            color: #333;
        }
        .status.completed {
            background-color: #4CAF50;
            color: white;
        }
        .status.cancelled {
            background-color: #f44336;
            color: white;
        }
        .payment-status {
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: bold;
        }
        .payment-status.pending {
            background-color: #ff9800;
            color: #333;
        }
        .payment-status.completed {
            background-color: #4CAF50;
            color: white;
        }
        .payment-status.failed {
            background-color: #f44336;
            color: white;
        }
        .button-container {
            display: flex;
            justify-content: center; /* Align buttons horizontally */
            gap: 15px; /* Add spacing between buttons */
            margin-top: 10px; /* Space above the button row */
        }
        .button-container a {
            background-color: #0056b3;
            color: white;
            font-size: 16px; /* Slightly smaller font size for better fit */
            padding: 10px 15px; /* Adjusted padding for better proportions */
            border-radius: 5px;
            text-decoration: none;
            transition: background-color 0.3s, transform 0.2s;
            display: inline-block;
            text-align: center;
        }
        .button-container a:hover {
            background-color: #004494;
            transform: scale(1.05); /* Slight scale effect on hover */
        }
    </style>
</head>
<body>
    <h1>My Orders</h1>
    <div class="orders-container">
<%
        // Iterate through the result set and display each order
        while (resultSet.next()) {
            String statusClass = "pending";
            if (resultSet.getString("status").equalsIgnoreCase("completed")) {
                statusClass = "completed";
            } else if (resultSet.getString("status").equalsIgnoreCase("cancelled")) {
                statusClass = "cancelled";
            }
            
            // Handle payment status classes
            String paymentStatusClass = "pending";
            if (resultSet.getString("payment_status").equalsIgnoreCase("completed")) {
                paymentStatusClass = "completed";
            } else if (resultSet.getString("payment_status").equalsIgnoreCase("failed")) {
                paymentStatusClass = "failed";
            }
%>
        <div class="order-card">
            <div class="order-header">Order</div>
            <div class="order-details">
                <span><strong>Service Name:</strong> <%= resultSet.getString("service_name") %></span>
                <span><strong>Provider Name:</strong> <%= resultSet.getString("provider_name") %></span>
                <span><strong>Address:</strong> <%= resultSet.getString("address") %></span>
                <span><strong>Phone:</strong> <%= resultSet.getString("phone") %></span>
                <span><strong>Service Date:</strong> <%= resultSet.getDate("service_date") %></span>
                <span><strong>Status:</strong> <span class="status <%= statusClass %>"><%= resultSet.getString("status") %></span></span>
                <span><strong>Payment Status:</strong> <span class="payment-status <%= paymentStatusClass %>"><%= resultSet.getString("payment_status") %></span></span>
            </div>
            <div class="button-container">
                <a href="payment.jsp?order_id=<%= resultSet.getInt("order_id") %>">Pay</a>
                <a href="chat.jsp?order_id=<%= resultSet.getInt("order_id") %>&provider_id=<%= resultSet.getInt("provider_id") %>&user_id=<%= session.getAttribute("user_id") %>">Chat</a>
                <% if (resultSet.getString("status").equalsIgnoreCase("completed")) { %>
                    <a href="add_review.jsp?order_id=<%= resultSet.getInt("order_id") %>&provider_id=<%= resultSet.getInt("provider_id") %>">Leave a Review</a>
                <% } %>
            </div>
        </div>
<%
        }
%>
    </div>
    <div class="button-container">
        <a href="services.html">Back to Services</a>
    </div>
</body>
</html>
<%
    } catch (Exception e) {
        out.println("<h2>Error:</h2> " + e.getMessage());
    } finally {
        if (resultSet != null) resultSet.close();
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    }
%>

