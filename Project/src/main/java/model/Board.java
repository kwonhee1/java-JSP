package model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;

//게시글 클래스
public class Board {
 public int id; // generate created
 public String title;
 public String content;
 public String userName; // String userId
 public String userImgURI;
 public String imgURI; // int imgId
 public int gymId;
 public int rate;
 public String createdAt;
 
 private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
 	public Board() {}	
 	
	public Board(int id, String title, String content, int gymId, int rate) {
		this.id = id;
		this.title = title;
		this.content = content;
		this.gymId = gymId;
		this.rate = rate;
	}
	public Board(String title, String content, int gymId, int rate) {
		this.title = title;
		this.content = content;
		this.gymId = gymId;
		this.rate = rate;
	}
	
	
	public String getUserImgURI() {
		return userImgURI;
	}

	public void setUserImgURI(String userImgURI) {
		this.userImgURI = userImgURI;
	}

	public String getImgURI() {
		return imgURI;
	}
	public void setImgURI(String imgURL) {
		this.imgURI = imgURL;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String author) {
		this.userName = author;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(java.sql.Timestamp createdAt) {
		this.createdAt = sdf.format(createdAt);
	}
	public int getGymId() {
		return gymId;
	}

	public void setGymId(int gymId) {
		this.gymId = gymId;
	}

	public int getRate() {
		return rate;
	}

	public void setRate(int rate) {
		this.rate = rate;
	}
}