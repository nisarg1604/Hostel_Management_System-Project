<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Hostel Management</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="login-image" style="background-image: url('images/hostel.webp');"></div>
            
            <div class="login-form">
                <h2>Admin Login</h2>
                <p>Administrator Access Only</p>
                
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-error">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>
                
                <form action="AdminLoginServlet" method="post">
                    <div class="form-group">
                        <label for="email">Admin Email</label>
                        <input type="email" id="email" name="email" required placeholder="admin@hostel.com">
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required placeholder="Enter admin password">
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Login as Admin</button>
                </form>
                
                <p style="text-align: center; margin-top: 20px; color: #666;">
                    <a href="index.jsp" class="link">← Back to Home</a>
                </p>
               
            </div>
        </div>
    </div>
</body>
</html>