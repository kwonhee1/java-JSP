package service;

import java.io.File;
import java.io.IOException;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;
import repository.FileRepository;

public class FileService {
	private FileRepository repository;
	
	public FileService() { repository = new FileRepository(); }
	
	public int saveFile(String imgURL, Part inputPart, int defaultInt) {
		String inputFileName = getFileName(inputPart);
		if(inputFileName == null) {
			System.out.println("File Service >> saveFile() >> no input file name (no file) >> return default img");
			return defaultInt;
		}
		String imgURI = getFilePath(imgURL, inputFileName+"%d.png");
		try {
			inputPart.write(imgURL + imgURI);
			System.out.println("FileService >> saveFile() >> success save file |inputName="+inputFileName+"|url="+imgURL+"|uri="+imgURI);
		} catch (IOException e) {
			System.out.println("FileService >> saveFile() >> [ERROR] : save fail !!");
			e.printStackTrace();
			return -1;
		}
		
		return repository.insertImage(imgURI);
	}
	
	public void removeImg(String imgURL, int imgId) {
		String imgURI = repository.getURI(imgId);
		try {
			File oldImg = new File(imgURI);
			oldImg.delete();
		}catch(Exception e) {
			System.out.println("FileService >> removeImg() fail uri:"+imgURI);
			e.printStackTrace();
		}
		repository.removeImage(imgId);
		System.out.println("FileService >> removeImg() success uri:"+imgURI);
	}
	
	public int updateImg(String imgURL, int oldImgId, Part inputPart, int defaultInt) {
		if(inputPart == null) {
			// no update img
			return oldImgId;
		}
		removeImg(imgURL, oldImgId);
		return saveFile(imgURL, inputPart, defaultInt); // return created new img id
	}
	
	private String getFilePath(String imgURL, String imgURIFormat) {
		for(int i = 0; i < 100; i++) {
			String imgURI = String.format(imgURIFormat, i);
			File file = new File(imgURL + imgURI);
			if(!file.exists()) {
				return imgURI;
			}
		}
		System.out.println("FileService >> saveFile()>>getFilePath() >> [EROOR] is already exists 100 same name files");
		return null;
	}
	
	private String getFileName(Part part) {
	    for (String content : part.getHeader("content-disposition").split(";")) {
	        if (content.trim().startsWith("filename")) {
	            String fileName = content.substring(content.indexOf("=") + 2, content.length() - 1);
	            return fileName; // .밑에 나머지는 그냥 버림 (대부분 확장자 또는 파일 경로명)
	        }
	    }
		return null;
	}
}
