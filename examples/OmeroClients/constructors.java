import java.util.Iterator;

import omero.model.Image;
import omero.model.ImageI;
import omero.model.Dataset;
import omero.model.DatasetI;
import omero.model.DatasetImageLink;
import omero.model.DatasetImageLinkI;

public class constructors {

    public static void main(String args[]) {

        Image image = new ImageI();
        Dataset dataset = new DatasetI(1L, false);
        dataset.linkImage(image);

    }

}
