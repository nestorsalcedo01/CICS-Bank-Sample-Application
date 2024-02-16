

package com.ibm.cics.cip.bankliberty.api.json;

import java.io.IOException;
import java.util.logging.LogManager;
import java.util.logging.Logger;

import javax.ws.rs.GET;

import javax.ws.rs.Path;

import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;

import com.ibm.cics.cip.bankliberty.dataInterfaces.GetCompany;
import com.ibm.cics.server.AbendException;
import com.ibm.cics.server.InvalidProgramIdException;
import com.ibm.cics.server.InvalidRequestException;
import com.ibm.cics.server.InvalidSystemIdException;
import com.ibm.cics.server.LengthErrorException;
import com.ibm.cics.server.NotAuthorisedException;
import com.ibm.cics.server.Program;
import com.ibm.cics.server.RolledBackException;

import com.ibm.cics.server.TerminalException;

import com.ibm.json.java.JSONObject;
/**
 * This class is used to get the Company Name
 * 
 */

/**
 * Licensed Materials - Property of IBM
 *
 * (c) Copyright IBM Corp. 2016,2020.
 *
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 * 
 */
@Path("/companyName")
public class CompanyNameResource{
	static String companyNameString = null;
	

	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2016,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";
	private static Logger logger = Logger.getLogger("com.ibm.cics.cip.bankliberty.api.json.CompanyNameResource");
	// </copyright>


	public CompanyNameResource()
	{
		sortOutLogging();
	}
	@GET
	@Produces("application/json")
	public Response getCompanyName() {
		logger.entering(this.getClass().getName(), "getCompanyName()");
// We cache the company name as a static variable. If not set, we jCICS LINK to a COBOL program to go get it
		if(companyNameString == null)
		{
			Program GETCOMPY = new Program();
			GETCOMPY.setName("GETCOMPY");

			byte[] companyNameBytes = new byte[40];



			try {
				GETCOMPY.link(companyNameBytes);
				GetCompany myGetCompanyData = new GetCompany(companyNameBytes);
				companyNameString = myGetCompanyData.getCompanyName().trim();
			} catch (InvalidRequestException | LengthErrorException
					| InvalidSystemIdException | NotAuthorisedException
					| InvalidProgramIdException | RolledBackException
					| TerminalException e) {
				Response myResponse = Response.status(500)
						.entity("CompanyNameResource.getCompanyName() has experienced error " + e.toString() + " linking to program GETCOMPY")
						.build();
				logger.warning("CompanyNameResource.getCompanyName() has experienced error " + e.toString() + " linking to program GETCOMPY");
				logger.exiting(this.getClass().getName(),  "getCompanyName()",myResponse);
				return myResponse;
			}
			catch (AbendException e) {
				logger.severe("CompanyNameResource.getCompanyName() has experienced abend " + e.toString() + " linking to program GETCOMPY");
				Response myResponse = Response.status(500).entity("CompanyNameResource.getCompanyName() has experienced error " + e.toString() + " linking to program GETCOMPY").build();
				logger.exiting(this.getClass().getName(),  "getCompanyName()",myResponse);
				return myResponse;
			}

		}

		JSONObject response = new JSONObject();
		response.put("companyName", companyNameString);
		
		Response myResponse = Response.status(200).entity(response.toString()).build();
		logger.exiting(this.getClass().getName(), "getCompanyName()",myResponse);

		return myResponse;
	}

	private void sortOutLogging()
	{
		try {
			LogManager.getLogManager().readConfiguration();
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
