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
    private final DataSource dataSource = DatabaseConfig.getDataSource();

    public List<Gym> findAllGyms() {
        List<Gym> gyms = new ArrayList<>();
        String sql = "SELECT * FROM gyms";

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

    public List<Gym> searchGyms(String searchQuery) {
        List<Gym> gyms = new ArrayList<>();
        String sql = "SELECT * FROM gyms WHERE name LIKE ?";

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

    public void updateGymStatus(int gymId, String status) {
        String sql = "UPDATE gyms SET status = ? WHERE id = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, gymId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Gym mapToGym(ResultSet rs) throws SQLException {
        Gym gym = new Gym();
        gym.setId(rs.getInt("id"));
        gym.setName(rs.getString("name"));
        gym.setStatus(rs.getString("status"));
        return gym;
    }
}
