package com.liferay.taglib.portlet.internal;

import java.util.HashMap;

import javax.portlet.PortletRequest;

import com.liferay.portal.kernel.servlet.SessionMessages;

//import javax.faces.context.FacesContext;
//import com.liferay.faces.portal.context.LiferayPortletHelperUtil;


/**
 * 
 *
 * @author  Vernon Singleton
 */
public class SessionMessagesMap extends HashMap<String, String> {

	// serialVersionUID
	private static final long serialVersionUID = 1L;
	
	SessionMessagesMap() { }
	
	public SessionMessagesMap(PortletRequest portletRequest) {
		_portletRequest = portletRequest;
	}

	@Override
	public String get(Object mapKey) {

		String value = super.get(mapKey);

		if (value == null) {

			value = "";

			String key = (String) mapKey;

			if (key != null) {
				value = (String) SessionMessages.get(_portletRequest, key);
			}

			put(key, value);
		}

		return value;
	}
	
	private transient PortletRequest _portletRequest;

}
