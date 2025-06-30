<%@ page import="java.io.*" %>
<%
    // Check if the session contains the user_id
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        // Session is not set; redirect to login page
        response.sendRedirect("index.html");
        return;
    }

    // If logged in, display a welcome message
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }
        header {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            text-align: center;
        }
        .container {
            margin: 20px;
        }
        .card {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin: 15px 0;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .card a {
            text-decoration: none;
            color: white;
            background-color: #007bff;
            padding: 10px 15px;
            border-radius: 5px;
        }
        .card a:hover {
            background-color: #0056b3;
        }
          .voice-button img {
            width: 40px;
            height: 40px;
            cursor: pointer;
            border-radius: 50%;
          
        }

        .voice-button.active img {
            background-color: #e53935;
            border-radius: 50%;
            padding: 5px;
        }

        .search-bar-container {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            margin-top: 30px;
            margin-right:100 px;
        }

        .search-bar {
            width: 40%;
            padding: 10px;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <header>
        <h1>Welcome to Your Dashboard</h1>
    </header>
    
     <div class="search-bar-container">
            <input type="text" id="search-bar" class="search-bar" placeholder="Search for services...">
            <div id="voice-btn" class="voice-button" onclick="toggleRecognition()">
                <img src="mic1.jpeg" alt="Voice Assistant">
            </div>
        </div>
        
    <div class="container">
        <h2>Hello, User </h2>
        <p>Select an option below to proceed:</p>

        <div class="card">
            <h3>My Orders</h3>
            <p>View all your current and past orders.</p>
            <a href="orders.jsp">View Orders</a>
        </div>

        <div class="card">
            <h3>My Account</h3>
            <p>Update your personal details and preferences.</p>
            <a href="accountu.jsp">Manage Account</a>
        </div>

        <div class="card">
            <h3>Hire a Service</h3>
            <p>Explore and book available services.</p>
            <a href="services.html">Hire Services</a>
        </div>

        <div class="card">
            <h3>Logout</h3>
            <p>Sign out from your account securely.</p>
            <a href="login.html">Logout</a>
        </div>
    </div><script>
        // JavaScript code for voice recognition and service search functionality
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) {
            alert("Your browser does not support voice recognition. Please use Google Chrome.");
        }

        const recognition = new SpeechRecognition();
        recognition.lang = 'en-US'; 
        recognition.interimResults = false;
        recognition.maxAlternatives = 1;

        let recognizing = false;

        const searchBar = document.getElementById('search-bar');
        const voiceBtn = document.getElementById('voice-btn');

        function toggleRecognition() {
            if (recognizing) {
                recognition.stop();
                recognizing = false;
                voiceBtn.classList.remove('active');
            } else {
                recognition.start();
                recognizing = true;
                voiceBtn.classList.add('active');
            }
        }

        recognition.onresult = (event) => {
            const speechToText = event.results[0][0].transcript;
            searchBar.value = speechToText;
            searchResults(speechToText);
        };

        recognition.onend = () => {
            recognizing = false;
            voiceBtn.classList.remove('active');
        };

        recognition.onerror = (event) => {
            console.error("Error occurred in recognition: ", event.error);
            recognizing = false;
            voiceBtn.classList.remove('active');
        };

        function searchResults(query) {
            if (query.trim() === "") return;

            const services = {
                "plumbing": "providers.jsp?service=plumbing",
                "electrician": "ecprovider.jsp?service=electrician",
                "carpentry": "ccprovider.jsp?service=carpentry",
                "driving": "drprovider.jsp?service=driving",
                "painting": "pprovider.jsp?service=painting"
            };

            const relatedKeywords = {
                "plumbing": ["plumber", "plumbing", "pipes", "leak", "drain", "clog", "water", "tap", "repair"],
                "electrician": ["electrician", "electrical", "electric", "wiring", "socket", "switch", "fuse", "lighting", "power", "circuit","tv","fridge","AC","fan","cooler","washing machine","light"],
                "carpentry": ["carpenter", "carpentry", "wood", "furniture", "cabinet", "joinery", "table", "chair","sofa"],
                "driving": ["drive", "driver", "driving", "vehicle", "car", "taxi", "transport","bike","bus","traveller","rapido","ola","auto","scooty","cycle"],
                "baby-sitter":["baby","caretaker","child care","kids","kid","kids care","child"],
                "Tutor":["teacher","teach","learn","sir","faculty","tution","student","homework"],
            };

            const foundService = Object.keys(services).find(service => query.toLowerCase().includes(service));
            const relatedMatch = Object.keys(relatedKeywords).find(service => {
                return relatedKeywords[service].some(keyword => query.toLowerCase().includes(keyword));
            });

            if (foundService) {
                window.location.href = services[foundService];
            } else if (relatedMatch) {
                window.location.href = services[relatedMatch];
            } else {
                alert("No matching service found for: " + query);
            }
        }

        searchBar.addEventListener('keypress', (event) => {
            if (event.key === 'Enter') {
                searchResults(searchBar.value);
            }
        });
    </script>
</body>
</html>

