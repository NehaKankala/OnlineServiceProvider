<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Service Booking</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: url('11.jpeg') no-repeat center center fixed;
            background-size: cover;
            font-family: Arial, sans-serif;
        }

        .form-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px 30px;
            background: rgba(0, 0, 0, 0.6);
            border-radius: 10px;
            color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .form-container h2 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .form-container label {
            font-size: 14px;
            display: block;
            margin-bottom: 8px;
        }

        .form-container input, .form-container select, .form-container textarea, .form-container button {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
        }

        .form-container button {
            background: #f04c4c;
            color: #fff;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s ease;
        }

        .form-container button:hover {
            background: #c0392b;
        }
    </style>
    <script>
        function validateForm() {
            // Check if all required fields are filled
            var name = document.getElementById("name").value;
            var service = document.getElementById("service").value;
            var email = document.getElementById("email").value;
            var phone = document.getElementById("phone").value;
            var address = document.getElementById("address").value;
            var date = document.getElementById("date").value;

            if (name == "" || service == "0" || email == "" || phone == "" || address == "" || date == "") {
                alert("Please fill out all fields before submitting the form.");
                return false; // Prevent form submission
            }
            return true; // Form is valid
        }

        function sendBookingForm() {
            // Validate form fields
            if (!validateForm()) {
                return; // Stop execution if form is invalid
            }

            var form = document.getElementById("bookingForm");
            var formData = new FormData(form);

            formData.append('access_key', '68a77da8-953b-4210-b9d1-d5da9d06fc47');
            formData.append('from_name', 'Notifications');
            formData.append('from_email', 'notifications@example.com');
            formData.append('subject', 'Service Booking from user');

            fetch("https://api.web3forms.com/submit", {
                method: "POST",
                body: formData
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    alert("Booking confirmed!");
                    form.action = "bs.jsp";
                    form.method = "POST";
                    form.submit();
                } else {
                    alert("Error: " + result.message);
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("There was an error processing your request.");
            });
        }
    </script>
</head>
<body>
    <div class="form-container">
        <h2>Service Booking</h2>
        <form id="bookingForm">
            <label for="name">NAME:</label>
            <input type="text" id="name" name="name" placeholder="Enter your name" required>

            <label for="service">SELECT SERVICE:</label>
            <select id="service" name="service_id" required>
                <option value="0">Select Service</option>
                <option value="1">Plumbing</option>
                <option value="2">Carpentry</option>
                <option value="3">Driving</option>
                <option value="4">Electrician</option>
                <option value="6">Babysitter</option>
                <option value="5">Tutor</option>
            </select>

            <label for="email">EMAIL:</label>
            <input type="email" id="email" name="email" placeholder="Enter your email" required>

            <label for="phone">PHONE NUMBER:</label>
            <input type="text" id="phone" name="phone" placeholder="Enter your phone number" required>

            <label for="address">ADDRESS:</label>
            <input type="text" id="address" name="address" placeholder="Enter your address" required>

            <label for="date">PREFERRED DATE:</label>
            <input type="date" id="date" name="date" required>

            <input type="hidden" name="provider_id" value="<%= request.getParameter("provider_id") %>">
            <input type="hidden" name="service_type" value="<%= request.getParameter("service_type") %>">
            <input type="hidden" name="user_id" value="<%= session.getAttribute("user_id") %>">

            <button type="button" onclick="sendBookingForm()">Book Service</button>
        </form>
        <button onclick="history.back()" class="send-button">Back</button>
    </div>
</body>
</html>

