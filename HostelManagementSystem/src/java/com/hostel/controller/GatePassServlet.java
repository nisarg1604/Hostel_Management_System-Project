package com.hostel.controller;

import com.hostel.dao.GatePassDAO;
import com.hostel.model.GatePass;
import com.hostel.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/GatePassServlet")
public class GatePassServlet extends HttpServlet {
    private GatePassDAO gatePassDAO;
    
    @Override
    public void init() {
        gatePassDAO = new GatePassDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Student student = (Student) session.getAttribute("student");
        
        if (student == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("apply".equals(action)) {
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            String reason = request.getParameter("reason");
            String destination = request.getParameter("destination");
            
            GatePass gatePass = new GatePass();
            gatePass.setStudentId(student.getId());
            gatePass.setFromDate(Date.valueOf(fromDate));
            gatePass.setToDate(Date.valueOf(toDate));
            gatePass.setReason(reason);
            gatePass.setDestination(destination);
            
            boolean success = gatePassDAO.applyGatePass(gatePass);
            
            if (success) {
                request.setAttribute("successMessage", "Gate pass applied successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to apply gate pass");
            }
            request.getRequestDispatcher("student/gatepass.jsp").forward(request, response);
        } else if ("approve".equals(action) || "reject".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = "approve".equals(action) ? "approved" : "rejected";
            
            boolean success = gatePassDAO.updateGatePassStatus(id, status);
            
            if (success) {
                request.setAttribute("successMessage", "Gate pass " + status + " successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to update gate pass");
            }
            request.getRequestDispatcher("admin/gatepasses.jsp").forward(request, response);
        }
    }
}