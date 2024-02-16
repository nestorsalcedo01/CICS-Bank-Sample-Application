

package com.ibm.cics.cip.bankliberty.web.db2;


import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.logging.LogManager;
import java.util.logging.Logger;

import com.ibm.cics.cip.bankliberty.api.json.AccountJSON;
import com.ibm.cics.cip.bankliberty.api.json.CounterResource;
import com.ibm.cics.cip.bankliberty.api.json.HBankDataAccess;
import com.ibm.cics.server.InvalidRequestException;
import com.ibm.cics.server.Task;

public class Account extends HBankDataAccess{

	/**
	 * Licensed Materials - Property of IBM
	 *
	 * (c) Copyright IBM Corp. 2020.
	 *
	 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
	 * 
	 */

	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";
	private static Logger logger = Logger.getLogger("com.ibm.cics.cip.bankliberty.web.db2");
	// </copyright>

	// String ACCOUNT_EYECATCHER             CHAR(4),
	private 	String 		customer_number;
	private 	String 		sortcode;              
	private 	String 		account_number;
	private 	String 		type;
	private 	double 		interest_rate;
	private 	Date 		opened;
	private 	int 		overdraft_limit;
	private 	Date 		last_statement;
	private 	Date 		next_statement;
	private	 	double 		available_balance;    
	private 	double 		actual_balance;

	public Account()
	{
		sortOutLogging();
	}



	public Account (String c_n, String sc, String a_n, String type, double i_r, Date opened, int o_l, Date l_s, Date n_s, double av_b, double ac_b) {
		setCustomer_number(c_n);
		setSortcode(sc);
		setAccount_number(a_n);
		setType(type);
		setInterest_rate(i_r);
		setOpened(opened);
		setOverdraft_limit(o_l);
		setLast_statement(l_s);
		setNext_statement(n_s);
		setAvailable_balance(av_b);
		setActual_balance(ac_b);
		sortOutLogging();
	}

	public Account(String c_n, String sc, String a_n, String type, double i_r, java.util.Date opened,
			int o_l, Date l_s, Date n_s, double av_b, double ac_b) {
		setCustomer_number(c_n);
		setSortcode(sc);
		setAccount_number(a_n);
		setType(type);
		setInterest_rate(i_r);
		setOpened(new Date(opened.getTime()));
		setOverdraft_limit(o_l);
		setLast_statement(l_s);
		setNext_statement(n_s);
		setAvailable_balance(av_b);
		setActual_balance(ac_b);
		sortOutLogging();
	}

	public void showInfo(){
		logger.fine("------------"+this.account_number+":"+this.sortcode+"------------");
		logger.fine("Customer number - "+this.customer_number);
		logger.fine("Type - "+this.type);
		logger.fine("Interest rate - "+this.interest_rate);
		logger.fine("Opened - "+this.opened.toString());
		logger.fine("Overdraft Limit - "+this.overdraft_limit);
		logger.fine("Last Statement - "+this.last_statement.toString());
		logger.fine("Next Statement - "+this.next_statement.toString());
		logger.fine("Available Balance - "+this.available_balance);
		logger.fine("Actual Balance - "+this.actual_balance);
	}

	public String getCustomer_number() {
		if(this.customer_number.length()<10)
		{
			for (int i=10;this.customer_number.length()<10;i--)
			{
				this.customer_number = "0" + this.customer_number;
			}
		}
		return this.customer_number;
	}

	public void setCustomer_number(String customer_number) {
		
		if(customer_number.length()<10)
		{
			for (int i=10;customer_number.length()<10;i--)
			{
				customer_number = "0" + customer_number;
			}
		}
		this.customer_number = customer_number;
	}

	public String getSortcode() {
		return sortcode;
	}

	public void setSortcode(String sortcode) {
		this.sortcode = sortcode;
	}

	public String getAccount_number() {
		if(this.account_number.length()<9)
		{
			for (int i=8;this.account_number.length()<9;i--)
			{
				this.account_number = "0" + this.account_number;
			}
		}
		return this.account_number;
	}

