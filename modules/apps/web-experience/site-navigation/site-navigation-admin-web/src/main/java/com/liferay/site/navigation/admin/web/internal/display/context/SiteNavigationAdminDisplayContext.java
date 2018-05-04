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

package com.liferay.site.navigation.admin.web.internal.display.context;

import com.liferay.frontend.taglib.clay.servlet.taglib.util.DropdownItem;
import com.liferay.frontend.taglib.clay.servlet.taglib.util.DropdownItemList;
import com.liferay.frontend.taglib.clay.servlet.taglib.util.NavigationItem;
import com.liferay.frontend.taglib.clay.servlet.taglib.util.NavigationItemList;
import com.liferay.petra.string.StringPool;
import com.liferay.portal.kernel.dao.search.EmptyOnClickRowChecker;
import com.liferay.portal.kernel.dao.search.SearchContainer;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.portlet.LiferayPortletRequest;
import com.liferay.portal.kernel.portlet.LiferayPortletResponse;
import com.liferay.portal.kernel.portlet.LiferayWindowState;
import com.liferay.portal.kernel.theme.PortletDisplay;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.OrderByComparator;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.site.navigation.admin.web.internal.constants.SiteNavigationAdminWebKeys;
import com.liferay.site.navigation.admin.web.internal.security.permission.resource.SiteNavigationPermission;
import com.liferay.site.navigation.admin.web.internal.util.SiteNavigationMenuPortletUtil;
import com.liferay.site.navigation.constants.SiteNavigationActionKeys;
import com.liferay.site.navigation.model.SiteNavigationMenu;
import com.liferay.site.navigation.service.SiteNavigationMenuLocalServiceUtil;
import com.liferay.site.navigation.service.SiteNavigationMenuServiceUtil;
import com.liferay.site.navigation.type.SiteNavigationMenuItemType;
import com.liferay.site.navigation.type.SiteNavigationMenuItemTypeRegistry;

import java.util.List;

import javax.portlet.PortletURL;
import javax.portlet.WindowStateException;

import javax.servlet.http.HttpServletRequest;

/**
 * @author Pavel Savinov
 */
public class SiteNavigationAdminDisplayContext {

	public SiteNavigationAdminDisplayContext(
		LiferayPortletRequest liferayPortletRequest,
		LiferayPortletResponse liferayPortletResponse,
		HttpServletRequest request) {

		_liferayPortletRequest = liferayPortletRequest;
		_liferayPortletResponse = liferayPortletResponse;
		_request = request;

		_siteNavigationMenuItemTypeRegistry =
			(SiteNavigationMenuItemTypeRegistry)_request.getAttribute(
				SiteNavigationAdminWebKeys.
					SITE_NAVIGATION_MENU_ITEM_TYPE_REGISTRY);
	}

	public List<DropdownItem> getAddSiteNavigationMenuItemDropdownItems() {
		ThemeDisplay themeDisplay = (ThemeDisplay)_request.getAttribute(
			WebKeys.THEME_DISPLAY);

		return new DropdownItemList() {
			{
				for (SiteNavigationMenuItemType siteNavigationMenuItemType :
						_siteNavigationMenuItemTypeRegistry.
							getSiteNavigationMenuItemTypes()) {

					add(
						dropdownItem -> {
							dropdownItem.setHref(
								_getAddURL(siteNavigationMenuItemType));
							dropdownItem.setLabel(
								siteNavigationMenuItemType.getLabel(
									themeDisplay.getLocale()));
						});
				}
			}
		};
	}

	public String getDisplayStyle() {
		if (_displayStyle != null) {
			return _displayStyle;
		}

		_displayStyle = ParamUtil.getString(_request, "displayStyle", "list");

		return _displayStyle;
	}

	public String[] getDisplayViews() {
		return new String[] {"list", "icon", "descriptive"};
	}

	public String getKeywords() {
		if (Validator.isNotNull(_keywords)) {
			return _keywords;
		}

		_keywords = ParamUtil.getString(_request, "keywords");

		return _keywords;
	}

	public List<NavigationItem> getNavigationItems() {
		return new NavigationItemList() {
			{
				add(
					navigationItem -> {
						navigationItem.setActive(true);
						navigationItem.setHref(
							_liferayPortletResponse.createRenderURL());
						navigationItem.setLabel(
							LanguageUtil.get(_request, "menus"));
					});
			}
		};
	}

	public String getOrderByCol() {
		if (_orderByCol != null) {
			return _orderByCol;
		}

		_orderByCol = ParamUtil.getString(
			_request, "orderByCol", "create-date");

		return _orderByCol;
	}

