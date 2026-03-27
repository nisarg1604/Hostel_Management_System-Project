package com.hostel.dao;

import com.hostel.model.Fee;
import com.hostel.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeeDAO {
    
    public List<Fee> getFeesByStudent(int studentId) {
        List<Fee> fees = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM fees WHERE student_id = ? ORDER BY year DESC, month DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Fee fee = new Fee();
                fee.setId(rs.getInt("id"));
                fee.setStudentId(rs.getInt("student_id"));
                fee.setFeeType(rs.getString("fee_type"));
                fee.setAmount(rs.getDouble("amount"));
                fee.setMonth(rs.getInt("month"));
                fee.setYear(rs.getInt("year"));
                fee.setDueDate(rs.getDate("due_date"));
                fee.setPaidStatus(rs.getString("paid_status"));
                fee.setPaidDate(rs.getDate("paid_date"));
                fee.setPaymentMethod(rs.getString("payment_method"));
                fees.add(fee);
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
        return fees;
    }
    
    public boolean updateFeeStatus(int id, String status, Date paidDate, String paymentMethod) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE fees SET paid_status = ?, paid_date = ?, payment_method = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setDate(2, paidDate);
            pstmt.setString(3, paymentMethod);
            pstmt.setInt(4, id);
            
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