package org.openmicroscopy.omero.model;

import java.io.Serializable;
import java.util.Set;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;


/** @author Hibernate CodeGenerator */
public class DisplayOption implements Serializable {

    /** identifier field */
    private Integer attributeId;

    /** nullable persistent field */
    private Boolean redOn;

    /** nullable persistent field */
    private Integer ZStart;

    /** nullable persistent field */
    private Boolean blueOn;

    /** nullable persistent field */
    private String colorMap;

    /** nullable persistent field */
    private Integer ZStop;

    /** nullable persistent field */
    private Float zoom;

    /** nullable persistent field */
    private Integer TStop;

    /** nullable persistent field */
    private Integer TStart;

    /** nullable persistent field */
    private Boolean greenOn;

    /** nullable persistent field */
    private Boolean displayRgb;

    /** persistent field */
    private org.openmicroscopy.omero.model.Image image;

    /** persistent field */
    private org.openmicroscopy.omero.model.ImagePixel imagePixel;

    /** persistent field */
    private org.openmicroscopy.omero.model.ModuleExecution moduleExecution;

    /** persistent field */
    private Set displayRois;

    /** full constructor */
    public DisplayOption(Integer attributeId, Boolean redOn, Integer ZStart, Boolean blueOn, String colorMap, Integer ZStop, Float zoom, Integer TStop, Integer TStart, Boolean greenOn, Boolean displayRgb, org.openmicroscopy.omero.model.Image image, org.openmicroscopy.omero.model.ImagePixel imagePixel, org.openmicroscopy.omero.model.ModuleExecution moduleExecution, Set displayRois) {
        this.attributeId = attributeId;
        this.redOn = redOn;
        this.ZStart = ZStart;
        this.blueOn = blueOn;
        this.colorMap = colorMap;
        this.ZStop = ZStop;
        this.zoom = zoom;
        this.TStop = TStop;
        this.TStart = TStart;
        this.greenOn = greenOn;
        this.displayRgb = displayRgb;
        this.image = image;
        this.imagePixel = imagePixel;
        this.moduleExecution = moduleExecution;
        this.displayRois = displayRois;
    }

    /** default constructor */
    public DisplayOption() {
    }

    /** minimal constructor */
    public DisplayOption(Integer attributeId, org.openmicroscopy.omero.model.Image image, org.openmicroscopy.omero.model.ImagePixel imagePixel, org.openmicroscopy.omero.model.ModuleExecution moduleExecution, Set displayRois) {
        this.attributeId = attributeId;
        this.image = image;
        this.imagePixel = imagePixel;
        this.moduleExecution = moduleExecution;
        this.displayRois = displayRois;
    }

    public Integer getAttributeId() {
        return this.attributeId;
    }

    public void setAttributeId(Integer attributeId) {
        this.attributeId = attributeId;
    }

    public Boolean getRedOn() {
        return this.redOn;
    }

    public void setRedOn(Boolean redOn) {
        this.redOn = redOn;
    }

    public Integer getZStart() {
        return this.ZStart;
    }

    public void setZStart(Integer ZStart) {
        this.ZStart = ZStart;
    }

    public Boolean getBlueOn() {
        return this.blueOn;
    }

    public void setBlueOn(Boolean blueOn) {
        this.blueOn = blueOn;
    }

    public String getColorMap() {
        return this.colorMap;
    }

    public void setColorMap(String colorMap) {
        this.colorMap = colorMap;
    }

    public Integer getZStop() {
        return this.ZStop;
    }

    public void setZStop(Integer ZStop) {
        this.ZStop = ZStop;
    }

    public Float getZoom() {
        return this.zoom;
    }

    public void setZoom(Float zoom) {
        this.zoom = zoom;
    }

    public Integer getTStop() {
        return this.TStop;
    }

    public void setTStop(Integer TStop) {
        this.TStop = TStop;
    }

    public Integer getTStart() {
        return this.TStart;
    }

    public void setTStart(Integer TStart) {
        this.TStart = TStart;
    }

    public Boolean getGreenOn() {
        return this.greenOn;
    }

    public void setGreenOn(Boolean greenOn) {
        this.greenOn = greenOn;
    }

    public Boolean getDisplayRgb() {
        return this.displayRgb;
    }

    public void setDisplayRgb(Boolean displayRgb) {
        this.displayRgb = displayRgb;
    }

    public org.openmicroscopy.omero.model.Image getImage() {
        return this.image;
    }

    public void setImage(org.openmicroscopy.omero.model.Image image) {
        this.image = image;
    }

    public org.openmicroscopy.omero.model.ImagePixel getImagePixel() {
        return this.imagePixel;
    }

    public void setImagePixel(org.openmicroscopy.omero.model.ImagePixel imagePixel) {
        this.imagePixel = imagePixel;
    }

    public org.openmicroscopy.omero.model.ModuleExecution getModuleExecution() {
        return this.moduleExecution;
    }

    public void setModuleExecution(org.openmicroscopy.omero.model.ModuleExecution moduleExecution) {
        this.moduleExecution = moduleExecution;
    }

    public Set getDisplayRois() {
        return this.displayRois;
    }

    public void setDisplayRois(Set displayRois) {
        this.displayRois = displayRois;
    }

    public String toString() {
        return new ToStringBuilder(this)
            .append("attributeId", getAttributeId())
            .toString();
    }

    public boolean equals(Object other) {
        if ( (this == other ) ) return true;
        if ( !(other instanceof DisplayOption) ) return false;
        DisplayOption castOther = (DisplayOption) other;
        return new EqualsBuilder()
            .append(this.getAttributeId(), castOther.getAttributeId())
            .isEquals();
    }

    public int hashCode() {
        return new HashCodeBuilder()
            .append(getAttributeId())
            .toHashCode();
    }

}
