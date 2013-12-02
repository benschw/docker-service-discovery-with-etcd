package com.benschw.example.core;

import net.spy.memcached.MemcachedClient;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.ArrayList;
import java.util.List;

public class DataStore {
	private DiscoveryClient discoveryClient;
	private MemcachedClient client;

	private static final String KEY = "foo";

	public DataStore(DiscoveryClient discoveryClient) {
		this.discoveryClient = discoveryClient;
	}

	private MemcachedClient getClient() {
		if (client == null) {
			try {
				String[] parts = discoveryClient.getAddress("memcached").split(":");
				client = new MemcachedClient(new InetSocketAddress(parts[0], Integer.valueOf(parts[1])));
			} catch (IOException e) {
				throw new RuntimeException(e);
			}
		}
		return client;
	}

	public void push(String value) {
		List<String> l = getList();
		l.add(value);


		getClient().set(KEY, 3600, l);
	}

	public List<String> getList() {
		List<String> l =  (List<String>) getClient().get(KEY);
		return l == null ? new ArrayList<String>() : l;
	}
}
