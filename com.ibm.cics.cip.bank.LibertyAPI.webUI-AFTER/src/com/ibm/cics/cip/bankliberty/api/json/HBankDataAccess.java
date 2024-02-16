package com.ibm.cics.cip.bankliberty.api.json;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.logging.LogManager;
import java.util.logging.Logger;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import javax.sql.DataSource;

import com.ibm.cics.server.InvalidRequestException;
import com.ibm.cics.server.RolledBackException;
import com.ibm.cics.server.Task;

/**
 * This class is used to hold a HashTable which in turn holds DB2 Connections
 * 
 */

/**
 * Licensed Materials - Property of IBM
 *
 * (c) Copyright IBM Corp. 2019,2020.
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 */


public class HBankDataAccess {
	private 	DataSource 	ds;
	protected 	Connection	conn = null;
	static int connectionCount = 0;
	
	@SuppressWarnings("rawtypes")
	static Hashtable cornedBeef = null;
	private static Logger logger = Logger.getLogger("com.ibm.cics.cip.bankliberty.api.json");
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2019,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";	

	public HBankDataAccess()
	{
		sortOutLogging();
		if(cornedBeef == null)
		{
			logger.fine("HBankDataAccess creating new hashtable");
			cornedBeef = new Hashtable<>();
		}
	}


	protected void openConnection(){
		logger.entering(this.getClass().getName(),"openConnection()");

		Integer taskNumberInteger = new Integer(Task.getTask().getTaskNumber());
		String db2ConnString = "DB2CONN".concat(taskNumberInteger.toString());
		logger.fine("Attempting to get DB2CONN for task number " + taskNumberInteger.toString());
		this.conn = (Connection) cornedBeef.get(db2ConnString);
		if(this.conn == null)
		{
			connectionCount++;
			logger.fine("Attempting to create DB2CONN for task number " + taskNumberInteger.toString());
			openConnectionInternal();
			logger.fine("Creation succcessful for DB2CONN for task number " + taskNumberInteger.toString());
		}
		else
		{
			logger.fine("Reusing DB2CONN for task number " + taskNumberInteger.toString());

			try {
				if(this.conn.isClosed())
				{
					logger.warning("DB2 connection was closed, attempting to reopen");
					openConnectionInternal();
				}
			} catch (SQLException e) {
				logger.severe(e.getLocalizedMessage());
			}
		}

		logger.exiting(this.getClass().getName(),"openConnection()");
	} 


	public void terminate()
	{
		closeConnection();
	}
	

	public void closeConnection(){
		logger.entering(this.getClass().getName(),"closeConnection()");

		connectionCount--;

		Integer taskNumberInterger = new Integer(Task.getTask().getTaskNumber());
		String db2ConnString = "DB2CONN".concat(taskNumberInterger.toString());
		this.conn = (Connection) cornedBeef.get(db2ConnString);
		if(this.conn != null)
		{
			logger.fine("We have a DB2 connection to close");
			try {
				logger.fine("Syncpointing");
				Task.getTask().commit();
				this.conn.close();
				cornedBeef.remove(db2ConnString);
			} catch (SQLException e) {
				logger.severe("SQLException in com.ibm.cics.cip.bankliberty.web.db2.Customer " + e.getErrorCode() + "," + e.getSQLState() + ","  + e.getMessage());
			} catch (InvalidRequestException e) {
				logger.severe(e.getLocalizedMessage());
			} catch (RolledBackException e) {
				logger.severe(e.getLocalizedMessage());
			} 
		}
		logger.exiting(this.getClass().getName(),"closeConnection()");
	}

	
	
	@SuppressWarnings("unchecked")
	void openConnectionInternal()
	{
		logger.entering(this.getClass().getName(),"openConnectionInternal");
		String jndiString = "jdbc/defaultCICSDataSource";
		Context ctx;

		try{
			ctx = new InitialContext();
			ds = (DataSource) ctx.lookup(jndiString);
			logger.fine("jndi string is " + jndiString);
			if(this.conn == null){
				logger.fine("About to attempt to get DB2 connection");
				this.conn = ds.getConnection();
				this.conn.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
				Integer taskNumberInterger = new Integer(Task.getTask().getTaskNumber());
				String db2ConnString = "DB2CONN".concat(taskNumberInterger.toString());
				cornedBeef.put(db2ConnString,this.conn);
				connectionCount++;

			}else{
				if(this.conn.isClosed()){
					logger.fine("DB2 connection was closed, getting a new one");
					this.conn = ds.getConnection();
				}
			}
		} catch (NamingException e) {
			logger.severe(e.getMessage());
			Task.getTask().abend("HDB2");
		} catch (SQLException e) {
			logger.severe(e.getMessage());
			Task.getTask().abend("HDB2");
		} 
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
