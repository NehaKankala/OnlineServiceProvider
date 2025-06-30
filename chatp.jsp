<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<html>
<head>
    <title>Provider Chat</title>
    <style>
        /* Global Styles */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
            color: #333;
        }
        .container {
            width: 90%;
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #444;
        }

        /* Chat Box */
        .chat-box {
            height: 400px;
            overflow-y: scroll;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #fafafa;
            margin-bottom: 20px;
        }
        .message {
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 10px;
            max-width: 75%;
            font-size: 0.9rem;
            word-wrap: break-word;
        }
        .message.provider{
            background-color: #d1e7dd;
            align-self: flex-end;
            margin-left: auto;
        }
        .message.user {
            background-color: #f8d7da;
            align-self: flex-start;
        }

        /* Form Styles */
        form {
            display: flex;
            gap: 10px;
        }
        .message-text {
            flex-grow: 1;
            padding: 10px;
            font-size: 0.9rem;
            border: 1px solid #ddd;
            border-radius: 5px;
            outline: none;
        }
        .send-button, .back-button {
            padding: 10px 20px;
            font-size: 0.9rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            background-color: #007bff;
            color: #fff;
            transition: background-color 0.3s;
        }
        .send-button:hover, .back-button:hover {
            background-color: #0056b3;
        }
        .back-button {
            background-color: #6c757d;
        }
        .back-button:hover {
            background-color: #495057;
        }

        /* Scrollbar Styles */
        .chat-box::-webkit-scrollbar {
            width: 8px;
        }
        .chat-box::-webkit-scrollbar-thumb {
            background-color: #ccc;
            border-radius: 4px;
        }
        .chat-box::-webkit-scrollbar-track {
            background-color: #f4f4f4;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Chat with Your Customer</h2>
    <div class="chat-box">
        <%
            String orderIdStr = request.getParameter("order_id");
            String providerIdStr = request.getParameter("provider_id");

            // Validate that we have order_id and provider_id
            if (orderIdStr == null || providerIdStr == null) {
                out.println("<h2>Error: Missing parameters</h2>");
                return;
            }

            int orderId = Integer.parseInt(orderIdStr);
            int providerId = Integer.parseInt(providerIdStr);

            // Establish database connection
            Connection connection = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/service_provider", "Neha", "neha1469");

                // Query to fetch both user and provider messages for this order_id, ordered by timestamp
                String query = "SELECT message_text, user_id, provider_id, 'user' AS sender, timestamp " +
                               "FROM user_messages WHERE order_id = ? " +
                               "UNION ALL " +
                               "SELECT message_text, user_id, provider_id, 'provider' AS sender, timestamp " +
                               "FROM provider_messages WHERE order_id = ? " +
                               "ORDER BY timestamp ASC";

                stmt = connection.prepareStatement(query);
                stmt.setInt(1, orderId);
                stmt.setInt(2, orderId);
                rs = stmt.executeQuery();

                // Displaying messages in the chat box
                while (rs.next()) {
                    String messageText = rs.getString("message_text");
                    String sender = rs.getString("sender");
                    %>
            <div class="message <%= sender %>">
                <%= messageText %>
            </div>
        <%
                }
            } catch (Exception e) {
                out.println("<h2>Error: " + e.getMessage() + "</h2>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (stmt != null) try { stmt.close(); } catch (Exception e) {}
                if (connection != null) try { connection.close(); } catch (Exception e) {}
            }
        %>
    </div>
    <form action="send_msgp.jsp" method="POST">
        <textarea class="message-text" name="message_text" rows="3" placeholder="Type your message..."></textarea>
        <input type="hidden" name="order_id" value="<%= orderId %>">
        <input type="hidden" name="provider_id" value="<%= providerId %>">
        <input type="hidden" name="user_id" value="<%= request.getParameter("user_id") %>">
        <button type="submit" class="send-button">Send</button>
    </form>
    <button onclick="history.back()" class="send-button">Back</button>
</div>
</body>
</html>

