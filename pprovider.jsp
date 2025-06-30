<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    String serviceType = null;
    String address = request.getParameter("address"); // Get the 'address' parameter from the search form
    Connection connection = null;
    Statement statement = null;
    PreparedStatement ratingStmt = null;
    ResultSet resultSet = null, ratingResult = null;

    try {
        // Fetching serviceType from the request
        serviceType = request.getParameter("service");
        if (serviceType == null) serviceType = "tutor"; // Default service type for babysitter

        // Database connection details
        String driver = "com.mysql.jdbc.Driver";
        String connectionUrl = "jdbc:mysql://localhost:3306/";
        String database = "service_provider";
        String userid = "Neha";
        String password = "neha1469";

        // Establishing connection
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        // Query to fetch service providers based on address (location) if available
        statement = connection.createStatement();
        String sql = "SELECT * FROM providers WHERE service_type='" + serviceType + "'";
        
        // Update query to filter by 'address' column
        if (address != null && !address.trim().isEmpty()) {
            sql += " AND address LIKE '%" + address + "%'";  // Filter by the 'address' column in the database
        }

        resultSet = statement.executeQuery(sql);
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<html>
<head>
    <title>Service Providers for <%= serviceType %></title>
    <style>
        /* CSS styles are the same as provided earlier */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            background: url('<%= serviceType.equals("tutor") ? "3.jpg" : "service_background.jpg" %>') no-repeat center center fixed;
            background-size: cover;
        }

        .banner {
            background: rgba(0, 0, 0, 0.5);
            padding: 40px 20px;
            text-align: center;
            color: white;
            font-size: 32px;
            font-weight: bold;
            text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
        }

        h2 {
            text-align: center;
            color: white;
            margin: 30px 0;
        }

        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }

        .provider-card {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            width: 80%;
            max-width: 600px;
            padding: 20px;
            margin: 10px 0;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }

        .provider-card:hover {
            transform: scale(1.05);
        }

        .provider-card strong {
            display: block;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .provider-card form {
            margin-top: 10px;
        }

        .provider-card input[type="submit"] {
            background-color: #0056b3;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .provider-card input[type="submit"]:hover {
            background-color: #004494;
        }
    </style>
</head>
<body>
    <!-- Banner Section -->
    <div class="banner">
        Welcome to <%= serviceType.substring(0, 1).toUpperCase() + serviceType.substring(1) %> Services
    </div>

    <h2>Available Providers for <%= serviceType.substring(0, 1).toUpperCase() + serviceType.substring(1) %></h2>

    <div class="container">
        <%
            try {
                int providerCount = 0;
                while (resultSet != null && resultSet.next()) {
                    providerCount++;
                    String providerId = resultSet.getString("provider_id");
                    String name = resultSet.getString("name");
                    String phone = resultSet.getString("phone");
                    String providerAddress = resultSet.getString("address");

                    // Query to fetch the average rating for the provider
                    String ratingQuery = "SELECT AVG(rating) AS avg_rating FROM reviews WHERE provider_id = ?";
                    ratingStmt = connection.prepareStatement(ratingQuery);
                    ratingStmt.setString(1, providerId);
                    ratingResult = ratingStmt.executeQuery();

                    double avgRating = 0.0;
                    if (ratingResult.next()) {
                        avgRating = ratingResult.getDouble("avg_rating");
                    }
        %>
                    <div class="provider-card">
                        <strong>Name:</strong> <%= name %>
                        <strong>Phone:</strong> <%= phone %>
                        <strong>Address:</strong> <%= providerAddress %>
                        <strong>Rating:</strong> <%= (avgRating > 0 ? String.format("%.1f", avgRating) + " / 5" : "No ratings yet") %>
                        <form action="bookService.jsp" method="POST">
                            <input type="hidden" name="provider_id" value="<%= providerId %>">
                            <input type="hidden" name="service_type" value="<%= serviceType %>">
                            <input type="submit" value="Book Service">
                        </form>
                    </div>
        <%
                }
                if (providerCount == 0) {
        %>
                    <div class="provider-card">No providers available for this service type or address.</div>
        <%
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>
    </div>
</body>
</html>

<%
    try {
        if (ratingResult != null) ratingResult.close();
        if (resultSet != null) resultSet.close();
        if (ratingStmt != null) ratingStmt.close();
        if (statement != null) statement.close();
        if (connection != null) connection.close();
    } catch (Exception ex) {
        out.println("Error closing resources: " + ex.getMessage());
    }
%>

