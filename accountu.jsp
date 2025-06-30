<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
    // Database connection details
    String driver = "com.mysql.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha";
    String password = "neha1469";

    // Check if the session contains the user_id
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        // Session is not set; redirect to login page
        response.sendRedirect("index.html");
        return;
    }

    Connection connection = null;
    PreparedStatement fetchStmt = null;
    ResultSet resultSet = null;

    // Variables to hold user details
    String userName = "";
    String userEmail = "";
    String userPhone = "";
    String userAddress = "";

    try {
        // Connect to the database
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        // Query to fetch user details
        String fetchQuery = "SELECT name, email, phone, address FROM users WHERE user_id = ?";
        fetchStmt = connection.prepareStatement(fetchQuery);
        fetchStmt.setInt(1, userId);
        resultSet = fetchStmt.executeQuery();

        if (resultSet.next()) {
            userName = resultSet.getString("name");
            userEmail = resultSet.getString("email");
            userPhone = resultSet.getString("phone");
            userAddress = resultSet.getString("address");
        }
    } catch (Exception e) {
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        if (resultSet != null) resultSet.close();
        if (fetchStmt != null) fetchStmt.close();
        if (connection != null) connection.close();
    }

    // Check for success parameter in query string
    String successMessage = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Account</title>
    <style>
  body {
    font-family: 'Roboto', sans-serif;
    margin: 0;
    padding: 0;
    background-image: url('bc.jpg'); /* Path to your background image */
    background-size: cover; /* Makes the image cover the entire viewport */
    background-repeat: no-repeat; /* Prevents tiling */
    background-position: center; /* Centers the image */
    background-attachment: fixed; /* Keeps the image fixed while scrolling */
    color: #fff; /* Adjust text color for visibility */
}

header {
    background: rgba(0, 0, 51, 0.85); /* Semi-transparent dark blue */
    padding: 20px;
    text-align: center;
    border-bottom: 2px solid rgba(255, 255, 255, 0.3); /* Subtle white border */
    color: #ffffff; /* White text for strong contrast */
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.5); /* Adds depth to the header */
}

header h1 {
    margin: 0;
    font-size: 28px;
    text-transform: uppercase;
    font-weight: 600;
    color: #00bfff; /* Bright cyan to complement the dark blue */
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7); /* Adds a subtle glow effect */
}


        .container {
            width: 90%;
            max-width: 600px;
            margin: 30px auto;
            background: #ffffff15;
            padding: 20px 25px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .success-message {
            background: #28a745;
            padding: 10px;
            text-align: center;
            border-radius: 4px;
            margin-bottom: 15px;
            color: #fff;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            font-size: 16px;
            font-weight: 500;
            margin: 10px 0 5px;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 15px;
            border: none;
            border-radius: 4px;
            background: #f4f4f9;
        }

        button {
            padding: 12px 20px;
            margin-top: 10px;
            border: none;
            border-radius: 5px;
            background: #007bff;
            color: #fff;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background: #0056b3;
        }

        .send-button {
            background: #17a2b8;
        }

        .send-button:hover {
            background: #117a8b;
        }

        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }

            header h1 {
                font-size: 22px;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1>Manage Your Account</h1>
    </header>
    <div class="container">
        <% if ("1".equals(successMessage)) { %>
            <p class="success-message">Account updated successfully!</p>
        <% } else if ("deleted".equals(successMessage)) { %>
            <p class="success-message">Account deleted successfully!</p>
        <% } %>
        <form action="update_accountu.jsp" method="POST">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" value="<%= userName %>" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= userEmail %>" required>
		
		<label for="password">Password (Leave blank if not changing):</label>
            <input type="password" id="password" name="password">
            
            <label for="phone">Phone:</label>
            <input type="text" id="phone" name="phone" value="<%= userPhone %>" required>

            <label for="address">Address:</label>
            <input type="text" id="address" name="address" value="<%= userAddress %>" required>

            <div><button type="submit">Update Account</button></div>
        </form>
        <br>
        <div><button onclick="history.back()" class="send-button">Back</button></div>
    </div>
</body>
</html>

