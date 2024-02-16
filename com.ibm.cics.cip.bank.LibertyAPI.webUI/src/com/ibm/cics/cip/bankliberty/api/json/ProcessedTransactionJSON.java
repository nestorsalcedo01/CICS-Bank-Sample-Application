package com.ibm.cics.cip.bankliberty.api.json;

import javax.validation.constraints.NotNull;
import javax.ws.rs.FormParam;

/**
 * This class describes the parts of the ProcessedTransactionJSON record, used by ProcessedTransaction, in JSON format
 */

/**
 * Licensed Materials - Property of IBM
 *
 * (c) Copyright IBM Corp. 2019,2020.
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 */


public class ProcessedTransactionJSON{
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2019,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";
	
	@NotNull
	@FormParam("sortCode")
	String sortCode;
	
	@NotNull
	@FormParam("accountNumber")
	String accountNumber;

	public String getSortCode() {
		return sortCode;
	}

	public void setSortCode(String sortCode) {
		this.sortCode = sortCode;
	}

	public String getAccountNumber() {
		return accountNumber;
	}

	public void setAccountNumber(String accountNumber) {
		this.accountNumber = accountNumber;
	}


	


}
