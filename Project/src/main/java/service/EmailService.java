package service;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.Message;
import javax.mail.MessagingException;

import model.User;

public class EmailService { // 서버에 유일한 class로 종속시켜야함 => servletContentListener에 추가 ? 다른 방법은 없나? 로그인할때 바로?
	private static Map<String, String> db = new HashMap<String, String>();
	private static int key = 1;
	
	//add db + send Email
	public void sendEmail(String inputUserId, String inputUserEmail) {
		String user = "jspproject2024@gmail.com", passwd = "ccdd thdn wdlz ywuw";
		String emailKey = createCode();
		
		 // SMTP 설정
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // TLS 설정
        props.put("mail.smtp.ssl.protocols", "TLSv1.2"); // 최신 TLS 버전 지정
        //props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");

        // 세션 생성
        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, passwd);
            }
        });

        try {
            // 이메일 메시지 작성
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(user));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(inputUserEmail));
            message.setSubject("Login Email Subject");
            message.setText("인증 코드 5자리 : " + emailKey);

            // 이메일 전송
            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
        db.put(emailKey, inputUserId);
        
        System.out.println("Email Sent Successfully to "+ inputUserEmail+ ", emailKey : "+ emailKey);
	}
	
	//check db by key code + update database
	public boolean checkByKeyCode(String inputUserId, String emailKey) {
		// 시간 지난 값들은 db에서 제외하기
		checkDbDate();
		
		System.out.println("EmailService >> checkByKeyCode() >> checking keyCode >> ");
		
		String userDbId = db.get(emailKey);
		if(userDbId == null || !userDbId.equals(inputUserId)) {
			// 잘못된 key값
			return false;
		}else {
			// update Db
			db.remove(emailKey);
			return true;
		}
	}
	
	//create key code
	private String createCode() {
		String random;
		while(true) {
			random = String.valueOf((int) (Math.random()*100000)); // 5자리
		
			if(db.get(random) == null)
				return random;
		}
	}
	
	// 시간 지난 값들은 db에서 제외하기
	private void checkDbDate() {
		
	}
}