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
MasterPageDisplayContext masterPageDisplayContext = new MasterPageDisplayContext(request, renderRequest, renderResponse);
%>

<clay:navigation-bar
	inverted="<%= true %>"
	navigationItems="<%= layoutPageTemplatesAdminDisplayContext.getNavigationItems() %>"
/>

<%
MasterPageManagementToolbarDisplayContext masterPageManagementToolbarDisplayContext = new MasterPageManagementToolbarDisplayContext(request, liferayPortletRequest, liferayPortletResponse, masterPageDisplayContext);
%>

<clay:management-toolbar
	displayContext="<%= masterPageManagementToolbarDisplayContext %>"
/>

<aui:form cssClass="container-fluid-1280" name="fm">
	<liferay-ui:search-container
		searchContainer="<%= masterPageDisplayContext.getMasterPagesSearchContainer() %>"
	>
		<liferay-ui:search-container-row
			className="com.liferay.layout.page.template.model.LayoutPageTemplateEntry"
			cssClass="selectable"
			escapedModel="<%= true %>"
			keyProperty="layoutPrototypeId"
			modelVar="layoutPageTemplateEntry"
		>

			<%
			row.setCssClass("entry-card lfr-asset-item");
			%>

			<liferay-ui:search-container-column-text>
				<clay:vertical-card
					verticalCard="<%= new MasterPageVerticalCard(layoutPageTemplateEntry, renderRequest, renderResponse) %>"
				/>
			</liferay-ui:search-container-column-text>
		</liferay-ui:search-container-row>

		<liferay-ui:search-iterator
			displayStyle="icon"
			markupView="lexicon"
		/>
	</liferay-ui:search-container>
</aui:form>

<portlet:actionURL name="/layout_page_template/update_layout_page_template_entry_preview" var="masterPagePreviewURL">
	<portlet:param name="redirect" value="<%= currentURL %>" />
</portlet:actionURL>

<aui:form action="<%= masterPagePreviewURL %>" name="masterPagePreviewFm">
	<aui:input name="layoutPageTemplateEntryId" type="hidden" />
	<aui:input name="fileEntryId" type="hidden" />
</aui:form>

<liferay-frontend:component
	componentId="<%= LayoutPageTemplateAdminWebKeys.MASTER_PAGE_DROPDOWN_DEFAULT_EVENT_HANDLER %>"
	module="js/MasterPageDropdownDefaultEventHandler.es"
/>

<liferay-frontend:component
	componentId="<%= masterPageManagementToolbarDisplayContext.getDefaultEventHandler() %>"
	module="js/MasterPageManagementToolbarDefaultEventHandler.es"
/>