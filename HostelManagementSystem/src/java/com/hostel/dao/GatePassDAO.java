package com.hostel.dao;

import com.hostel.model.GatePass;
import com.hostel.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GatePassDAO {
    
    public boolean applyGatePass(GatePass gatePass) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO gate_passes (student_id, from_date, to_date, reason, destination) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, gatePass.getStudentId());
            pstmt.setDate(2, gatePass.getFromDate());
            pstmt.setDate(3, gatePass.getToDate());
            pstmt.setString(4, gatePass.getReason());
            pstmt.setString(5, gatePass.getDestination());
            
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
    
    public List<GatePass> getGatePassesByStudent(int studentId) {
        List<GatePass> gatePasses = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM gate_passes WHERE student_id = ? ORDER BY created_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                GatePass gatePass = new GatePass();
                gatePass.setId(rs.getInt("id"));
                gatePass.setStudentId(rs.getInt("student_id"));
                gatePass.setFromDate(rs.getDate("from_date"));
                gatePass.setToDate(rs.getDate("to_date"));
                gatePass.setReason(rs.getString("reason"));
                gatePass.setDestination(rs.getString("destination"));
                gatePass.setStatus(rs.getString("status"));
                gatePass.setCreatedAt(rs.getTimestamp("created_at"));
                gatePasses.add(gatePass);
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
        return gatePasses;
    }
    
    public List<GatePass> getAllGatePasses() {
        List<GatePass> gatePasses = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT gp.*, s.name as student_name FROM gate_passes gp INNER JOIN students s ON gp.student_id = s.id ORDER BY gp.created_at DESC";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                GatePass gatePass = new GatePass();
                gatePass.setId(rs.getInt("id"));
                gatePass.setStudentId(rs.getInt("student_id"));
                gatePass.setStudentName(rs.getString("student_name"));
                gatePass.setFromDate(rs.getDate("from_date"));
                gatePass.setToDate(rs.getDate("to_date"));
                gatePass.setReason(rs.getString("reason"));
                gatePass.setDestination(rs.getString("destination"));
                gatePass.setStatus(rs.getString("status"));
                gatePass.setCreatedAt(rs.getTimestamp("created_at"));
                gatePasses.add(gatePass);
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
        return gatePasses;
    }
    
    public boolean updateGatePassStatus(int id, String status) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE gate_passes SET status = ?, approved_at = CURRENT_TIMESTAMP WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, id);
            
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