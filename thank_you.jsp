<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thank You</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            text-align: center;
            margin: 0;
            padding: 0;
        }
        .container {
            margin: 100px auto;
            padding: 20px;
            width: 50%;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #4CAF50;
        }
        p {
            font-size: 18px;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        a:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Thank You for Your Payment!</h1>
        <p>Your payment was successful.</p>
        <p><strong>Order ID:</strong> <%= request.getParameter("order_id") %></p>
        <p><strong>Amount Paid:</strong> rs:<%= request.getParameter("amount") %></p>
        <p><strong>Payment Method:</strong> <%= request.getParameter("payment_method") %></p>
        <a href="orders.jsp">Go to My Orders</a>
    </div>
</body>
</html>
