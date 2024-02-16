
package com.example.com_ibm_cics_cip_bank_libertyapi_webui;

/**
 * This class is part of the "Vaadin" user interface. 
 */

/**
 * Licensed Materials - Property of IBM
 *
 * (c) Copyright IBM Corp. 2017,2020.
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 */

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Date;

import javax.ws.rs.core.Response;

import com.ibm.cics.cip.bankliberty.webui.dataAccess.Account;
import com.ibm.cics.cip.bankliberty.api.json.SortCodeResource;


import com.vaadin.ui.Alignment;
import com.vaadin.ui.Button;

import com.vaadin.ui.HorizontalLayout;
import com.vaadin.ui.Label;
import com.vaadin.ui.TextField;
import com.vaadin.ui.UI;
import com.vaadin.ui.VerticalLayout;

import com.vaadin.ui.Button.ClickEvent;
import com.vaadin.ui.ComboBox;


public class AccountUI extends VerticalLayout{
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2017,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";
	private static final long serialVersionUID = 1L;
	private Account a;
	private UI ui;
	private VerticalLayout vl = new VerticalLayout();
	private Boolean edit = false;
	private TextField accNumT; 
	private TextField cusNumT; private TextField sCodeT;
	private ComboBox typeT; private TextField interestT;
	private TextField overdraftT; private TextField balanceT;
	private static String sortcode;

	public AccountUI(UI ui, String user, welcome back){
		createAccUI(ui, back, user);
		edit = false;
		setSortcode();

	}

	public AccountUI(UI ui, String user, welcome back, Account acc){
		edit = true;
		this.a = acc;
		createAccUI(ui, back, user, acc);
		setFields(acc);
		setSortcode();

	}



	private void createAccUI(UI ui, welcome back, String user, Account acc) {
		this.ui = ui;
		HB_Header header = new HB_Header(ui, "New Account", back);
		this.addComponent(header);
		this.setExpandRatio(header, 0.1f);

		Label title = new Label("Account Creation / Update");
		this.addComponent(title);

		accNumT = new TextField("Account Number");
		accNumT.setValue(acc.getAccount_number());
		accNumT.setEnabled(false);

		HorizontalLayout cusNumL = new HorizontalLayout();
		cusNumL.setWidth("60%");
		cusNumT = new TextField("Customer Number");
		cusNumT.setValue(acc.getCustomer_number());
		cusNumT.setEnabled(false);

		sCodeT = new TextField("Sortcode");
		sCodeT.setValue(getSortcode());
		sCodeT.setEnabled(false);

		cusNumL.addComponent(accNumT);
		cusNumL.addComponent(cusNumT);
		cusNumT.setEnabled(!edit);
		cusNumL.addComponent(sCodeT);
		cusNumL.setComponentAlignment(sCodeT, Alignment.MIDDLE_RIGHT);

		HorizontalLayout typeL = new HorizontalLayout();
		typeL.setWidth("60%");

		typeT = new ComboBox("Type");
		typeT.addItem("CURRENT");
		typeT.addItem("ISA");
		typeT.addItem("LOAN");
		typeT.addItem("MORTGAGE");
		typeT.addItem("SAVING");
		typeT.setValue(acc.getType());
		typeT.setNullSelectionAllowed(false);
		interestT = new TextField("Interest");
		interestT.setValue(acc.getInterest_rate().setScale(2,RoundingMode.HALF_UP).toString());
		typeL.addComponent(typeT);
		typeL.addComponent(interestT);
		typeL.setComponentAlignment(interestT, Alignment.MIDDLE_RIGHT);

		HorizontalLayout overdraftL = new HorizontalLayout();
		overdraftL.setWidth("60%");
		overdraftT = new TextField("Overdraft Limit");
		balanceT = new TextField("Balance");
		balanceT.setEnabled(false);
		overdraftL.addComponent(overdraftT);
		overdraftL.addComponent(balanceT);
		overdraftL.setComponentAlignment(balanceT, Alignment.MIDDLE_RIGHT);

		Button submit;
		if (this.edit)
		{
			submit = new Button("Edit account");
		}
		else
		{
			submit = new Button("Create account");
		}
		HorizontalLayout buttonL = new HorizontalLayout();
		buttonL.setWidth("60%");
		buttonL.addComponent(submit);
		submit.setWidth("100%");

		submit.addClickListener(new Button.ClickListener() {
			/**
			 * 
			 */
			private static final long serialVersionUID = 3760485465663201508L;

			public void buttonClick(ClickEvent event) {
				if(edit == false){
					String temp = createNewAccount();
					if(temp.startsWith("-1"))
					{
						event.getButton().setCaption("Create new account failed");
					}
					else
					{
						event.getButton().setCaption("Create new account successful for account " + temp);
					}
				}
				else{

					if(!editAccount())
					{
						event.getButton().setCaption("Editing account " + a.getAccount_number() + " failed");
					}
					else
					{
						event.getButton().setCaption("Editing account " + a.getAccount_number() + " successful");
					}
				}
			}
		});

		this.addComponent(cusNumL);
		this.addComponent(typeL);
		this.addComponent(overdraftL);
		this.addComponent(buttonL);

		this.setComponentAlignment(buttonL, Alignment.MIDDLE_CENTER);
		this.setComponentAlignment(cusNumL, Alignment.MIDDLE_CENTER);
		this.setComponentAlignment(typeL, Alignment.MIDDLE_CENTER);
		this.setComponentAlignment(overdraftL, Alignment.MIDDLE_CENTER);



	}

