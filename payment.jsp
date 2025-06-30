<%@ page import="java.sql.*" %>
<%
    String driver = "com.mysql.jdbc.Driver";
    String connectionUrl = "jdbc:mysql://localhost:3306/";
    String database = "service_provider";
    String userid = "Neha";
    String password = "neha1469";

    // Get the order ID from the query string
    String orderIdParam = request.getParameter("order_id");
    if (orderIdParam == null || orderIdParam.isEmpty()) {
        out.println("<h2>Invalid Request: Order ID is missing!</h2>");
        return;
    }

    int orderId;
    try {
        orderId = Integer.parseInt(orderIdParam);
    } catch (NumberFormatException e) {
        out.println("<h2>Invalid Order ID Format</h2>");
        return;
    }

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    try {
        Class.forName(driver);
        connection = DriverManager.getConnection(connectionUrl + database, userid, password);

        String query = "SELECT o.order_id, o.service_id, o.payment_status, " +
                       "       s.service_name, s.price AS amount " +
                       "FROM orders o " +
                       "JOIN services s ON o.service_id = s.service_id " +
                       "WHERE o.order_id = ?";
        preparedStatement = connection.prepareStatement(query);
        preparedStatement.setInt(1, orderId);
        resultSet = preparedStatement.executeQuery();

        if (!resultSet.next()) {
            out.println("<h2>No Order Found for ID: " + orderId + "</h2>");
            return;
        }

        String serviceName = resultSet.getString("service_name");
        double amount = resultSet.getDouble("amount");
        String paymentStatus = resultSet.getString("payment_status");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Payment for Order</title>
    <style>
        /* Base styles for the page */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #eef2f7;
            margin: 0;
            padding: 0;
        }

        /* Center the main container */
        .container {
            margin: 5% auto;
            width: 90%;
         
            padding: 20px;
            background: linear-gradient(to bottom right, #ffffff, #f7f9fc);
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        /* Section heading */
        h1 {
            font-size: 1.8rem;
            color: #334e68;
            margin-bottom: 20px;
        }

        /* Service and payment info */
        p {
            font-size: 1.1rem;
            color: #2a2a2a;
            line-height: 1.6;
        }

        /* Highlighted text */
        p strong {
            color: #1d3557;
        }

        /* Form */
        form {
            margin-top: 20px;
        }

        label {
            display: block;
            font-size: 1rem;
            color: #495057;
            margin: 10px 0 5px;
            text-align: left;
        }

        input[type="text"],
        select {
            width: 100%;
            padding: 10px;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 15px;
            box-sizing: border-box;
        }

        input[type="text"]:focus,
        select:focus {
            outline: none;
            border-color: #80bdff;
            box-shadow: 0 0 8px rgba(128, 189, 255, 0.5);
        }

        button[type="submit"],
        button[type="button"] {
            display: inline-block;
            padding: 10px 20px;
            font-size: 1rem;
            color: #fff;
            background-color: #1d3557;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.3s ease;
        }

        button[type="submit"]:hover,
        button[type="button"]:hover {
            background-color: #457b9d;
        }

        /* Hidden sections for payment details */
        .payment-details {
            display: none;
        }

        /* Styling for the generated barcode */
        #barcode-container {
            text-align: center;
            margin-top: 20px;
        }

        #barcode {
            margin-top: 10px;
        }

        /* Responsive styling */
        @media (max-width: 768px) {
            .container {
                width: 90%;
                padding: 15px;
            }
            h1 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Payment for Order</h1>
        <p><strong>Service:</strong> <%= serviceName %></p>
        <p><strong>Amount:</strong> <%= amount %></p>
        <p><strong>Payment Status:</strong> <%= paymentStatus %></p>

        <% if (!"Paid".equalsIgnoreCase(paymentStatus)) { %>
        <form id="payment-form" action="process_payment.jsp" method="post">
            <input type="hidden" name="order_id" value="<%= orderId %>">
            <input type="hidden" name="amount" value="<%= amount %>">

            <label for="payment-method">Choose Payment Method:</label>
            <select id="payment-method" name="payment_method" required>
                <option value="">Select a method</option>
                <option value="credit-card">Credit Card</option>
                <option value="debit-card">Debit Card</option>
                <option value="barcode">Barcode (QR Code)</option>
                <option value="upi">UPI</option>
            </select>

            <div id="card-details" class="payment-details" style="display: none;">
                <label for="card-number">Card Number:</label>
                <input type="text" id="card-number" name="card-number" placeholder="Enter card number">

                <label for="expiry-date">Expiry Date (MM/YY):</label>
                <input type="text" id="expiry-date" name="expiry-date" placeholder="MM/YY">

                <label for="cvv">CVV:</label>
                <input type="text" id="cvv" name="cvv" placeholder="CVV">
            </div>

            <div id="upi-details" class="payment-details" style="display: none;">
                <label for="upi-id">UPI ID:</label>
                <input type="text" id="upi-id" name="upi-id" placeholder="Enter UPI ID">
            </div>

            <div id="barcode-container" class="payment-details" style="display: none;">
                <button type="button" onclick="generateBarcode()">Generate Barcode</button>
                <svg id="barcode"></svg>
            </div>

            <button type="submit">Submit Payment</button>
        </form>
        <% } else { %>
        <p><strong>Payment already completed!</strong></p>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>
<script>
    document.getElementById("payment-method").addEventListener("change", function () {
        const paymentMethod = this.value;
        document.getElementById("card-details").style.display = "none";
        document.getElementById("upi-details").style.display = "none";
        document.getElementById("barcode-container").style.display = "none";

        if (paymentMethod === "credit-card" || paymentMethod === "debit-card") {
            document.getElementById("card-details").style.display = "block";
        } else if (paymentMethod === "upi") {
            document.getElementById("upi-details").style.display = "block";
        } else if (paymentMethod === "barcode") {
            document.getElementById("barcode-container").style.display = "block";
        }
    });

    function generateBarcode() {
        const targetUrl = "https://www.google.com"; // The URL for barcode generation
        JsBarcode("#barcode", targetUrl, {
            format: "CODE128", // Barcode format changed to CODE128
            lineColor: "#000",
            width: 3,
            height: 40,
            displayValue: false,
        });

        // Add an instruction for users to scan the barcode
        const barcodeContainer = document.getElementById("barcode-container");
        if (!document.getElementById("barcode-instruction")) {
            const instruction = document.createElement("p");
            instruction.id = "barcode-instruction";
            instruction.textContent = "Scan the barcode to proceed to Google.";
            instruction.style.color = "#1d3557";
            instruction.style.fontSize = "1.1rem";
            barcodeContainer.appendChild(instruction);
        }
    }
</script>

</body>
</html>
<%
    } catch (Exception e) {
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        if (resultSet != null) resultSet.close();
        if (preparedStatement != null) preparedStatement.close();
        if (connection != null) connection.close();
    }
%>
