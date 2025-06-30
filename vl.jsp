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
    String role = request.getParameter("role"); // User-selected role
    String email = request.getParameter("uname");
    String pwd = request.getParameter("pwd");

    if (email == null || pwd == null || role == null) {
        out.println("<h2>Error: Missing email, password, or role!</h2>");
        return;
    }

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    try {
        // Connect to the database
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        boolean isValid = false;

        if ("admin".equalsIgnoreCase(role)) {
            // Check admin credentials in the users table
            String query = "SELECT name, user_id FROM users WHERE email = ? AND password = ? AND name = 'admin'";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, pwd);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                isValid = true;
                session.setAttribute("user_name", resultSet.getString("name"));
                session.setAttribute("user_id", resultSet.getInt("user_id"));
                response.sendRedirect("admin.jsp");
            }
        } else if ("provider".equalsIgnoreCase(role)) {
            // Check provider credentials in the providers table
            String query = "SELECT name, provider_id FROM providers WHERE email = ? AND password = ?";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, pwd);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                isValid = true;
                session.setAttribute("provider_name", resultSet.getString("name"));
                session.setAttribute("provider_id", resultSet.getInt("provider_id"));
                response.sendRedirect("provider.jsp");
            }
        } else if ("user".equalsIgnoreCase(role)) {
            // Check user credentials in the users table
            String query = "SELECT name, user_id FROM users WHERE email = ? AND password = ? AND name != 'admin'";
            preparedStatement = connection.prepareStatement(query);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, pwd);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                isValid = true;
                session.setAttribute("user_name", resultSet.getString("name"));
                session.setAttribute("user_id", resultSet.getInt("user_id"));
                response.sendRedirect("services.jsp");
            }
        }

        if (!isValid) {
            // Invalid login
            out.println("<h2>Invalid credentials or role mismatch. Please try again.</h2>");
        }
    } catch (Exception e) {
        out.println("<h2>Error:</h2> " + e.getMessage());
    } finally {
        if (resultSet != null) resultSet.close();
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    }
%>

