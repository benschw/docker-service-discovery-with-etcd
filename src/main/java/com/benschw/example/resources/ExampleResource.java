package com.benschw.example.resources;

import com.benschw.example.core.DataStore;
import com.benschw.example.core.ServiceClient;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.GenericType;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.List;
import java.util.Random;

@Path("/")
public class ExampleResource {
	private ServiceClient client;
	private DataStore data;

	public ExampleResource(DataStore data, ServiceClient client) {
		this.data = data;
		this.client = client;
	}

	@GET
	@Path("/demo")
	@Produces(MediaType.APPLICATION_JSON)
	public List<String> demo() {
		Random rn = new Random();
		String i = String.valueOf(rn.nextInt());

		List<String> data = client.getResource()
				.path("entry")
				.type(MediaType.TEXT_PLAIN_TYPE)
				.accept(MediaType.APPLICATION_JSON_TYPE)
				.entity(i)
				.post(ClientResponse.class)
				.getEntity(new GenericType<List<String>>() {
				});

		return data;
	}

	@POST
	@Path("/entry")
	@Consumes(MediaType.TEXT_PLAIN)
	@Produces(MediaType.APPLICATION_JSON)
	public List<String> addEntry(String entry) {
		data.push(entry);

		return data.getList();
	}
}