	private void setFields(Account acc){
//		acc.showInfo();
		cusNumT.setValue(acc.getCustomer_number());
		sCodeT.setValue(acc.getSortcode());
		typeT.setValue(acc.getType().trim());
		interestT.setValue(String.valueOf(acc.getInterest_rate().setScale(2,RoundingMode.HALF_UP)));
		overdraftT.setValue(String.valueOf(acc.getOverdraft_limit()));
		balanceT.setValue(String.valueOf(acc.getActual_balance().setScale(2,RoundingMode.HALF_UP)));
	}

	@SuppressWarnings("serial")
	private void createAccUI(UI ui, welcome back, String user){

		this.ui = ui;
		HB_Header header = new HB_Header(ui, "New Account", back);
		this.addComponent(header);
		this.setExpandRatio(header, 0.1f);

		Label title = new Label("Account Creation / Update");
		this.addComponent(title);

		HorizontalLayout cusNumL = new HorizontalLayout();
		cusNumL.setWidth("60%");
		cusNumT = new TextField("Customer Number");
		sCodeT = new TextField("Sortcode");
		sCodeT.setValue(getSortcode());
		sCodeT.setEnabled(false);
		cusNumL.addComponent(cusNumT);
		cusNumT.setEnabled(!edit);
		cusNumL.addComponent(sCodeT);
		cusNumL.setComponentAlignment(sCodeT, Alignment.MIDDLE_RIGHT);

		HorizontalLayout typeL = new HorizontalLayout();
		typeL.setWidth("60%");

		typeT = new ComboBox("Type");
		typeT.addItem("CURRENT");
		typeT.addItem("ISA");
		typeT.addItem("LOAN");
		typeT.addItem("MORTGAGE");
		typeT.addItem("SAVING");
		typeT.setValue("CURRENT");
		typeT.setNullSelectionAllowed(false);
		interestT = new TextField("Interest");
		interestT.setValue("0.00");
		typeL.addComponent(typeT);
		typeL.addComponent(interestT);
		typeL.setComponentAlignment(interestT, Alignment.MIDDLE_RIGHT);

		HorizontalLayout overdraftL = new HorizontalLayout();
		overdraftL.setWidth("60%");
		overdraftT = new TextField("Overdraft Limit");
		overdraftT.setValue("0");

		balanceT = new TextField("Balance");
		balanceT.setEnabled(false);
		balanceT.setValue("0.00");
		overdraftL.addComponent(overdraftT);
		overdraftL.addComponent(balanceT);
		overdraftL.setComponentAlignment(balanceT, Alignment.MIDDLE_RIGHT);

		Button submit = new Button("Create account");
		HorizontalLayout buttonL = new HorizontalLayout();
		buttonL.setWidth("60%");
		buttonL.addComponent(submit);
		submit.setWidth("100%");

		submit.addClickListener(new Button.ClickListener() {
			public void buttonClick(ClickEvent event) {
				if(edit == false){
					String temp = createNewAccount();
					if(temp.startsWith("-1"))
					{
						event.getButton().setCaption("Create new account failed");
					}
					else
					{
						event.getButton().setCaption("Create new account successful for account " + temp);
					}
				}
				else{

					if(!editAccount())
					{
						event.getButton().setCaption("Editing account " + a.getAccount_number() + " failed");
					}
					else
					{
						event.getButton().setCaption("Editing account " + a.getAccount_number() + " successful");
					}

				}
			}
		});


		this.addComponent(cusNumL);
		this.addComponent(typeL);
		this.addComponent(overdraftL);
		this.addComponent(buttonL);

		this.setComponentAlignment(buttonL, Alignment.MIDDLE_CENTER);
		this.setComponentAlignment(cusNumL, Alignment.MIDDLE_CENTER);
		this.setComponentAlignment(typeL, Alignment.MIDDLE_CENTER);
		this.setComponentAlignment(overdraftL, Alignment.MIDDLE_CENTER);


	}

