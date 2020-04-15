import java.util.ArrayList;

public class User {
	private ArrayList<User> friends = new ArrayList<User>();
	private Schedule schedule = new Schedule();
	
	public void addEvent(Event e) {
		schedule.add(e);
	}
	
	public void removeEvent(Event e) {
		schedule.remove(e);
	}
	
	public void editEvent(Event e) {
		
	}
	
	public void viewSchedule() {
		
	}
	
	public void clearSchedule() {
		for (int i = schedule.events.size() - 1; i >= 0; --i)
			schedule.events.remove(i);
	}
	
	public void requestFriend() {
		
	}
	
	public void removeFriend() {
		
	}
	
	public void combineSchedule(User friend) {
		
	}
	
}
