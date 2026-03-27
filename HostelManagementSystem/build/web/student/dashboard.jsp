<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hostel.model.Student" %>
<%@ page import="com.hostel.dao.*" %>
<%@ page import="com.hostel.model.*" %>
<%@ page import="java.util.List" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    GatePassDAO gatePassDAO = new GatePassDAO();
    ComplaintDAO complaintDAO = new ComplaintDAO();
    FeeDAO feeDAO = new FeeDAO();
    
    List<GatePass> gatePasses = gatePassDAO.getGatePassesByStudent(student.getId());
    List<Complaint> complaints = complaintDAO.getComplaintsByStudent(student.getId());
    List<Fee> fees = feeDAO.getFeesByStudent(student.getId());
    
    long pendingGatePasses = gatePasses.stream().filter(g -> "pending".equals(g.getStatus())).count();
    long pendingComplaints = complaints.stream().filter(c -> "pending".equals(c.getStatus())).count();
    double totalDue = fees.stream().filter(f -> "unpaid".equals(f.getPaidStatus())).mapToDouble(Fee::getAmount).sum();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Hostel Management</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <h1>Hostel Management System</h1>
            <div class="navbar-menu">
                <a href="dashboard.jsp">Dashboard</a>
                <a href="gatepass.jsp">Gate Pass</a>
                <a href="complaints.jsp">Complaints</a>
                <a href="fees.jsp">Fees</a>
                <span style="color: #667eea;"><%= student.getName() %></span>
                <a href="../LogoutServlet" style="color: #ef4444;">Logout</a>
            </div>
        </div>
    </nav>
    
    <div class="container">
        <div class="welcome-section">
            <h2>Welcome, <%= student.getName() %>!</h2>
            <p style="color: #666;">Room No: <strong><%= student.getRoomNo() != null ? student.getRoomNo() : "Not Assigned" %></strong> | Email: <%= student.getEmail() %></p>
        </div>
        
        <div class="dashboard-grid">
            <div class="card">
                <h3>Room Number</h3>
                <div class="value"><%= student.getRoomNo() != null ? student.getRoomNo() : "N/A" %></div>
                <div class="label">Assigned Room</div>
            </div>
            
            <div class="card">
                <h3>Gate Passes</h3>
                <div class="value"><%= pendingGatePasses %></div>
                <div class="label">Pending Approval</div>
            </div>
            
            <div class="card">
                <h3>Complaints</h3>
                <div class="value"><%= pendingComplaints %></div>
                <div class="label">Open Complaints</div>
            </div>
            
            <div class="card">
                <h3>Fees Due</h3>
                <div class="value" style="font-size: 28px;">₹<%= String.format("%.2f", totalDue) %></div>
                <div class="label">Total Outstanding</div>
            </div>
        </div>
        
        <div class="table-container">
            <h3 style="margin-bottom: 20px;">Recent Gate Passes</h3>
            <table>
                <thead>
                    <tr>
                        <th>From Date</th>
                        <th>To Date</th>
                        <th>Destination</th>
                        <th>Status</th>
                        <th>Applied On</th>
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
                        <td><%= gp.getFromDate() %></td>
                        <td><%= gp.getToDate() %></td>
                        <td><%= gp.getDestination() %></td>
                        <td><span class="badge badge-<%= gp.getStatus() %>"><%= gp.getStatus().toUpperCase() %></span></td>
                        <td><%= gp.getCreatedAt() %></td>
                    </tr>
                    <% } %>
                    <% if (gatePasses.isEmpty()) { %>
                    <tr>
                        <td colspan="5" style="text-align: center; color: #999;">No gate passes found</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>