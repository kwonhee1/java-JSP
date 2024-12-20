package repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;
import java.util.List;

import model.Gym;

public class FavoritesRepository extends Repository {
    
    // 즐겨찾기에 추가
    public boolean addFavorite(String userId, int gymId) {
        String query = "INSERT INTO favorite (userId, gymId) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userId);
            pstmt.setInt(2, gymId);
            return pstmt.executeUpdate() > 0;
        }catch(SQLIntegrityConstraintViolationException e) { 
        	// duplicate
        	return true;
        }catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect(conn, pstmt); // 부모 클래스의 메서드를 사용
        }
        return false;
    }

    // 즐겨찾기 삭제
    public boolean removeFavorite(String userId, int gymId) {
        String query = "DELETE FROM favorite WHERE userId = ? AND gymId = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userId);
            pstmt.setInt(2, gymId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect(conn, pstmt); // 부모 클래스의 메서드를 사용
        }
        return false;
    }

    // 특정 사용자의 즐겨찾기 목록 조회
    public List<Gym> getFavoritesByUserId(String userId) {
        String query = """
            SELECT g.id, g.siteCode, g.oldAddr, g.newAddr, g.name, g.y, g.x, g.status 
            FROM favorite f
            JOIN gym g ON f.gymId = g.id
            WHERE f.userId = ?;
        """;

        List<Gym> gyms = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Gym gym = new Gym();
                gym.setId(rs.getInt("id"));
                gym.setSiteCode(rs.getString("siteCode"));
                gym.setOldAddr(rs.getString("oldAddr"));
                gym.setNewAddr(rs.getString("newAddr"));
                gym.setName(rs.getString("name"));
                gym.setY(rs.getDouble("y"));
                gym.setX(rs.getDouble("x"));
                gym.status = rs.getBoolean("status"); // 직접 필드에 설정
                gyms.add(gym);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            disconnect(conn, pstmt, rs); // 부모 클래스의 메서드를 사용
        }
        return gyms;
    }
}
