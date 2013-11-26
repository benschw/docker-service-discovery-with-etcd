package com.benschw.example.core;


import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.WebResource;

public class ServiceClient {

	private final DiscoveryClient discoveryClient;
	private Client client;

	public ServiceClient(Client client, DiscoveryClient discoveryClient) {
		this.client = client;
		this.discoveryClient = discoveryClient;
	}


	public WebResource getResource() {

		return client.resource("http://" + discoveryClient.getAddress("service"));
	}


}
