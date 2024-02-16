package com.ibm.cics.cip.bankliberty.api.json;

import java.math.BigDecimal;
import java.sql.Date;

import javax.validation.constraints.NotNull;
import javax.ws.rs.FormParam;

/**
 * This class describes the parts of the Account record in JSON format
 */

/**
 * Licensed Materials - Property of IBM
 *
 * (c) Copyright IBM Corp. 2019,2020.
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 */

public class AccountJSON {
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2019,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";


	@NotNull
	@FormParam("accountType")
	String accountType;

	@NotNull
	@FormParam("customerNumber")
	String customerNumber;

	@FormParam("dateOpened")
	Date dateOpened;

	@FormParam("lastStatementDate")
	Date lastStatementDate;

	@FormParam("nextStatementDate")
	Date nextStatementDate;

	@NotNull
	@FormParam("sortCode")
	String sortCode;

	@NotNull
	@FormParam("overdraft")
	Integer overdraft;

	@FormParam("actualBalance")
	BigDecimal actualBalance;

	@FormParam("availableBalance")
	BigDecimal availableBalance;

	@FormParam("interestRate")
	BigDecimal interestRate;

	public BigDecimal getInterestRate() {
		return interestRate;
	}

	public void setInterestRate(BigDecimal interestRate) {
		this.interestRate = interestRate;
	}

	String id;


	public String getAccountType() {
		return accountType;
	}

	public void setAccountType(String accountType) {
		this.accountType = accountType;
	}

	public String getCustomerNumber() {
		return customerNumber;
	}

	public void setCustomerNumber(String customerNumber) {
		this.customerNumber = customerNumber;
	}

	public Date getDateOpened() {
		return dateOpened;
	}

	public void setDateOpened(Date dateOpened) {
		this.dateOpened = dateOpened;
	}

	public Date getLastStatementDate() {
		return lastStatementDate;
	}

	public void setLastStatementDate(Date lastStatement) {
		this.lastStatementDate = lastStatement;
	}

	public Date getNextStatementDate() {
		return nextStatementDate;
	}

	public void setNextStatementDate(Date nextStatement) {
		this.nextStatementDate = nextStatement;
	}

	public Integer getOverdraft() {
		return overdraft;
	}

	public void setOverdraft(Integer overdraft) {
		this.overdraft = overdraft;
	}

	public BigDecimal getActualBalance() {
		return actualBalance;
	}

	public void setActualBalance(BigDecimal actualBalance) {
		this.actualBalance = actualBalance;
	}

	public BigDecimal getAvailableBalance() {
		return availableBalance;
	}

	public void setAvailableBalance(BigDecimal availableBalance) {
		this.availableBalance = availableBalance;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getSortCode() {
		return sortCode;
	}

	public void setSortCode(String sortCode) {
		this.sortCode = sortCode;
	}

	public boolean validateType(String accountType2) {
		// TODO Auto-generated method stub
		if(accountType2.equalsIgnoreCase("ISA")) 
		{
			return true;
		}
		if(accountType2.equalsIgnoreCase("MORTGAGE")) 
		{
			return true;
		}
		if(accountType2.equalsIgnoreCase("LOAN")) 
		{
			return true;
		}
		if(accountType2.equalsIgnoreCase("SAVING")) 
		{
			return true;
		}
		if(accountType2.equalsIgnoreCase("CURRENT")) 
		{
			return true;
		}
		
		return false;
	}









}
