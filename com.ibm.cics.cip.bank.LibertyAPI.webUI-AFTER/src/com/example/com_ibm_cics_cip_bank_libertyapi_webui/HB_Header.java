
package com.example.com_ibm_cics_cip_bank_libertyapi_webui;

import java.io.IOException;

import javax.ws.rs.core.Response;

import com.ibm.cics.cip.bankliberty.api.json.CompanyNameResource;
import com.ibm.json.java.JSONObject;
import com.vaadin.ui.Alignment;
import com.vaadin.ui.Button;
import com.vaadin.ui.HorizontalLayout;
import com.vaadin.ui.Label;
import com.vaadin.ui.UI;
import com.vaadin.ui.Button.ClickEvent;

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

public class HB_Header extends HorizontalLayout{
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2016,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";
	/**
	 * 
	 */
	private static final long serialVersionUID = -5542630839520498092L;
	Button back;
	Label label;

	@SuppressWarnings("unused")
	public HB_Header(UI ui, String name){
		setup();
		this.setComponentAlignment(label, Alignment.MIDDLE_CENTER);
	}

	@SuppressWarnings("unused")
	public HB_Header(final UI ui, String name, final welcome wlc){
		setupBack();
		setup();

		back.addClickListener(new Button.ClickListener() {
			/**
			 * 
			 */
			private static final long serialVersionUID = 3078798822184263174L;

			public void buttonClick(ClickEvent event) {
				ui.setContent(wlc);
			}
		});
	}

	@SuppressWarnings("unused")
	public HB_Header(final UI ui, String name, final Com_ibm_cics_cip_bank_libertyapi_webuiUI exit){
		setupBack();
		setup();

		back.addClickListener(new Button.ClickListener() {
			/**
			 * 
			 */
			private static final long serialVersionUID = 5051598750473268539L;

			public void buttonClick(ClickEvent event) {
				ui.setContent(exit);
			}
		});
	}



	@SuppressWarnings("unused")
	public HB_Header(final UI ui, String name, final Acc_list acc_list){
		setupBack();
		setup();

		back.addClickListener(new Button.ClickListener() {
			/**
			 * 
			 */
			private static final long serialVersionUID = -4825345661184875623L;

			public void buttonClick(ClickEvent event) {
				ui.setContent(acc_list);
			}
		});
	}

	private void setup(){
		this.setWidth("100%");
		this.setHeight("100px");
		//this.addStyleName("header");
		CompanyNameResource myCompanyNameResource = new CompanyNameResource();
		Response myCompanyNameResponse = null;

		myCompanyNameResponse = myCompanyNameResource.getCompanyName();

		if(myCompanyNameResponse.getStatus() == 200)
		{
			String myCompanyNameString = myCompanyNameResponse.getEntity().toString();

			JSONObject myCompanyNameJSON;
			try {
				myCompanyNameJSON = JSONObject.parse(myCompanyNameString);

				String companyName = (String) myCompanyNameJSON.get("companyName");
				label = new Label(companyName);
			}
			catch (IOException e) {
				e.printStackTrace();
				label = new Label("CICS Bank Sample Application");
			}

		}
		else
		{
			label = new Label("CICS Bank Sample Application");
		}



		label.setWidth(null);
		this.addComponent(label);
		this.setComponentAlignment(label, Alignment.MIDDLE_LEFT);
	}
	
	private void setupBack(){
		back = new Button("<---");
		this.addComponent(back);
		this.setComponentAlignment(back, Alignment.MIDDLE_LEFT);
	}

}
