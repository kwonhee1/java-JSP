package repository;

import model.Gym;
import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GymRepository {
    private final DataSource dataSource = DatabaseConfig.getDataSource();

    // 모든 헬스장 가져오기
    public List<Gym> findAllGyms() {
        List<Gym> gyms = new ArrayList<>();
        String sql = "SELECT * FROM gyms"; // 여기에 맞는 테이블 이름을 사용하세요.

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

    // 헬스장 검색
    public List<Gym> searchGyms(String searchQuery) {
        List<Gym> gyms = new ArrayList<>();
        String sql = "SELECT * FROM gyms WHERE name LIKE ?"; // 여기에 맞는 테이블 이름을 사용하세요.

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
    public void updateGymStatus(int gymId, boolean status) {
        String sql = "UPDATE gyms SET status = ? WHERE id = ?"; // 여기에 맞는 테이블 이름을 사용하세요.

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, status);
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
        gym.setSiteCode(rs.getString("siteCode"));
        gym.setOldAddr(rs.getString("oldAddr"));
        gym.setNewAddr(rs.getString("newAddr"));
        gym.setName(rs.getString("name"));
        gym.setX(rs.getDouble("x")); // X 좌표
        gym.setY(rs.getDouble("y")); // Y 좌표
        gym.setStatus(rs.getBoolean("status")); // 운영 상태
        return gym;
    }
}
