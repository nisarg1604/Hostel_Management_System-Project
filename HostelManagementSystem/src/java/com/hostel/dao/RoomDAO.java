package com.hostel.dao;

import com.hostel.model.Room;
import com.hostel.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {
    
    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            String sql = "SELECT * FROM rooms ORDER BY room_no";
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("id"));
                room.setRoomNo(rs.getString("room_no"));
                room.setCapacity(rs.getInt("capacity"));
                room.setOccupied(rs.getInt("occupied"));
                room.setHostelBlock(rs.getString("hostel_block"));
                room.setFloor(rs.getInt("floor"));
                room.setStatus(rs.getString("status"));
                rooms.add(room);
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
        return rooms;
    }
    
    public boolean allocateRoom(int studentId, String roomNo) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            String sql1 = "UPDATE students SET room_no = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql1);
            pstmt.setString(1, roomNo);
            pstmt.setInt(2, studentId);
            pstmt.executeUpdate();
            pstmt.close();
            
            String sql2 = "UPDATE rooms SET occupied = occupied + 1 WHERE room_no = ?";
            pstmt = conn.prepareStatement(sql2);
            pstmt.setString(1, roomNo);
            pstmt.executeUpdate();
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}