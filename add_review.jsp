<%@ page import="java.sql.*" %>
<%
    String orderId = request.getParameter("order_id");
    String providerId = request.getParameter("provider_id");
    Integer userId = (Integer) session.getAttribute("user_id");

    if (orderId == null || providerId == null || userId == null) {
        out.println("<h2>Error: Missing parameters or not logged in!</h2>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Leave a Review</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f9;
            text-align: center;
            padding: 20px;
        }
        .review-container {
            max-width: 600px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
        .review-container h1 {
            font-size: 24px;
            margin-bottom: 20px;
        }
        .review-container textarea {
            width: 100%;
            height: 100px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .review-container select, 
        .review-container button {
            padding: 10px;
            border: none;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 16px;
        }
        .review-container button {
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="review-container">
        <h1>Leave a Review</h1>
        <form action="submit_review.jsp" method="POST">
            <input type="hidden" name="order_id" value="<%= orderId %>">
            <input type="hidden" name="provider_id" value="<%= providerId %>">
            <textarea name="review_text" placeholder="Write your review..." required></textarea>
            <select name="rating" required>
                <option value="">Rate the service</option>
                <option value="1">1 - Poor</option>
                <option value="2">2 - Fair</option>
                <option value="3">3 - Good</option>
                <option value="4">4 - Very Good</option>
                <option value="5">5 - Excellent</option>
            </select>
            <button type="submit">Submit Review</button>
        </form>
    </div>
</body>
</html>