	public String getOrderByType() {
		if (_orderByType != null) {
			return _orderByType;
		}

		_orderByType = ParamUtil.getString(_request, "orderByType", "asc");

		return _orderByType;
	}

	public String[] getOrderColumns() {
		String[] orderColumns = {"create-date", "name"};

		return orderColumns;
	}

	public PortletURL getPortletURL() {
		PortletURL portletURL = _liferayPortletResponse.createRenderURL();

		String displayStyle = ParamUtil.getString(_request, "displayStyle");

		if (Validator.isNotNull(displayStyle)) {
			portletURL.setParameter("displayStyle", getDisplayStyle());
		}

		String orderByCol = getOrderByCol();

		if (Validator.isNotNull(orderByCol)) {
			portletURL.setParameter("orderByCol", orderByCol);
		}

		String orderByType = getOrderByType();

		if (Validator.isNotNull(orderByType)) {
			portletURL.setParameter("orderByType", orderByType);
		}

		return portletURL;
	}

	public SiteNavigationMenu getPrimarySiteNavigationMenu() {
		ThemeDisplay themeDisplay = (ThemeDisplay)_request.getAttribute(
			WebKeys.THEME_DISPLAY);

		return SiteNavigationMenuLocalServiceUtil.
			fetchPrimarySiteNavigationMenu(themeDisplay.getScopeGroupId());
	}

	public SearchContainer getSearchContainer() {
		if (_searchContainer != null) {
			return _searchContainer;
		}

		ThemeDisplay themeDisplay = (ThemeDisplay)_request.getAttribute(
			WebKeys.THEME_DISPLAY);

		SearchContainer searchContainer = new SearchContainer(
			_liferayPortletRequest, getPortletURL(), null,
			"there-are-no-navigation-menus");

		if (Validator.isNotNull(getKeywords())) {
			searchContainer.setSearch(true);
		}

		OrderByComparator<SiteNavigationMenu> orderByComparator =
			SiteNavigationMenuPortletUtil.getOrderByComparator(
				getOrderByCol(), getOrderByType());

		searchContainer.setOrderByCol(getOrderByCol());
		searchContainer.setOrderByComparator(orderByComparator);
		searchContainer.setOrderByType(getOrderByType());

		EmptyOnClickRowChecker emptyOnClickRowChecker =
			new EmptyOnClickRowChecker(_liferayPortletResponse);

		searchContainer.setRowChecker(emptyOnClickRowChecker);

		List<SiteNavigationMenu> menus = null;
		int menusCount = 0;

		if (Validator.isNotNull(getKeywords())) {
			menus = SiteNavigationMenuServiceUtil.getSiteNavigationMenus(
				themeDisplay.getScopeGroupId(), getKeywords(),
				searchContainer.getStart(), searchContainer.getEnd(),
				orderByComparator);

			menusCount =
				SiteNavigationMenuServiceUtil.getSiteNavigationMenusCount(
					themeDisplay.getScopeGroupId(), getKeywords());
		}
		else {
			menus = SiteNavigationMenuServiceUtil.getSiteNavigationMenus(
				themeDisplay.getScopeGroupId(), searchContainer.getStart(),
				searchContainer.getEnd(), orderByComparator);

			menusCount =
				SiteNavigationMenuServiceUtil.getSiteNavigationMenusCount(
					themeDisplay.getScopeGroupId());
		}

		searchContainer.setResults(menus);
		searchContainer.setTotal(menusCount);

		_searchContainer = searchContainer;

		return _searchContainer;
	}

	public JSONObject getSelectedItemTypeJSONObject() {
		if (Validator.isNotNull(_selectedItemTypeJSONObject)) {
			return _selectedItemTypeJSONObject;
		}

		String selectedItemType = ParamUtil.getString(
			_request, "selectedItemType", _getFirstSiteNavigationMenuItem());

		SiteNavigationMenuItemType siteNavigationMenuItemType =
			_siteNavigationMenuItemTypeRegistry.getSiteNavigationMenuItemType(
				selectedItemType);

		if (siteNavigationMenuItemType == null) {
			return null;
		}

		ThemeDisplay themeDisplay = (ThemeDisplay)_request.getAttribute(
			WebKeys.THEME_DISPLAY);

		JSONObject selectedItemTypeJSONObject =
			JSONFactoryUtil.createJSONObject();

		selectedItemTypeJSONObject.put(
			"icon", siteNavigationMenuItemType.getIcon());
		selectedItemTypeJSONObject.put(
			"label",
			siteNavigationMenuItemType.getLabel(themeDisplay.getLocale()));
		selectedItemTypeJSONObject.put(
			"type", siteNavigationMenuItemType.getType());

		_selectedItemTypeJSONObject = selectedItemTypeJSONObject;

		return _selectedItemTypeJSONObject;
	}

