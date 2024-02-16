

package com.ibm.cics.cip.bankliberty.web.db2;


import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.Calendar;
import java.util.logging.LogManager;
import java.util.logging.Logger;

import com.ibm.cics.cip.bankliberty.api.json.HBankDataAccess;
import com.ibm.cics.cip.bankliberty.dataInterfaces.PROCTRAN;
import com.ibm.cics.server.Task;

public class ProcessedTransaction extends HBankDataAccess{

	/**
	 * Licensed Materials - Property of IBM
	 *
	 * (c) Copyright IBM Corp. 2019,2020.
	 *
	 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
	 * 
	 */

	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2019,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";
	private static Logger logger = Logger.getLogger("com.ibm.cics.cip.bankliberty.web.db2");


	public static final String BRANCH_CREATE_ACCOUNT = PROCTRAN.PROC_TY_BRANCH_CREATE_ACCOUNT;
	public static final String WEB_CREATE_ACCOUNT = PROCTRAN.PROC_TY_WEB_CREATE_ACCOUNT;
	public static final String BRANCH_CREATE_CUSTOMER = PROCTRAN.PROC_TY_BRANCH_CREATE_CUSTOMER;
	public static final String WEB_CREATE_CUSTOMER = PROCTRAN.PROC_TY_WEB_CREATE_CUSTOMER;

	public static String CREDIT = PROCTRAN.PROC_TY_CREDIT;
	public static String DEBIT = PROCTRAN.PROC_TY_DEBIT;
	public static String BRANCH_DELETE_ACCOUNT = PROCTRAN.PROC_TY_BRANCH_DELETE_ACCOUNT;
	public static String WEB_DELETE_ACCOUNT = PROCTRAN.PROC_TY_WEB_DELETE_ACCOUNT;
	public static String BRANCH_DELETE_CUSTOMER = PROCTRAN.PROC_TY_BRANCH_DELETE_CUSTOMER;
	public static String WEB_DELETE_CUSTOMER = PROCTRAN.PROC_TY_WEB_DELETE_CUSTOMER;
	public static String TRANSFER = PROCTRAN.PROC_TRAN_DESC_XFR_FLAG;
	
	// String ACCOUNT_EYECATCHER             CHAR(4),
	private 	String 		sortcode;              
	private 	String 		customerName;

	int retrieved = 0, stored = 0, offset = 0, limit = 0;


