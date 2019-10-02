import java.util.*;
import java.io.*;
import java.sql.*;

public class Sample {
	public static void main(String args[]) {
		Scanner in = new Scanner(System.in);
		Random rng = new Random();
		Connection c = null;
		String command, previousCommand, url, user;
		int seed = 0;
		boolean repeat = false;
        boolean last_command = true;
		url = "jdbc:postgresql://stampy.cs.wisc.edu/cs564instr?sslfactory=org.postgresql.ssl.NonValidatingFactory&ssl";
		user = "";
		previousCommand = "";
		command = "";

    System.out.println("\nFor command information, type \"help\"\n");

		do {
			if(!repeat) System.out.print(user + "> ");
			if(!command.equals("") && !command.equals("help") && last_command) previousCommand = command;
			if(!repeat) {command = in.nextLine(); command = command.trim();}
			repeat = false;
            last_command = true;
			switch(command.split(" ")[0]) {
					case "seed":
						try {
							seed = Integer.parseInt(command.split(" ")[1]);
							rng = new Random(seed);
							System.out.println("Seed set to " + seed);
						} catch (NumberFormatException e) {
							System.out.println(command.split(" ")[1] + ":Not valid. Type integer.");
							System.out.println("Usage: > seed <seed value>");
						}
						break;
					case "sample":
						String query = "";
						String table = "";
						int num_sample = 0;
						int num_count = 0;

						if(c == null) {
							System.out.println("Error: Not connected. Use the 'connect' command.");
							break;
						}

						if(command.split(" ").length > 1) {
							try {
								num_sample = Integer.parseInt(command.split(" ")[1]);
							} catch(NumberFormatException e) {
								System.out.println("Error: Required integer number of samples");
								System.out.println("Usage: > sample <number> <table>");
								break;
							}
						}

						if(command.split(" ").length == 3) {
							table = command.split(" ")[2];
							num_count = getnum_countFromTable(table, c);
							if(num_count < 0) break;

							int count = 0;
							int select = 0;

							boolean printAll = num_count < num_sample;
							num_sample = Math.min(num_count, num_sample);
                            boolean firstTime = true;
							while(select < num_sample) {
								if((num_count - count) * rng.nextFloat() < num_sample - select) {
									fetchAndPrintRecord(table, true, count, c, firstTime);
                                    firstTime = false;
									select++;
								}
								count++;
							}

							if(printAll) {
								System.out.println("All records returned.");
							}

						} else if(command.split(" ").length > 3) {
							StringBuilder strBuilder = new StringBuilder();
							for(int i = 2; i < command.split(" ").length; i++) {
								strBuilder.append(command.split(" ")[i] + " ");
							}
							query = strBuilder.toString().trim();

							num_count = getnum_countFromQuery(query, c);
							if(num_count < 0) break;

							int count = 0;
							int select = 0;
							boolean printAll = num_count < num_sample;
							num_sample = Math.min(num_count, num_sample);
							boolean firstTime = true;
							while(select < num_sample) {
								if((num_count - count) * rng.nextFloat() < num_sample - select) {
									fetchAndPrintRecord(query, false, count, c, firstTime);
                                    firstTime = false;
									select++;
								}
								count++;
							}

							if(printAll) {
								System.out.println("All records returned.");
							}

						} else {
							System.out.println("Usage: > sample <number> <table>");
							break;
						}
						break;

					case "connect":
						String password = "";
                        String previousURL = "";
						String className = "org.postgresql.Driver";

						try {
							Class.forName(className);
						} catch (ClassNotFoundException e) {
							System.out.println("Error: " + className + " not found");
						}

						if(command.split(" ").length == 4) {
                            previousURL = url;
							url = command.split(" ")[1];
							user = command.split(" ")[2];
							password = command.split(" ")[3];
						} else if(command.split(" ").length == 2) {
                            previousURL = url;
                            url = command.split(" ")[1];
                        } else if(command.split(" ").length != 1) {
                            System.out.println("Usage: > connect <url> <user> <password>");
                            break;
                        }

                        try {
                            if(command.split(" ").length == 4) {
    							c = DriverManager.getConnection(url, user, password);
                            } else {
                                c = DriverManager.getConnection(url);
                            }
						} catch(SQLException e) {
							System.out.println("Error: Not connected to " + url);
							user = "";
                            url = previousURL;
							e.printStackTrace();
						}

						break;
                    case "quit":
					case "exit":
						try {
							if(c != null) c.close();
						} catch (SQLException e) {
							System.out.println("Error: Unable to close connection");
						}
						System.exit(1);
						break;
					case "re":
						repeat = true;
						command = previousCommand;
						break;
					case "help":
						System.out.println("\n------ Current status ------");
						System.out.println("url  = " + url);
						System.out.println("user = " + (user.equals("") ? "" : user));
						System.out.println("last command = " + previousCommand);
						System.out.println("seed = " + seed);
						System.out.println("\n------ Commands ------");
						System.out.println("seed <seed value>		: gives the specified seed");
						System.out.println("connect		: connect to the last url");
            System.out.println("connect <url>		: connect to the <url>");
            System.out.println("connect <url> <user> <password>		:connect to the specified url");
						System.out.println("sample <number> <table>		:sample the number of sample from table");
						System.out.println("return 	:repeat the last command\n");
						System.out.println("exit, quit:		quit");
						break;
					default:
						if(command.length() > 0) System.out.println("Not valid command : " + command);
                        last_command = false;
			}
		} while(!command.equals("exit"));
	}

