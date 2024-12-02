package service;

import model.Gym;
import java.util.List;

public class GymService {
    private final GymRepository gymRepository = new GymRepository();

    // 모든 헬스장 가져오기
    public List<Gym> getAllGyms() {
        return gymRepository.findAllGyms();
    }

    // 헬스장 검색
    public List<Gym> searchGyms(String query) {
        return gymRepository.searchGyms(query);
    }

    // 헬스장 상태 업데이트
    public void updateGymStatus(int gymId, boolean status) {
        gymRepository.updateGymStatus(gymId, status);
    }
}
