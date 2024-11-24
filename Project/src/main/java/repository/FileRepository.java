package repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class FileRepository extends Repository{
	private Connection conn;
	
	public int insertImage(String imgURI) {
		conn = getConnection();
        String query = "INSERT INTO img(uri) VALUES (?)";
        int imgId = -1;
        try (PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, imgURI);
            
            if(pstmt.executeUpdate() > 0) {
            	ResultSet resultset = pstmt.getGeneratedKeys();
            	if(resultset.next())
            		imgId = resultset.getInt(1);
            }
            
            System.out.println("FileRepository >> insertImage() >> success generated imgId:"+imgId);
        } catch (SQLException e) {
        	System.out.println("FileRepository >> insertImage() >> fail");
            e.printStackTrace();
        }
        disConnection(conn);
        
        return imgId;
    }

	// ID로 URI 조회 메서드
    public String getURI(int primaryKey) {
        conn = getConnection();
        String query = "SELECT uri FROM img WHERE id = ?";
        String uri = null;
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, primaryKey);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    uri = rs.getString("uri");
                    System.out.println("FileRepository >> getURL() >> imgid:"+primaryKey+"uri:"+uri);
                }
            }
        } catch (SQLException e) {
            System.out.println("FileRepository >> getURL() >> fail");
            e.printStackTrace();
        }
        disConnection(conn);
        return uri;
    }

    // 이미지 삭제 메서드
    public void removeImage(int primaryKey) {
        conn = getConnection();
        String query = "DELETE FROM img WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, primaryKey);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("FileRepository >> eraseImage() >> success id:"+primaryKey);
            } else {
                System.out.println("FileRepository >> eraseImage() >> no image found with the given ID");
            }
        } catch (SQLException e) {
            System.out.println("FileRepository >> eraseImage() >> fail");
            e.printStackTrace();
        }
        disConnection(conn);
        
        sortImgId();
    }
    
    private void sortImgId() {
    	conn = getConnection();
    	String sqls = "ALTER TABLE img AUTO_INCREMENT = 1;,"
    				+ "SET @COUNT = 0;,"
    				+ "UPDATE img SET id = @COUNT := @COUNT + 1;";
    	Statement stmt = null;
    	try {
			stmt = conn.createStatement();
			for(String sql : sqls.split(",")) {
				stmt.execute(sql);
			}
		} catch (SQLException e) {
			System.out.println("FileService >> sortImgId() :: fail >> cannot sort primary key imgId");
			e.printStackTrace();
		}finally{
			disconnect(conn, stmt);
		}
    	
    	System.out.println("FileService >> sortImgId() :: success >> sorted primary key imgId");
    }
}
