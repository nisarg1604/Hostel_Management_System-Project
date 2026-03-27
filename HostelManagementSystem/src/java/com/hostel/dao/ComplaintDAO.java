package com.hostel.dao;

import com.hostel.model.Complaint;
import com.hostel.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {
    
    public boolean addComplaint(Complaint complaint) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO complaints (student_id, category, title, description, priority) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, complaint.getStudentId());
            pstmt.setString(2, complaint.getCategory());
            pstmt.setString(3, complaint.getTitle());
            pstmt.setString(4, complaint.getDescription());
            pstmt.setString(5, complaint.getPriority());
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public List<Complaint> getComplaintsByStudent(int studentId) {
        List<Complaint> complaints = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM complaints WHERE student_id = ? ORDER BY created_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Complaint complaint = new Complaint();
                complaint.setId(rs.getInt("id"));
                complaint.setStudentId(rs.getInt("student_id"));
                complaint.setCategory(rs.getString("category"));
                complaint.setTitle(rs.getString("title"));
                complaint.setDescription(rs.getString("description"));
                complaint.setStatus(rs.getString("status"));
                complaint.setPriority(rs.getString("priority"));
                complaint.setCreatedAt(rs.getTimestamp("created_at"));
                complaint.setResolvedAt(rs.getTimestamp("resolved_at"));
                complaint.setAdminRemarks(rs.getString("admin_remarks"));
                complaints.add(complaint);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return complaints;
    }
    
    public List<Complaint> getAllComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT c.*, s.name as student_name FROM complaints c INNER JOIN students s ON c.student_id = s.id ORDER BY c.created_at DESC";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Complaint complaint = new Complaint();
                complaint.setId(rs.getInt("id"));
                complaint.setStudentId(rs.getInt("student_id"));
                complaint.setStudentName(rs.getString("student_name"));
                complaint.setCategory(rs.getString("category"));
                complaint.setTitle(rs.getString("title"));
                complaint.setDescription(rs.getString("description"));
                complaint.setStatus(rs.getString("status"));
                complaint.setPriority(rs.getString("priority"));
                complaint.setCreatedAt(rs.getTimestamp("created_at"));
                complaint.setResolvedAt(rs.getTimestamp("resolved_at"));
                complaint.setAdminRemarks(rs.getString("admin_remarks"));
                complaints.add(complaint);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return complaints;
    }
    
    public boolean updateComplaintStatus(int id, String status, String remarks) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE complaints SET status = ?, admin_remarks = ?, resolved_at = CURRENT_TIMESTAMP WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setString(2, remarks);
            pstmt.setInt(3, id);
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}