	public SiteNavigationMenu getSiteNavigationMenu() throws PortalException {
		if (getSiteNavigationMenuId() == 0) {
			return null;
		}

		return SiteNavigationMenuServiceUtil.fetchSiteNavigationMenu(
			getSiteNavigationMenuId());
	}

	public long getSiteNavigationMenuId() {
		if (_siteNavigationMenuId != null) {
			return _siteNavigationMenuId;
		}

		_siteNavigationMenuId = ParamUtil.getLong(
			_request, "siteNavigationMenuId");

		return _siteNavigationMenuId;
	}

	public SiteNavigationMenuItemTypeRegistry
		getSiteNavigationMenuItemTypeRegistry() {

		return _siteNavigationMenuItemTypeRegistry;
	}

	public String getSiteNavigationMenuName() throws PortalException {
		if (_siteNavigationMenuName != null) {
			return _siteNavigationMenuName;
		}

		SiteNavigationMenu siteNavigationMenu = getSiteNavigationMenu();

		_siteNavigationMenuName = siteNavigationMenu.getName();

		return _siteNavigationMenuName;
	}

	public boolean isShowAddButton() {
		ThemeDisplay themeDisplay = (ThemeDisplay)_request.getAttribute(
			WebKeys.THEME_DISPLAY);

		if (SiteNavigationPermission.contains(
				themeDisplay.getPermissionChecker(),
				themeDisplay.getSiteGroupId(),
				SiteNavigationActionKeys.ADD_SITE_NAVIGATION_MENU)) {

			return true;
		}

		return false;
	}

	public boolean isShowPrimarySiteNavigationMenuMessage() {
		SiteNavigationMenu primarySiteNavigationMenu =
			getPrimarySiteNavigationMenu();

		if ((primarySiteNavigationMenu == null) ||
			(primarySiteNavigationMenu.getSiteNavigationMenuId() ==
				getSiteNavigationMenuId())) {

			return false;
		}

		return true;
	}

	private String _getAddURL(
		SiteNavigationMenuItemType siteNavigationMenuItemType) {

		ThemeDisplay themeDisplay = (ThemeDisplay)_request.getAttribute(
			WebKeys.THEME_DISPLAY);

		PortletDisplay portletDisplay = themeDisplay.getPortletDisplay();

		PortletURL addURL = _liferayPortletResponse.createRenderURL();

		addURL.setParameter("mvcPath", "/add_site_navigation_menu_item.jsp");

		PortletURL addSiteNavigationMenuItemRedirectURL =
			_liferayPortletResponse.createRenderURL();

		addSiteNavigationMenuItemRedirectURL.setParameter(
			"mvcPath", "/add_site_navigation_menu_item_redirect.jsp");
		addSiteNavigationMenuItemRedirectURL.setParameter(
			"portletResource", portletDisplay.getId());

		addURL.setParameter(
			"redirect", addSiteNavigationMenuItemRedirectURL.toString());

		addURL.setParameter(
			"siteNavigationMenuId", String.valueOf(getSiteNavigationMenuId()));
		addURL.setParameter("type", siteNavigationMenuItemType.getType());

		try {
			addURL.setWindowState(LiferayWindowState.POP_UP);
		}
		catch (WindowStateException wse) {
			return StringPool.BLANK;
		}

		return addURL.toString();
	}

	private String _getFirstSiteNavigationMenuItem() {
		String[] types = _siteNavigationMenuItemTypeRegistry.getTypes();

		String selectedItemType = StringPool.BLANK;

		if (types.length > 0) {
			return types[0];
		}

		return selectedItemType;
	}

	private String _displayStyle;
	private String _keywords;
	private final LiferayPortletRequest _liferayPortletRequest;
	private final LiferayPortletResponse _liferayPortletResponse;
	private String _orderByCol;
	private String _orderByType;
	private final HttpServletRequest _request;
	private SearchContainer _searchContainer;
	private JSONObject _selectedItemTypeJSONObject;
	private Long _siteNavigationMenuId;
	private final SiteNavigationMenuItemTypeRegistry
		_siteNavigationMenuItemTypeRegistry;
	private String _siteNavigationMenuName;

}