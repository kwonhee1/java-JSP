package repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import model.Gym;

public class GymRepository {
    private final DataSource dataSource = DatabaseConfig.getDataSource(); // 데이터베이스 연결 설정

    // 모든 헬스장 가져오기
    public List<Gym> findAllGyms() {
        List<Gym> gyms = new ArrayList<>();
        String sql = "SELECT * FROM gym";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                gyms.add(mapToGym(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return gyms;
    }

    // 검색된 헬스장 가져오기
    public List<Gym> searchGyms(String searchQuery) {
        List<Gym> gyms = new ArrayList<>();
        String sql = "SELECT * FROM gym WHERE name LIKE ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + searchQuery + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    gyms.add(mapToGym(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return gyms;
    }

    // 헬스장 상태 업데이트
    public void updateGymStatus(int gymId, String status) {
        String sql = "UPDATE gym SET status = ? WHERE id = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status); // String 값으로 설정
            stmt.setInt(2, gymId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ResultSet을 Gym 객체로 매핑
    private Gym mapToGym(ResultSet rs) throws SQLException {
        Gym gym = new Gym();
        gym.setId(rs.getInt("id"));
        gym.setSiteCode(rs.getString("siteCode")); // 데이터베이스 컬럼 이름과 Gym 필드 매핑
        gym.setOldAddr(rs.getString("oldAddr"));
        gym.setNewAddr(rs.getString("newAddr"));
        gym.setName(rs.getString("name"));
        gym.setX(rs.getDouble("x")); // 좌표 매핑
        gym.setY(rs.getDouble("y"));
        gym.setStatus(rs.getString("status")); // String 값으로 매핑
        return gym;
    }
}
