package repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

import model.User;

public class LoginRepository extends Repository{
    private Connection conn;
    // 회원 추가
    // SQL: INSERT INTO user (id, passwd, name, authority, email) VALUES (?, ?, ?, ?, ?);
    public boolean addUser(User user) {
        boolean re = false;
        try {
            conn = getConnection();
            PreparedStatement statement = conn.prepareStatement("INSERT INTO user (id, passwd, name, authority, email) VALUES (?, ?, ?, ?, ?);");
            statement.setString(1, user.getId());
            statement.setString(2, user.getPasswd());
            statement.setString(3, user.getName());
            statement.setString(4, user.getAuthority());
            statement.setString(5, user.getEmail());  // Set email
            
            re = statement.executeUpdate() > 0; // 성공시 true 반환
            
            if(re)
                System.out.println("LoginRepository >> success addUser()");
            
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return re;
    }
    
    // ID로 사용자 검색
    // SQL: SELECT * FROM user WHERE id = ?;
    public User getUserById(String id) {
        User user = null;
        Connection conn = null;
        PreparedStatement statement = null;
        ResultSet rs = null;

        try {
            // DB 연결
            conn = getConnection();

            // SQL 쿼리 준비
            String sql = "SELECT u.id, u.passwd, u.name, u.authority, u.email, i.uri AS img " +
                         "FROM user u " +
                         "JOIN img i ON u.imgId = i.id " +
                         "WHERE u.id = ?";
            statement = conn.prepareStatement(sql);
            statement.setString(1, id); // 사용자 ID 매핑

            // 쿼리 실행
            rs = statement.executeQuery();

            // 결과 처리
            if (rs.next()) {
                // user 정보를 User 객체로 생성
                user = new User(
                    rs.getString("id"),
                    rs.getString("passwd"),
                    rs.getString("name"),
                    rs.getString("authority"),
                    rs.getString("email"),
                    rs.getString("img") // 이미지는 img 테이블에서 가져온 uri
                );
                System.out.println("LoginRepository >> success getUserById()");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            // 리소스 해제
            disconnect(conn, statement, rs);
        }
        
        return user;
    }

    
    public int getImgId(String userId) {
        int imgId = 0; // 기본값
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            String sql = "SELECT imgId FROM user WHERE id = ?;";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                imgId = rs.getInt("imgId");
                System.out.println("getImgId() >> 성공적으로 imgId 조회");
            }
        } catch (SQLException e) {
            System.out.println("getImgId() >> 에러 발생");
            e.printStackTrace();
        } finally {
            disconnect(conn, pstmt, rs);
        }
        return imgId;
    }


    public void updateUser(User inputUser, int imgId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        System.out.println("updateUSer() try update "+inputUser.toString());
        try {
            conn = getConnection();
            String sql = "UPDATE user SET passwd = ?, name = ?, email = ?, imgId = ? WHERE id = ?;";
            pstmt = conn.prepareStatement(sql);

            // User 객체의 데이터와 imgId를 설정
            pstmt.setString(1, inputUser.getPasswd());
            pstmt.setString(2, inputUser.getName());
            pstmt.setString(3, inputUser.getEmail());
            pstmt.setInt(4, imgId);
            pstmt.setString(5, inputUser.getId());

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("updateUser() >> success update");
            } else {
                System.out.println("updateUser() >> fail update");
            }
        } catch (SQLException e) {
            System.out.println("updateUser() >> error");
            e.printStackTrace();
        } finally {
            disconnect(conn, pstmt);
        }
    }

}
