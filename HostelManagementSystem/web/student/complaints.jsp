<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hostel.model.Student" %>
<%@ page import="com.hostel.dao.ComplaintDAO" %>
<%@ page import="com.hostel.model.Complaint" %>
<%@ page import="java.util.List" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    ComplaintDAO complaintDAO = new ComplaintDAO();
    List<Complaint> complaints = complaintDAO.getComplaintsByStudent(student.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaints - Hostel Management</title>
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
                <h2>Complaint Management</h2>
                <button onclick="document.getElementById('complaintModal').style.display='flex'" class="btn btn-primary" style="width: auto;">Submit Complaint</button>
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
            <h3 style="margin-bottom: 20px;">Your Complaints</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Category</th>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Submitted</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Complaint c : complaints) { %>
                    <tr>
                        <td>#<%= c.getId() %></td>
                        <td><%= c.getCategory() %></td>
                        <td><%= c.getTitle() %></td>
                        <td><%= c.getDescription().length() > 50 ? c.getDescription().substring(0, 50) + "..." : c.getDescription() %></td>
                        <td><span class="badge badge-<%= c.getPriority() %>"><%= c.getPriority().toUpperCase() %></span></td>
                        <td><span class="badge badge-<%= c.getStatus() %>"><%= c.getStatus().toUpperCase() %></span></td>
                        <td><%= c.getCreatedAt() %></td>
                    </tr>
                    <% if (c.getAdminRemarks() != null && !c.getAdminRemarks().isEmpty()) { %>
                    <tr style="background: #f9fafb;">
                        <td colspan="7" style="padding-left: 40px;">
                            <strong>Admin Remarks:</strong> <%= c.getAdminRemarks() %>
                        </td>
                    </tr>
                    <% } %>
                    <% } %>
                    <% if (complaints.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align: center; color: #999;">No complaints found. Click "Submit Complaint" to register one.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <div id="complaintModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Submit Complaint</h3>
                <span class="close" onclick="document.getElementById('complaintModal').style.display='none'">&times;</span>
            </div>
            <form action="../ComplaintServlet" method="post">
                <input type="hidden" name="action" value="submit">
                
                <div class="form-group">
                    <label for="category">Category</label>
                    <select id="category" name="category" required>
                        <option value="">Select Category</option>
                        <option value="Room">Room Issue</option>
                        <option value="Electricity">Electricity</option>
                        <option value="Water">Water Supply</option>
                        <option value="Cleanliness">Cleanliness</option>
                        <option value="Maintenance">Maintenance</option>
                        <option value="Mess">Mess/Food</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="title">Title</label>
                    <input type="text" id="title" name="title" required placeholder="Brief title of complaint">
                </div>
                
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" required placeholder="Detailed description of the issue"></textarea>
                </div>
                
                <div class="form-group">
                    <label for="priority">Priority</label>
                    <select id="priority" name="priority" required>
                        <option value="low">Low</option>
                        <option value="medium" selected>Medium</option>
                        <option value="high">High</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-primary">Submit Complaint</button>
            </form>
        </div>
    </div>
</body>
</html>