/*
 * org.openmicroscopy.shoola.agents.treeviewer.OriginalFileLoader 
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
package org.openmicroscopy.shoola.agents.treeviewer;


//Java imports
import java.io.File;
import java.util.Collection;

//Third-party libraries

//Application-internal dependencies
import org.openmicroscopy.shoola.agents.dataBrowser.DataBrowserLoader;
import org.openmicroscopy.shoola.agents.treeviewer.view.TreeViewer;
import org.openmicroscopy.shoola.env.data.events.DSCallFeedbackEvent;
import org.openmicroscopy.shoola.env.data.views.CallHandle;

/** 
 * Loads the original files associated to the passed collection of pixels.
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
public class OriginalFileLoader 
	extends DataTreeViewerLoader
{

	/** The folder where to save the file. */
	private File folder;
	
	/** The collection of pixels sets. */
	private Collection<Long> pixelsID;
	
	/** Handle to the asynchronous call so that we can cancel it. */
    private CallHandle	handle;
    
	 /**	
     * Creates a new instance.
     * 
     * @param viewer 	The viewer this data loader is for.
     *               	Mustn't be <code>null</code>.
     * @param pixelsID	The collection of the pixels set to handle.
     * @param folder	The folder where to save the files.
     */
    public OriginalFileLoader(TreeViewer viewer, Collection<Long> pixelsID, 
    		File folder)
    {
    	 super(viewer);
    	 this.pixelsID = pixelsID;
    	 this.folder = folder;
    }
    
	/** 
	 * Loads the files. 
	 * @see DataTreeViewerLoader#load()
	 */
	public void load()
	{
		handle = mhView.loadOriginalFiles(pixelsID, this);
	}
	
	/** 
	 * Cancels the data loading. 
	 * @see DataTreeViewerLoader#cancel()
	 */
	public void cancel() { handle.cancel(); }
	
	/** 
     * Feeds the files back to the viewer, as they arrive. 
     * @see DataTreeViewerLoader#update(DSCallFeedbackEvent)
     */
    public void update(DSCallFeedbackEvent fe) 
    {
    	Object o = fe.getPartialResult();
    	if (o != null) viewer.setDownloadedFiles(folder, (Collection) o);
    }
    
    /**
     * Does nothing as the asynchronous call returns <code>null</code>.
     * The actual payload (files) is delivered progressively
     * during the updates.
     * @see DataTreeViewerLoader#handleNullResult()
     */
    public void handleNullResult() {}
    
}
