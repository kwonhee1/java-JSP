package model;

public class User {
	public String id, name, passwd, email, imgURI;
	public String authority; // "user" / "admin"
	public String key;
	
	public boolean isAdmin() {
		return authority.equals("admin");
	}
	
	public String getImgURI() {
		return imgURI;
	}

	public void setImgURI(String img) {
		this.imgURI = img;
	}
	public User() {}
	//check id passwd  >> login 
	public User(String id, String email) {
		this.id = id;
		this.email = email;
	}
	
	// create User
	public User(String id, String passwd, String name, String email) {
		this.id = id;
		this.passwd = passwd;
		this.name = name;
		this.email = email;
		authority = "user";
	}
	
	//get from DataBase
	public User(String id, String passwd, String name, String au,String email, String img) {
		this.id = id;
		this.passwd = passwd;
		this.name = name;
		this.authority = au;
		this.email = email;
		this.imgURI = img;
	}

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPasswd() {
		return passwd;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	public String getAuthority() {
		return authority;
	}
	public void setAuthority(String authority) {
		this.authority = authority;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getEmail() {
		return email;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getKey() {
		return key;
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", name=" + name + ", passwd=" + passwd + ", email=" + email + ", imgURI=" + imgURI
				+ ", authority=" + authority + ", key=" + key + "]";
	}

}
