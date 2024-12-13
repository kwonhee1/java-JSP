package model;

import java.util.HashMap;

import service.CoordinateService;

public class Gym {
	public int id;
	public String siteCode; //OPNSFTEAMCODE 지역 코드
	// public int trdstategbm; // TRDSTATEGBN 영업 상태 코드
	public String oldAddr; // SITEWHLADDR 구 주소
	public String newAddr; //RDNWHLADDR 도로명 주소
	public String name; // BPLCNM 이름
	public double y,x;
	public boolean status; // 1 : 정상 영엄 / 0 : 운영 안함
	
	public Gym(String siteCode, String oldAddr, String newAddr, String name, boolean status) {
		this.siteCode = siteCode;
		this.oldAddr = oldAddr;
		this.newAddr = newAddr;
		this.name = name;
		this.status = status;
	} 
	/*
	<OPNSFTEAMCODE>3160000</OPNSFTEAMCODE> 지역 코드
	<TRDSTATEGBN>01</TRDSTATEGBN>
	<TRDSTATENM>영업/정상</TRDSTATENM>
	<SITEWHLADDR>서울특별시 구로구 가리봉동 25-294 오봉빌딩 </SITEWHLADDR>
	<RDNWHLADDR>서울특별시 구로구 구로동로5길 2, 오봉빌딩 3, 4층 (가리봉동)</RDNWHLADDR>
	<BPLCNM>동양휘트니스</BPLCNM>
	<X>189829.933904895 </X>
	<Y>442550.649761429 </Y>
	 */
	public Gym() {}
	public int getId() {
		return id;
	}

	public void setId(int pk) {
		this.id = pk;
	}

	public String getSiteCode() {
		return siteCode;
	}

	public void setSiteCode(String siteCode) {
		this.siteCode = siteCode;
	}

	public String getOldAddr() {
		return oldAddr;
	}

	public void setOldAddr(String oldAddr) {
		this.oldAddr = oldAddr;
	}

	public String getNewAddr() {
		return newAddr;
	}

	public void setNewAddr(String newAddr) {
		this.newAddr = newAddr;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public double getY() {
		return y;
	}

	public void setY(double y) {
		this.y = y;
	}

	public double getX() {
		return x;
	}

	public void setX(double x) {
		this.x = x;
	}

	@Override
	public String toString() {
		return "Gym [pk=" + id + ", siteCode=" + siteCode + ", oldAddr=" + oldAddr + ", newAddr=" + newAddr + ", name="
				+ name + ", y=" + y + ", x=" + x + "]";
	}
}
