package service;

import model.User;
import java.util.List;
import java.util.ArrayList;

public class UserService {
    
    // 사용자 목록을 가져오는 메소드
    public List<User> getAllUsers() {
        // 여기서는 예시로 더미 데이터를 반환합니다. 실제로는 데이터베이스에서 데이터를 조회해야 합니다.
        List<User> userList = new ArrayList<>();
        
        // 예시로 더미 데이터 추가
        userList.add(new User("user1", "user1@example.com", "010-1234-5678", null));
        userList.add(new User("user2", "user2@example.com", "010-2345-6789", null));
        
        return userList;
    }

    // 사용자 정보를 수정하는 메소드
    public void updateUser(String userId, String newEmail, String newPhone) {
        // 실제로는 데이터베이스에서 사용자 정보를 수정하는 로직을 추가해야 합니다.
        System.out.println("사용자 ID: " + userId + " 의 이메일과 전화번호를 수정했습니다.");
        System.out.println("새로운 이메일: " + newEmail + ", 새로운 전화번호: " + newPhone);
    }

    // 사용자 정보를 삭제하는 메소드
    public void deleteUser(String userId) {
        // 실제로는 데이터베이스에서 사용자 정보를 삭제하는 로직을 추가해야 합니다.
        System.out.println("사용자 ID: " + userId + " 을(를) 삭제했습니다.");
    }
}
