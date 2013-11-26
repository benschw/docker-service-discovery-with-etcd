package com.benschw.example.health;

import com.yammer.metrics.core.HealthCheck;

public class ExampleHealthCheck extends HealthCheck {

	public ExampleHealthCheck(String name) {
		super(name);
	}

	@Override
	protected HealthCheck.Result check() throws Exception {
		return HealthCheck.Result.healthy();
	}

}
