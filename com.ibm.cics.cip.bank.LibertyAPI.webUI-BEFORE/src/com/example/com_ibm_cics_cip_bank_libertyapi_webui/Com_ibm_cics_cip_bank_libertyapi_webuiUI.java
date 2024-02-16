package com.example.com_ibm_cics_cip_bank_libertyapi_webui;


import javax.servlet.annotation.WebServlet;

import com.vaadin.annotations.Theme;
import com.vaadin.annotations.VaadinServletConfiguration;

import com.vaadin.server.VaadinRequest;
import com.vaadin.ui.UI;

/**
 * This class is part of the "Vaadin" user interface. 
 */

/**
 * Licensed Materials - Property of IBM
 *
 * (c) Copyright IBM Corp. 2016,2020.
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 */



@SuppressWarnings("serial")
@Theme("com_ibm_cics_cip_bank_libertyapi_webui")

public class Com_ibm_cics_cip_bank_libertyapi_webuiUI extends UI {
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2016,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";

	@WebServlet(value = "/*", asyncSupported = true)
	@VaadinServletConfiguration(productionMode = false, ui = Com_ibm_cics_cip_bank_libertyapi_webuiUI.class)
	public static class Servlet extends JMeterServlet{
	}

	@Override
	protected void init(VaadinRequest request) {
		UI ui = this;
//		Authenticator.setDefault(new Authenticator() {
//
//		    @Override
//		    protected PasswordAuthentication getPasswordAuthentication() {          
//		        return new PasswordAuthentication("USERID", ("PASSWORD").toCharArray());
//		    }
//		});
		setTheme("com_ibm_cics_cip_bank_libertyapi_webui");
		setContent(new welcome(ui, ""));					

		
	}

}