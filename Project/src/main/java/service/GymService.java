package service;

import model.Gym;
import repository.MapRepository;

import java.util.List;

public class GymService {
    private final MapRepository gymRepository = new MapRepository();


    // 헬스장 상태 업데이트
    public void updateGymStatus(int gymId, boolean status) {
        gymRepository.updateGymStatus(gymId, status);
    }


	public List<Gym> getAllGyms() {
		// TODO Auto-generated method stub
		return null;
	}


	public List<Gym> searchGyms(String searchQuery) {
		// TODO Auto-generated method stub
		return null;
	}
}
