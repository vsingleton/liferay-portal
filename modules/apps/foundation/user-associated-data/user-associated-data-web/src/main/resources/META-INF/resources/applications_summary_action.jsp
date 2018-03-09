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
ResultRow row = (ResultRow)request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);

UADApplicationSummaryDisplay uadApplicationsSummaryDisplay = (UADApplicationSummaryDisplay)row.getObject();
%>

<liferay-ui:icon-menu
	direction="left-side"
	disabled="<%= uadApplicationsSummaryDisplay.getCount() == 0 %>"
	icon="<%= StringPool.BLANK %>"
	markupView="lexicon"
	message="<%= StringPool.BLANK %>"
	showWhenSingleIcon="<%= true %>"
	triggerCssClass='<%= uadApplicationsSummaryDisplay.getCount() <= 0 ? "component-action disabled" : "component-action" %>'
>
	<portlet:renderURL var="manageUADEntitiesURL">
		<portlet:param name="mvcRenderCommandName" value="/user_associated_data/manage_user_associated_data_entities" />
		<portlet:param name="selUserId" value="<%= String.valueOf(selUserId) %>" />
		<portlet:param name="uadEntitySetName" value="<%= uadApplicationsSummaryDisplay.getName() %>" />
		<portlet:param name="uadRegistryKey" value="<%= uadApplicationsSummaryDisplay.getDefaultUADRegistryKey() %>" />
	</portlet:renderURL>

	<liferay-ui:icon
		message="edit"
		url="<%= manageUADEntitiesURL.toString() %>"
	/>

	<portlet:actionURL name="/user_associated_data/anonymize_application_user_associated_data_entities" var="anonymizeUADEntitiesURL">
		<portlet:param name="redirect" value="<%= currentURL %>" />
		<portlet:param name="selUserId" value="<%= String.valueOf(selUserId) %>" />
		<portlet:param name="uadEntitySetName" value="<%= uadApplicationsSummaryDisplay.getName() %>" />
	</portlet:actionURL>

	<liferay-ui:icon
		message="anonymize"
		url="<%= anonymizeUADEntitiesURL.toString() %>"
	/>

	<portlet:actionURL name="/user_associated_data/delete_application_user_associated_data_entities" var="deleteUADEntitiesURL">
		<portlet:param name="redirect" value="<%= currentURL %>" />
		<portlet:param name="selUserId" value="<%= String.valueOf(selUserId) %>" />
		<portlet:param name="uadEntitySetName" value="<%= uadApplicationsSummaryDisplay.getName() %>" />
	</portlet:actionURL>

	<liferay-ui:icon
		message="delete"
		url="<%= anonymizeUADEntitiesURL.toString() %>"
	/>
</liferay-ui:icon-menu>