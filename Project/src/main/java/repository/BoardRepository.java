package repository;

import model.Board;

import java.sql.*;
import java.util.ArrayList;

public class BoardRepository extends Repository {

	public ArrayList<Board> getBoardList(int gymId) {
	    String sql = "SELECT b.id, b.title, b.content, u.name AS userName, i.uri AS imgURI, b.rate, b.created_at, i2.uri as userImgURI " +
	                 "FROM board b " +
	                 "LEFT JOIN user u ON b.userId = u.id " +
	                 "LEFT JOIN img i ON b.imgId = i.id " +
	                 "left join img i2 on u.imgId = i2.id "+
	                 "WHERE b.gymId = ?;";
	    ArrayList<Board> boardList = new ArrayList<>();
	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, gymId);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                Board board = new Board();
	                board.setId(rs.getInt("id"));
	                board.setTitle(rs.getString("title"));
	                board.setContent(rs.getString("content"));
	                board.setUserName(rs.getString("userName"));
	                board.setImgURI(rs.getString("imgURI"));
	                board.setRate(rs.getInt("rate"));
	                board.setCreatedAt(rs.getTimestamp("created_at"));
	                board.setUserImgURI(rs.getString("userImgURI"));
	                boardList.add(board);
	            }
	        }
	        System.out.println("BoardRepository >> getBoardList >> success");
	    } catch (SQLException e) {
	        System.out.println("BoardRepository >> getBoardList >> fail");
	        e.printStackTrace();
	    }
	    return boardList;
	}
	
	public ArrayList<Board> getAllBoardList() {
	    String sql = "SELECT b.id, b.title, b.content, u.name AS userName, i.uri AS imgURI, b.rate, b.created_at, i2.uri as userImgURI " +
	                 "FROM board b " +
	                 "LEFT JOIN user u ON b.userId = u.id " +
	                 "LEFT JOIN img i ON b.imgId = i.id " +
	                 "left join img i2 on u.imgId = i2.id;";
	    ArrayList<Board> boardList = new ArrayList<>();
	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                Board board = new Board();
	                board.setId(rs.getInt("id"));
	                board.setTitle(rs.getString("title"));
	                board.setContent(rs.getString("content"));
	                board.setUserName(rs.getString("userName"));
	                board.setImgURI(rs.getString("imgURI"));
	                board.setRate(rs.getInt("rate"));
	                board.setCreatedAt(rs.getTimestamp("created_at"));
	                board.setUserImgURI(rs.getString("userImgURI"));
	                boardList.add(board);
	            }
	        }
	        System.out.println("BoardRepository >> getAllBoardList >> success");
	    } catch (SQLException e) {
	        System.out.println("BoardRepository >> getAllBoardList >> fail");
	        e.printStackTrace();
	    }
	    return boardList;
	}

	public void create(Board board, String userId, Integer imgId) {
	    String sql = "INSERT INTO board (title, content, userId, imgId, gymId, rate) VALUES (?, ?, ?, ?, ?, ?)";
	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, board.getTitle());
	        pstmt.setString(2, board.getContent());
	        pstmt.setString(3, userId);
	        if (imgId != null) {
	            pstmt.setInt(4, imgId);
	        } else {
	            pstmt.setNull(4, java.sql.Types.INTEGER);
	        }
	        pstmt.setInt(5, board.getGymId());
	        pstmt.setInt(6, board.getRate());
	        pstmt.executeUpdate();
	        System.out.println("BoardRepository >> create >> success");
	    } catch (SQLException e) {
	        System.out.println("BoardRepository >> create >> fail");
	        e.printStackTrace();
	    }
	}

	public Board getBoard(int boardId) {
	    String sql = "SELECT b.id, b.title, b.content, i.uri AS imgURI, b.gymId, b.rate, b.created_at " +
	                 "FROM board b " +
	                 "LEFT JOIN img i ON b.imgId = i.id " +
	                 "WHERE b.id = ?";
	    Board board = null;
	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, boardId);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                board = new Board();
	                board.setId(rs.getInt("id"));
	                board.setTitle(rs.getString("title"));
	                board.setContent(rs.getString("content"));
	                board.setImgURI(rs.getString("imgURI"));
	                board.setGymId(rs.getInt("gymId"));
	                board.setRate(rs.getInt("rate"));
	                board.setCreatedAt(rs.getTimestamp("created_at"));
	            }
	        }
	        System.out.println("BoardRepository >> getBoard >> success");
	    } catch (SQLException e) {
	        System.out.println("BoardRepository >> getBoard >> fail");
	        e.printStackTrace();
	    }
	    return board;
	}

	public void remove(int boardId) {
	    String sql = "DELETE FROM board WHERE id = ?";
	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, boardId);
	        pstmt.executeUpdate();
	        System.out.println("BoardRepository >> remove >> success");
	    } catch (SQLException e) {
	        System.out.println("BoardRepository >> remove >> fail");
	        e.printStackTrace();
	    }
	}
	
	// 게시글 삭제
	public void deleteBoard(int boardId) {
	    String sql = "DELETE FROM board WHERE id = ?";
	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setInt(1, boardId);
	        pstmt.executeUpdate();
	        System.out.println("BoardRepository >> deleteBoard >> success");
	    } catch (SQLException e) {
	        System.out.println("BoardRepository >> deleteBoard >> fail");
	        e.printStackTrace();
	    }
	}

	public boolean update(Board board, String userId, Integer imgId) {
	    String sql = "UPDATE board SET title = ?, content = ?, userId = ?, imgId = ?, rate = ? WHERE id = ?";
	    try (Connection conn = getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, board.getTitle());
	        pstmt.setString(2, board.getContent());
	        pstmt.setString(3, userId);
	        if (imgId != null) {
	            pstmt.setInt(4, imgId);
	        } else {
	            pstmt.setNull(4, java.sql.Types.INTEGER);
	        }
	        pstmt.setInt(5, board.getRate());
	        pstmt.setInt(6, board.getId());
	        pstmt.executeUpdate();
	        System.out.println("BoardRepository >> update >> success");
	        return true;
	    } catch (SQLException e) {
	        System.out.println("BoardRepository >> update >> fail");
	        e.printStackTrace();
	    }
	    return false;
	}


    public String getUserIdWithBoardId(int boardId) {
        String sql = "SELECT userId FROM board WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String userId = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, boardId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                userId = rs.getString("userId");
            }
            System.out.println("BoardRepository >> getUserIdWithBoardId >> success");
        } catch (SQLException e) {
            System.out.println("BoardRepository >> getUserIdWithBoardId >> fail");
            e.printStackTrace();
        } finally {
            disconnect(conn, pstmt, rs);
        }

        return userId;
    }

    public String getImgURIWithBoardId(int boardId) {
        String sql = "SELECT i.uri " +
                     "FROM board b " +
                     "LEFT JOIN img i ON b.imgId = i.id " +
                     "WHERE b.id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String imgURI = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, boardId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                imgURI = rs.getString("uri");
            }
            System.out.println("BoardRepository >> getImgURIWithBoardId >> success");
        } catch (SQLException e) {
            System.out.println("BoardRepository >> getImgURIWithBoardId >> fail");
            e.printStackTrace();
        } finally {
            disconnect(conn, pstmt, rs);
        }

        return imgURI;
    }

    public int getImgIdWithBoardId(int boardId) {
        String sql = "SELECT imgId FROM board WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int imgId = -1;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, boardId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                imgId = rs.getInt("imgId");
            }
            System.out.println("BoardRepository >> getImgIdWithBoardId >> success");
        } catch (SQLException e) {
            System.out.println("BoardRepository >> getImgIdWithBoardId >> fail");
            e.printStackTrace();
        } finally {
            disconnect(conn, pstmt, rs);
        }

        return imgId;
    }
}
