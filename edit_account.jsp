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
    PreparedStatement stmt = null;
    ResultSet resultSet = null;

    String name = "", email = "", phone = "";

    try {
        // Connect to the database
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        // Query to fetch the provider's account details
        String query = "SELECT name, email, phone FROM providers WHERE provider_id = ?";
        stmt = connection.prepareStatement(query);
        stmt.setInt(1, providerId);
        resultSet = stmt.executeQuery();

        if (resultSet.next()) {
            name = resultSet.getString("name");
            email = resultSet.getString("email");
            phone = resultSet.getString("phone");
        }
    } catch (Exception e) {
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        if (resultSet != null) resultSet.close();
        if (stmt != null) stmt.close();
        if (connection != null) connection.close();
    }
%>

<html>
<head>
    <title>Edit Account Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 60%;
            margin: 20px auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
        }

        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .form-group input[type="submit"] {
            background-color: #28a745;
            color: white;
            border: none;
            cursor: pointer;
        }

        .form-group input[type="submit"]:hover {
            background-color: #218838;
        }
        .send-button {
    display: block; /* Makes the button a block element */
    margin: 0 auto; /* Centers the button horizontally */
    padding: 10px 20px;
    background-color: #3498db;
    color: white;
    font-size: 18px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    text-align: center;
}

    </style>
</head>
<body>
    <div class="container">
        <h1>Edit Your Account Details</h1>
        <form action="update_account.jsp" method="POST">
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" value="<%= name %>" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="<%= email %>" required>
            </div>
            <div class="form-group">
                <label for="phone">Phone Number:</label>
                <input type="text" id="phone" name="phone" value="<%= phone %>" required>
            </div>
            <div class="form-group">
                <input type="submit" value="Update Details">
            </div>
        </form>
    </div>
    <button onclick="history.back()" class="send-button">Back</button>

</body>
</html>

