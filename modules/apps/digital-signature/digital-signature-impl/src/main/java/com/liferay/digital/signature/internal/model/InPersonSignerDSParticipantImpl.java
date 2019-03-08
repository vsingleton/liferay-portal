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

package com.liferay.digital.signature.internal.model;

import com.liferay.digital.signature.model.DSInPersonSignerType;
import com.liferay.digital.signature.model.DSParticipantRole;
import com.liferay.digital.signature.model.DSParticipantVisitor;
import com.liferay.digital.signature.model.InPersonSignerDSParticipant;

/**
 * @author Michael C. Han
 */
public class InPersonSignerDSParticipantImpl
	extends SignerDSParticipantImpl implements InPersonSignerDSParticipant {

	public InPersonSignerDSParticipantImpl(
		String hostName, String hostEmail, String signerName,
		String signerEmail, int routingOrder) {

		super(signerName, signerEmail, routingOrder);

		setDSParticipantRole(DSParticipantRole.IN_PERSON_SIGNER);

		_hostName = hostName;
		_hostEmail = hostEmail;
	}

	@Override
	public String getHostEmailAddress() {
		return _hostEmail;
	}

	@Override
	public String getHostName() {
		return _hostName;
	}

	public DSInPersonSignerType getDSInPersonSignerType() {
		return DSInPersonSignerType.IN_PERSON;
	}

	@Override
	public String getSignerEmailAddress() {
		return getEmailAddress();
	}

	@Override
	public String getSignerName() {
		return getName();
	}

	@Override
	public <T> T translate(DSParticipantVisitor<T> dsParticipantVisitor) {
		return dsParticipantVisitor.visit(this);
	}

	private final String _hostEmail;
	private final String _hostName;

}