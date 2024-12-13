package repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.Gym;

public class MapRepository extends Repository {
	public void save(ArrayList<Gym> gyms) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    String sql = "INSERT INTO gym (siteCode, oldAddr, newAddr, name, x, y, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
	    
	    try {
	        conn = getConnection();
	        pstmt = conn.prepareStatement(sql);
	        
	        for (Gym gym : gyms) {
	            pstmt.setString(1, gym.siteCode);
	            pstmt.setString(2, gym.oldAddr);
	            pstmt.setString(3, gym.newAddr);
	            pstmt.setString(4, gym.name);
	            pstmt.setDouble(5, gym.x);
	            pstmt.setDouble(6, gym.y);
	            pstmt.setBoolean(7, gym.status);
	            pstmt.addBatch(); // Batch 처리
	        }
	        
	        pstmt.executeBatch(); // 실행
	    } catch (SQLException e) {
	        System.out.println("Maprepository >> save fail");
	        e.printStackTrace();
	    } finally {
	        disconnect(conn, pstmt);
	    }
	    System.out.println("Maprepository >> save success");
	}
	
	// 새로 생긴 데이터 들은 모두 더함 + 없어진 데이터들은 운영안한 처리
	public void updateAll(ArrayList<Gym> gyms) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = getConnection();

	        // 1. 임시 테이블 생성 (필요시 한 번만 생성)
	        String deleteTemp = "delete from gym_temp";
	        pstmt = conn.prepareStatement(deleteTemp);
	        pstmt.execute();
	        pstmt.close();

	        // 2. 임시 테이블에 입력 데이터 삽입
	        String insertTempSql = """
	            INSERT INTO temp_gym (siteCode, oldAddr, newAddr, name, x, y)
	            VALUES (?, ?, ?, ?, ?, ?)
	        """;
	        pstmt = conn.prepareStatement(insertTempSql);
	        for (Gym gym : gyms) {
	            pstmt.setString(1, gym.siteCode);
	            pstmt.setString(2, gym.oldAddr);
	            pstmt.setString(3, gym.newAddr);
	            pstmt.setString(4, gym.name);
	            pstmt.setDouble(5, gym.x);
	            pstmt.setDouble(6, gym.y);
	            pstmt.setBoolean(7, gym.status);
	            pstmt.addBatch();
	        }
	        pstmt.executeBatch();
	        pstmt.close();

	        // 3. 새로운 데이터 추가 (temp_gym에 있지만 gym에 없는 데이터)
	        String insertNewDataSql = """
	            DELETE g
	        		FROM gym g
	        		LEFT JOIN gym_temp t 
	        		ON t.name = g.name AND t.x = g.x AND t.y = g.y 
	        		WHERE t.siteCode IS NULL;
	        """;
	        pstmt = conn.prepareStatement(insertNewDataSql);
	        pstmt.executeUpdate();
	        pstmt.close();

	        // 4. 입력 데이터에 없는 기존 데이터 비활성화
	        String deactivateOldDataSql = """
	            insert into gym (siteCode, oldAddr, newAddr, name, x, y, status)
	        		     	select t.siteCode, t.oldAddr, t.newAddr, t.name, t.x, t.y, t.status 
	        				from gym g right JOIN gym_temp t ON t.name = g.name AND t.x = g.x AND t.y = g.y where g.id is null;
	        """;
	        pstmt = conn.prepareStatement(deactivateOldDataSql);
	        pstmt.executeUpdate();
	        pstmt.close();

	        // 5. 임시 테이블 삭제
	        pstmt = conn.prepareStatement(deleteTemp);
	        pstmt.execute();
	        pstmt.close();

	    } catch (SQLException e) {
	        System.out.println("repository:update error :: cannot update gyms");
	        e.printStackTrace();
	    } finally {
	        disconnect(conn, pstmt, rs);
	    }
	}

	public void update(Gym gym) {
		// update set gym where gym.id == id
	}


	public ArrayList<Gym> getAllGyms() {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList<Gym> gyms = new ArrayList<>();
	    String sql = "SELECT * FROM gym";
	    
	    try {
	        conn = getConnection();
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            Gym gym = new Gym();
	            gym.id = rs.getInt("id");
	            gym.siteCode = rs.getString("siteCode");
	            gym.oldAddr = rs.getString("oldAddr");
	            gym.newAddr = rs.getString("newAddr");
	            gym.name = rs.getString("name");
	            gym.x = rs.getDouble("x");
	            gym.y = rs.getDouble("y");
	            gym.status = rs.getBoolean("status");
	            gyms.add(gym);
	        }
	    } catch (SQLException e) {
	        System.out.println("maprepository >> getAllGyms fail :: cannot retrieve gyms");
	        e.printStackTrace();
	    } finally {
	        disconnect(conn, pstmt, rs);
	    }
	    System.out.println("maprepository >> getAllGyms success");
	    return gyms;
	}
	
	public ArrayList<Gym> getAvaliableGyms(String siteCode) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList<Gym> gyms = new ArrayList<>();
	    String sql = "SELECT * FROM gym WHERE siteCode = ? and status = true";
	    
	    try {
	        conn = getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, siteCode);
	        rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            Gym gym = new Gym();
	            gym.id = rs.getInt("id");
	            gym.siteCode = rs.getString("siteCode");
	            gym.oldAddr = rs.getString("oldAddr");
	            gym.newAddr = rs.getString("newAddr");
	            gym.name = rs.getString("name");
	            gym.x = rs.getDouble("x");
	            gym.y = rs.getDouble("y");
	            gyms.add(gym);
	        }
	    } catch (SQLException e) {
	        System.out.println("maprepository >> getAvaliableGyms fail :: cannot retrieve gyms");
	        e.printStackTrace();
	    } finally {
	        disconnect(conn, pstmt, rs);
	    }
	    System.out.println("maprepository >> getAvaliableGyms success");
	    return gyms;
	}
	
	public void deleteAll() {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    String sql = "DELETE FROM gym";
	    
	    try {
	        conn = getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.executeUpdate();
	    } catch (SQLException e) {
	        System.out.println("maprepository:deleteAll error :: cannot delete all gyms");
	        e.printStackTrace();
	    } finally {
	        disconnect(conn, pstmt);
	    }
	    System.out.println("maprepository >> deleteAll success");
	}

	
	public ArrayList<Gym> getGymsWithName(String name) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList<Gym> gyms = new ArrayList<>();
	    String sql = "SELECT * FROM gym WHERE name LIKE ? AND status = true";
	    
	    try {
	        conn = getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, "%" + name + "%"); // 부분 일치를 위한 LIKE 조건
	        rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            Gym gym = new Gym();
	            gym.id = rs.getInt("id");
	            gym.siteCode = rs.getString("siteCode");
	            gym.oldAddr = rs.getString("oldAddr");
	            gym.newAddr = rs.getString("newAddr");
	            gym.name = rs.getString("name");
	            gym.x = rs.getDouble("x");
	            gym.y = rs.getDouble("y");
	            gym.status = rs.getBoolean("status");
	            gyms.add(gym);
	        }
	    } catch (SQLException e) {
	        System.out.println("maprepository >> getGymsWithName fail :: no gyms with name containing " + name);
	        e.printStackTrace();
	        disconnect(conn, pstmt, rs);
	        return null;
	    } 
	    disconnect(conn, pstmt, rs);
	    System.out.println("maprepository >> getGymsWithName success count : " + gyms.size());
	    return gyms;
	}
	
	public Gym getGymAdmin(String name) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = "SELECT * FROM gym WHERE name = ?;";
	    Gym gym = new Gym();
	    
	    try {
	        conn = getConnection();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, name); // 부분 일치를 위한 LIKE 조건
	        rs = pstmt.executeQuery();
	        
	        while (rs.next()) {
	            gym.id = rs.getInt("id");
	            gym.siteCode = rs.getString("siteCode");
	            gym.oldAddr = rs.getString("oldAddr");
	            gym.newAddr = rs.getString("newAddr");
	            gym.name = rs.getString("name");
	            gym.x = rs.getDouble("x");
	            gym.y = rs.getDouble("y");
	            gym.status = rs.getBoolean("status");
	        }
	    } catch (SQLException e) {
	        System.out.println("maprepository >> getGymAdmin fail :: no gyms with name containing " + name);
	        e.printStackTrace();
	        disconnect(conn, pstmt, rs);
	        return null;
	    } 
	    disconnect(conn, pstmt, rs);
	    System.out.println("maprepository >> getGymAdmin success count : " + gym.toString());
	    return gym;
	}

	public void updateGymStatus(int gymId,  int status) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    String sql = "UPDATE gym SET status = ? WHERE id = ?"; // 헬스장 상태 업데이트 쿼리

	    try {
	        conn = getConnection(); // 데이터베이스 연결
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, status); // 상태 값 설정
	        pstmt.setInt(2, gymId); // 헬스장 ID 설정

	        int rowsUpdated = pstmt.executeUpdate(); // 쿼리 실행

	        if (rowsUpdated > 0) {
	            System.out.println("헬스장 상태 업데이트 성공: ID=" + gymId + ", status=" + status);
	        } else {
	            System.out.println("헬스장 상태 업데이트 실패: ID=" + gymId + "를 찾을 수 없습니다.");
	        }
	    } catch (SQLException e) {
	        System.out.println("헬스장 상태 업데이트 중 오류 발생");
	        e.printStackTrace();
	    } finally {
	        disconnect(conn, pstmt); // 자원 해제
	    }
	}

}