	public void setAccount_number(String account_number) {
		if(account_number.length()<9)
		{
			for (int i=8;account_number.length()<9;i--)
			{
				account_number = "0" + account_number;
			}
		}
		this.account_number = account_number;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public double getInterest_rate() {
		return interest_rate;
	}

	public void setInterest_rate(double interest_rate) {
		this.interest_rate = interest_rate;
	}

	public Date getOpened() {
		return opened;
	}

	public void setOpened(Date opened) {
		this.opened = opened;
	}

	public int getOverdraft_limit() {
		return overdraft_limit;
	}

	public void setOverdraft_limit(int overdraft_limit) {
		this.overdraft_limit = overdraft_limit;
	}

	public Date getLast_statement() {
		return last_statement;
	}

	public void setLast_statement(Date last_statement) {
		if(last_statement == null){
			this.last_statement = this.opened;
		}
		else{
			this.last_statement = last_statement;
		}
	}

	public Date getNext_statement() {
		return next_statement;
	}

	@SuppressWarnings("static-access")
	public void setNext_statement(Date next_statement) {
		if(next_statement == null){
			Calendar cal = Calendar.getInstance();
			cal.setTime(opened);
			cal.add(cal.DATE, +7);
			this.next_statement =  new Date(cal.getTime().getTime());
		}
		else{
			this.next_statement = next_statement;
		}
	}



	public double getAvailable_balance() {
		return available_balance;
	}

	public void setAvailable_balance(double available_balance) {
		this.available_balance = available_balance;
	}

	public double getActual_balance() {
		return actual_balance;
	}

	public void setActual_balance(double actual_balance) {
		this.actual_balance = actual_balance;
	}

	public void updateThis(){
		openConnection();

		String sql = "UPDATE ACCOUNT "+
				"SET"+
				" ACCOUNT_TYPE = '"+this.type+"'"+
				" ,ACCOUNT_INTEREST_RATE = "+this.interest_rate+
				" ,ACCOUNT_OVERDRAFT_LIMIT = "+this.overdraft_limit+
				" ,ACCOUNT_LAST_STATEMENT = '"+this.last_statement.toString()+"'"+
				" ,ACCOUNT_NEXT_STATEMENT = '"+this.next_statement.toString()+"'"+
				" ,ACCOUNT_AVAILABLE_BALANCE = "+this.available_balance+
				" ,ACCOUNT_ACTUAL_BALANCE = "+this.actual_balance+
				" WHERE ACCOUNT_NUMBER like '"+this.account_number+"'"+
				" AND ACCOUNT_SORTCODE like '"+this.sortcode+"'";
		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void addToDB(){
		openConnection();

		String sql = "INSERT INTO ACCOUNT "+
				"(ACCOUNT_EYECATCHER,"+
				"ACCOUNT_CUSTOMER_NUMBER,"+
				"ACCOUNT_SORTCODE,"+
				"ACCOUNT_NUMBER,"+
				"ACCOUNT_TYPE,"+
				"ACCOUNT_INTEREST_RATE,"+
				"ACCOUNT_OPENED,"+
				"ACCOUNT_OVERDRAFT_LIMIT,"+
				"ACCOUNT_LAST_STATEMENT,"+
				"ACCOUNT_NEXT_STATEMENT,"+
				"ACCOUNT_AVAILABLE_BALANCE,"+
				"ACCOUNT_ACTUAL_BALANCE) "+
				"Values("+
				"'ACCT',"+
				"'"+String.format("%010d",Integer.parseInt(this.customer_number))+"',"+
				"'"+this.sortcode+"',"+
				"'"+String.format("%08d",Integer.parseInt(this.account_number))+"',"+
				"'"+this.type+"',"+
				""+this.interest_rate+","+
				"'"+this.opened.toString()+"',"+
				""+this.overdraft_limit+","+
				"'"+this.last_statement.toString()+"',"+
				"'"+this.next_statement.toString()+"',"+
				""+this.available_balance+","+
				""+this.actual_balance+")";

		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}
	public boolean inDB(){
		openConnection();
		boolean temp = false;
		String sql = "SELECT * from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_NUMBER = "+this.account_number+" and ACCOUNT_SORTCODE like '"+ this.sortcode +"'";
		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				temp = true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		return temp;
	}

	public Account getAccount(long account, int sortCode){
		logger.entering(this.getClass().getName(),"getAccount(int accountNumber, int sortCode) for account " + account);
		openConnection();
		Account temp = null;
		StringBuffer myStringBuffer = new StringBuffer(new Integer(sortCode).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();
		if(account == 999999999L)
		{
			String sql = "SELECT * from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_SORTCODE like '"+ sortCodeString +"' order by ACCOUNT_NUMBER DESC";
			logger.fine("About to do SELECT <" + sql + ">");
			try {
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery();
				if(rs.next())
				{
					temp = new Account(rs.getString("ACCOUNT_CUSTOMER_NUMBER"), rs.getString("ACCOUNT_SORTCODE"),
							rs.getString("ACCOUNT_NUMBER"), rs.getString("ACCOUNT_TYPE"), rs.getDouble("ACCOUNT_INTEREST_RATE"),
							rs.getDate("ACCOUNT_OPENED"), rs.getInt("ACCOUNT_OVERDRAFT_LIMIT"), rs.getDate("ACCOUNT_LAST_STATEMENT"),
							rs.getDate("ACCOUNT_NEXT_STATEMENT"), rs.getDouble("ACCOUNT_AVAILABLE_BALANCE"),
							rs.getDouble("ACCOUNT_ACTUAL_BALANCE"));
					rs.close();
					logger.exiting(this.getClass().getName(),"getAccount(int accountNumber, int sortCode) for account " + account,temp);
					return temp;
				}
				else
				{
					logger.warning("No results found");
					logger.exiting(this.getClass().getName(),"getAccount(int accountNumber, int sortCode) for account " + account,null);
					return null;
				}

			} catch (SQLException e) {
				logger.severe(e.getLocalizedMessage());
				logger.exiting(this.getClass().getName(),"getAccount(int accountNumber, int sortCode) for account " + account,null);
				return null;
			}
		}
		else
		{
			String sql = "SELECT * from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_NUMBER = "+ account + " and ACCOUNT_SORTCODE like '"+ sortCodeString +"'";
			try {
				logger.fine("About to execute query SQL <" + sql + ">");
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery();
				if(rs.isClosed())
				{
					logger.warning("Result set is closed so returning 'temp' which is " + temp);
					logger.exiting(this.getClass().getName(),"getAccount(int accountNumber, int sortCode) for account " + account,temp);
					return temp;
				}
				else
				{
					while(rs.next())
					{
						temp = new Account(rs.getString("ACCOUNT_CUSTOMER_NUMBER"), rs.getString("ACCOUNT_SORTCODE"),
								rs.getString("ACCOUNT_NUMBER"), rs.getString("ACCOUNT_TYPE"), rs.getDouble("ACCOUNT_INTEREST_RATE"),
								rs.getDate("ACCOUNT_OPENED"), rs.getInt("ACCOUNT_OVERDRAFT_LIMIT"), rs.getDate("ACCOUNT_LAST_STATEMENT"),
								rs.getDate("ACCOUNT_NEXT_STATEMENT"), rs.getDouble("ACCOUNT_AVAILABLE_BALANCE"),
								rs.getDouble("ACCOUNT_ACTUAL_BALANCE"));
						rs.close();
						logger.exiting(this.getClass().getName(),"getAccount(int accountNumber, int sortCode) for account " + account,temp);
						return temp;
					}

				}

			} catch (SQLException e) {
				logger.severe(e.getLocalizedMessage());
				logger.exiting(this.getClass().getName(),"getAccount(int accountNumber, int sortCode) for account " + account,null);
				return null;
			}
		}
		logger.exiting(this.getClass().getName(),"getAccount(int accountNumber, int sortCode) for account " + account,temp);
		return temp;
	}

	public Account[] getAccounts(long l, int sortCode){
		logger.entering(this.getClass().getName(),"getAccounts(long l, int sortCode) for customer " + l);
		openConnection();
		Account[] temp = new Account[10];
		int i = 0;
		StringBuffer myStringBuffer = new StringBuffer(new Long(l).toString());
		for(int z = myStringBuffer.length(); z < 10;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String customerNumberString = myStringBuffer.toString();

		myStringBuffer = new StringBuffer(new Integer(sortCode).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();

		String sql = "SELECT * from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_CUSTOMER_NUMBER like '"+ customerNumberString + "' and ACCOUNT_SORTCODE like '"+ sortCodeString +"' ORDER BY ACCOUNT_NUMBER";
		logger.fine("About to issue query SQL <" + sql + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				temp[i] = new Account(rs.getString("ACCOUNT_CUSTOMER_NUMBER"), rs.getString("ACCOUNT_SORTCODE"),
						rs.getString("ACCOUNT_NUMBER"), rs.getString("ACCOUNT_TYPE"), rs.getDouble("ACCOUNT_INTEREST_RATE"),
						rs.getDate("ACCOUNT_OPENED"), rs.getInt("ACCOUNT_OVERDRAFT_LIMIT"), rs.getDate("ACCOUNT_LAST_STATEMENT"),
						rs.getDate("ACCOUNT_NEXT_STATEMENT"), rs.getDouble("ACCOUNT_AVAILABLE_BALANCE"),
						rs.getDouble("ACCOUNT_ACTUAL_BALANCE"));
				i++;
			}
		} catch (SQLException e) {
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"getAccounts(long l, int sortCode) for customer " + l,null);
			return null;
		}
		Account[] real = new Account[i];
		for(int j=0;j<i;j++)
		{
			real[j] = temp[j];
		}
		logger.exiting(this.getClass().getName(),"getAccounts(long l, int sortCode) for customer " + l,real);
		return real;
	}

	public Account[] getAccounts(int sortCode){
		logger.entering(this.getClass().getName(),"getAccounts(int sortCode)");
		openConnection();
		Account[] temp = new Account[250000];
		int i = 0;
		StringBuffer myStringBuffer = new StringBuffer(new Integer(sortCode).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();
		String sql = "SELECT * from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_SORTCODE like '"+ sortCodeString +"' ORDER BY ACCOUNT_NUMBER";
		logger.fine("About is issue query SQL <" + sql + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				temp[i] = new Account(rs.getString("ACCOUNT_CUSTOMER_NUMBER"), rs.getString("ACCOUNT_SORTCODE"),
						rs.getString("ACCOUNT_NUMBER"), rs.getString("ACCOUNT_TYPE"), rs.getDouble("ACCOUNT_INTEREST_RATE"),
						rs.getDate("ACCOUNT_OPENED"), rs.getInt("ACCOUNT_OVERDRAFT_LIMIT"), rs.getDate("ACCOUNT_LAST_STATEMENT"),
						rs.getDate("ACCOUNT_NEXT_STATEMENT"), rs.getDouble("ACCOUNT_AVAILABLE_BALANCE"),
						rs.getDouble("ACCOUNT_ACTUAL_BALANCE"));
				i++;
			}
		} catch (SQLException e) {
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"getAccounts(int sortCode)",null);
			return null;
		}
		Account[] real = new Account[i];
		for(int j=0;j<i;j++)
		{
			real[j] = temp[j];
		}
		logger.exiting(this.getClass().getName(),"getAccounts(int sortCode)",real);
		return real;
	}

	public int getAccountsCountOnly(int sortCode){
		logger.entering(this.getClass().getName(),"getAccountsCountOnly(int sortCode)");
		openConnection();
		StringBuffer myStringBuffer = new StringBuffer(new Integer(sortCode).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();
		String sql = "SELECT COUNT(*) as ACCOUNT_COUNT from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_SORTCODE like '"+ sortCodeString +"'";
		logger.fine("About to issue query SQL <" + sql + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
			{
				logger.exiting(this.getClass().getName(),"getAccountsCountOnly(int sortCode)",rs.getInt("ACCOUNT_COUNT"));
				return rs.getInt("ACCOUNT_COUNT");
			}
			else 
			{
				logger.exiting(this.getClass().getName(),"getAccountsCountOnly(int sortCode)",-1);
				return -1;
			}
		} catch (SQLException e) {
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"getAccountsCountOnly(int sortCode)",-1);
			return -1;
		}
	}

	public Account deleteAccount(long account, int sortcode) {
		logger.entering(this.getClass().getName(),"deleteAccount(long account, int sortCode)");
		Account db2Account = this.getAccount(account, sortcode);
		if(db2Account == null)
		{
			logger.exiting(this.getClass().getName(),"deleteAccount(long account, int sortCode)",null);
			return null;
		}
		Account temp = null;
		openConnection();
		StringBuffer myStringBuffer = new StringBuffer(new Long(account).toString());
		for(int z = myStringBuffer.length(); z < 9;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String accountNumberString = myStringBuffer.toString();

		myStringBuffer = new StringBuffer(new Integer(sortcode).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();

		String sql1 = "SELECT * from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_NUMBER like '"+ accountNumberString + "' and ACCOUNT_SORTCODE like '"+ sortCodeString +"'";
		String sql2 = "DELETE from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_NUMBER like '"+ accountNumberString + "' and ACCOUNT_SORTCODE like '"+ sortCodeString +"'";
		
		
		try {
			logger.fine("About to issue query SQL <" + sql1 + ">");
			PreparedStatement stmt = conn.prepareStatement(sql1);
			ResultSet rs = stmt.executeQuery();
			
			
			while (rs.next()) {
				temp = new Account(rs.getString("ACCOUNT_CUSTOMER_NUMBER"), rs.getString("ACCOUNT_SORTCODE"),
						rs.getString("ACCOUNT_NUMBER"), rs.getString("ACCOUNT_TYPE"), rs.getDouble("ACCOUNT_INTEREST_RATE"),
						rs.getDate("ACCOUNT_OPENED"), rs.getInt("ACCOUNT_OVERDRAFT_LIMIT"), rs.getDate("ACCOUNT_LAST_STATEMENT"),
						rs.getDate("ACCOUNT_NEXT_STATEMENT"), rs.getDouble("ACCOUNT_AVAILABLE_BALANCE"),
						rs.getDouble("ACCOUNT_ACTUAL_BALANCE"));
				db2Account = temp;
				logger.fine("About to issue delete SQL <" + sql2 + ">");
				stmt = conn.prepareStatement(sql2);
				stmt.execute();
				logger.exiting(this.getClass().getName(),"deleteAccount(int account, int sortCode)",temp);
				return temp;
			}
		} catch (SQLException e) {
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"deleteAccount(int account, int sortCode)",null);
			return null;
		}
		
		logger.exiting(this.getClass().getName(),"deleteAccount(int account, int sortCode)",db2Account);
		return db2Account;
	}



	@SuppressWarnings("deprecation")
	public Account createAccount(AccountJSON account, Integer sortcode, boolean useNamedCounter) 
	{
		logger.entering(this.getClass().getName(),"createAccount(AccountJSON account, Integer sortcode, boolean use NamedCounter)");

		Account temp = null;
		openConnection();
		String accountNumberString = null;
		StringBuffer myStringBuffer = null;

		temp = new Account();
		myStringBuffer = new StringBuffer(sortcode.toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();
		// named counter resource does BOTH, bizarrely
		CounterResource myCounterResource = new CounterResource();
		Long accountNumber =0L;
		String controlString = sortcode.toString() + "-" + "ACCOUNT-LAST";
		String sql = "SELECT * from CONTROL where CONTROL_NAME = '" + controlString + "'";
		logger.fine("About to do SELECT <" + sql + ">");

		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
			{
				accountNumber = (Long) rs.getLong("CONTROL_VALUE_NUM");
				rs.close();
			}
		} catch (SQLException e) {
			logger.severe("Error accessing Control Table " + e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"createAccount(AccountJSON account, Integer sortcode, boolean use NamedCounter)",null);
			try {
				Task.getTask().rollback();
			} catch (InvalidRequestException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			return null;
		}
		accountNumber++;

		myStringBuffer = new StringBuffer(accountNumber.toString());
		for(int z = myStringBuffer.length(); z < 9;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		accountNumberString = myStringBuffer.toString();


		//
		// Store today's date as the ACCOUNT-OPENED date and calculate
		// the LAST-STMT-DATE (which should be today) and the
		// NEXT-STMT-DATE (which should be today + 30 days).

		Calendar myCalendar = Calendar.getInstance();
		Date today = new Date(myCalendar.getTimeInMillis());

		Date dateOpened = today;
		Date lastStatement = dateOpened;

		temp.setOpened(dateOpened);
		temp.setLast_statement(lastStatement);

		long timeNow = myCalendar.getTimeInMillis();
		// You must specify the values here as longs otherwise it ends up negative due to overflow
		long nextMonthInMs = 0L;
		switch(today.getMonth())
		{
		case 0:
		case 2:
		case 4:
		case 6:
		case 7:
		case 9:
		case 11:
			nextMonthInMs = 1000L * 60L * 60L * 24L * 31L;
			break;
		case 8:
		case 3:
		case 5:
		case 10:
			nextMonthInMs = 1000L * 60L * 60L * 24L * 30L;
			break;
		case 1:
			if((today.getYear() + 1900) % 4 > 0)
			{
				nextMonthInMs = 1000L * 60L * 60L * 24L * 28L;
			}
			else
			{
				if((today.getYear() + 1900) % 100 > 0)
				{
					nextMonthInMs = 1000L * 60L * 60L * 24L * 29L;
				}
				else
				{
					if((today.getYear() + 1900) % 400 == 0)
					{
						nextMonthInMs = 1000L * 60L * 60L * 24L * 29L;
					}
					else
					{
						nextMonthInMs = 1000L * 60L * 60L * 24L * 28L;
					}
				}
			}
		}

		long nextStatementLong = timeNow + nextMonthInMs;
		Date nextStatement =  new Date(nextStatementLong);

		temp.setNext_statement(nextStatement);



		myStringBuffer = new StringBuffer(new Integer(account.getCustomerNumber()).toString());
		for(int z = myStringBuffer.length(); z < 10;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String customerNumberString = myStringBuffer.toString();

		String sqlInsert = "INSERT INTO ACCOUNT "+
				"(ACCOUNT_EYECATCHER," +
				"ACCOUNT_CUSTOMER_NUMBER,"+
				"ACCOUNT_SORTCODE," +
				"ACCOUNT_NUMBER," +
				"ACCOUNT_TYPE," +
				"ACCOUNT_INTEREST_RATE," +
				"ACCOUNT_OPENED,"+
				"ACCOUNT_OVERDRAFT_LIMIT,"+
				"ACCOUNT_LAST_STATEMENT,"+
				"ACCOUNT_NEXT_STATEMENT,"+
				"ACCOUNT_AVAILABLE_BALANCE,"+
				"ACCOUNT_ACTUAL_BALANCE"+
				") " +
				"VALUES ('ACCT'"+
				",'" + customerNumberString + "'" +
				",'" + sortCodeString + "'" +
				",'" + accountNumberString + "'" +
				",'" + account.getAccountType() + "'" +
				","  + account.getInterestRate() + "" + 
				",'" + dateOpened + "'" +
				// no quotes for overdraft as it is an integer
				"," + account.getOverdraft() + "" + 
				",'" + lastStatement + "'" +
				",'" + nextStatement + "'" +
				// no quotes for balances as they are numbers
				"," + 0.00 + "" +
				"," + 0.00 + "" +
				")";
		logger.fine("About to insert record SQL <" + sqlInsert + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sqlInsert);
			stmt.execute();
			temp.setAccount_number(accountNumberString);
			temp.setActual_balance(0.00);
			temp.setAvailable_balance(0.00);
			temp.setCustomer_number(customerNumberString);
			temp.setInterest_rate(account.getInterestRate().doubleValue());
			temp.setLast_statement(lastStatement);
			temp.setNext_statement(nextStatement);
			temp.setOverdraft_limit(account.getOverdraft().intValue());
			temp.setSortcode(sortCodeString);
			temp.setType(account.getAccountType());
			temp.setOpened(dateOpened);
			controlString = sortcode.toString() + "-" + "ACCOUNT-LAST";
			sql = "SELECT * from CONTROL where CONTROL_NAME LIKE '" + controlString + "'";
			logger.fine("About to do SELECT <" + sql + ">");
			try {
				stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery();
				rs.next();
				String sqlUpdate = "UPDATE CONTROL "+
						"SET"+
						" CONTROL_VALUE_NUM = '"+ accountNumber +"'"+
						" WHERE CONTROL_NAME = '"+ controlString +"'";

				logger.fine("About to execute update SQL <" + sqlUpdate + ">");
				stmt = conn.prepareStatement(sqlUpdate);
				stmt.execute();
			} catch (SQLException e) {
				logger.severe("Error accessing Control Table " + e.getLocalizedMessage());
				logger.exiting(this.getClass().getName(),"createAccount(AccountJSON account, Integer sortcode, boolean use NamedCounter)",null);
				try {
					Task.getTask().rollback();
				} catch (InvalidRequestException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				return null;
			}			
			return temp;
		}
		catch (SQLException e) {

			if(e.getErrorCode() == -803)
			{
				logger.severe("SQLException -803 duplicate value. Have you combined named counter and non-named counter with the same data? com.ibm.cics.cip.bankliberty.web.db2.Account " + e.getErrorCode() + "," + e.getSQLState() + ","  + e.getMessage());
			}
			try {
				Task.getTask().rollback();
			} catch (InvalidRequestException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			logger.severe("SQL statement #" + sqlInsert + "# had error " + e.getErrorCode());
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"createAccount(AccountJSON account, Integer sortcode, boolean use NamedCounter)",null);
			return null;
		}

	}




	public Account updateAccount(AccountJSON account) {
		logger.entering(this.getClass().getName(),"updateAccount(AccountJSON account)");
		Account db2Account = this.getAccount(new Long(account.getId()).longValue(), new Integer(sortcode).intValue());
		if(db2Account == null)
		{
			logger.warning("Unable to access DB2 account " + account.getId());
			logger.exiting(this.getClass().getName(),"updateAccount(AccountJSON account)",null);
			return null;
		}
		Account temp = null;
		openConnection();
		String accountNumberString = db2Account.getAccount_number();
		Integer accountNumber = new Integer(db2Account.getAccount_number());
		StringBuffer myStringBuffer = new StringBuffer(accountNumber.toString());
		for(int z = myStringBuffer.length(); z < 9;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		accountNumberString = myStringBuffer.toString();
		myStringBuffer = new StringBuffer(new Integer(sortcode).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();
		String sql1 = "SELECT * from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_NUMBER like '"+ accountNumberString + "' and ACCOUNT_SORTCODE like '"+ sortCodeString +"'";
		logger.fine("About to perform query SQL <" + sql1 + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sql1);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				temp = new Account(rs.getString("ACCOUNT_CUSTOMER_NUMBER"), rs.getString("ACCOUNT_SORTCODE"),
						rs.getString("ACCOUNT_NUMBER"), rs.getString("ACCOUNT_TYPE"), rs.getDouble("ACCOUNT_INTEREST_RATE"),
						rs.getDate("ACCOUNT_OPENED"), rs.getInt("ACCOUNT_OVERDRAFT_LIMIT"), rs.getDate("ACCOUNT_LAST_STATEMENT"),
						rs.getDate("ACCOUNT_NEXT_STATEMENT"), rs.getDouble("ACCOUNT_AVAILABLE_BALANCE"),
						rs.getDouble("ACCOUNT_ACTUAL_BALANCE"));
				db2Account = temp;

				String sqlUpdate = "UPDATE ACCOUNT "+
						"SET"+
						" ACCOUNT_TYPE = '"+ account.getAccountType() +"'"+
						" ,ACCOUNT_INTEREST_RATE = '"+ account.getInterestRate() + "'" +
						" ,ACCOUNT_OVERDRAFT_LIMIT = '"+ account.getOverdraft() + "'" +
						" WHERE ACCOUNT_NUMBER like '"+ accountNumberString +"'" +
						" AND ACCOUNT_SORTCODE like '"+ account.getSortCode()+"'";

				logger.fine("About to execute update SQL <" + sqlUpdate + ">");
				stmt = conn.prepareStatement(sqlUpdate);
				stmt.execute();
				logger.exiting(this.getClass().getName(),"updateAccount(AccountJSON account)",temp);
				return temp;
			}
		} catch (SQLException e) {
			logger.severe(e.toString());
			logger.exiting(this.getClass().getName(),"updateAccount(AccountJSON account)",null);
			return null;
		}
		logger.exiting(this.getClass().getName(),"updateAccount(AccountJSON account)",temp);
		return temp;
	}



	public boolean debitCredit(BigDecimal apiAmount) {
		logger.entering(this.getClass().getName(),"debitCredit(BigDecimal apiAmount)");
		Account temp = this.getAccount(new Long(this.getAccount_number()).longValue(), new Integer(this.getSortcode()).intValue());
		if(temp == null)
		{
			logger.warning("Unable to find account " + this.getAccount_number());
			logger.exiting(this.getClass().getName(),"debitCredit(BigDecimal apiAmount)",false);
			return false;
		}

		openConnection();
		String accountNumberString = temp.getAccount_number();
		StringBuffer myStringBuffer = new StringBuffer(this.getSortcode());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();
		String sql1 = "SELECT * from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_NUMBER like '"+ accountNumberString + "' and ACCOUNT_SORTCODE like '" + sortCodeString +"'";
		logger.fine("About to issue QUERY <" + sql1 + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sql1);
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
			{
				temp = new Account(rs.getString("ACCOUNT_CUSTOMER_NUMBER"), rs.getString("ACCOUNT_SORTCODE"),
						rs.getString("ACCOUNT_NUMBER"), rs.getString("ACCOUNT_TYPE"), rs.getDouble("ACCOUNT_INTEREST_RATE"),
						rs.getDate("ACCOUNT_OPENED"), rs.getInt("ACCOUNT_OVERDRAFT_LIMIT"), rs.getDate("ACCOUNT_LAST_STATEMENT"),
						rs.getDate("ACCOUNT_NEXT_STATEMENT"), rs.getDouble("ACCOUNT_AVAILABLE_BALANCE"),
						rs.getDouble("ACCOUNT_ACTUAL_BALANCE"));

			}
			else 
			{
				logger.warning("Result set had no results");
				logger.exiting(this.getClass().getName(),"debitCredit(BigDecimal apiAmount)",false);
				return false;
			}

			double newActualBalance = temp.getActual_balance();
			double newAvailableBalance = temp.getAvailable_balance();


			newActualBalance = newActualBalance + apiAmount.doubleValue();
			newAvailableBalance = newAvailableBalance + apiAmount.doubleValue();

			this.setActual_balance(newActualBalance);
			this.setAvailable_balance(newAvailableBalance);

			String sqlUpdate = "UPDATE ACCOUNT "+
					"SET"+
					" ACCOUNT_ACTUAL_BALANCE = "+ newActualBalance +""+
					" ,ACCOUNT_AVAILABLE_BALANCE = "+ newAvailableBalance + "" +
					" WHERE ACCOUNT_NUMBER like '"+ accountNumberString +"'" +
					" AND ACCOUNT_SORTCODE like '"+ sortCodeString +"'";
			logger.fine("About to issue update SQL <" + sqlUpdate + ">");

			stmt = conn.prepareStatement(sqlUpdate);
			stmt.execute();

			logger.exiting(this.getClass().getName(),"debitCredit(BigDecimal apiAmount)",true);
			return true;

		} catch (SQLException e) {
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"debitCredit(BigDecimal apiAmount)",false);
			return false;
		}
	}



	public Account[] getAccountsByBalance(Integer sortCode2, BigDecimal balance, boolean lessThan) {
		logger.entering(this.getClass().getName(), "getAccountsByBalance(Integer sortCode2, BigDecimal balance, boolean lessThan)");
		openConnection();
		Account[] temp = new Account[250000];
		int i = 0;
		StringBuffer myStringBuffer = new StringBuffer(new Integer(sortCode2).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();
		String sql = "SELECT * from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_SORTCODE like '"+ sortCodeString +"' ";
		if(lessThan)
		{
			sql=sql.concat(" AND ACCOUNT_ACTUAL_BALANCE <= " + balance);
		}
		else
		{
			sql=sql.concat(" AND ACCOUNT_ACTUAL_BALANCE >= " + balance);
		}
		sql = sql.concat(" order by ACCOUNT_NUMBER");

		sql = sql.concat(" , ACCOUNT_ACTUAL_BALANCE DESC");


		logger.fine("About to issue query SQL <" + sql + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				temp[i] = new Account(rs.getString("ACCOUNT_CUSTOMER_NUMBER"), rs.getString("ACCOUNT_SORTCODE"),
						rs.getString("ACCOUNT_NUMBER"), rs.getString("ACCOUNT_TYPE"), rs.getDouble("ACCOUNT_INTEREST_RATE"),
						rs.getDate("ACCOUNT_OPENED"), rs.getInt("ACCOUNT_OVERDRAFT_LIMIT"), rs.getDate("ACCOUNT_LAST_STATEMENT"),
						rs.getDate("ACCOUNT_NEXT_STATEMENT"), rs.getDouble("ACCOUNT_AVAILABLE_BALANCE"),
						rs.getDouble("ACCOUNT_ACTUAL_BALANCE"));
				i++;
			}
		} catch (SQLException e) {
			System.err.println("Sql was <" + sql + ">");
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(), "getAccountsByBalance(Integer sortCode2, BigDecimal balance, boolean lessThan)",null);
			return null;
		}
		Account[] real = new Account[i];
		for(int j=0;j<i;j++)
		{
			real[j] = temp[j];
		}
		logger.exiting(this.getClass().getName(), "getAccountsByBalance(Integer sortCode2, BigDecimal balance, boolean lessThan)",real);
		return real;

	}



	public Account[] getAccounts(Integer sortCode, int limit, int offset) {
		logger.entering(this.getClass().getName(), "getAccounts(Integer sortCode, int limit, int offset)");
		openConnection();
		Account[] temp = new Account[limit];
		int i = 0, retrieved = 0;
		StringBuffer myStringBuffer = new StringBuffer(new Integer(sortCode).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();
		String sql = "SELECT * from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_SORTCODE like '"+ sortCodeString +"' ORDER BY ACCOUNT_NUMBER";
		logger.fine("About to issue query SQL <" + sql + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next() && i < limit) {
				if(retrieved >= offset)
				{
					temp[i] = new Account(rs.getString("ACCOUNT_CUSTOMER_NUMBER"), rs.getString("ACCOUNT_SORTCODE"),
							rs.getString("ACCOUNT_NUMBER"), rs.getString("ACCOUNT_TYPE"), rs.getDouble("ACCOUNT_INTEREST_RATE"),
							rs.getDate("ACCOUNT_OPENED"), rs.getInt("ACCOUNT_OVERDRAFT_LIMIT"), rs.getDate("ACCOUNT_LAST_STATEMENT"),
							rs.getDate("ACCOUNT_NEXT_STATEMENT"), rs.getDouble("ACCOUNT_AVAILABLE_BALANCE"),
							rs.getDouble("ACCOUNT_ACTUAL_BALANCE"));
					i++;
				}
				retrieved++;
			}
		} catch (SQLException e) {
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(), "getAccounts(Integer sortCode, int limit, int offset)",null);
			return null;
		}
		Account[] real = new Account[i];
		for(int j=0;j<i;j++)
		{
			real[j] = temp[j];
		}
		logger.exiting(this.getClass().getName(), "getAccounts(Integer sortCode, int limit, int offset)",real);
		return real;

	}



	public Account[] getAccountsByBalance(Integer sortCode2, BigDecimal balance, boolean lessThan, int offset,
			int limit) {
		logger.entering(this.getClass().getName(), "getAccountsByBalance(Integer sortCode2, BigDecimal balance, boolean lessThan, int offset, int limit)");
		openConnection();
		Account[] temp = new Account[250000];
		int i = 0;
		StringBuffer myStringBuffer = new StringBuffer(new Integer(sortCode2).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();
		String sql = "SELECT * from (SELECT p.*,row_number() over() as rn from ACCOUNT as p where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_SORTCODE like '"+ sortCodeString+"'";
		if(lessThan)
		{
			sql=sql.concat(" AND ACCOUNT_ACTUAL_BALANCE <= " + balance);
		}
		else
		{
			sql=sql.concat(" AND ACCOUNT_ACTUAL_BALANCE >= " + balance);
		}

		sql = sql.concat(" order by ACCOUNT_NUMBER");

		sql = sql.concat(" , ACCOUNT_ACTUAL_BALANCE DESC)");

		sql = sql.concat(" as col where rn between "
				+ offset + " and " + ((limit+offset) -1));

		logger.fine("About to issue query SQL <" + sql + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				temp[i] = new Account(rs.getString("ACCOUNT_CUSTOMER_NUMBER"), rs.getString("ACCOUNT_SORTCODE"),
						rs.getString("ACCOUNT_NUMBER"), rs.getString("ACCOUNT_TYPE"), rs.getDouble("ACCOUNT_INTEREST_RATE"),
						rs.getDate("ACCOUNT_OPENED"), rs.getInt("ACCOUNT_OVERDRAFT_LIMIT"), rs.getDate("ACCOUNT_LAST_STATEMENT"),
						rs.getDate("ACCOUNT_NEXT_STATEMENT"), rs.getDouble("ACCOUNT_AVAILABLE_BALANCE"),
						rs.getDouble("ACCOUNT_ACTUAL_BALANCE"));
				i++;
			}
		} catch (SQLException e) {
			System.err.println("Sql was <" + sql + ">");
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(), "getAccountsByBalance(Integer sortCode2, BigDecimal balance, boolean lessThan, int offset, int limit)",null);
			return null;
		}
		Account[] real = new Account[i];
		for(int j=0;j<i;j++)
		{
			real[j] = temp[j];
		}
		logger.exiting(this.getClass().getName(), "getAccountsByBalance(Integer sortCode2, BigDecimal balance, boolean lessThan, int offset, int limit)",real);
		return real;
	}



	public int getAccountsCountOnly(Integer sortCode2) {
		logger.entering(this.getClass().getName(), "getAccountsCountOnly(Integer sortCode2)");
		openConnection();
		int accountCount = 0;
		StringBuffer myStringBuffer = new StringBuffer(new Integer(sortCode2).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();
		String sql = "SELECT COUNT(*) as ACCOUNT_COUNT from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_SORTCODE like '"+ sortCodeString +"'";
		logger.fine("About to issue query SQL <" + sql + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
			{
				accountCount = rs.getInt("ACCOUNT_COUNT");
			}
			else
			{
				logger.exiting(this.getClass().getName(), "getAccountsCountOnly(Integer sortCode2)",-1);
				return -1;
			}
		} catch (SQLException e) {
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(), "getAccountsCountOnly(Integer sortCode2)",-1);
			return -1;
		}
		logger.exiting(this.getClass().getName(), "getAccountsCountOnly(Integer sortCode2)",accountCount);
		return accountCount;
	}



	public int getAccountsByBalanceCountOnly(Integer sortCode2, BigDecimal balance, boolean lessThan, Integer offset, Integer limit) 
	{
		logger.entering(this.getClass().getName(), "getAccountsByBalanceCountOnly(Integer sortCode2, BigDecimal balance, boolean lessThan, Integer offset, Integer limit)");
		int accountCount = 0;
		openConnection();
		StringBuffer myStringBuffer = new StringBuffer(new Integer(sortCode2).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();
		String sql = "SELECT COUNT(*) AS ACCOUNT_COUNT from ACCOUNT where ACCOUNT_EYECATCHER LIKE 'ACCT' AND ACCOUNT_SORTCODE like '" + sortCodeString + "'";
		if(lessThan)
		{
			sql=sql.concat(" AND ACCOUNT_ACTUAL_BALANCE <= " + balance);
		}
		else
		{
			sql=sql.concat(" AND ACCOUNT_ACTUAL_BALANCE >= " + balance);
		}


		logger.fine("About to issue query SQL <" + sql + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			if(rs.next())
			{
				accountCount = rs.getInt("ACCOUNT_COUNT");
			}
			else
			{
				logger.exiting(this.getClass().getName(), "getAccountsByBalanceCountOnly(Integer sortCode2, BigDecimal balance, boolean lessThan, Integer offset, Integer limit)",-1);
				return -1;
			}
		} catch (SQLException e) {
			System.err.println("Sql was <" + sql + ">");
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(), "getAccountsByBalanceCountOnly(Integer sortCode2, BigDecimal balance, boolean lessThan, Integer offset, Integer limit)",-1);
			return -1;
		}
		logger.exiting(this.getClass().getName(), "getAccountsByBalanceCountOnly(Integer sortCode2, BigDecimal balance, boolean lessThan, Integer offset, Integer limit)",accountCount);
		return accountCount;
	}

	private void sortOutLogging()
	{
		try {
			LogManager.getLogManager().readConfiguration();
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
