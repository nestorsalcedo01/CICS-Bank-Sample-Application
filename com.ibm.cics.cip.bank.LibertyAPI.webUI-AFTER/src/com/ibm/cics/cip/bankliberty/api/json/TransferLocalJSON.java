package com.ibm.cics.cip.bankliberty.api.json;





import javax.ws.rs.FormParam;

/**
 * This class describes the parts of the TransferLocal record in JSON format
 */

/**
 * Licensed Materials - Property of IBM
 *
 * (c) Copyright IBM Corp. 2019,2020.
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 */

public class TransferLocalJSON extends DebitCreditAccountJSON{
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2019,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";


	@FormParam("targetAccount")
	Integer targetAccount;

	public Integer getTargetAccount() {
		return targetAccount;
	}

	public void setTargetAccount(Integer targetAccount) {
		this.targetAccount = targetAccount;
	}



}