	private static int getnum_countFromTable(String table, Connection c) {
		int num_count = 0;
		try {
			Statement stmt = c.createStatement();
			ResultSet data = stmt.executeQuery("select count(*) as rowCount from " + table + " as countTable;");
			if(data.next()) {
				num_count = data.getInt("rowCount");
			}
			stmt.close();
		} catch(SQLException e) {
			System.out.println("Error: Cannot get number of records in table :" + table);
			num_count = -1;
		}

		return num_count;
	}

	private static int getnum_countFromQuery(String query, Connection c) {
		int num_count = 0;
		try {
			Statement stmt = c.createStatement();
			ResultSet data = stmt.executeQuery("select count(*) as rowCount from (" + query + ") as countTable;");
			if(data.next()) {
				num_count = data.getInt("rowCount");
			}
			stmt.close();
		} catch(SQLException e) {
			System.out.println("Error: Cannot read number of records in query");
			num_count = -1;
		}

		return num_count;
	}

	private static void fetchAndPrintRecord(String query, boolean isTable, int count, Connection c, boolean printColNames) {
		try {
			Statement stmt = c.createStatement();
			ResultSet rs;
			if(isTable) {
				rs = stmt.executeQuery("select * from (select ROW_NUMBER() over () as rownum, * from " + query + ") as tbl where tbl.rownum = " + (count + 1) + ";");
			} else {
				rs = stmt.executeQuery("select * from (select ROW_NUMBER() over () as rownum, * from (" + query + ") as someHopefullyUniqueTableName) as tbl where tbl.rownum = " + (count + 1) + ";");
			}
			ResultSetMetaData rsmd = rs.getMetaData();
			ArrayList<String> cols = new ArrayList<String>();
			for(int i = 1; i <= rsmd.getColumnCount(); i++) {
				if(!rsmd.getColumnName(i).equals("rownum")) {
                    cols.add(rsmd.getColumnName(i));
                }
			}

			while(rs.next()) {
                if(printColNames) {
                    for(int i = 0; i < cols.size(); i++) {
                        System.out.print(cols.get(i) + ((i != cols.size() - 1) ? " | " : ""));
				    }
                    System.out.println();
                }
				for(int i = 0; i < cols.size(); i++) {
					String seperator = "";
					if(i < cols.size() - 1) seperator = " | ";
					System.out.print(rs.getString(cols.get(i)) + seperator);
				}
				System.out.println();
			}
			rs.close();
			stmt.close();
		} catch(SQLException e) {
			System.out.println("Error: Cannot process sample query");
			e.printStackTrace();
		}
	}
}
