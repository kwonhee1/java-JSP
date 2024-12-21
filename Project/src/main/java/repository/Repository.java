package repository;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Repository {
	public Connection getConnection() {
        // MySQL 데이터베이스 연결
        try {
			return DriverManager.getConnection("jdbc:mysql://localhost:3306/jsp?CHARACTER SET utf8", "jsp", "dongyang");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("repository:getConntection error :: cannot get connection");
			e.printStackTrace();
			return null;
		}
    }
	
	public void disconnect(Connection conn, Statement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
	
	public void disconnect(Connection conn, Statement pstmt) {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
	
	public void disconnect(Connection conn) {
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
