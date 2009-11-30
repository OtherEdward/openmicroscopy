/*
 * org.openmicroscopy.shoola.env.data.model.DownloadActivityParam 
 *
 *------------------------------------------------------------------------------
 *  Copyright (C) 2006-2009 University of Dundee. All rights reserved.
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
package org.openmicroscopy.shoola.env.data.model;


//Java imports
import java.io.File;
import javax.swing.Icon;


//Third-party libraries

//Application-internal dependencies
import omero.model.OriginalFile;

/** 
 * Parameters required to download a file.
 *
 * @author  Jean-Marie Burel &nbsp;&nbsp;&nbsp;&nbsp;
 * <a href="mailto:j.burel@dundee.ac.uk">j.burel@dundee.ac.uk</a>
 * @author Donald MacDonald &nbsp;&nbsp;&nbsp;&nbsp;
 * <a href="mailto:donald@lifesci.dundee.ac.uk">donald@lifesci.dundee.ac.uk</a>
 * @version 3.0
 * <small>
 * (<b>Internal version:</b> $Revision: $Date: $)
 * </small>
 * @since 3.0-Beta4
 */
public class DownloadActivityParam
{

    /** The icon associated to the parameters. */
    private Icon			icon;
    
    /** The folder where to download the file. */
    private File			folder; 
    
    /** The file to download. */
    private OriginalFile	file;
    
    /** Create a legend as a separate text file. */
    private String			legend;
    
    /** The name of the file to save. */
    private String			fileName;
    
    /** The extension for the legend. Default is <code>null</code>.*/
    private String			legendExtension;
    
    /**
     * Downloads the passed file.
     * 
     * @param file 	 	The file to download.
     * @param folder 	The folder where to download the file.
     * @param icon	 	The associated icon.
     * @param fileName 	The file name to set.
     */
    public DownloadActivityParam(OriginalFile file, File folder, Icon icon)
    {
    	if (file == null) 
    		throw new IllegalArgumentException("No file to download.");
    	this.file = file;
    	this.folder = folder;
    	this.icon = icon;
    	legend = null;
    	fileName = null;
    	legendExtension = null;
    }

    /**
     * Returns the name to give to the file. 
     * 
     * @return See above.
     */
    public String getFileName() { return fileName; }
    
    /**
     * Sets the name to give to the file to download.
     * 
     * @param fileName The value to set.
     */
    public void setFileName(String fileName) { this.fileName = fileName; }
    
    /**
     * Sets the legend associated to the file.
     * 
     * @param legend The value to set.
     */
    public void setLegend(String legend) { this.legend = legend; }
    
    /**
     * Returns the legend associated to the text. 
     * 
     * @return See above.
     */
    public String getLegend() { return legend; }
    
    /**
     * Sets the extension of the legend associated to the file.
     * 
     * @param legendExtension The value to set.
     */
    public void setLegendExtension(String legendExtension)
    {
    	this.legendExtension = legendExtension;
    }
    
    /**
     * Returns the legend extension. 
     * 
     * @return See above.
     */
    public String getLegendExtension() { return legendExtension; }
    
	/**
	 * Returns the icon if set or <code>null</code>.
	 * 
	 * @return See above.
	 */
	public Icon getIcon() { return icon; }
	
	/** 
	 * Returns the folder where to download the file.
	 * 
	 * @return See above.
	 */
	public File getFolder() { return folder; }
	
	/** 
	 * Returns the file to download.
	 * 
	 * @return See above.
	 */
	public OriginalFile getFile() { return file; }
	
}
