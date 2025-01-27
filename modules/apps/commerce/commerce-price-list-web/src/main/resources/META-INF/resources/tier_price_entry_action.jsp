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
CommerceTierPriceEntryDisplayContext commerceTierPriceEntryDisplayContext = (CommerceTierPriceEntryDisplayContext)request.getAttribute(WebKeys.PORTLET_DISPLAY_CONTEXT);

ResultRow row = (ResultRow)request.getAttribute(WebKeys.SEARCH_CONTAINER_RESULT_ROW);

CommerceTierPriceEntry commerceTierPriceEntry = null;

if (row != null) {
	commerceTierPriceEntry = (CommerceTierPriceEntry)row.getObject();
}
else {
	commerceTierPriceEntry = (CommerceTierPriceEntry)request.getAttribute("info_panel.jsp-entry");
}

CommercePriceEntry commercePriceEntry = commerceTierPriceEntry.getCommercePriceEntry();

long commercePriceListId = 0;

if (commercePriceEntry != null) {
	commercePriceListId = commercePriceEntry.getCommercePriceListId();
}
%>

<liferay-ui:icon-menu
	direction="left-side"
	icon="<%= StringPool.BLANK %>"
	markupView="lexicon"
	message="<%= StringPool.BLANK %>"
	showWhenSingleIcon="<%= true %>"
>
	<c:if test="<%= commerceTierPriceEntryDisplayContext.hasPermission(commercePriceListId, ActionKeys.UPDATE) %>">
		<portlet:renderURL var="editURL">
			<portlet:param name="mvcRenderCommandName" value="editCommerceTierPriceEntry" />
			<portlet:param name="redirect" value="<%= currentURL %>" />
			<portlet:param name="commercePriceEntryId" value="<%= String.valueOf(commerceTierPriceEntry.getCommercePriceEntryId()) %>" />
			<portlet:param name="commercePriceListId" value="<%= String.valueOf(commercePriceListId) %>" />
			<portlet:param name="commerceTierPriceEntryId" value="<%= String.valueOf(commerceTierPriceEntry.getCommerceTierPriceEntryId()) %>" />
		</portlet:renderURL>

		<liferay-ui:icon
			message="edit"
			url="<%= editURL %>"
		/>

		<portlet:actionURL name="editCommerceTierPriceEntry" var="deleteURL">
			<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DELETE %>" />
			<portlet:param name="redirect" value="<%= currentURL %>" />
			<portlet:param name="commercePriceEntryId" value="<%= String.valueOf(commerceTierPriceEntry.getCommercePriceEntryId()) %>" />
			<portlet:param name="commerceTierPriceEntryId" value="<%= String.valueOf(commerceTierPriceEntry.getCommerceTierPriceEntryId()) %>" />
		</portlet:actionURL>

		<liferay-ui:icon-delete
			url="<%= deleteURL %>"
		/>
	</c:if>
</liferay-ui:icon-menu>