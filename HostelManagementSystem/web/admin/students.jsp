<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hostel.model.Admin" %>
<%@ page import="com.hostel.dao.StudentDAO" %>
<%@ page import="com.hostel.model.Student" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("../adminLogin.jsp");
        return;
    }
    
    StudentDAO studentDAO = new StudentDAO();
    List<Student> students = studentDAO.getAllStudents();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Students - Admin Panel</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <h1>The Second Home - Admin</h1>
            <div class="navbar-menu">
                <a href="dashboard.jsp">Dashboard</a>
                <a href="students.jsp">Students</a>
                <a href="gatepasses.jsp">Gate Passes</a>
                <a href="complaints.jsp">Complaints</a>
                <a href="rooms.jsp">Rooms</a>
                <span style="color: #667eea;"><%= admin.getName() %></span>
                <a href="../LogoutServlet" style="color: #ef4444;">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="container">
        <div class="welcome-section">
            <h2>Student Management</h2>
            <p style="color: #666;">View and manage all registered students</p>
        </div>
        <a href="addStudent.jsp" class="btn">+ Add Student</a>
        <div class="table-container">
            <h3 style="margin-bottom: 20px;">All Students</h3>
            <table>
                <thead>
                    <tr>
                       
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Room No</th>
                        <th>Admission Date</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Student s : students) { %>
                    <tr>
                        
                        <td><%= s.getName() %></td>
                        <td><%= s.getEmail() %></td>
                        <td><%= s.getPhone() %></td>
                        <td><strong><%= s.getRoomNo() != null ? s.getRoomNo() : "Not Assigned" %></strong></td>
                        <td><%= s.getAdmissionDate() %></td>
                        <td><span class="badge badge-approved"><%= s.getStatus() != null ? s.getStatus().toUpperCase() : "ACTIVE" %></span></td>
                    </tr>
                    <% } %>
                    <% if (students.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: #999;">No students registered</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>