import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.security.MessageDigest;

public class JDBCTest {
	
	public static boolean verifyUser(String username, String password) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			ps = conn.prepareStatement("SELECT username, password FROM Users");
			rs = ps.executeQuery();
			MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
	        byte[] hash = messageDigest.digest(password.getBytes("UTF-8"));
	        StringBuffer hexString = new StringBuffer();
	        for (int i = 0; i < hash.length; i++) {
	            String hex = Integer.toHexString(0xff & hash[i]);
	            if(hex.length() == 1) hexString.append('0');
	            hexString.append(hex);
	        }
			String encryptedString = hexString.toString();
			while (rs.next())
				if (rs.getString("username").equals(username) && rs.getString("password").equals(encryptedString))
					return true;
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (Exception e) {
			System.out.println("Driver Exception: " + e.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		return false;
	}
	
	public static int newUser(String username, String password) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		PreparedStatement ps4 = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			ps2 = conn.prepareStatement("SELECT * FROM Users");
			rs = ps2.executeQuery();
			while (rs.next())
				if (rs.getString("username").equals(username))
					return 1;
			ps3 = conn.prepareStatement("INSERT INTO Schedules (username) VALUES (?)");
			ps3.setString(1,  username);
			int rowsAffected = ps3.executeUpdate();
			ps4 = conn.prepareStatement("SELECT schedule_id FROM Schedules WHERE username=?");
			ps4.setString(1, username);
			rs = ps4.executeQuery();
			rs.next();
			int id = rs.getInt("schedule_id");
			ps = conn.prepareStatement("INSERT INTO Users (username, password, schedule_id) VALUES (?,?,?)");
			ps.setString(1, username);
			ps.setString(2, password);
			ps.setInt(3, id);
			rowsAffected = ps.executeUpdate();
			return 0;
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
			return 0;
		} catch (Exception e) {
			System.out.println("Driver Exception: " + e.getMessage());
			return 0;
		} finally {
			try {
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (ps3 != null) {
					ps3.close();
				}
				if (ps4 != null) {
					ps4.close();
				}
				if (conn != null) {
					conn.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
	}
	
	public static void removeFriend(String user, String frienduser) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		PreparedStatement ps4 = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			//get userid from username
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, user);
			rs = ps.executeQuery();
			rs.next();
            int id  = rs.getInt("user_id");
            String userID = Integer.toString(id);
            
            //get friendid from friend username
            ps2 = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps2.setString(1, frienduser); 
			rs = ps2.executeQuery();
			rs.next();
            int id2  = rs.getInt("user_id");
            String friendID = Integer.toString(id2);
			
			//delete from friend requests
			ps3 = conn.prepareStatement("DELETE FROM User_Has_Friends WHERE user_id=? AND friend_id=?");
			ps3.setString(2, userID);
			ps3.setString(1, friendID);
			int rowsAffected1 = ps3.executeUpdate();
			
			//delete friend request
			ps4 = conn.prepareStatement("DELETE FROM User_Has_Friends WHERE user_id=? AND friend_id=?");
			ps4.setString(1, userID);
			ps4.setString(2, friendID);
			int rowsAffected2 = ps4.executeUpdate();
			
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (Exception e) {
			System.out.println("Driver Exception: " + e.getMessage());
		} finally {
			try {
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (ps3 != null) {
					ps3.close();
				}
				if (ps4 != null) {
					ps4.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
	}
	
	public static void acceptFriendRequest(String user, String frienduser) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		PreparedStatement ps4 = null;
		PreparedStatement ps5 = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			//get userid from username
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, user);
			rs = ps.executeQuery();
			rs.next();
            int id  = rs.getInt("user_id");
            String userID = Integer.toString(id);
            
            //get friendid from friend username
            ps2 = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps2.setString(1, frienduser); 
			rs = ps2.executeQuery();
			rs.next();
            int id2  = rs.getInt("user_id");
            String friendID = Integer.toString(id2);
			
			//delete from friend requests
			ps3 = conn.prepareStatement("DELETE FROM User_Has_Friend_Requests WHERE user_id=? AND friend_id=?");
			ps3.setString(1, userID);
			ps3.setString(2, friendID);
			int rowsAffected = ps3.executeUpdate();
			
			//accept friend request
			ps4 = conn.prepareStatement("INSERT INTO User_Has_Friends (user_id, friend_id) VALUES (?,?)");
			ps4.setString(1, userID);
			ps4.setString(2, friendID);
			rowsAffected = ps4.executeUpdate();
			
			ps5 = conn.prepareStatement("INSERT INTO User_Has_Friends (user_id, friend_id) VALUES (?,?)");
			ps5.setString(2, userID);
			ps5.setString(1, friendID);
			rowsAffected = ps5.executeUpdate();
			
			
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (Exception e) {
			System.out.println("Driver Exception: " + e.getMessage());
		} finally {
			try {
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (conn != null) {
					conn.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (ps3 != null) {
					ps3.close();
				}
				if (ps4 != null) {
					ps4.close();
				}
				if (ps5 != null) {
					ps5.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
	}
	
	public static int sendFriendRequest (String user, String frienduser) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		PreparedStatement ps4 = null;
		PreparedStatement ps5 = null;
		PreparedStatement ps6 = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			//get userid from username
			ps = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps.setString(1, user);
			rs = ps.executeQuery();
			rs.next();
            int id  = rs.getInt("user_id");
            String userID = Integer.toString(id);
            
            //get friendid from friend username
            ps2 = conn.prepareStatement("SELECT * FROM Users WHERE username=?");
			ps2.setString(1, frienduser); 
			rs = ps2.executeQuery();
			rs.next();
            id  = rs.getInt("user_id");
            String friendID = Integer.toString(id);
            
            //check if they tried to send a request to themself
            if (friendID.equals(userID))
            {
            	return 1;
            }
            
            //check if they already sent this person a request
            ps3 = conn.prepareStatement("SELECT * FROM User_Has_Friend_Requests WHERE user_id=? AND friend_id=?");
			ps3.setString(1, userID); 
			ps3.setString(2, friendID); 
			rs = ps3.executeQuery();
			int rowcount = 0;
			if (rs.last()) {
			  rowcount = rs.getRow();
			  rs.beforeFirst();
			}
			if (rowcount > 0)
			{
				return 2;
			}
			
			//check if this person already sent them a request
            ps4 = conn.prepareStatement("SELECT * FROM User_Has_Friend_Requests WHERE user_id=? AND friend_id=?");
			ps4.setString(2, userID); 
			ps4.setString(1, friendID); 
			rs = ps4.executeQuery();
			rowcount = 0;
			if (rs.last()) {
			  rowcount = rs.getRow();
			  rs.beforeFirst();
			}
			if (rowcount > 0)
			{
				return 3;
			}
			
			//check if they are already friends
            ps6 = conn.prepareStatement("SELECT * FROM User_Has_Friends WHERE user_id=? AND friend_id=?");
			ps6.setString(2, userID); 
			ps6.setString(1, friendID); 
			rs = ps6.executeQuery();
			rowcount = 0;
			if (rs.last()) {
			  rowcount = rs.getRow();
			  rs.beforeFirst();
			}
			if (rowcount > 0)
			{
				return 4;
			}
			
			//successfully send request
			ps5 = conn.prepareStatement("INSERT INTO User_Has_Friend_Requests (user_id, friend_id) VALUES (?,?)");
			ps5.setString(2, userID);
			ps5.setString(1, friendID);
			int rowsAffected = ps5.executeUpdate();
			return 0;
			
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
			return 0;
		} catch (Exception e) {
			System.out.println("Driver Exception: " + e.getMessage());
			return 0;
		} finally {
			try {
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (ps3 != null) {
					ps3.close();
				}
				if (ps4 != null) {
					ps4.close();
				}
				if (ps5 != null) {
					ps5.close();
				}
				if (ps6 != null) {
					ps6.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
				return 0;
			}
		}
	}
	
	public static void newEvent(String username, String name, String color, String day, String duration, String time) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		PreparedStatement ps4 = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			ps = conn.prepareStatement("INSERT INTO Events (name, start_time, duration, day, color, username) VALUES (?,?,?,?,?,?)");
			ps.setString(1, name);
			ps.setString(2, time);
			ps.setString(3, duration);
			ps.setString(4, day);
			ps.setString(5, color);
			ps.setString(6, username);
			
			int rowsAffected = ps.executeUpdate();
			
			ps2 = conn.prepareStatement("SELECT event_id FROM Events WHERE name=? AND start_time=? AND duration=? AND day=? AND color=? AND username=?");
			ps2.setString(1, name);
			ps2.setString(2, time);
			ps2.setString(3, duration);
			ps2.setString(4, day);
			ps2.setString(5, color);
			ps2.setString(6, username);
			
			rs = ps2.executeQuery();
			rs.next();
			int event_id = rs.getInt("event_id");
			
			ps3 = conn.prepareStatement("SELECT schedule_id FROM Users WHERE username=?");
			ps3.setString(1, username);
			
			rs = ps3.executeQuery();
			rs.next();
			int schedule_id = rs.getInt("schedule_id");
			
			ps4 = conn.prepareStatement("INSERT INTO Schedule_Has_Events (schedule_id, event_id) VALUES (?,?)");
			ps4.setInt(1, schedule_id);
			ps4.setInt(2, event_id);
			rowsAffected = ps4.executeUpdate();
			
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (Exception e) {
			System.out.println("Driver Exception: " + e.getMessage());
		} finally {
			try {
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (ps3 != null) {
					ps3.close();
				}
				if (ps4 != null) {
					ps4.close();
				}
				if (conn != null) {
					conn.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
	}
	
	public static void editEvent(String username, String name, String color, String day, String duration, String time, String newname, String newcolor, String newduration) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			ps2 = conn.prepareStatement("SELECT event_id FROM Events WHERE name=? AND start_time=? AND duration=? AND day=? AND color=? AND username=?");
			ps2.setString(1, name);
			ps2.setString(2, time);
			ps2.setString(3, duration);
			ps2.setString(4, day);
			ps2.setString(5, color);
			ps2.setString(6, username);
			
			rs = ps2.executeQuery();
			rs.next();
			int event_id = rs.getInt("event_id");
			
			ps = conn.prepareStatement("UPDATE Events SET name=?, color=?, duration=? WHERE event_id=?");
			ps.setString(1, newname);
			ps.setString(2, newcolor);
			ps.setString(3, newduration);
			ps.setInt(4, event_id);
			
			int rowsAffected = ps.executeUpdate();
			
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (Exception e) {
			System.out.println("Driver Exception: " + e.getMessage());
		} finally {
			try {
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn != null) {
					conn.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
	}
	
	public static void deleteEvent(String username, String name, String color, String day, String duration, String time) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		PreparedStatement ps4 = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			ps2 = conn.prepareStatement("SELECT event_id FROM Events WHERE name=? AND start_time=? AND duration=? AND day=? AND color=? AND username=?");
			ps2.setString(1, name);
			ps2.setString(2, time);
			ps2.setString(3, duration);
			ps2.setString(4, day);
			ps2.setString(5, color);
			ps2.setString(6, username);
			
			rs = ps2.executeQuery();
			rs.next();
			int event_id = rs.getInt("event_id");
			
			ps3 = conn.prepareStatement("SELECT schedule_id FROM Users WHERE username=?");
			ps3.setString(1, username);
			
			rs = ps3.executeQuery();
			rs.next();
			int schedule_id = rs.getInt("schedule_id");
			
			ps4 = conn.prepareStatement("DELETE FROM Schedule_Has_Events WHERE schedule_id=? AND event_id=?");
			ps4.setInt(1, schedule_id);
			ps4.setInt(2, event_id);
			int rowsAffected = ps4.executeUpdate();
			
			ps = conn.prepareStatement("DELETE FROM Events WHERE name=? AND start_time=? AND duration=? AND day=? AND color=? AND username=?");
			ps.setString(1, name);
			ps.setString(2, time);
			ps.setString(3, duration);
			ps.setString(4, day);
			ps.setString(5, color);
			ps.setString(6, username);
			
			rowsAffected = ps.executeUpdate();
			
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (Exception e) {
			System.out.println("Driver Exception: " + e.getMessage());
		} finally {
			try {
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (ps3 != null) {
					ps3.close();
				}
				if (ps4 != null) {
					ps4.close();
				}
				if (conn != null) {
					conn.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
	}

	public static void main (String[] args) {
		Connection conn = null;
		Statement st = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			conn = DriverManager.getConnection("jdbc:mysql://localhost/FreeTime?user=root&password=root&useLegacyDatetimeCode=false&serverTimezone=UTC");
			st = conn.createStatement();
			
			ps = conn.prepareStatement("SELECT * FROM Users");
			rs = ps.executeQuery();
			while (rs.next())
				System.out.println("User: " + rs.getString("username") + "\nPassword: " + rs.getString("password"));
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
	}
}