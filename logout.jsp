<%
    session.invalidate(); // Clear the session
    response.sendRedirect("index.html"); // Redirect to login page
%>

