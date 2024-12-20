package service;

import java.util.ArrayList;

import jakarta.servlet.http.Part;
import model.Board;
import model.User;
import repository.BoardRepository;
import repository.LoginRepository;

public class BoardService {
	BoardRepository repository = new BoardRepository();
	
	public void createBoard(Board board, String userId,int imgId) {	
		repository.create(board,userId, imgId);
	}
	
	public boolean removeBoard(int boardId, String imgURL, User user) {
		//Board board = repository.getBoard(boardId);
		
		if(isSameUserId(boardId, user))
			return false;
		
		//get imgId from Board database
		int imgId = repository.getImgIdWithBoardId(boardId);
		
		new FileService().removeImg(imgURL, imgId);
		repository.remove(boardId);
		
		return true;
	}
	
	public boolean updateBoard(Board board, User user, String imgURL,Part inputPart) {
		int boardId = board.getId();
		
		FileService fileService = new FileService();
		
		String oldUserId = repository.getUserIdWithBoardId(boardId);
		if(!user.isAdmin() && !oldUserId.equals(user.getId())) {
			System.out.println("user id가 일치 하지 않음");
			return false;
		}
		
		int oldImgId = repository.getImgIdWithBoardId(boardId);
		
		int newImgId = fileService.updateImg(imgURL, oldImgId, inputPart, 2);
		
		if(!repository.update(board, user.getId(), newImgId)) {
			System.out.println("BoardService >> updateBoard() >> repository.update() >> fail");
			return false;
		}
		System.out.println("BoardService >> updateBoard() >> success");
		return true;
	}
	
	private boolean isSameUserId(int boardId, User user) {
		return !(repository.getUserIdWithBoardId(boardId).equals(user.getId()) || user.isAdmin());
	}
}
