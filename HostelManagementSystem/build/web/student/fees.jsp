<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hostel.model.Student" %>
<%@ page import="com.hostel.dao.FeeDAO" %>
<%@ page import="com.hostel.model.Fee" %>
<%@ page import="java.util.List" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    FeeDAO feeDAO = new FeeDAO();
    List<Fee> fees = feeDAO.getFeesByStudent(student.getId());
    
    double totalPaid = fees.stream().filter(f -> "paid".equals(f.getPaidStatus())).mapToDouble(Fee::getAmount).sum();
    double totalDue = fees.stream().filter(f -> "unpaid".equals(f.getPaidStatus())).mapToDouble(Fee::getAmount).sum();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fees - Hostel Management</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <h1>The Second Home</h1>
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
            <h2>Fee Management</h2>
            <p style="color: #666;">Track your hostel fees and payment history</p>
        </div>
        
        <div class="dashboard-grid" style="grid-template-columns: repeat(2, 1fr);">
            <div class="card">
                <h3>Total Paid</h3>
                <div class="value" style="color: #10b981;">₹<%= String.format("%.2f", totalPaid) %></div>
                <div class="label">Payment Completed</div>
            </div>
            
            <div class="card">
                <h3>Total Due</h3>
                <div class="value" style="color: #ef4444;">₹<%= String.format("%.2f", totalDue) %></div>
                <div class="label">Outstanding Amount</div>
            </div>
        </div>
        
        <div class="table-container">
            <h3 style="margin-bottom: 20px;">Fee Details</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Fee Type</th>
                        <th>Month/Year</th>
                        <th>Amount</th>
                        <th>Due Date</th>
                        <th>Status</th>
                        <th>Paid Date</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
                    for (Fee f : fees) { 
                    %>
                    <tr>
                        <td>#<%= f.getId() %></td>
                        <td><%= f.getFeeType() %></td>
                        <td><%= months[f.getMonth() - 1] %> <%= f.getYear() %></td>
                        <td style="font-weight: 600; color: #667eea;">₹<%= String.format("%.2f", f.getAmount()) %></td>
                        <td><%= f.getDueDate() %></td>
                        <td><span class="badge badge-<%= f.getPaidStatus() %>"><%= f.getPaidStatus().toUpperCase() %></span></td>
                        <td><%= f.getPaidDate() != null ? f.getPaidDate().toString() : "-" %></td>
                    </tr>
                    <% } %>
                    <% if (fees.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: #999;">No fee records found.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <% if (totalDue > 0) { %>
        <div style="margin-top: 30px; padding: 20px; background: #fff7ed; border-radius: 10px; border-left: 4px solid #f59e0b;">
            <h3 style="color: #92400e; margin-bottom: 10px;">Payment Reminder</h3>
            <p style="color: #92400e;">You have an outstanding balance of <strong>₹<%= String.format("%.2f", totalDue) %></strong>. Please clear your dues at the earliest.</p>
        </div>
        <% } %>
    </div>
</body>
</html>