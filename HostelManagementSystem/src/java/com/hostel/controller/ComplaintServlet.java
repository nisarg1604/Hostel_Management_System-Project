package com.hostel.controller;

import com.hostel.dao.ComplaintDAO;
import com.hostel.model.Complaint;
import com.hostel.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ComplaintServlet")
public class ComplaintServlet extends HttpServlet {
    private ComplaintDAO complaintDAO;
    
    @Override
    public void init() {
        complaintDAO = new ComplaintDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String action = request.getParameter("action");
        
        if ("submit".equals(action)) {
            Student student = (Student) session.getAttribute("student");
            
            if (student == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            String category = request.getParameter("category");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String priority = request.getParameter("priority");
            
            Complaint complaint = new Complaint();
            complaint.setStudentId(student.getId());
            complaint.setCategory(category);
            complaint.setTitle(title);
            complaint.setDescription(description);
            complaint.setPriority(priority);
            
            boolean success = complaintDAO.addComplaint(complaint);
            
            if (success) {
                request.setAttribute("successMessage", "Complaint submitted successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to submit complaint");
            }
            request.getRequestDispatcher("student/complaints.jsp").forward(request, response);
        } else if ("resolve".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            String remarks = request.getParameter("remarks");
            
            boolean success = complaintDAO.updateComplaintStatus(id, status, remarks);
            
            if (success) {
                request.setAttribute("successMessage", "Complaint updated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update complaint");
            }
            request.getRequestDispatcher("admin/complaints.jsp").forward(request, response);
        }
    }
}