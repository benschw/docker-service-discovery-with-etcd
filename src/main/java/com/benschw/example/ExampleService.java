package com.benschw.example;

import com.benschw.example.core.DataStore;
import com.benschw.example.core.DiscoveryClient;
import com.benschw.example.core.ServiceClient;
import com.benschw.example.health.ExampleHealthCheck;
import com.benschw.example.resources.ExampleResource;
import com.sun.jersey.api.client.Client;
import com.yammer.dropwizard.Service;
import com.yammer.dropwizard.client.JerseyClientBuilder;
import com.yammer.dropwizard.config.Bootstrap;
import com.yammer.dropwizard.config.Environment;
import jetcd.EtcdClientFactory;

public class ExampleService extends Service<ExampleConfiguration> {


	public static void main(String[] args) throws Exception {
		new ExampleService().run(args);
	}

	private ExampleService() {
	}

	@Override
	public void initialize(Bootstrap<ExampleConfiguration> bootstrap) {
		bootstrap.setName("example-service");
	}

	@Override
	public void run(ExampleConfiguration configuration, Environment environment) throws ClassNotFoundException {
		String etcdAddress = System.getenv("ETCD");

		DiscoveryClient discoveryClient = new DiscoveryClient(EtcdClientFactory.newInstance(etcdAddress));

		Client client = new JerseyClientBuilder()
				.using(configuration.getJerseyClientConfiguration())
				.using(environment)
				.build();

		environment.addHealthCheck(new ExampleHealthCheck("example"));


		environment.addResource(new ExampleResource(new DataStore(discoveryClient), new ServiceClient(client, discoveryClient)));
	}

}
