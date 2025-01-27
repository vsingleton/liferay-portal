<%--
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
--%>

<%@ include file="/init.jsp" %>

<%
MailManager mailManager = MailManager.getInstance(request);

JSONObject defaultAccountsJSONObject = mailManager.getDefaultAccountsJSONObject();

JSONArray accountsJSONArray = defaultAccountsJSONObject.getJSONArray("accounts");

String tabs1Names = "";

for (int i = 0; i < accountsJSONArray.length(); i++) {
	JSONObject accountJSONObject = accountsJSONArray.getJSONObject(i);

	String titleLanguageKey = accountJSONObject.getString("titleLanguageKey");

	tabs1Names += titleLanguageKey;

	if (i != (accountsJSONArray.length() - 1)) {
		tabs1Names += ",";
	}
}
%>

<liferay-ui:tabs
	names="<%= tabs1Names %>"
	refresh="<%= false %>"
>

	<%
	for (int i = 0; i < accountsJSONArray.length(); i++) {
		JSONObject accountJSONObject = accountsJSONArray.getJSONObject(i);

		String titleLanguageKey = accountJSONObject.getString("titleLanguageKey");
		boolean useLocalPartAsLogin = accountJSONObject.getBoolean("useLocalPartAsLogin");
		boolean hideSettings = accountJSONObject.getBoolean("hideSettings");
		String incomingPort = accountJSONObject.getString("incomingPort");
		String outgoingPort = accountJSONObject.getString("outgoingPort");
	%>

		<liferay-ui:section>
			<div class="mail-status"></div>

			<aui:form cssClass="account-form" name='<%= "dialogFm" + (i + 1) %>' onSubmit="event.preventDefault();">
				<aui:input name="personalName" type="hidden" value="<%= user.getFullName() %>" />
				<aui:input name="protocol" type="hidden" value='<%= accountJSONObject.getString("protocol") %>' />
				<aui:input name="signature" type="hidden" />
				<aui:input name="useSignature" type="hidden" value="false" />
				<aui:input name="folderPrefix" type="hidden" value='<%= accountJSONObject.getString("folderPrefix") %>' />
				<aui:input name="defaultSender" type="hidden" value="false" />
				<aui:input name="useLocalPartAsLogin" type="hidden" value="<%= useLocalPartAsLogin %>" />

				<c:if test="<%= hideSettings %>">
					<aui:input name="incomingHostName" type="hidden" value='<%= accountJSONObject.getString("incomingHostName") %>' />
					<aui:input name="incomingPort" type="hidden" value="<%= incomingPort %>" />
					<aui:input name="incomingSecure" type="hidden" value='<%= accountJSONObject.getBoolean("incomingSecure") %>' />
					<aui:input name="outgoingHostName" type="hidden" value='<%= accountJSONObject.getString("outgoingHostName") %>' />
					<aui:input name="outgoingPort" type="hidden" value="<%= outgoingPort %>" />
					<aui:input name="outgoingSecure" type="hidden" value='<%= accountJSONObject.getBoolean("outgoingSecure") %>' />
				</c:if>

				<c:if test="<%= useLocalPartAsLogin %>">
					<aui:input name="login" type="hidden" />
				</c:if>

				<liferay-ui:message key='<%= accountJSONObject.getString("descriptionLanguageKey") %>' />

				<aui:fieldset label="account-settings">
					<aui:input name="address" value='<%= accountJSONObject.getString("address") %>' />

					<c:if test="<%= !useLocalPartAsLogin %>">
						<aui:input name="login" />
					</c:if>

					<aui:input name="password" type="password" />

					<aui:input name="savePassword" type="checkbox" value="false" />
				</aui:fieldset>

				<c:if test="<%= !hideSettings %>">
					<aui:fieldset label="incoming-settings">
						<aui:input name="incomingHostName" />

						<aui:select name="incomingPort">

							<%
							for (String curIncomingPort : mailGroupServiceConfiguration.incomingPorts()) {
							%>

								<aui:option selected="<%= incomingPort.equals(curIncomingPort) %>" value="<%= curIncomingPort %>"><%= curIncomingPort %></aui:option>

							<%
							}
							%>

						</aui:select>

						<aui:input label="use-secure-incoming-connection" name="incomingSecure" type="checkbox" />
					</aui:fieldset>

					<aui:fieldset label="outgoing-settings">
						<aui:input label="outgoing-smtp-server" name="outgoingHostName" />

						<aui:select name="outgoingPort">

							<%
							for (String curOutgoingPort : mailGroupServiceConfiguration.outgoingPorts()) {
							%>

								<aui:option selected="<%= outgoingPort.equals(curOutgoingPort) %>" value="<%= curOutgoingPort %>"><%= curOutgoingPort %></aui:option>

							<%
							}
							%>

						</aui:select>

						<aui:input label="use-secure-outgoing-connection" name="outgoingSecure" type="checkbox" />
					</aui:fieldset>
				</c:if>

				<aui:button-row>
					<aui:button cssClass="add-account" type="submit" value="add-account" />
				</aui:button-row>
			</aui:form>
		</liferay-ui:section>

	<%
	}
	%>

</liferay-ui:tabs>

<aui:script use="aui-io-deprecated">
	A.all('.mail-dialog form.account-form').on('submit', function (event) {
		event.preventDefault();

		Liferay.Mail.setStatus(
			'info',
			'<liferay-ui:message key="adding-account" />',
			true
		);

		var form = event.currentTarget;

		A.io.request(themeDisplay.getLayoutURL() + '/-/mail/update_account', {
			dataType: 'JSON',
			form: {
				id: form.getDOMNode(),
			},
			method: 'POST',
			on: {
				failure: function (event, id, obj) {
					Liferay.Mail.setStatus(
						'error',
						'<liferay-ui:message key="unable-to-connect-with-mail-server" />'
					);
				},

				success: function (event, id, obj) {
					var responseData = this.get('responseData');

					Liferay.Mail.setStatus(
						responseData.status,
						responseData.message
					);

					if (responseData.status == 'success') {
						Liferay.Mail.loadAccounts(Liferay.Mail.accountId);
					}
				},
			},
		});
	});
</aui:script>