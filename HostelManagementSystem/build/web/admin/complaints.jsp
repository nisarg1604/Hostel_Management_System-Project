<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.hostel.model.Admin" %>
<%@ page import="com.hostel.dao.ComplaintDAO" %>
<%@ page import="com.hostel.model.Complaint" %>
<%@ page import="java.util.List" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("../adminLogin.jsp");
        return;
    }
    
    ComplaintDAO complaintDAO = new ComplaintDAO();
    List<Complaint> complaints = complaintDAO.getAllComplaints();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaints - Admin Panel</title>
    <link rel="stylesheet" href="../css/style.css">
    <script>
        function showResolveModal(id, title) {
            document.getElementById('resolveModal').style.display = 'flex';
            document.getElementById('complaintId').value = id;
            document.getElementById('modalTitle').innerText = 'Resolve: ' + title;
        }
    </script>
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
            <h2>Complaint Management</h2>
            <p style="color: #666;">Review and resolve student complaints</p>
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
            <h3 style="margin-bottom: 20px;">All Complaints</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student</th>
                        <th>Category</th>
                        <th>Title</th>
                        <th>Description</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Submitted</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Complaint c : complaints) { %>
                    <tr>
                        <td>#<%= c.getId() %></td>
                        <td><%= c.getStudentName() %></td>
                        <td><%= c.getCategory() %></td>
                        <td><%= c.getTitle() %></td>
                        <td><%= c.getDescription().length() > 40 ? c.getDescription().substring(0, 40) + "..." : c.getDescription() %></td>
                        <td><span class="badge badge-<%= c.getPriority() %>"><%= c.getPriority().toUpperCase() %></span></td>
                        <td><span class="badge badge-<%= c.getStatus() %>"><%= c.getStatus().toUpperCase() %></span></td>
                        <td><%= c.getCreatedAt() %></td>
                        <td>
                            <% if ("pending".equals(c.getStatus())) { %>
                            <button onclick="showResolveModal(<%= c.getId() %>, '<%= c.getTitle().replace("'", "'") %>')" class="btn btn-success" style="padding: 5px 12px; font-size: 12px;">Resolve</button>
                            <% } else { %>
                            -
                            <% } %>
                        </td>
                    </tr>
                    <% if (c.getAdminRemarks() != null && !c.getAdminRemarks().isEmpty()) { %>
                    <tr style="background: #f9fafb;">
                        <td colspan="9" style="padding-left: 40px;">
                            <strong>Admin Remarks:</strong> <%= c.getAdminRemarks() %>
                        </td>
                    </tr>
                    <% } %>
                    <% } %>
                    <% if (complaints.isEmpty()) { %>
                    <tr>
                        <td colspan="9" style="text-align: center; color: #999;">No complaints registered</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <div id="resolveModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Resolve Complaint</h3>
                <span class="close" onclick="document.getElementById('resolveModal').style.display='none'">&times;</span>
            </div>
            <form action="../ComplaintServlet" method="post">
                <input type="hidden" name="action" value="resolve">
                <input type="hidden" id="complaintId" name="id">
                
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status" required>
                        <option value="in-progress">In Progress</option>
                        <option value="resolved">Resolved</option>
                        <option value="rejected">Rejected</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="remarks">Admin Remarks</label>
                    <textarea id="remarks" name="remarks" required placeholder="Enter your remarks or resolution details"></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary">Update Complaint</button>
            </form>
        </div>
    </div>
</body>
</html>