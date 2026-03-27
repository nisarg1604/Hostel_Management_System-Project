<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hostel.model.Admin" %>
<%@ page import="com.hostel.dao.GatePassDAO" %>
<%@ page import="com.hostel.model.GatePass" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("../adminLogin.jsp");
        return;
    }
    
    GatePassDAO gatePassDAO = new GatePassDAO();
    List<GatePass> gatePasses = gatePassDAO.getAllGatePasses();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gate Passes - Admin Panel</title>
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
            <h2>Gate Pass Management</h2>
            <p style="color: #666;">Review and approve gate pass requests</p>
        </div>
        
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <div class="table-container">
            <h3 style="margin-bottom: 20px;">All Gate Pass Requests</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student Name</th>
                        <th>From Date</th>
                        <th>To Date</th>
                        <th>Destination</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Applied On</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (GatePass gp : gatePasses) { %>
                    <tr>
                        <td>#<%= gp.getId() %></td>
                        <td><%= gp.getStudentName() %></td>
                        <td><%= gp.getFromDate() %></td>
                        <td><%= gp.getToDate() %></td>
                        <td><%= gp.getDestination() %></td>
                        <td><%= gp.getReason().length() > 30 ? gp.getReason().substring(0, 30) + "..." : gp.getReason() %></td>
                        <td><span class="badge badge-<%= gp.getStatus() %>"><%= gp.getStatus().toUpperCase() %></span></td>
                        <td><%= gp.getCreatedAt() %></td>
                        <td>
                            <% if ("pending".equals(gp.getStatus())) { %>
                            <form action="../GatePassServlet" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="id" value="<%= gp.getId() %>">
                                <button type="submit" class="btn btn-success" style="padding: 5px 12px; font-size: 12px;">Approve</button>
                            </form>
                            <form action="../GatePassServlet" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="reject">
                                <input type="hidden" name="id" value="<%= gp.getId() %>">
                                <button type="submit" class="btn btn-danger" style="padding: 5px 12px; font-size: 12px;">Reject</button>
                            </form>
                            <% } else { %>
                            -
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                    <% if (gatePasses.isEmpty()) { %>
                    <tr>
                        <td colspan="9" style="text-align: center; color: #999;">No gate pass requests</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
