package com.benschw.example.core;

import jetcd.EtcdClient;
import jetcd.EtcdException;

import java.util.Map;
import java.util.Random;

public class DiscoveryClient {

	private EtcdClient client;

	public DiscoveryClient(EtcdClient client) {
		this.client = client;
	}


	public String getAddress(String key) {
		try {
			Map<String, String> map = client.list("svc/"+key+"/instances");

			Random generator = new Random();
			Object[] values = map.values().toArray();
			String val = (String) values[generator.nextInt(values.length)];

			if (val == null) {
				throw new RuntimeException("No results for "+key);
			}
			return val;

		} catch (EtcdException e) {
			throw new RuntimeException(e);
		}

	}

}

