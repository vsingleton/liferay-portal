/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.mule.internal.error;

import java.io.IOException;

import org.mule.runtime.extension.api.exception.ModuleException;
import org.mule.runtime.http.api.domain.entity.HttpEntity;
import org.mule.runtime.http.api.domain.message.response.HttpResponse;

/**
 * @author Matija Petanjek
 */
public class LiferayResponseValidator {

	public void validate(HttpResponse httpResponse) throws IOException {
		if (httpResponse == null) {
			throw new ModuleException(
				"Server error", LiferayError.SERVER_ERROR);
		}
		else if (httpResponse.getStatusCode() >= 400) {
			throw new ModuleException(
				_getMessage(httpResponse),
				LiferayError.fromStatus(httpResponse.getStatusCode()));
		}
	}

	private String _getMessage(HttpResponse httpResponse) throws IOException {
		HttpEntity httpEntity = httpResponse.getEntity();

		return new String(httpEntity.getBytes());
	}

}