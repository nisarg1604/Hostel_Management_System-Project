package com.hostel.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.annotation.*;
import java.time.LocalDate;

import com.hostel.dao.StudentDAO;
import com.hostel.model.Student;

@WebServlet("/admin/AddStudentServlet")
public class AddStudentServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest req, HttpServletResponse res)throws ServletException, IOException
    {
        res.sendRedirect("students.jsp");
    }
    
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String roomNo = req.getParameter("roomNo");

        // Validation
        if (name == null || name.trim().isEmpty() || 
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            roomNo == null || roomNo.trim().isEmpty()) {
            res.sendRedirect("error.jsp?msg=All fields are required");
            return;
        }

        Date sqlDate = java.sql.Date.valueOf(LocalDate.now());

        Student s = new Student();
        s.setName(name.trim());
        s.setEmail(email.trim());
        s.setPhone(phone.trim());
        s.setAdmissionDate(sqlDate);
        s.setPassword(password);
        s.setRoomNo(roomNo.trim());
        s.setStatus("ACTIVE");

        StudentDAO dao = new StudentDAO();

        if (dao.addStudent(s)) {
            res.sendRedirect("students.jsp?success=Student Added Successfully");
        } else {
            res.sendRedirect("error.jsp?msg=Failed to add student");
        }
    }
}