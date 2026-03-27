package com.hostel.controller;

import com.hostel.dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RoomServlet")
public class RoomServlet extends HttpServlet {
    private RoomDAO roomDAO;
    
    @Override
    public void init() {
        roomDAO = new RoomDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("allocate".equals(action)) {
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            String roomNo = request.getParameter("roomNo");
            
            boolean success = roomDAO.allocateRoom(studentId, roomNo);
            
            if (success) {
                request.setAttribute("successMessage", "Room allocated successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to allocate room");
            }
            request.getRequestDispatcher("admin/rooms.jsp").forward(request, response);
        }
    }
}