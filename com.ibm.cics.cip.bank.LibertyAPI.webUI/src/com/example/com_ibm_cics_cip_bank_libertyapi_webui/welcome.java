
package com.example.com_ibm_cics_cip_bank_libertyapi_webui;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.core.Response;

import com.ibm.cics.cip.bankliberty.api.json.CompanyNameResource;
import com.ibm.json.java.JSONObject;

import com.vaadin.ui.Alignment;
import com.vaadin.ui.Button;
import com.vaadin.ui.HorizontalLayout;
import com.vaadin.ui.Label;
import com.vaadin.ui.UI;
import com.vaadin.ui.VerticalLayout;



import com.vaadin.ui.Button.ClickEvent;

/**
 * @author georgerushton
 *
 */

/**
 * This class is part of the "Vaadin" user interface. It is the first page you see!
 */

/**
 * Licensed Materials - Property of IBM
 *
 * (c) Copyright IBM Corp. 2016,2020.
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 */
public class welcome extends VerticalLayout{
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2016,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";
	
	/**
	 * This screen's UI
	 */
	private static final long serialVersionUID = 1L;
	// overall ui, needed to change content view
	private UI ui;

	public welcome(UI ui, String user){
		this.ui = ui;
		// create an add header
		HB_Header header = new HB_Header(ui, "welcome");
		this.addComponent(header);
		this.setExpandRatio(header, 0.1f);
		// create and add labels
		addLabels(user);
		// create and add buttons
		addButtons(user);
		
	}
	
	private void addLabels(String user){
		
		// creation
		Label welcomeText;
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
				welcomeText = new Label("Welcome to " + companyName + " " + user);
			}
			catch (IOException e) {
				e.printStackTrace();
				welcomeText = new Label("Welcome to CICS Bank Sample Application " + user +"!");
			}

		}
		else
		{
			welcomeText = new Label("Welcome to CICS Bank Sample Application " + user +"!");
		}
		
		
		Label selectText = new Label("Please select an option");
		welcomeText.setWidth(null);
		selectText.setWidth(null);
		
		// property edits + add to there own section (layout)
		
		VerticalLayout labels_vl = new VerticalLayout();
		labels_vl.setWidth("100%");
		labels_vl.setHeight("100%");
		
		labels_vl.addComponent(welcomeText);
		labels_vl.setComponentAlignment(welcomeText, Alignment.MIDDLE_CENTER);
		labels_vl.addComponent(selectText);
		labels_vl.setComponentAlignment(selectText, Alignment.MIDDLE_CENTER);
		
		// add section to class layout + class properties
		
		this.addComponent(labels_vl);
		this.setExpandRatio(labels_vl, 0.2f);
		this.setHeight("100%");
	}
	
	private void addButtons(final String user){
		// This bit adds the buttons that we see on the screen
		final welcome cur = this;
		// create button list (new buttons only need to be added here)
		List<Button> buttons = new ArrayList<Button>();
		buttons.add(new Button("List / Search Accounts"));
		buttons.add(new Button("Add Account"));
		buttons.add(new Button("List / Search Customers"));
		buttons.add(new Button("Add Customer"));
		
		// create horizontal layout list
		List<HorizontalLayout> hls= new ArrayList<HorizontalLayout>();
		
		// buttons vertical layout (all horizontal layouts added to this)
		VerticalLayout options_vl = new VerticalLayout();
		options_vl.setWidth("100%");
		options_vl.setHeight("100%");
		
		HorizontalLayout hl = new HorizontalLayout();
		
		// create all buttons and stick to style
		
		for(int i = 0; i<buttons.size();i++){
			final int i_ = i;
			buttons.get(i).setWidth("75%");
			buttons.get(i).setId("button"+i);
			// every 2 buttons create new horizontal layout, starting from 0
			
			if(i%2==0){
				hl = new HorizontalLayout();
				hl.setWidth("80%");
			}
				hl.addComponent(buttons.get(i));
				
			// every 2nd button set to right hand alignment
				
			if(i%2 != 0){
				hl.setComponentAlignment(buttons.get(i), Alignment.MIDDLE_RIGHT);
			}
			hls.add(hl);
			options_vl.addComponent(hl);
			options_vl.setComponentAlignment(hl, Alignment.MIDDLE_CENTER);
			
			buttons.get(i).addClickListener(new Button.ClickListener() {
				/**
				 * 
				 */
				private static final long serialVersionUID = 2410530021932378287L;

				@SuppressWarnings("unused")
				public void buttonClick(ClickEvent event) {
					int temp = 0;
					switch(i_){
					case 0: // Account List
						try
						{
							ui.setContent(new Acc_list(ui, cur));
						}
						catch(NumberFormatException nfe)
						{
							event.getButton().setCaption("Could not get load account list: GETSORTCODE link failed");
						}
						break;
					case 1: // Create Account
						ui.setContent(new AccountUI(ui, user, cur));
						break;
					case 2: // Customer List
						try
						{
							ui.setContent(new Cust_List(ui, user, cur));
						}
						catch(NumberFormatException nfe)
						{
							event.getButton().setCaption("Could not get load customer list: GETSORTCODE link failed");
						}
						break;
					case 3: // Create Customer
						ui.setContent(new CustomerUI(ui, user, cur));
						break;
					}
				}
			});
		}
		
		this.addComponent(options_vl);
		this.setExpandRatio(options_vl, 0.7f);
	}
		

	

}