	private String createNewAccount(){
		if(validateSimple()){
			int temp = 0;
			BigDecimal tempBD = new BigDecimal(interestT.getValue()).setScale(2,RoundingMode.HALF_UP);
			Account newAcc = new Account(cusNumT.getValue(), sCodeT.getValue(), String.format("%08d",temp), 
					typeT.getValue().toString(), tempBD, new Date(), 
					Integer.valueOf(overdraftT.getValue()), null, null, 
					new BigDecimal(Double.valueOf(balanceT.getValue())), new BigDecimal(Double.valueOf(balanceT.getValue())));
//			newAcc.showInfo();
			temp = newAcc.addToDB();
			if(newAcc.inDB()){
				return newAcc.getAccount_number();
			}else{
				return "-1";
			}
		}
		return "-1";
	}

	private boolean editAccount(){


		a.setType(typeT.getValue().toString());
		a.setInterest_rate(new BigDecimal(Double.valueOf(interestT.getValue())));
		BigDecimal temp = a.getInterest_rate().setScale(2,RoundingMode.HALF_UP);
		a.setInterest_rate(temp);
		a.setOverdraft_limit(Integer.valueOf(overdraftT.getValue()));
		a.setActual_balance(new BigDecimal(Double.valueOf(balanceT.getValue())));
		a.setSortcode(sCodeT.getValue());
		if(a.updateThis())
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	private boolean validateSimple(){
		if(cusNumT.getValue().isEmpty())
		{
			return false;
		}
		try
		{
			Long temp = new Long(cusNumT.getValue());
		}
		catch(NumberFormatException e)
		{
			return false;
		}

		if(sCodeT.getValue().isEmpty())
		{
			return false;
		}
		if(typeT.getValue().toString().isEmpty())
		{
			return false;
		}
		
		if(interestT.getValue().isEmpty())
		{
			return false;
		}
		try
		{
			BigDecimal temp = new BigDecimal(interestT.getValue());
			if(temp.doubleValue() < 0)
			{
				return false;
			}
		}
		catch(NumberFormatException e)
		{
			return false;
		}
		
		if(overdraftT.getValue().isEmpty())
		{
			return false;
		}
		try
		{
			Integer temp = new Integer(overdraftT.getValue());
			if(temp.intValue() < 0)
			{
				return false;
			}
		}
		catch(NumberFormatException e)
		{
			return false;
		}
		
		if(balanceT.getValue().isEmpty())
		{
			return false;
		}
		return true;
	}
	private String getSortcode(){
		if(sortcode == null)
		{
			SortCodeResource mySortCodeResource = new SortCodeResource();
			Response mySortCodeJSON = mySortCodeResource.getSortCode();
			sortcode = ((String) mySortCodeJSON.getEntity()).substring(13, 19);
		}
		return sortcode;
	}
	
	private void setSortcode(){
		if(sortcode == null)
		{
			SortCodeResource mySortCodeResource = new SortCodeResource();
			Response mySortCodeJSON = mySortCodeResource.getSortCode();
			sortcode = ((String) mySortCodeJSON.getEntity()).substring(13, 19);
		}

	}

}
