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

<c:set var="namespace"><portlet:namespace /></c:set>
<c:set var="errorMessage" value="${sessionErrors['gogo']}" />
<c:set var="maxOrPopUp" value="${windowState eq 'maximized' or windowState eq 'pop_up'}" />

<c:set var="command" value="${sessionMessages['command']}" />
<c:set var="commandOutput" value="${sessionMessages['commandOutput']}" />
<c:set var="prompt" value="${sessionMessages['prompt']}" />

<portlet:actionURL name="executeCommand" var="executeCommandURL" />

<div class="container-fluid-1280">

	<a>errorException = ${errorException}</a><br />

	<aui:form action="${executeCommandURL}" method="post" name="fm" onSubmit="event.preventDefault(); ${namespace}executeCommand();">
		<aui:input name="redirect" type="hidden" value="${currentURL}" />

		<liferay-ui:error key="gogo">
			<% 
				Exception e = (Exception) errorException; 
			%>
			<%= HtmlUtil.escape(e.getMessage()) %>
			${fn:escapeXml(errorMessage)}
		</liferay-ui:error>

		<aui:fieldset-group markupView="lexicon">
			<aui:fieldset>
				<aui:input autoFocus="${maxOrPopUp}" name="command" prefix="${prompt}" value="${command}" />
			</aui:fieldset>
		</aui:fieldset-group>

		<aui:button-row>
			<aui:button primary="${true}" type="submit" value="execute" />
		</aui:button-row>

		<c:if test="${not empty commandOutput}">
			<b><liferay-ui:message key="output" /></b>

			<pre>${commandOutput}</pre>
		</c:if>
	</aui:form>
</div>

<aui:script>
	function ${namespace}executeCommand() {
		var form = document.getElementById('<portlet:namespace />fm');

		if (form) {
			submitForm(form);
		}
	}
</aui:script>