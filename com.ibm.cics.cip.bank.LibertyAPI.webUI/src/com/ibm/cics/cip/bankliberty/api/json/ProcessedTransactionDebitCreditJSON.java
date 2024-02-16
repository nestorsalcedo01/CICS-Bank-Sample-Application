package com.ibm.cics.cip.bankliberty.api.json;

import java.math.BigDecimal;

import javax.validation.constraints.NotNull;
import javax.ws.rs.FormParam;

/**
 * This class describes the parts of the ProcessedTransactionDebitCreditJSON record, used by ProcessedTransaction, in JSON format
 */

/**
 * Licensed Materials - Property of IBM
 *
 * (c) Copyright IBM Corp. 2019,2020.
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 */


public class ProcessedTransactionDebitCreditJSON extends ProcessedTransactionJSON{
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2019,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";
	
	@NotNull
	@FormParam("amount")
	BigDecimal amount;
	
	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}


}