	int valid_proctran_records = 0;
	public String getCustomerName() {
		return customerName;
	}


	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}



	private 	String 		account_number;
	private 	String 		account_type;
	private 	Date  		last_statement, next_statement;
	private     boolean     transfer = false;
	private 	String 		description;
	private 	Date 		transactionDate;
	private	 	double 		amount;
	private String customer = "";

	private Date dateOfBirth;

	private     int maximum_retries = 100, totalSleep = 3000;



	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}


	public String getAccount_type() {
		return account_type;
	}


	public void setAccount_type(String account_type) {
		this.account_type = account_type;
	}


	public Date getLast_statement() {
		return last_statement;
	}


	public void setLast_statement(Date last_statement) {
		this.last_statement = last_statement;
	}


	public Date getNext_statement() {
		return next_statement;
	}


	public void setNext_statement(Date next_statement) {
		this.next_statement = next_statement;
	}



	private 	String 		target_account_number;
	private 	String 		target_sortcode;
	private 	String 		type;
	private 	String 		reference;
	public String getTarget_sortcode() {
		return target_sortcode;
	}


	public void setTarget_sortcode(String target_sortcode) {
		this.target_sortcode = target_sortcode;
	}









	public ProcessedTransaction()
	{
		sortOutLogging();
	}


	public void setCustomer(String customer) {
		this.customer = customer;
	}


	public String getSortcode() {
		return sortcode;
	}

	public void setSortcode(String sortcode) {
		this.sortcode = sortcode;
	}

	public String getAccount_number() {
		return account_number;
	}

	public void setAccount_number(String account_number) {
		this.account_number = account_number;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}







	public ProcessedTransaction[] getProcessedTransactions(int sortCode, Integer limit, Integer offset){
		logger.entering(this.getClass().getName(),"getProcessedTransactions(int sortCode, Integer limit, Integer offset)");


		ProcessedTransaction[] temp = new ProcessedTransaction[limit];


		this.offset = offset.intValue();
		this.limit = limit.intValue();
		int i = 0;

		StringBuffer myStringBuffer = new StringBuffer(new Integer(sortCode).toString());
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String sortCodeString = myStringBuffer.toString();


		openConnection();
		String sql = "SELECT * from (SELECT p.*,row_number() over() as rn from PROCTRAN as p where PROCTRAN_SORTCODE like '" + sortCodeString + "' ORDER BY PROCTRAN_DATE ASC, PROCTRAN_TIME ASC) as col where rn between " 	+ offset+1 + " and " + ((limit+offset));
		logger.fine("About to issue query SQL <" + sql + ">");

		try {
			PreparedStatement stmt = conn.prepareStatement(sql);
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) 
			{
				temp[i] = new ProcessedTransaction();
				
				temp[i].setAccount_number(rs.getString("PROCTRAN_NUMBER"));
				temp[i].setReference(rs.getString("PROCTRAN_REF"));
				temp[i].setSortcode(rs.getString("PROCTRAN_SORTCODE"));
				this.setSortcode(temp[i].getSortcode());
				temp[i].setDescription(rs.getString("PROCTRAN_DESC"));
				temp[i].setAmount(rs.getDouble("PROCTRAN_AMOUNT"));
				temp[i].setType(rs.getString("PROCTRAN_TYPE"));
				
				if((temp[i].getType()).compareTo("TFR") == 0)
				{
					String targetSortcode = temp[i].getDescription().substring(25, 31);
					String targetAccount = temp[i].getDescription().substring(31, 40);
					
					temp[i].setTarget_account_number(targetAccount);
					temp[i].setTarget_sortcode(targetSortcode);
					temp[i].setTransfer(true);
				}
				if(temp[i].getType().compareTo("IDA") == 0 || temp[i].getType().compareTo("ODA") == 0)
				{
					String deletedAccountCustomer = temp[i].getDescription().substring(0,10);
					String deletedAccountType     = temp[i].getDescription().substring(10,18);
					String lastStatementDD        = temp[i].getDescription().substring(18,20);
					String lastStatementMM        = temp[i].getDescription().substring(20,22);
					String lastStatementYYYY      = temp[i].getDescription().substring(22,26);
					String nextStatementDD        = temp[i].getDescription().substring(26,28);
					String nextStatementMM        = temp[i].getDescription().substring(28,30);
					String nextStatementYYYY      = temp[i].getDescription().substring(30,34);

					temp[i].setAccount_type(deletedAccountType);
					Date lastStatementDate = new Date(new Integer(lastStatementYYYY).intValue() - 1900, new Integer(lastStatementMM).intValue() -1, new Integer(lastStatementDD).intValue());
					Date nextStatementDate = new Date(new Integer(nextStatementYYYY).intValue() - 1900, new Integer(nextStatementMM).intValue() -1, new Integer(nextStatementDD).intValue());
					temp[i].setLast_statement(lastStatementDate);
					temp[i].setNext_statement(nextStatementDate);
					temp[i].setCustomer(deletedAccountCustomer);
				}
				if(temp[i].getType().compareTo("ICA") == 0 || temp[i].getType().compareTo("OCA") == 0)
				{
					String createdAccountCustomer = temp[i].getDescription().substring(0,10);
					String createdAccountType     = temp[i].getDescription().substring(10,18);
					String lastStatementDD        = temp[i].getDescription().substring(18,20);
					String lastStatementMM        = temp[i].getDescription().substring(20,22);
					String lastStatementYYYY      = temp[i].getDescription().substring(22,26);
					String nextStatementDD        = temp[i].getDescription().substring(26,28);
					String nextStatementMM        = temp[i].getDescription().substring(28,30);
					String nextStatementYYYY      = temp[i].getDescription().substring(30,34);

					temp[i].setAccount_type(createdAccountType);
					Date lastStatementDate = new Date(new Integer(lastStatementYYYY).intValue() - 1900, new Integer(lastStatementMM).intValue() -1, new Integer(lastStatementDD).intValue());
					Date nextStatementDate = new Date(new Integer(nextStatementYYYY).intValue() - 1900, new Integer(nextStatementMM).intValue() -1, new Integer(nextStatementDD).intValue());
					temp[i].setLast_statement(lastStatementDate);
					temp[i].setNext_statement(nextStatementDate);
					temp[i].setCustomer(createdAccountCustomer);
				}

				if(temp[i].getType().compareTo("IDC") == 0 || temp[i].getType().compareTo("ODC") == 0)
				{
					String deletedCustomerNumber = temp[i].getDescription().substring(6,16);
					String deletedCustomerName   = temp[i].getDescription().substring(16,30);
					temp[i].setCustomerName(deletedCustomerName);
					String dateOfBirthDD        = temp[i].getDescription().substring(30,32);
					String dateOfBirthMM        = temp[i].getDescription().substring(33,35);
					String dateOfBirthYYYY      = temp[i].getDescription().substring(36,40);
					Date dateOfBirth = new Date(new Integer(dateOfBirthYYYY).intValue() - 1900, new Integer(dateOfBirthMM).intValue() -1, new Integer(dateOfBirthDD).intValue());
					temp[i].setDateOfBirth(dateOfBirth);
					temp[i].setCustomer(deletedCustomerNumber);
				}

				if(temp[i].getType().compareTo("ICC") == 0 || temp[i].getType().compareTo("OCC") == 0)
				{
					String createdCustomerNumber = temp[i].getDescription().substring(6,16);
					String createdCustomerName   = temp[i].getDescription().substring(16,30);
					temp[i].setCustomerName(createdCustomerName);
					String dateOfBirthDD        = temp[i].getDescription().substring(30,32);
					String dateOfBirthMM        = temp[i].getDescription().substring(33,35);
					String dateOfBirthYYYY      = temp[i].getDescription().substring(36,40);
					Date dateOfBirth = new Date(new Integer(dateOfBirthYYYY).intValue() - 1900, new Integer(dateOfBirthMM).intValue() -1, new Integer(dateOfBirthDD).intValue());
					temp[i].setDateOfBirth(dateOfBirth);
					temp[i].setCustomer(createdCustomerNumber);
				}


				Calendar myCalendar = Calendar.getInstance();
				Date transactionDate = rs.getDate("PROCTRAN_DATE");
				String transactionTime = rs.getString("PROCTRAN_TIME");
				long seconds = 0, minutes = 0, hours = 0;
				if(transactionTime.length() == 6)
				{
					seconds = new Integer(transactionTime.substring(4));
					minutes = new Integer(transactionTime.substring(2,4));
					hours   = new Integer(transactionTime.substring(0,2));
				}


				myCalendar.setTime(transactionDate);
				long timeInMillis = myCalendar.getTimeInMillis();
				timeInMillis = timeInMillis + (hours * 60 * 60 * 1000);
				timeInMillis = timeInMillis + (minutes * 60 * 1000);
				timeInMillis = timeInMillis + (seconds * 1000);
				transactionDate = new Date(timeInMillis);
				temp[i].setTransactionDate(transactionDate);
				i++;
			}
		} catch (SQLException e) {
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"getProcessedTransactions(int sortCode, Integer limit, Integer offset)",null);
			return null;
		}
		ProcessedTransaction[] real = new ProcessedTransaction[i];
		for(int j=0;j<i;j++)
		{
			real[j] = temp[j];	
		}
		logger.exiting(this.getClass().getName(),"getProcessedTransactions(int sortCode, Integer limit, Integer offset)",real);
		return real;
	}


	public String getTarget_account_number() {
		return target_account_number;
	}



	public void setTarget_account_number(String target_account_number) {
		this.target_account_number = target_account_number;
	}



	public String getReference() {
		return reference;
	}



	public void setReference(String reference) {
		this.reference = reference;
	}



	public String getDescription() {
		return description;
	}



	public void setDescription(String description) {
		this.description = description;
	}



	public double getAmount() {
		return amount;
	}



	public void setAmount(double amount) {
		this.amount = amount;
	}



	public Date getTransactionDate() {
		return transactionDate;
	}



	public void setTransactionDate(Date transactionDate) {
		this.transactionDate = transactionDate;
	}


	public boolean isTransfer() {
		return transfer;
	}


	public void setTransfer(boolean transfer) {
		this.transfer = transfer;
	}


	public String getCustomer() {
		return customer;
	}



	@SuppressWarnings("deprecation")
	public boolean writeDebit(String accountNumber, String sortcode, BigDecimal amount2) {
		logger.entering(this.getClass().getName(),"writeDebit(String accountNumber, String sortcode, BigDecimal amount2)");

		long now = Calendar.getInstance().getTimeInMillis();
		Date timestamp = new Date(now);
		Time time = new Time(now);
		String timeString = "";
		StringBuffer myStringBuffer = new StringBuffer(new Integer(time.getHours()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getMinutes()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getSeconds()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());


		myStringBuffer = new StringBuffer(new Integer(Task.getTask().getTaskNumber()).toString());
		for(int z = myStringBuffer.length(); z < 12;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String taskRef = myStringBuffer.toString();




		openConnection();

		String sqlInsert = "INSERT INTO PROCTRAN "+
				"(PROCTRAN_EYECATCHER, "
				+ "PROCTRAN_SORTCODE,  "
				+ "PROCTRAN_NUMBER,  "
				+ "PROCTRAN_DATE, "
				+ "PROCTRAN_TIME, " 
				+ "PROCTRAN_REF, "
				+ "PROCTRAN_TYPE, "
				+ "PROCTRAN_DESC, "
				+ "PROCTRAN_AMOUNT) " +
				"VALUES ('" + PROCTRAN.PROC_TRAN_VALID + "'"+
				",'" + sortcode + "'" +
				",'" + String.format("%09d",Integer.parseInt(accountNumber)) + "'" +
				",'" + timestamp.toString() + "'" +
				",'" + timeString + "'" +
				",'" + taskRef + "'" +
				","  + "'" + PROCTRAN.PROC_TY_DEBIT + "'" + 
				",'" + "INTERNET WTHDRW" + "'" +
				"," + amount2 + "" + 
				")";
		logger.fine("About to insert record SQL <" + sqlInsert + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sqlInsert);
			stmt.executeUpdate();
		}
		catch(SQLException e)
		{
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"writeDebit(String accountNumber, String sortcode, BigDecimal amount2)",false);
			return false;
		}
		logger.exiting(this.getClass().getName(),"writeDebit(String accountNumber, String sortcode, BigDecimal amount2)",true);
		return true;
	}

	@SuppressWarnings("deprecation")
	public boolean writeCredit(String accountNumber, String sortcode, BigDecimal amount2) {
		logger.entering(this.getClass().getName(),"writeCredit(String accountNumber, String sortcode, BigDecimal amount2)",false);
		long now = Calendar.getInstance().getTimeInMillis();
		Date timestamp = new Date(now);
		Time time = new Time(now);
		String timeString = "";
		StringBuffer myStringBuffer = new StringBuffer(new Integer(time.getHours()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getMinutes()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getSeconds()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());


		myStringBuffer = new StringBuffer(new Integer(Task.getTask().getTaskNumber()).toString());
		for(int z = myStringBuffer.length(); z < 12;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String taskRef = myStringBuffer.toString();




		openConnection();

		String sqlInsert = "INSERT INTO PROCTRAN "+
				"(PROCTRAN_EYECATCHER, "
				+ "PROCTRAN_SORTCODE,  "
				+ "PROCTRAN_NUMBER,  "
				+ "PROCTRAN_DATE, "
				+ "PROCTRAN_TIME, " 
				+ "PROCTRAN_REF, "
				+ "PROCTRAN_TYPE, "
				+ "PROCTRAN_DESC, "
				+ "PROCTRAN_AMOUNT) " +
				"VALUES ('" + PROCTRAN.PROC_TRAN_VALID + "'"+
				",'" + sortcode + "'" +
				",'" + String.format("%09d",Integer.parseInt(accountNumber)) + "'" +
				",'" + timestamp.toString() + "'" +
				",'" + timeString + "'" +
				",'" + taskRef + "'" +
				","  + "'" + PROCTRAN.PROC_TY_CREDIT + "'" + 
				",'" + "INTERNET RECVED" + "'" +
				"," + amount2 + "" + 
				")";
		logger.fine("About to insert record SQL <" + sqlInsert + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sqlInsert);
			stmt.executeUpdate();
		}
		catch(SQLException e)
		{
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"writeCredit(String accountNumber, String sortcode, BigDecimal amount2)",false);
			return false;
		}
		logger.exiting(this.getClass().getName(),"writeCredit(String accountNumber, String sortcode, BigDecimal amount2)",true);
		return true;
	}


	@SuppressWarnings("deprecation")
	public boolean writeTransferLocal(String sortCode2, String account_number2, BigDecimal amount2,	String target_account_number2) {
		logger.entering(this.getClass().getName(),"writeTransferLocal(String sortCode2, String account_number2, BigDecimal amount2,	String target_account_number2)");

		long now = Calendar.getInstance().getTimeInMillis();
		Date timestamp = new Date(now);
		Time time = new Time(now);
		String timeString = "";
		StringBuffer myStringBuffer = new StringBuffer(new Integer(time.getHours()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getMinutes()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getSeconds()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());





		String transferDescription = "";
		transferDescription = transferDescription + PROCTRAN.PROC_TRAN_DESC_XFR_FLAG;
		transferDescription = transferDescription.concat("                  ");
		myStringBuffer = new StringBuffer(sortCode2);
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		transferDescription = transferDescription.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(target_account_number2);
		for(int z = myStringBuffer.length(); z < 8;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		transferDescription = transferDescription.concat(myStringBuffer.toString());





		myStringBuffer = new StringBuffer(new Integer(Task.getTask().getTaskNumber()).toString());
		for(int z = myStringBuffer.length(); z < 12;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String taskRef = myStringBuffer.toString();




		openConnection();

		String sqlInsert = "INSERT INTO PROCTRAN "+
				"(PROCTRAN_EYECATCHER, "
				+ "PROCTRAN_SORTCODE,  "
				+ "PROCTRAN_NUMBER,  "
				+ "PROCTRAN_DATE, "
				+ "PROCTRAN_TIME, " 
				+ "PROCTRAN_REF, "
				+ "PROCTRAN_TYPE, "
				+ "PROCTRAN_DESC, "
				+ "PROCTRAN_AMOUNT) " +
				"VALUES ('" + PROCTRAN.PROC_TRAN_VALID + "'"+
				",'" + sortCode2 + "'" +
				",'" + String.format("%09d",Integer.parseInt(account_number2)) + "'" +
				",'" + timestamp.toString() + "'" +
				",'" + timeString + "'" +
				",'" + taskRef + "'" +
				","  + "'" + PROCTRAN.PROC_TY_TRANSFER + "'" + 
				",'" + transferDescription + "'" +
				"," + amount2 + "" + 
				")";
		logger.fine("About to insert record SQL <" + sqlInsert + ">");

		try {
			PreparedStatement stmt = conn.prepareStatement(sqlInsert);
			stmt.executeUpdate();
		}
		catch(SQLException e)
		{
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"writeTransferLocal(String sortCode2, String account_number2, BigDecimal amount2,	String target_account_number2)",false);
			return false;
		}
		logger.exiting(this.getClass().getName(),"writeTransferLocal(String sortCode2, String account_number2, BigDecimal amount2,	String target_account_number2)",true);
		return true;	
	}


	@SuppressWarnings("deprecation")
	public boolean writeDeleteCustomer(String sortCode2, String accountNumber, double amount_which_will_be_zero, Date customerDOB, String customerName, String customerNumber) {
		logger.entering(this.getClass().getName(),"writeDeleteCustomer(String sortCode2, String accountNumber, double amount_which_will_be_zero, Date customerDOB, String customerName, String customerNumber)");

		long now = Calendar.getInstance().getTimeInMillis();
		Date timestamp = new Date(now);
		Time time = new Time(now);

		String timeString = "";
		StringBuffer myStringBuffer = new StringBuffer(new Integer(time.getHours()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getMinutes()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getSeconds()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());

		String deleteCustomerDescription = "";
		myStringBuffer = new StringBuffer(sortCode2);
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		deleteCustomerDescription = deleteCustomerDescription.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(customerNumber);
		for(int z = myStringBuffer.length(); z < 10;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		deleteCustomerDescription = deleteCustomerDescription.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(customerName);
		for(int z = myStringBuffer.length(); z < 14;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		deleteCustomerDescription = deleteCustomerDescription.concat(myStringBuffer.substring(0,14).toString());

		int dobYYYY = customerDOB.getYear() + 1900;
		int dobMM   = customerDOB.getMonth() + 1;
		int dobDD   = customerDOB.getDate();
		String customerDOBString = new String();
		myStringBuffer = new StringBuffer(new Integer(dobDD).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		customerDOBString = customerDOBString + myStringBuffer.toString();
		customerDOBString = customerDOBString + "-";
		myStringBuffer = new StringBuffer(new Integer(dobMM).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		customerDOBString = customerDOBString + myStringBuffer.toString();
		customerDOBString = customerDOBString + "-";
		myStringBuffer = new StringBuffer(new Integer(dobYYYY).toString());
		for(int z = myStringBuffer.length(); z < 4;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		customerDOBString = customerDOBString + myStringBuffer.toString();

		deleteCustomerDescription = deleteCustomerDescription + customerDOBString;		

		myStringBuffer = new StringBuffer(new Integer(Task.getTask().getTaskNumber()).toString());
		for(int z = myStringBuffer.length(); z < 12;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String taskRef = myStringBuffer.toString();

		openConnection();

		String sqlInsert = "INSERT INTO PROCTRAN "+
				"(PROCTRAN_EYECATCHER, "
				+ "PROCTRAN_SORTCODE,  "
				+ "PROCTRAN_NUMBER,  "
				+ "PROCTRAN_DATE, "
				+ "PROCTRAN_TIME, " 
				+ "PROCTRAN_REF, "
				+ "PROCTRAN_TYPE, "
				+ "PROCTRAN_DESC, "
				+ "PROCTRAN_AMOUNT) " +
				"VALUES ('" + PROCTRAN.PROC_TRAN_VALID + "'"+
				",'" + sortCode2 + "'" +
				",'" + String.format("%09d",Integer.parseInt(accountNumber)) + "'" +
				",'" + timestamp.toString() + "'" +
				",'" + timeString + "'" +
				",'" + taskRef + "'" +
				","  + "'" + PROCTRAN.PROC_TY_WEB_DELETE_CUSTOMER + "'" + 
				",'" + deleteCustomerDescription + "'" +
				"," + amount_which_will_be_zero + "" + 
				")";

		logger.fine("About to insert record SQL <" + sqlInsert + ">");

		try {
			PreparedStatement stmt = conn.prepareStatement(sqlInsert);
			stmt.executeUpdate();
		}
		catch(SQLException e)
		{
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"writeDeleteCustomer(String sortCode2, String accountNumber, double amount_which_will_be_zero, Date customerDOB, String customerName, String customerNumber)",false);
			return false;
		}
		logger.exiting(this.getClass().getName(),"writeDeleteCustomer(String sortCode2, String accountNumber, double amount_which_will_be_zero, Date customerDOB, String customerName, String customerNumber)",true);
		return true;	
	}


	@SuppressWarnings("deprecation")
	public boolean writeCreateCustomer(String sortCode2, String accountNumber, double amount_which_will_be_zero, Date customerDOB, String customerName, String customerNumber) {
		logger.entering(this.getClass().getName(),"writeCreateCustomer(String sortCode2, String accountNumber, double amount_which_will_be_zero, Date customerDOB, String customerName, String customerNumber)");
		long now = Calendar.getInstance().getTimeInMillis();
		Date timestamp = new Date(now);
		Time time = new Time(now);

		String timeString = "";
		StringBuffer myStringBuffer = new StringBuffer(new Integer(time.getHours()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getMinutes()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getSeconds()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());

		String createCustomerDescription = "";
		myStringBuffer = new StringBuffer(sortCode2);
		for(int z = myStringBuffer.length(); z < 6;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		createCustomerDescription = createCustomerDescription.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(customerNumber);
		for(int z = myStringBuffer.length(); z < 10;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		createCustomerDescription = createCustomerDescription.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(customerName);
		for(int z = myStringBuffer.length(); z < 14;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		createCustomerDescription = createCustomerDescription.concat(myStringBuffer.substring(0,14).toString());

		int dobYYYY = customerDOB.getYear() + 1900;
		int dobMM   = customerDOB.getMonth() + 1;
		int dobDD   = customerDOB.getDate();
		String customerDOBString = new String();
		myStringBuffer = new StringBuffer(new Integer(dobDD).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		customerDOBString = customerDOBString + myStringBuffer.toString();
		customerDOBString = customerDOBString + "-";
		myStringBuffer = new StringBuffer(new Integer(dobMM).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		customerDOBString = customerDOBString + myStringBuffer.toString();
		customerDOBString = customerDOBString + "-";
		myStringBuffer = new StringBuffer(new Integer(dobYYYY).toString());
		for(int z = myStringBuffer.length(); z < 4;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		customerDOBString = customerDOBString + myStringBuffer.toString();

		createCustomerDescription = createCustomerDescription + customerDOBString;		

		myStringBuffer = new StringBuffer(new Integer(Task.getTask().getTaskNumber()).toString());
		for(int z = myStringBuffer.length(); z < 12;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String taskRef = myStringBuffer.toString();




		openConnection();

		String sqlInsert = "INSERT INTO PROCTRAN "+
				"(PROCTRAN_EYECATCHER, "
				+ "PROCTRAN_SORTCODE,  "
				+ "PROCTRAN_NUMBER,  "
				+ "PROCTRAN_DATE, "
				+ "PROCTRAN_TIME, " 
				+ "PROCTRAN_REF, "
				+ "PROCTRAN_TYPE, "
				+ "PROCTRAN_DESC, "
				+ "PROCTRAN_AMOUNT) " +
				"VALUES ('" + PROCTRAN.PROC_TRAN_VALID + "'"+
				",'" + sortCode2 + "'" +
				",'" + String.format("%09d",Integer.parseInt(accountNumber)) + "'" +
				",'" + timestamp.toString() + "'" +
				",'" + timeString + "'" +
				",'" + taskRef + "'" +
				","  + "'" + PROCTRAN.PROC_TY_WEB_CREATE_CUSTOMER + "'" + 
				",'" + createCustomerDescription + "'" +
				"," + amount_which_will_be_zero + "" + 
				")";

		logger.fine("About to insert record SQL <" + sqlInsert + ">");

		try {
			PreparedStatement stmt = conn.prepareStatement(sqlInsert);
			stmt.executeUpdate();
		}
		catch(SQLException e)
		{
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"writeCreateCustomer(String sortCode2, String accountNumber, double amount_which_will_be_zero, Date customerDOB, String customerName, String customerNumber)",false);
			return false;
		}
		logger.exiting(this.getClass().getName(),"writeCreateCustomer(String sortCode2, String accountNumber, double amount_which_will_be_zero, Date customerDOB, String customerName, String customerNumber)",true);
		return true;	
	}


	@SuppressWarnings("deprecation")
	public boolean writeDeleteAccount(String sortCode2, String accountNumber, BigDecimal actualBalance,	Date lastStatement, Date nextStatement, String customerNumber, String accountType) {
		logger.entering(this.getClass().getName(),"writeDeleteAccount(String sortCode2, String accountNumber, BigDecimal actualBalance,	Date lastStatement, Date nextStatement, String customerNumber, String accountType)");

		PROCTRAN myPROCTRAN = new PROCTRAN();

		myPROCTRAN.setProcDescDelaccLastDd(lastStatement.getDate());
		myPROCTRAN.setProcDescDelaccLastMm(lastStatement.getMonth() + 1);
		myPROCTRAN.setProcDescDelaccLastYyyy(lastStatement.getYear() + 1900);
		myPROCTRAN.setProcDescDelaccNextDd(nextStatement.getDate());
		myPROCTRAN.setProcDescDelaccNextMm(nextStatement.getMonth() + 1);
		myPROCTRAN.setProcDescDelaccNextYyyy(nextStatement.getYear() + 1900);
		myPROCTRAN.setProcDescDelaccAcctype(accountType);
		myPROCTRAN.setProcDescDelaccCustomer(new Integer(customerNumber).intValue());
		myPROCTRAN.setProcDescDelaccFooter(PROCTRAN.PROC_DESC_DELACC_FLAG);

		String description = myPROCTRAN.getProcTranDesc();



		long now = Calendar.getInstance().getTimeInMillis();
		Date timestamp = new Date(now);
		Time time = new Time(now);

		String timeString = "";
		StringBuffer myStringBuffer = new StringBuffer(new Integer(time.getHours()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getMinutes()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getSeconds()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());

		myStringBuffer = new StringBuffer(new Integer(Task.getTask().getTaskNumber()).toString());
		for(int z = myStringBuffer.length(); z < 12;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String taskRef = myStringBuffer.toString();




		openConnection();

		String sqlInsert = "INSERT INTO PROCTRAN "+
				"(PROCTRAN_EYECATCHER, "
				+ "PROCTRAN_SORTCODE,  "
				+ "PROCTRAN_NUMBER,  "
				+ "PROCTRAN_DATE, "
				+ "PROCTRAN_TIME, " 
				+ "PROCTRAN_REF, "
				+ "PROCTRAN_TYPE, "
				+ "PROCTRAN_DESC, "
				+ "PROCTRAN_AMOUNT) " +
				"VALUES ('" + PROCTRAN.PROC_TRAN_VALID + "'"+
				",'" + sortCode2 + "'" +
				",'" + String.format("%09d",Integer.parseInt(accountNumber)) + "'" +
				",'" + timestamp.toString() + "'" +
				",'" + timeString + "'" +
				",'" + taskRef + "'" +
				","  + "'" + PROCTRAN.PROC_TY_WEB_DELETE_ACCOUNT + "'" + 
				",'" + description + "'" +
				"," + actualBalance.setScale(2,RoundingMode.HALF_UP) + "" + 
				")";

		logger.fine("About to insert record SQL <" + sqlInsert + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sqlInsert);
			stmt.executeUpdate();
		}
		catch(SQLException e)
		{
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"writeDeleteAccount(String sortCode2, String accountNumber, BigDecimal actualBalance,	Date lastStatement, Date nextStatement, String customerNumber, String accountType)",false);
			return false;
		}
		logger.exiting(this.getClass().getName(),"writeDeleteAccount(String sortCode2, String accountNumber, BigDecimal actualBalance,	Date lastStatement, Date nextStatement, String customerNumber, String accountType)",true);
		return true;	
	}


	public Date getDateOfBirth() {
		return dateOfBirth;
	}


	@SuppressWarnings("deprecation")
	public boolean writeCreateAccount(String sortCode2, String accountNumber, BigDecimal actualBalance,	Date lastStatement, Date nextStatement, String customerNumber, String accountType) {
		logger.entering(this.getClass().getName(),"writeCreateAccount(String sortCode2, String accountNumber, BigDecimal actualBalance,	Date lastStatement, Date nextStatement, String customerNumber, String accountType)");
		long now = Calendar.getInstance().getTimeInMillis();
		Date timestamp = new Date(now);
		Time time = new Time(now);

		String timeString = "";
		StringBuffer myStringBuffer = new StringBuffer(new Integer(time.getHours()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getMinutes()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());
		myStringBuffer = new StringBuffer(new Integer(time.getSeconds()).toString());
		for(int z = myStringBuffer.length(); z < 2;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		timeString = timeString.concat(myStringBuffer.toString());

		myStringBuffer = new StringBuffer(new Integer(Task.getTask().getTaskNumber()).toString());
		for(int z = myStringBuffer.length(); z < 12;z++)
		{
			myStringBuffer = myStringBuffer.insert(0, "0");	
		}
		String taskRef = myStringBuffer.toString();




		PROCTRAN myPROCTRAN = new PROCTRAN();

		myPROCTRAN.setProcDescCreaccLastDd(lastStatement.getDate());
		myPROCTRAN.setProcDescCreaccLastMm(lastStatement.getMonth() + 1);
		myPROCTRAN.setProcDescCreaccLastYyyy(lastStatement.getYear() + 1900);
		myPROCTRAN.setProcDescCreaccNextDd(nextStatement.getDate());
		myPROCTRAN.setProcDescCreaccNextMm(nextStatement.getMonth() + 1);
		myPROCTRAN.setProcDescCreaccNextYyyy(nextStatement.getYear() + 1900);
		myPROCTRAN.setProcDescCreaccAcctype(accountType);
		myPROCTRAN.setProcDescCreaccCustomer(new Integer(customerNumber).intValue());
		myPROCTRAN.setProcDescCreaccFooter(PROCTRAN.PROC_DESC_CREACC_FLAG);

		String description = myPROCTRAN.getProcTranDesc();





		openConnection();

		String sqlInsert = "INSERT INTO PROCTRAN "+
				"(PROCTRAN_EYECATCHER, "
				+ "PROCTRAN_SORTCODE,  "
				+ "PROCTRAN_NUMBER,  "
				+ "PROCTRAN_DATE, "
				+ "PROCTRAN_TIME, " 
				+ "PROCTRAN_REF, "
				+ "PROCTRAN_TYPE, "
				+ "PROCTRAN_DESC, "
				+ "PROCTRAN_AMOUNT) " +
				"VALUES ('" + PROCTRAN.PROC_TRAN_VALID + "'"+
				",'" + sortCode2 + "'" +
				",'" + String.format("%09d",Integer.parseInt(accountNumber)) + "'" +
				",'" + timestamp.toString() + "'" +
				",'" + timeString + "'" +
				",'" + taskRef + "'" +
				","  + "'" + PROCTRAN.PROC_TY_WEB_CREATE_ACCOUNT + "'" + 
				",'" + description + "'" +
				"," + actualBalance.setScale(2,RoundingMode.HALF_UP) + "" + 
				")";
		logger.fine("About to insert record SQL <" + sqlInsert + ">");
		try {
			PreparedStatement stmt = conn.prepareStatement(sqlInsert);
			stmt.executeUpdate();
		}
		catch(SQLException e)
		{
			logger.severe(e.getLocalizedMessage());
			logger.exiting(this.getClass().getName(),"writeCreateAccount(String sortCode2, String accountNumber, BigDecimal actualBalance,	Date lastStatement, Date nextStatement, String customerNumber, String accountType)",false);
			return false;
		}
		logger.exiting(this.getClass().getName(),"writeCreateAccount(String sortCode2, String accountNumber, BigDecimal actualBalance,	Date lastStatement, Date nextStatement, String customerNumber, String accountType)",true);
		return true;		
	}
	private void sortOutLogging()
	{
		try {
			LogManager.getLogManager().readConfiguration();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}