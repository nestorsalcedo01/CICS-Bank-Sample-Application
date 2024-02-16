package com.ibm.cics.cip.bankliberty.api.json;

import java.math.BigDecimal;
import java.sql.Date;

import javax.validation.constraints.NotNull;
import javax.ws.rs.FormParam;

/**
 * This class describes the parts of the ProcessedTransactionAccountJSON record, used by ProcessedTransaction, in JSON format
 */

/**
 * Licensed Materials - Property of IBM
 *
 * (c) Copyright IBM Corp. 2019,2020.
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 */

public class ProcessedTransactionAccountJSON extends ProcessedTransactionJSON{
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2019,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";
	
	@NotNull
	@FormParam("customerNumber")
	String customerNumber;
	
	@NotNull
	@FormParam("type")
	String type;
	
	@NotNull
	@FormParam("lastStatement")
	Date lastStatement;
	
	@NotNull
	@FormParam("nextStatement")
	Date nextStatement;
	
	@NotNull
	@FormParam("actualBalance")
	BigDecimal actualBalance;

	public String getCustomerNumber() {
		return customerNumber;
	}

	public void setCustomerNumber(String customerNumber) {
		this.customerNumber = customerNumber;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Date getLastStatement() {
		return lastStatement;
	}

	public void setLastStatement(Date lastStatement) {
		this.lastStatement = lastStatement;
	}

	public Date getNextStatement() {
		return nextStatement;
	}

	public void setNextStatement(Date nextStatement) {
		this.nextStatement = nextStatement;
	}

	public BigDecimal getActualBalance() {
		return actualBalance;
	}

	public void setActualBalance(BigDecimal actualBalance) {
		this.actualBalance = actualBalance;
	}
	
	
	
	
	
	


}
