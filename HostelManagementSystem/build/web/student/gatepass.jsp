<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hostel.model.Student" %>
<%@ page import="com.hostel.dao.GatePassDAO" %>
<%@ page import="com.hostel.model.GatePass" %>
<%@ page import="java.util.List" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    GatePassDAO gatePassDAO = new GatePassDAO();
    List<GatePass> gatePasses = gatePassDAO.getGatePassesByStudent(student.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gate Pass - Hostel Management</title>
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
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <h2>Gate Pass Management</h2>
                <button onclick="document.getElementById('applyModal').style.display='flex'" class="btn btn-primary" style="width: auto;">Apply for Gate Pass</button>
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
            <h3 style="margin-bottom: 20px;">Your Gate Passes</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>From Date</th>
                        <th>To Date</th>
                        <th>Reason</th>
                        <th>Destination</th>
                        <th>Status</th>
                        <th>Applied On</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (GatePass gp : gatePasses) { %>
                    <tr>
                        <td>#<%= gp.getId() %></td>
                        <td><%= gp.getFromDate() %></td>
                        <td><%= gp.getToDate() %></td>
                        <td><%= gp.getReason() %></td>
                        <td><%= gp.getDestination() %></td>
                        <td><span class="badge badge-<%= gp.getStatus() %>"><%= gp.getStatus().toUpperCase() %></span></td>
                        <td><%= gp.getCreatedAt() %></td>
                    </tr>
                    <% } %>
                    <% if (gatePasses.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: #999;">No gate passes found. Click "Apply for Gate Pass" to create one.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <div id="applyModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Apply for Gate Pass</h3>
                <span class="close" onclick="document.getElementById('applyModal').style.display='none'">&times;</span>
            </div>
            <form action="../GatePassServlet" method="post">
                <input type="hidden" name="action" value="apply">
                
                <div class="form-group">
                    <label for="fromDate">From Date</label>
                    <input type="date" id="fromDate" name="fromDate" required>
                </div>
                
                <div class="form-group">
                    <label for="toDate">To Date</label>
                    <input type="date" id="toDate" name="toDate" required>
                </div>
                
                <div class="form-group">
                    <label for="destination">Destination</label>
                    <input type="text" id="destination" name="destination" required placeholder="Enter destination">
                </div>
                
                <div class="form-group">
                    <label for="reason">Reason</label>
                    <textarea id="reason" name="reason" required placeholder="Enter reason for leave"></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary">Submit Application</button>
            </form>
        </div>
    </div>
</body>
</html>