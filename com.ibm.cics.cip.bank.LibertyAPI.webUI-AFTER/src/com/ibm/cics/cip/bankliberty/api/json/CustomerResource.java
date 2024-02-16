
package com.ibm.cics.cip.bankliberty.api.json;

import java.io.IOException;
import java.util.logging.LogManager;
import java.util.logging.Logger;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.ibm.cics.cip.bankliberty.web.vsam.Customer;
import com.ibm.cics.server.InvalidRequestException;
import com.ibm.cics.server.Task;
import com.ibm.json.java.JSONArray;
import com.ibm.json.java.JSONObject;

@Path("/customer")
public class CustomerResource{

	/**
	 * This class describes the methods of the Customer Resource
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
	static final String COPYRIGHT = "Licensed Materials - Property of IBM (c) Copyright IBM Corp. 2016,2020. All Rights Reserved. US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.";
	// </copyright>

	static String sortcode = null;



	private static Logger logger = Logger.getLogger("com.ibm.cics.cip.bankliberty.api.json");

	public CustomerResource()
	{
		sortOutLogging();
	}

	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public Response createCustomerExternal(CustomerJSON customer) {
		logger.entering(this.getClass().getName(),"createCustomerExternal(CustomerJSON customer) for customer " + customer.toString());
		Response myResponse = createCustomerInternal(customer); 
		HBankDataAccess myHBankDataAccess = new HBankDataAccess();
		myHBankDataAccess.terminate();
		logger.exiting(this.getClass().getName(),"createCustomerExternal(CustomerJSON customer)",myResponse);
		return myResponse;
	}


	public Response createCustomerInternal(CustomerJSON customer) {
		logger.entering(this.getClass().getName(),"createCustomerInternal(CustomerJSON customer) for customer " + customer.toString());
		Integer sortcode = this.getSortCode();
		JSONObject response = new JSONObject();

		String[] name = customer.getCustomerName().split(" ");


		if(!customer.validateTitle(name[0].trim()))
		{
			JSONObject error = new JSONObject();
			error.put("errorMessage", "Customer title " + name[0] + " is not valid");
			Response myResponse = Response.status(400).entity(error.toString()).build();
			logger.warning("Invalid title in CustomerResource.createCustomerInternal(), " + name[0].trim());
			logger.exiting(this.getClass().getName(), "createCustomerInternal() exiting",myResponse);
			return myResponse;
		}

		Integer inputSortCode = new Integer(customer.getSortCode());
		Integer thisSortCode = this.getSortCode();

		if(inputSortCode.intValue() != thisSortCode.intValue())
		{
			JSONObject error = new JSONObject();
			error.put("errorMessage", "Sortcode " +  inputSortCode + " not valid for this bank (" + thisSortCode + ")");
			Response myResponse = Response.status(400).entity(error.toString()).build();
			logger.warning("Invalid sortcode CustomerResource.createCustomerInternal(), " + inputSortCode.intValue());
			logger.exiting(this.getClass().getName(), "createCustomerInternal() exiting",myResponse);
			return myResponse;
		}



		com.ibm.cics.cip.bankliberty.web.vsam.Customer vsamCustomer = new com.ibm.cics.cip.bankliberty.web.vsam.Customer();

		customer.setSortCode(this.getSortCode().toString());
		vsamCustomer = vsamCustomer.createCustomer(customer, this.getSortCode(),false);

		if (vsamCustomer == null) 
		{
			JSONObject error = new JSONObject();
			error.put("errorMessage", "Failed to create customer in com.ibm.cics.cip.bankliberty.web.vsam.Customer");
			logger.severe("Failed to create customer in com.ibm.cics.cip.bankliberty.web.vsam.Customer");
			Response myResponse = Response.status(500).entity(error.toString()).build();
			logger.exiting(this.getClass().getName(), "createCustomerInternal() exiting",myResponse);
			return myResponse;
		}


		response.put("id", vsamCustomer.getCustomer_number());
		response.put("sortcode", sortcode.toString());
		response.put("customerName", customer.getCustomerName());
		response.put("customerAddress", customer.getCustomerAddress());
		response.put("dateOfBirth", customer.getDateOfBirth().toString());

		ProcessedTransactionResource myProcessedTransactionResource = new ProcessedTransactionResource();

		ProcessedTransactionCreateCustomerJSON myCreatedCustomer = new ProcessedTransactionCreateCustomerJSON();
		myCreatedCustomer.setAccountNumber("0");
		myCreatedCustomer.setCustomerDOB(vsamCustomer.getDob());
		myCreatedCustomer.setCustomerName(vsamCustomer.getName());
		myCreatedCustomer.setSortCode(vsamCustomer.getSortcode());
		myCreatedCustomer.setCustomerNumber(vsamCustomer.getCustomer_number());

		Response writeCreateCustomerResponse = myProcessedTransactionResource.writeCreateCustomerInternal(myCreatedCustomer);
		if(writeCreateCustomerResponse == null || writeCreateCustomerResponse.getStatus() != 200)
		{
			JSONObject error = new JSONObject();
			error.put("errorMessage", "Failed to write to PROCTRAN data store");
			try {
				logger.severe("Customer: createCustomer: Failed to write to PROCTRAN");
				Task.getTask().rollback();
			} catch (InvalidRequestException e) {
			}
			Response myResponse = Response.status(500).entity(error.toString()).build();
			logger.exiting(this.getClass().getName(), "createCustomerInternal() exiting",myResponse);
			return myResponse;
		}



		Response myResponse = Response.status(201).entity(response.toString()).build();
		logger.exiting(this.getClass().getName(), "createCustomerInternal() exiting",myResponse);
		return myResponse;
	}

	@PUT
	@Path("/{id}")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.APPLICATION_JSON)
	public Response updateCustomerExternal(
			@PathParam("id") Long id,
			CustomerJSON customer) {
		logger.entering(this.getClass().getName(), "updateCustomerExternal for customerNumber " + id);
		Response myResponse = updateCustomerInternal(id,customer); 
		HBankDataAccess myHBankDataAccess = new HBankDataAccess();
		myHBankDataAccess.terminate();
		logger.exiting(this.getClass().getName(), "updateCustomerExternal for customerNumber " + id,myResponse);
		return myResponse;

	}


	public Response updateCustomerInternal(
			@PathParam("id") Long id,
			CustomerJSON customer) {
		logger.entering(this.getClass().getName(), "updateCustomerInternal for customerNumber " + id);
		String[] name = customer.getCustomerName().split(" ");


		if(!customer.validateTitle(name[0].trim()))
		{
			JSONObject error = new JSONObject();
			error.put("errorMessage", "Customer title " + name[0] + " is not valid");
			Response myResponse = Response.status(400).entity(error.toString()).build();
			logger.warning("Invalid title in CustomerResource.updateCustomerInternal(), " + name[0].trim());
			logger.exiting(this.getClass().getName(), "createCustomerInternal() exiting",myResponse);
			return myResponse;
		}

		Integer inputSortCode = new Integer(customer.getSortCode());
		Integer thisSortCode = this.getSortCode();

		if(inputSortCode.intValue() != thisSortCode.intValue())
		{
			JSONObject error = new JSONObject();
			error.put("errorMessage", "Sortcode " +  inputSortCode + " not valid for this bank (" + thisSortCode + ")");
			logger.warning("Invalid sortcode in CustomerResource.updateCustomerInternal(), " + inputSortCode);
			return Response.status(400).entity(error.toString()).build();
		}

		JSONObject response = new JSONObject();



		com.ibm.cics.cip.bankliberty.web.vsam.Customer vsamCustomer = new com.ibm.cics.cip.bankliberty.web.vsam.Customer();
		customer.setId(id.toString());
		customer.setSortCode(this.getSortCode().toString());
		vsamCustomer = vsamCustomer.updateCustomer(customer);
		if(vsamCustomer != null)
		{
			if(vsamCustomer.isNot_found())
			{
				JSONObject error = new JSONObject();
				error.put("errorMessage", "Customer " + id.toString() + " not found.");
				Response myResponse = Response.status(404).entity(error.toString()).build();
				logger.warning("Failed to find customer in com.ibm.cics.cip.bankliberty.web.vsam.Customer");
				logger.exiting(this.getClass().getName(), "updateCustomerInternal() exiting",myResponse);
				return myResponse;
			}
			response.put("id", vsamCustomer.getCustomer_number());
			response.put("sortCode", vsamCustomer.getSortcode().trim());
			response.put("customerName", vsamCustomer.getName().trim());
			response.put("customerAddress", vsamCustomer.getAddress().trim());
			response.put("dateOfBirth", vsamCustomer.getDob().toString().trim());
		}
		else
		{
			JSONObject error = new JSONObject();
			error.put("errorMessage", "Failed to update customer in com.ibm.cics.cip.bankliberty.web.vsam.Customer");
			Response myResponse = Response.status(500).entity(error.toString()).build();
			logger.warning("Failed to update customer in com.ibm.cics.cip.bankliberty.web.vsam.Customer");
			logger.exiting(this.getClass().getName(), "updateCustomerInternal() exiting",myResponse);
			return myResponse;
		}

		logger.exiting(this.getClass().getName(), "updateCustomerInternal for customerNumber " + id,Response.status(200).entity(response.toString()).build());
		return Response.status(200).entity(response.toString()).build();
	}


	@GET
	@Path("/{id}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getCustomerExternal(@PathParam("id") Long id) {
		logger.entering(this.getClass().getName(),"getCustomerExternal for customerNumber " + id);

		try{
			Response myResponse = getCustomerInternal(id);
			HBankDataAccess myHBankDataAccess = new HBankDataAccess();
			myHBankDataAccess.terminate();
			logger.exiting(this.getClass().getName(),"getCustomerExternal",myResponse);
			return myResponse;

		} catch (Exception ex) {
			// Log the exception
			logger.warning("Exception in getCustomerExternal "+ ex );
			ex.printStackTrace();
		}
		logger.exiting(this.getClass().getName(),"getCustomerExternal",null);

		return null;


	}


	public Response getCustomerInternal(@PathParam("id") Long id) {
		logger.entering(this.getClass().getName(),"getCustomerInternal for customerNumber " + id);
		Integer sortCode = this.getSortCode();
		Long id_safe = id;


		JSONObject response = new JSONObject();

		if(id.longValue() < 0)
		{

			response.put("errorMessage","Customer number cannot be negative");
			Response myResponse = Response.status(404).entity(response.toString()).build();
			logger.warning("Customer number supplied was negative in CustomerResource.getCustomerInternal");
			logger.exiting(this.getClass().getName(), "getCustomerInternal() exiting",myResponse);
			return myResponse;
		}


		com.ibm.cics.cip.bankliberty.web.vsam.Customer vsamCustomer = new com.ibm.cics.cip.bankliberty.web.vsam.Customer();
		vsamCustomer = vsamCustomer.getCustomer(new Long(id).longValue(), sortCode.intValue());
		if(vsamCustomer != null)
		{
			response.put("sortCode", vsamCustomer.getSortcode().trim());
			response.put("id", vsamCustomer.getCustomer_number().trim());
			response.put("customerName", vsamCustomer.getName().trim());
			response.put("customerAddress", vsamCustomer.getAddress().trim());
			response.put("dateOfBirth", vsamCustomer.getDob().toString());
			response.put("customerCreditScore", vsamCustomer.getCreditScore().trim());
			response.put("customerCreditScoreReviewDate", vsamCustomer.getReviewDate().toString());
		}
		else
		{

			response.put("errorMessage","Customer " + id + " not found");
			Response myResponse = Response.status(404).entity(response.toString()).build();
			logger.warning("Customer not found in in com.ibm.cics.cip.bankliberty.web.vsam.Customer");
			logger.exiting(this.getClass().getName(), "getCustomerInternal() exiting",myResponse);
			return myResponse;
		}

		logger.exiting(this.getClass().getName(), "getCustomerInternal(Long id)",Response.status(200).entity(response.toString()).build());
		return Response.status(200).entity(response.toString()).build();
	}


	@DELETE
	@Path("/{id}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response deleteCustomerExternal(@PathParam("id") Long id) {
		logger.entering(this.getClass().getName(), "deleteCustomerExtnernal(Long id) for customerNumber " + id);
		Response myResponse = deleteCustomerInternal(id); 
		HBankDataAccess myHBankDataAccess = new HBankDataAccess();
		myHBankDataAccess.terminate();
		logger.exiting(this.getClass().getName(), "deleteCustomerExternal(Long id)",myResponse);
		return myResponse;
	}


	public Response deleteCustomerInternal(Long id) {
		logger.entering(this.getClass().getName(), "deleteCustomerInternal(Long id) for customerNumber " + id);

		Integer sortCode = this.getSortCode();


		JSONObject response = new JSONObject();

		if(id.longValue() < 0)
		{

			response.put("errorMessage","Customer number cannot be negative");
			Response myResponse = Response.status(404).entity(response.toString()).build();
			logger.warning("Customer number supplied was negative in deleteCustomerInternal()");
			logger.exiting(this.getClass().getName(), "deleteCustomerInternal() exiting",myResponse);
			return myResponse;
		}


		// First we need to delete all the accounts

		AccountsResource myAccountsResource = new AccountsResource();

		JSONObject myAccountsJSON;
		try {
			myAccountsJSON = JSONObject.parse(myAccountsResource.getAccountsByCustomerInternal(id,false).getEntity().toString());
		} catch (IOException e) {

			response.put("errorMessage","Error obtaining accounts to delete for customer " + id);
			Response myResponse = Response.status(500).entity(response.toString()).build();
			logger.warning("Error obtaining accounts to delete for customer " + id + " in deleteCustomerInternal()");
			logger.exiting(this.getClass().getName(), "getCustomerInternal() exiting",myResponse);
			return myResponse;
		}
		//		
		JSONArray accounts_to_delete = (JSONArray) myAccountsJSON.get("accounts");
		for(int i = 0; i < accounts_to_delete.size();i++)
		{

			JSONObject account_to_delete = (JSONObject) accounts_to_delete.get(i);
			Long account_to_delete_long = new Long((String) account_to_delete.get("id"));
			Response deleteAccountResponse = myAccountsResource.deleteAccountInternal(account_to_delete_long);


			if(deleteAccountResponse.getStatus() == 404)
			{

				response.put("errorMessage","Error deleting account " + account_to_delete_long + " for customer " + id + ",account not found");
				try {
					System.err.println("Customer: deleteAccount: Failed to delete account, not found");
					Task.getTask().rollback();
				} catch (InvalidRequestException e) {
					System.err.println("rollback failed " + e.toString());
					e.printStackTrace();
				}
				Response myResponse = Response.status(404).entity(response.toString()).build();
				logger.warning("Customer: deleteAccount: Failed to delete account, not found for customer " + id + " in deleteCustomerInternal()");
				logger.exiting(this.getClass().getName(), "deleteCustomerInternal() exiting",myResponse);
				return myResponse;
			}

			if(deleteAccountResponse.getStatus() != 200)
			{

				response.put("errorMessage","Error deleting account " + account_to_delete_long + " for customer " + id);
				try {
					System.err.println("Customer: deleteAccount: Failed to delete account, error");
					Task.getTask().rollback();
				} catch (InvalidRequestException e) {
					System.err.println("rollback failed " + e.toString());
					e.printStackTrace();
				}
				Response myResponse = Response.status(deleteAccountResponse.getStatus()).entity(response.toString()).build();
				logger.exiting(this.getClass().getName(), "deleteCustomerInternal() exiting",myResponse);
				return myResponse;
			}
		}

		// If we are still here then we can try to delete the customer

		com.ibm.cics.cip.bankliberty.web.vsam.Customer vsamCustomer = new com.ibm.cics.cip.bankliberty.web.vsam.Customer();

		vsamCustomer = vsamCustomer.deleteCustomer(new Long(id).longValue(), sortCode.intValue());

		if(vsamCustomer != null)
		{
			if(vsamCustomer.isNot_found())
			{
				response.put("errorMessage","Customer " + id + " not found");
				Response myResponse = Response.status(404).entity(response.toString()).build();
				logger.warning("CustomerResource.deleteCustomerInternal() customer " + id + " not found");
				logger.exiting(this.getClass().getName(), "deleteCustomerInternal()",myResponse);
				return myResponse;	
			}
			response.put("sortCode", vsamCustomer.getSortcode().trim());
			response.put("id", vsamCustomer.getCustomer_number().trim());
			response.put("customerName", vsamCustomer.getName().trim());
			response.put("customerAddress", vsamCustomer.getAddress().trim());

			response.put("dateOfBirth", vsamCustomer.getDob().toString());

			if(vsamCustomer.getCreditScore() != null){
				response.put("customerCreditScore", vsamCustomer.getCreditScore().toString());
				response.put("customerCreditScoreReviewDate", vsamCustomer.getReviewDate().toString());
			}

			ProcessedTransactionResource myProcessedTransactionResource = new ProcessedTransactionResource();

			ProcessedTransactionDeleteCustomerJSON myDeletedCustomer = new ProcessedTransactionDeleteCustomerJSON();
			myDeletedCustomer.setAccountNumber("0");
			myDeletedCustomer.setCustomerDOB(vsamCustomer.getDob());
			myDeletedCustomer.setCustomerName(vsamCustomer.getName());
			myDeletedCustomer.setSortCode(vsamCustomer.getSortcode());
			myDeletedCustomer.setCustomerNumber(vsamCustomer.getCustomer_number());

			Response writeDeleteCustomerResponse = myProcessedTransactionResource.writeDeleteCustomerInternal(myDeletedCustomer);
			if(writeDeleteCustomerResponse == null || writeDeleteCustomerResponse.getStatus() != 200)
			{
				JSONObject error = new JSONObject();
				error.put("errorMessage", "Failed to write to PROCTRAN data store");
				try {
					System.err.println("Customer: deleteCustomer: Failed to write to proctran");
					Task.getTask().rollback();
				} catch (InvalidRequestException e) {
				}
				Response myResponse = Response.status(500).entity(error.toString()).build();
				logger.warning("CustomerResource.deleteCustomerInternal() failed to write to proctran");
				logger.exiting(this.getClass().getName(), "deleteCustomerInternal()",myResponse);
				return myResponse;
			}


		}
		else
		{
			response.put("errorMessage","Unable to access Customer " + id + ".");
			Response myResponse = Response.status(500).entity(response.toString()).build();
			logger.warning("CustomerResource.deleteCustomerInternal() unable to access customer " + id);
			logger.exiting(this.getClass().getName(), "deleteCustomerInternal()",myResponse);
			return myResponse;
		}

		logger.exiting(this.getClass().getName(), "deleteCustomerInternal(Long id)",Response.status(200).entity(response.toString()).build());
		return Response.status(200).entity(response.toString()).build();
	}

	@GET
	@Path("/all/town/{town}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getCustomersTownExternal(@PathParam ("town") String town) {

		logger.entering(this.getClass().getName(), "getCustomersTownExternal(String town) for town " + town);
		Response myResponse = getCustomersTownInternal(town); 
		HBankDataAccess myHBankDataAccess = new HBankDataAccess();
		myHBankDataAccess.terminate();
		logger.exiting(this.getClass().getName(), "getCustomersTownExternal(String town)",myResponse);
		return myResponse;
	}


	public Response getCustomersTownInternal(String town) {

		logger.entering(this.getClass().getName(), "getCustomersTownInternal(String town) for town " + town);

		JSONArray allCustomers = new JSONArray();


		JSONObject response = new JSONObject();

		com.ibm.cics.cip.bankliberty.web.vsam.Customer myCustomer = new Customer();
		myCustomer.setSortcode(this.getSortCode().toString());
		com.ibm.cics.cip.bankliberty.web.vsam.Customer vsamCustomers[] = myCustomer.getCustomersByTown(town);


		for(int i=0;i<vsamCustomers.length;i++)
		{
			response.put("id", vsamCustomers[i].getCustomer_number().trim());
			response.put("name", vsamCustomers[i].getName().trim());
			response.put("address", vsamCustomers[i].getAddress().trim());

			String dateOfBirth = new String();
			Integer dobDD = new Integer(vsamCustomers[i].getDob().getDay());
			dateOfBirth = dateOfBirth.concat(dobDD.toString());
			dateOfBirth = dateOfBirth.concat("-");

			Integer dobMM = new Integer(vsamCustomers[i].getDob().getMonth()+1);
			dateOfBirth = dateOfBirth.concat(dobMM.toString());
			dateOfBirth = dateOfBirth.concat("-");

			Integer dobYYYY = new Integer(vsamCustomers[i].getDob().getYear()+1900);
			dateOfBirth = dateOfBirth.concat(dobYYYY.toString());

			response.put("Date of Birth",dateOfBirth);
			allCustomers.add(response);
		}

		logger.exiting(this.getClass().getName(), "getCustomersTownInternal(String town)",Response.status(200).entity(allCustomers.toString()).build());
		return Response.status(200).entity(allCustomers.toString()).build();
	}

	@GET
	@Path("/all/surname/{surname}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getCustomersSurnameExternal(@PathParam ("surname") String surname) {
		logger.entering(this.getClass().getName(), "getCustomersSurnameExternal(String surname) for surname " + surname);
		Response myResponse = getCustomersSurnameInternal(surname); 
		HBankDataAccess myHBankDataAccess = new HBankDataAccess();
		myHBankDataAccess.terminate();
		logger.exiting(this.getClass().getName(), "getCustomersSurnameExternal(String surname)",myResponse);
		return myResponse;
	}

	public Response getCustomersSurnameInternal(String surname) {

		logger.entering(this.getClass().getName(), "getCustomersSurnameInternal(String surname) for surname " + surname);

		JSONArray allCustomers = new JSONArray();


		JSONObject response = new JSONObject();

		com.ibm.cics.cip.bankliberty.web.vsam.Customer myCustomer = new Customer();
		myCustomer.setSortcode(this.getSortCode().toString());
		com.ibm.cics.cip.bankliberty.web.vsam.Customer vsamCustomers[] = myCustomer.getCustomersBySurname(surname);


		for(int i=0;i<vsamCustomers.length;i++)
		{
			response.put("id", vsamCustomers[i].getCustomer_number().trim());
			response.put("name", vsamCustomers[i].getName().trim());
			response.put("address", vsamCustomers[i].getAddress().trim());

			String dateOfBirth = new String();
			Integer dobDD = new Integer(vsamCustomers[i].getDob().getDay());
			dateOfBirth = dateOfBirth.concat(dobDD.toString());
			dateOfBirth = dateOfBirth.concat("-");

			Integer dobMM = new Integer(vsamCustomers[i].getDob().getMonth()+1);
			dateOfBirth = dateOfBirth.concat(dobMM.toString());
			dateOfBirth = dateOfBirth.concat("-");

			Integer dobYYYY = new Integer(vsamCustomers[i].getDob().getYear()+1900);
			dateOfBirth = dateOfBirth.concat(dobYYYY.toString());

			response.put("Date of Birth",dateOfBirth);
			allCustomers.add(response);
		}

		logger.exiting(this.getClass().getName(), "getCustomersSurnameInternal(String surname)",Response.status(200).entity(allCustomers.toString()).build());
		return Response.status(200).entity(allCustomers.toString()).build();	
	}

	@SuppressWarnings("deprecation")
	@GET
	@Path("/all/age/{age}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getCustomersAgeExternal(@PathParam ("age") String age) {
		logger.entering(this.getClass().getName(), "getCustomersAgeExternal(String age) for age " + age);
		Response myResponse = getCustomersAgeInternal(age); 
		HBankDataAccess myHBankDataAccess = new HBankDataAccess();
		myHBankDataAccess.terminate();
		logger.entering(this.getClass().getName(), "getCustomersAgeExternal(String age)",myResponse);
		return myResponse;
	}


	public Response getCustomersAgeInternal(String age) {

		logger.entering(this.getClass().getName(), "getCustomersAgeInternalInternal(String age) for age " + age);

		JSONArray allCustomers = new JSONArray();


		JSONObject response = new JSONObject();

		com.ibm.cics.cip.bankliberty.web.vsam.Customer myCustomer = new Customer();
		myCustomer.setSortcode(this.getSortCode().toString());
		com.ibm.cics.cip.bankliberty.web.vsam.Customer vsamCustomers[] = myCustomer.getCustomersByAge(new Integer(age).intValue());


		for(int i=0;i<vsamCustomers.length;i++)
		{
			response.put("id", vsamCustomers[i].getCustomer_number().trim());
			response.put("name", vsamCustomers[i].getName().trim());
			response.put("address", vsamCustomers[i].getAddress().trim());

			String dateOfBirth = new String();
			Integer dobDD = new Integer(vsamCustomers[i].getDob().getDay());
			dateOfBirth = dateOfBirth.concat(dobDD.toString());
			dateOfBirth = dateOfBirth.concat("-");

			Integer dobMM = new Integer(vsamCustomers[i].getDob().getMonth()+1);
			dateOfBirth = dateOfBirth.concat(dobMM.toString());
			dateOfBirth = dateOfBirth.concat("-");

			Integer dobYYYY = new Integer(vsamCustomers[i].getDob().getYear()+1900);
			dateOfBirth = dateOfBirth.concat(dobYYYY.toString());

			response.put("Date of Birth",dateOfBirth);
			allCustomers.add(response);
		}

		logger.exiting(this.getClass().getName(), "getCustomersAgeInternal(String age)",Response.status(200).entity(allCustomers.toString()).build());
		return Response.status(200).entity(allCustomers.toString()).build();	
	}

	private Integer getSortCode() {
		logger.entering(this.getClass().getName(), "getSortCode()");
		if(sortcode == null)
		{
			SortCodeResource mySortCodeResource = new SortCodeResource();
			Response mySortCodeJSON = mySortCodeResource.getSortCode();
			sortcode = ((String) mySortCodeJSON.getEntity()).substring(13, 19);
		}
		logger.exiting(this.getClass().getName(), "getSortCode()",new Integer(sortcode));
		return new Integer(sortcode);
	}


	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public Response getCustomersExternal(@QueryParam("limit") Integer limit, @QueryParam("offset") Integer offset,@QueryParam("countOnly") Boolean countOnly) {
		logger.entering(this.getClass().getName(), "getCustomersExternal(Integer limit, Integer offset, Boolean countOnly) " + limit + " " + offset + " " + countOnly);
		boolean countOnlyReal = false;
		if(countOnly != null)
		{
			countOnlyReal = countOnly.booleanValue();
		}
		Response myResponse = getCustomersInternal(limit,offset,countOnlyReal); 
		HBankDataAccess myHBankDataAccess = new HBankDataAccess();
		myHBankDataAccess.terminate();
		logger.exiting(this.getClass().getName(), "getCustomersExternal(Integer limit, Integer offset, Boolean countOnly)",myResponse);
		return myResponse;
	}

	public Response getCustomersInternal(@QueryParam("limit") Integer limit, @QueryParam("offset") Integer offset,boolean countOnly) {
		logger.entering(this.getClass().getName(), "getCustomersInternal(Integer limit, Integer offset, Boolean countOnly) " + limit + " " + offset + " " + countOnly);
		Integer sortCode = this.getSortCode();


		JSONObject response = new JSONObject();
		JSONArray customers = null;


		logger.fine("offset is " + offset);
		if(offset == null)
		{
			logger.fine("Offset is null defaulting to zero");
			offset = new Integer(0);
		}

		if(limit == null)
		{
			logger.fine("Limit not supplied, defaulting to zero");
			limit = new Integer(250000);
		}

		if(limit.intValue() == 0)
		{
			logger.fine("Limit is zero, defaulting to 250,000");
			limit = new Integer(250000);
		}

		if(countOnly)
		{
			com.ibm.cics.cip.bankliberty.web.vsam.Customer vsamCustomer = new com.ibm.cics.cip.bankliberty.web.vsam.Customer();
			long customerCount = vsamCustomer.getCustomersCountOnly(sortCode.intValue());
			response.put("numberOfCustomers",customerCount);
		}
		else
		{
			com.ibm.cics.cip.bankliberty.web.vsam.Customer[] myCustomers = null;
			com.ibm.cics.cip.bankliberty.web.vsam.Customer vsamCustomer = new com.ibm.cics.cip.bankliberty.web.vsam.Customer();
			myCustomers = vsamCustomer.getCustomers(sortCode.intValue(),limit,offset);

			if(myCustomers != null)
			{
				customers = new JSONArray(myCustomers.length);


				for(int i = 0;i < myCustomers.length;i++)
				{
					JSONObject customer = new JSONObject();
					customer.put("sortCode", myCustomers[i].getSortcode().trim());
					customer.put("customerName", myCustomers[i].getName().trim());
					customer.put("id",myCustomers[i].getCustomer_number().trim());
					customer.put("customerAddress", myCustomers[i].getAddress().trim());
					customer.put("dateOfBirth", myCustomers[i].getDob().toString());
					customer.put("customerCreditScore", myCustomers[i].getCreditScore().trim());
					customer.put("customerCreditScoreReviewDate", myCustomers[i].getReviewDate().toString());
					customers.add(customer);

				}
				response.put("customers", customers);
				response.put("numberOfCustomers",customers.size());

			}
			else
			{

				response.put("errorMessage","Customers cannot be listed in com.ibm.cics.cip.bankliberty.web.vsam.Customer");
				logger.warning(this.getClass().getName() + ".getCustomersInternal() " + " Customers cannot be listed in com.ibm.cics.cip.bankliberty.web.vsam.Customer");
				Response myResponse = Response.status(404).entity(response.toString()).build();
				logger.exiting(this.getClass().getName(),"getCustomersInternal()",myResponse);
				return myResponse;
			}
		}

		logger.exiting(this.getClass().getName(), "getCustomersInternal(Integer limit, Integer offset, Boolean countOnly)",Response.status(200).entity(response.toString()).build());
		return Response.status(200).entity(response.toString()).build();

	}

	@GET
	@Path("/name")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getCustomersByNameExternal(@QueryParam("name") String name,@QueryParam("limit") Integer limit, @QueryParam("offset") Integer offset,@QueryParam("countOnly") Boolean countOnly)
	{
		logger.entering(this.getClass().getName(), "getCustomersByNameExternal(String name, Integer limit, Integer offset, Boolean countOnly) " + name + " " + limit + " " + offset + " " + countOnly);

		boolean countOnlyReal = false;
		if(countOnly != null)
		{
			countOnlyReal = countOnly.booleanValue();
		}
		logger.fine("offset is " + offset);
		if(offset == null)
		{
			logger.fine("Offset is null defaulting to zero");
			offset = new Integer(0);
		}

		if(limit == null)
		{
			logger.fine("Limit not supplied, defaulting to 250,000");
			limit = new Integer(250000);
		}

		if(limit.intValue() == 0)
		{
			logger.fine("Limit is zero, defaulting to 250,000");
			limit = new Integer(250000);
		}
		Response myResponse = getCustomersByNameInternal(name,limit,offset,countOnlyReal); 
		HBankDataAccess myHBankDataAccess = new HBankDataAccess();
		myHBankDataAccess.terminate();
		logger.exiting(this.getClass().getName(), "getCustomersByNameExternal(String name, Integer limit, Integer offset, Boolean countOnly)",myResponse);
		return myResponse;
	}


	public Response getCustomersByNameInternal(@QueryParam("name") String name,@QueryParam("limit") int limit, @QueryParam("offset") int offset, boolean countOnly) 
	{
		logger.entering(this.getClass().getName(), "getCustomersByNameInternal(String name, Integer limit, Integer offset, Boolean countOnly) " + name + " " + limit + " " + offset + " " + countOnly);
		Integer sortCode = this.getSortCode();


		JSONObject response = new JSONObject();
		JSONArray customers = null;


		if(countOnly)
		{
			com.ibm.cics.cip.bankliberty.web.vsam.Customer vsamCustomer = new com.ibm.cics.cip.bankliberty.web.vsam.Customer();
			long numberOfCustomers = 0;
			numberOfCustomers = vsamCustomer.getCustomersByNameCountOnly(sortCode.intValue(),name);
			response.put("numberOfCustomers", numberOfCustomers);
		}
		else
		{
			com.ibm.cics.cip.bankliberty.web.vsam.Customer[] myCustomers = null;
			com.ibm.cics.cip.bankliberty.web.vsam.Customer vsamCustomer = new com.ibm.cics.cip.bankliberty.web.vsam.Customer();
			vsamCustomer.setSortcode(sortCode.toString());

			myCustomers = vsamCustomer.getCustomersByName(sortCode.intValue(),limit,offset,name);

			if(myCustomers != null)
			{
				customers = new JSONArray(myCustomers.length);

				for(int i = 0;i < myCustomers.length;i++)
				{
					JSONObject customer = new JSONObject();
					customer.put("sortCode", myCustomers[i].getSortcode().trim());
					customer.put("customerName", myCustomers[i].getName().trim());
					customer.put("id",myCustomers[i].getCustomer_number().trim());
					customer.put("customerAddress", myCustomers[i].getAddress().trim());
					customer.put("dateOfBirth", myCustomers[i].getDob().toString());
					customer.put("customerCreditScore", myCustomers[i].getCreditScore().trim());
					customer.put("customerCreditScoreReviewDate", myCustomers[i].getReviewDate().toString());
					customers.add(customer);

				}
				response.put("customers", customers);
				response.put("numberOfCustomers", customers.size());

			}
			else
			{
				response.put("errorMessage","Customers cannot be listed in com.ibm.cics.cip.bankliberty.web.vsam.Customer");
				logger.warning(this.getClass().getName() + ".getCustomersByNameInternal() " + " Customers cannot be listed in com.ibm.cics.cip.bankliberty.web.vsam.Customer");
				Response myResponse = Response.status(404).entity(response.toString()).build();
				logger.exiting(this.getClass().getName(),"getCustomersByNameInternal()",myResponse);
				return myResponse;
			}
		}
		logger.exiting(this.getClass().getName(), "getCustomersByNameInternal(String name, Integer limit, Integer offset, Boolean countOnly)", Response.status(200).entity(response.toString()).build());
		return Response.status(200).entity(response.toString()).build();

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
