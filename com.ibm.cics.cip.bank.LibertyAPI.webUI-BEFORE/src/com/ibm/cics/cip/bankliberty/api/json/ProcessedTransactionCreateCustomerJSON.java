package com.ibm.cics.cip.bankliberty.api.json;

import java.sql.Date;

import javax.validation.constraints.NotNull;
import javax.ws.rs.FormParam;


/**
 * This class describes the parts of the ProcessedTransactionCreateCustomerJSON record, used by ProcessedTransaction, in JSON format
 */

/**
 * Licensed Materials - Property of IBM
 *
 * (c) Copyright IBM Corp. 2019,2020.
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 */


public class ProcessedTransactionCreateCustomerJSON extends ProcessedTransactionJSON{
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2019,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";
	
	@NotNull
	@FormParam("customerName")
	String customerName;
	
	@NotNull
	@FormParam("customerNumber")
	String customerNumber;
	
	@NotNull
	@FormParam("customerDOB")
	Date customerDOB;
	
	@NotNull
	@FormParam("customerCreditScore")
	String customerCreditScore;
	
	@NotNull
	@FormParam("customerReviewDate")
	Date customerReviewDate;

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCustomerNumber() {
		return customerNumber;
	}

	public void setCustomerNumber(String customerNumber) {
		this.customerNumber = customerNumber;
	}

	public Date getCustomerDOB() {
		return customerDOB;
	}

	public void setCustomerDOB(Date customerDOB) {
		this.customerDOB = customerDOB;
	}

	public String getCreditScore() {
		return customerCreditScore;
	}

	public void setCreditScore(String customerCreditScore) {
		this.customerCreditScore = customerCreditScore;
	}

	public Date getReviewDate() {
		return customerDOB;
	}

	public void setReviewDate(Date customerReviewDate) {
		this.customerReviewDate = customerReviewDate;
	}
}
