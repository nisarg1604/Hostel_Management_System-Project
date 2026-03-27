<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hostel.model.Admin" %>
<%@ page import="com.hostel.dao.RoomDAO" %>
<%@ page import="com.hostel.model.Room" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("../adminLogin.jsp");
        return;
    }
    
    RoomDAO roomDAO = new RoomDAO();
    List<Room> rooms = roomDAO.getAllRooms();
    
    int totalRooms = rooms.size();
    int totalCapacity = rooms.stream().mapToInt(Room::getCapacity).sum();
    int totalOccupied = rooms.stream().mapToInt(Room::getOccupied).sum();
    int totalAvailable = totalCapacity - totalOccupied;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rooms - Admin Panel</title>
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
            <h2>Room Management</h2>
            <p style="color: #666;">View room allocation and availability</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>Total Rooms</h3>
                <div class="value"><%= totalRooms %></div>
                <div class="label">All Rooms</div>
            </div>
            
            <div class="card">
                <h3>Total Capacity</h3>
                <div class="value"><%= totalCapacity %></div>
                <div class="label">Maximum Students</div>
            </div>
            
            <div class="card">
                <h3>Occupied</h3>
                <div class="value" style="color: #f59e0b;"><%= totalOccupied %></div>
                <div class="label">Current Occupancy</div>
            </div>
            
            <div class="card">
                <h3>Available</h3>
                <div class="value" style="color: #10b981;"><%= totalAvailable %></div>
                <div class="label">Vacant Seats</div>
            </div>
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
            <h3 style="margin-bottom: 20px;">All Rooms</h3>
            <table>
                <thead>
                    <tr>
                        <th>Room No</th>
                        <th>Block</th>
                        <th>Floor</th>
                        <th>Capacity</th>
                        <th>Occupied</th>
                        <th>Available</th>
                        <th>Status</th>
                        <th>Occupancy %</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Room r : rooms) { 
                        int occupancyPercent = (r.getCapacity() > 0) ? (r.getOccupied() * 100 / r.getCapacity()) : 0;
                        String statusColor = occupancyPercent == 100 ? "rejected" : (occupancyPercent >= 80 ? "pending" : "approved");
                    %>
                    <tr>
                        <td><strong><%= r.getRoomNo() %></strong></td>
                        <td><%= r.getHostelBlock() %></td>
                        <td><%= r.getFloor() %></td>
                        <td><%= r.getCapacity() %></td>
                        <td><%= r.getOccupied() %></td>
                        <td style="font-weight: 600; color: #10b981;"><%= r.getAvailable() %></td>
                        <td><span class="badge badge-<%= statusColor %>"><%= r.getStatus().toUpperCase() %></span></td>
                        <td>
                            <div style="background: #e5e7eb; border-radius: 10px; height: 20px; overflow: hidden;">
                                <div style="background: <%= occupancyPercent == 100 ? "#ef4444" : (occupancyPercent >= 80 ? "#f59e0b" : "#10b981") %>; height: 100%; width: <%= occupancyPercent %>%; text-align: center; color: white; font-size: 11px; font-weight: bold; line-height: 20px;">
                                    <%= occupancyPercent %>%
                                </div>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    <% if (rooms.isEmpty()) { %>
                    <tr>
                        <td colspan="8" style="text-align: center; color: #999;">No rooms available</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
