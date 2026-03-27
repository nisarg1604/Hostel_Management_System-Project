<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hostel.model.Admin" %>
<%@ page import="com.hostel.dao.*" %>
<%@ page import="com.hostel.model.*" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("../adminLogin.jsp");
        return;
    }
    
    StudentDAO studentDAO = new StudentDAO();
    GatePassDAO gatePassDAO = new GatePassDAO();
    ComplaintDAO complaintDAO = new ComplaintDAO();
    RoomDAO roomDAO = new RoomDAO();
    
    List<Student> students = studentDAO.getAllStudents();
    List<GatePass> gatePasses = gatePassDAO.getAllGatePasses();
    List<Complaint> complaints = complaintDAO.getAllComplaints();
    List<Room> rooms = roomDAO.getAllRooms();
    
    long pendingGatePasses = gatePasses.stream().filter(g -> "pending".equals(g.getStatus())).count();
    long pendingComplaints = complaints.stream().filter(c -> "pending".equals(c.getStatus())).count();
    long availableRooms = rooms.stream().filter(r -> r.getAvailable() > 0).count();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Hostel Management</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <h1>Hostel Management System - Admin</h1>
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
            <h2>Welcome, <%= admin.getName() %>!</h2>
            <p style="color: #666;">Administrator Dashboard - Manage hostel operations</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>Total Students</h3>
                <div class="value"><%= students.size() %></div>
                <div class="label">Registered Students</div>
            </div>
            
            <div class="card">
                <h3>Pending Gate Passes</h3>
                <div class="value" style="color: #f59e0b;"><%= pendingGatePasses %></div>
                <div class="label">Require Approval</div>
            </div>
            
            <div class="card">
                <h3>Open Complaints</h3>
                <div class="value" style="color: #ef4444;"><%= pendingComplaints %></div>
                <div class="label">Need Attention</div>
            </div>
            
            <div class="card">
                <h3>Available Rooms</h3>
                <div class="value" style="color: #10b981;"><%= availableRooms %></div>
                <div class="label">Rooms with Vacancy</div>
            </div>
        </div>
        
        <div class="table-container">
            <h3 style="margin-bottom: 20px;">Recent Gate Pass Requests</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student</th>
                        <th>From Date</th>
                        <th>To Date</th>
                        <th>Destination</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    int count = 0;
                    for (GatePass gp : gatePasses) {
                        if (count >= 5) break;
                        count++;
                    %>
                    <tr>
                        <td>#<%= gp.getId() %></td>
                        <td><%= gp.getStudentName() %></td>
                        <td><%= gp.getFromDate() %></td>
                        <td><%= gp.getToDate() %></td>
                        <td><%= gp.getDestination() %></td>
                        <td><span class="badge badge-<%= gp.getStatus() %>"><%= gp.getStatus().toUpperCase() %></span></td>
                        <td>
                            <% if ("pending".equals(gp.getStatus())) { %>
                            <a href="gatepasses.jsp" class="btn btn-success" style="padding: 5px 12px; font-size: 12px;">Review</a>
                            <% } else { %>
                            -
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                    <% if (gatePasses.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: #999;">No gate pass requests</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <div class="table-container" style="margin-top: 30px;">
            <h3 style="margin-bottom: 20px;">Recent Complaints</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student</th>
                        <th>Category</th>
                        <th>Title</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    count = 0;
                    for (Complaint c : complaints) {
                        if (count >= 5) break;
                        count++;
                    %>
                    <tr>
                        <td>#<%= c.getId() %></td>
                        <td><%= c.getStudentName() %></td>
                        <td><%= c.getCategory() %></td>
                        <td><%= c.getTitle() %></td>
                        <td><span class="badge badge-<%= c.getPriority() %>"><%= c.getPriority().toUpperCase() %></span></td>
                        <td><span class="badge badge-<%= c.getStatus() %>"><%= c.getStatus().toUpperCase() %></span></td>
                        <td>
                            <% if ("pending".equals(c.getStatus())) { %>
                            <a href="complaints.jsp" class="btn btn-success" style="padding: 5px 12px; font-size: 12px;">Resolve</a>
                            <% } else { %>
                            -
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                    <% if (complaints.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: #999;">No complaints registered</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>