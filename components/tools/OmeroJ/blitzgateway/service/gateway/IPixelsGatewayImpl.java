/*
 * blitzgateway.service.gateway.IPixelsImpl 
 *
  *------------------------------------------------------------------------------
 *  Copyright (C) 2006-2007 University of Dundee. All rights reserved.
 *
 *
 * 	This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *  
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 *------------------------------------------------------------------------------
 */
package blitzgateway.service.gateway;



//Java imports
import java.util.List;

//Third-party libraries

//Application-internal dependencies
import omero.RObject;
import omero.api.IPixelsPrx;
import omero.model.IObject;
import omero.model.Pixels;
import omero.model.PixelsType;

import org.openmicroscopy.shoola.env.data.DSAccessException;
import org.openmicroscopy.shoola.env.data.DSOutOfServiceException;

import blitzgateway.util.ServiceUtilities;

/** 
 * 
 *
 * @author  Jean-Marie Burel &nbsp;&nbsp;&nbsp;&nbsp;
 * 	<a href="mailto:j.burel@dundee.ac.uk">j.burel@dundee.ac.uk</a>
 * @author	Donald MacDonald &nbsp;&nbsp;&nbsp;&nbsp;
 * 	<a href="mailto:donald@lifesci.dundee.ac.uk">donald@lifesci.dundee.ac.uk</a>
 * @version 3.0
 * <small>
 * (<b>Internal version:</b> $Revision: $Date: $)
 * </small>
 * @since OME3.0
 */
class IPixelsGatewayImpl
	implements IPixelsGateway
{
	private BlitzGateway blitzGateway;
	
	IPixelsGatewayImpl(BlitzGateway gateway)
	{
		blitzGateway = gateway;
	}

	/* (non-Javadoc)
	 * @see IPixelsGateway#copyAndResizePixels(long, int, int, int, int, List, 
	 * String)
	 */
	public long copyAndResizePixels(long pixelsId, int x, int y, int t, int z, 
			List<Integer> channelList, String methodology) 
			throws DSOutOfServiceException, DSAccessException
	{		
		try
		{
			IPixelsPrx service = blitzGateway.getPixelsService(); 
			omero.RLong val = service.copyAndResizePixels(pixelsId, 
				new omero.RInt(x), new omero.RInt(y), new omero.RInt(z), new omero.RInt(t),
				channelList, methodology);
			return val.val;
		}
		catch (Exception e)
		{
			ServiceUtilities.handleException(e, "Cannot copy pixels.");
		}
		return -1;
	}
	
	/* (non-Javadoc)
	 * @see IPixelsGateway#getAllEnumerations(java.lang.String)
	 */
	public <T extends IObject> List<T> getAllEnumerations(String enumClass)
			throws DSOutOfServiceException, DSAccessException
	{
		try
		{
			IPixelsPrx service = blitzGateway.getPixelsService(); 
			return (List<T>)service.getAllEnumerations(enumClass);
		}
		catch (Exception e)
		{
			ServiceUtilities.handleException(e, "Cannot copy pixels.");
		}
		return null;
	}

	/* (non-Javadoc)
	 * @see IPixelsGateway#getBitDepth(omero.model.PixelsType)
	 */
	public int getBitDepth(PixelsType type) throws DSOutOfServiceException,
			DSAccessException
	{
		try
		{
			IPixelsPrx service = blitzGateway.getPixelsService(); 
			return service.getBitDepth(type);
		}
		catch (Exception e)
		{
			ServiceUtilities.handleException(e, "Cannot copy pixels.");
		}
		return -1;
	}

	/* (non-Javadoc)
	 * @see IPixelsGateway#getEnumeration(java.lang.String, java.lang.String)
	 */
	public RObject getEnumeration(String enumClass, String value)
			throws DSOutOfServiceException, DSAccessException
	{
		try
		{
			IPixelsPrx service = blitzGateway.getPixelsService(); 
			return service.getEnumeration(enumClass, value);
		}
		catch (Exception e)
		{
			ServiceUtilities.handleException(e, "Cannot copy pixels.");
		}
		return null;
	}
	/* (non-Javadoc)
	 * @see IPixelsGateway#retrievePixDescription(long)
	 */
	public Pixels retrievePixDescription(long pixId)
			throws DSOutOfServiceException, DSAccessException
	{
		try
		{
			IPixelsPrx service = blitzGateway.getPixelsService(); 
			return service.retrievePixDescription(pixId);
		}
		catch (Exception e)
		{
			ServiceUtilities.handleException(e, "Cannot copy pixels.");
		}
		return null;
	}
}


