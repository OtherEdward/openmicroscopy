/*
 *   $Id$
 * 
 *   Copyright 2007 Glencoe Software, Inc. All rights reserved.
 *   Use is subject to license terms supplied in LICENSE.txt
 *
 */

#ifndef omero_API
#define omero_API

#include <omero/fwd.ice>
#include <omero/ROMIO.ice>
#include <omero/RTypes.ice>
#include <omero/Scripts.ice>
#include <omero/System.ice>
#include <Glacier2/Session.ice>
#include <Ice/BuiltinSequences.ice>

/*
 * The omero::api module defines all the central verbs for working
 * with OMERO.blitz. Arguments and return values consist of those
 * types defined in the other ice files available here. With no
 * further custom code, it is possible to interoperate with
 * OMERO.blitz simply via the definitions here. Start with the
 * ServiceFactory definition at the end of this file.
 *
 * Note: Using these types is significantly easier in combination with
 * the JavaDocs of the OMERO.server, specifically the ome.api
 * package. Where not further noted below, the follow mappings between
 * ome.api argument types and omero::api argument types hold:
 *
 *     +-----------------------+------------------------+
 *     |        ome.api        |      omero::api        |
 *     +-----------------------+------------------------+
 *     |java.lang.Class        |string                  |
 *     +-----------------------+------------------------+
 *     |java.util.Set          |java.util.List/vector   |
 *     +-----------------------+------------------------+
 *     |IPojo options (Map)    |omero::sys::ParamMap    |
 *     +-----------------------+------------------------+
 *     |If null needed         |omero::RType subclass   |
 *     +-----------------------+------------------------+
 *     |...                    |...                     |
 *     +-----------------------+------------------------+
 */
module omero {

  module api {

    ["java:type:java.util.ArrayList"]
      sequence<omero::model::Experimenter> ExperimenterList;

    ["java:type:java.util.ArrayList"]
      sequence<omero::model::ExperimenterGroup> ExperimenterGroupList;

    ["java:type:java.util.ArrayList"]
      sequence<omero::model::Annotation> AnnotationList;

      dictionary<string, omero::model::Annotation> SearchMetadata;

    ["java:type:java.util.ArrayList"]
      sequence<SearchMetadata> SearchMetadataList;

    ["java:type:java.util.ArrayList<omero.model.IObject>:java.util.List<omero.model.IObject>"]
      sequence<omero::model::IObject> IObjectList;

      dictionary<string, IObjectList> IObjectListMap;
      
      dictionary<string, Ice::LongSeq> IdListMap;
      
    ["java:type:java.util.ArrayList"]
      sequence<omero::model::Image> ImageList;

    ["java:type:java.util.ArrayList"]
      sequence<omero::model::Session> SessionList;

    ["java:type:java.util.ArrayList<String>:java.util.List<String>"]
      sequence<string> StringSet;
	
	dictionary<long, string> ScriptIDNameMap;



    /*
     * Service marker similar to ome.api.ServiceInterface
     */
    interface ServiceInterface
      {
      };

	sequence<ServiceInterface*> ServiceList;

    /*
     * Service marker for stateful services which permits the closing
     * of a particular service before the destruction of the session.
     */
    interface StatefulServiceInterface extends ServiceInterface
      {
        void close();
        idempotent omero::sys::EventContext getCurrentEventContext() throws ServerError;
      };

    interface IAdmin extends ServiceInterface
      {

	// Getters
	idempotent omero::model::Experimenter getExperimenter(long id) throws ServerError;
	idempotent omero::model::Experimenter lookupExperimenter(string name) throws ServerError;
	idempotent ExperimenterList lookupExperimenters() throws ServerError;
	idempotent omero::model::ExperimenterGroup getGroup(long id) throws ServerError;
	idempotent omero::model::ExperimenterGroup lookupGroup(string name) throws ServerError ; 
	idempotent ExperimenterGroupList lookupGroups() throws ServerError;
	idempotent ExperimenterList containedExperimenters(long groupId) throws ServerError;
	idempotent ExperimenterGroupList containedGroups(long experimenterId) throws ServerError;
	idempotent omero::model::ExperimenterGroup getDefaultGroup(long experimenterId) throws ServerError;
	idempotent string lookupLdapAuthExperimenter(long id) throws ServerError;
	idempotent RList lookupLdapAuthExperimenters() throws ServerError;
    
	// Mutators
    
    void updateSelf(omero::model::Experimenter experimenter) throws ServerError;
	void updateExperimenter(omero::model::Experimenter experimenter) throws ServerError;
	void updateGroup(omero::model::ExperimenterGroup group) throws ServerError;
	long createUser(omero::model::Experimenter experimenter, string group) throws ServerError;
	long createSystemUser(omero::model::Experimenter experimenter) throws ServerError;
	long createExperimenter(omero::model::Experimenter user, 
				omero::model::ExperimenterGroup defaultGroup, ExperimenterGroupList groups) throws ServerError; 
	long createGroup(omero::model::ExperimenterGroup group) throws ServerError;
	idempotent void addGroups(omero::model::Experimenter user, ExperimenterList groups) throws ServerError;
	idempotent void removeGroups(omero::model::Experimenter user, ExperimenterGroupList groups) throws ServerError;
	idempotent void setDefaultGroup(omero::model::Experimenter user, omero::model::ExperimenterGroup group) throws ServerError;
	idempotent void setGroupOwner(omero::model::ExperimenterGroup group, omero::model::Experimenter owner) throws ServerError;
	idempotent void deleteExperimenter(omero::model::Experimenter user) throws ServerError;
	idempotent void changeOwner(omero::model::IObject obj, string omeName) throws ServerError;
	idempotent void changeGroup(omero::model::IObject obj, string omeName) throws ServerError;
	idempotent void changePermissions(omero::model::IObject obj, omero::model::Permissions perms) throws ServerError;
	/* Leaving this non-idempotent, because of the overhead, though technically it is. */
	Ice::BoolSeq unlock(IObjectList objects) throws ServerError;

	// UAuth
	idempotent void changePassword(omero::RString newPassword) throws ServerError;
	idempotent void changeUserPassword(string omeName, omero::RString newPassword) throws ServerError;
	idempotent void synchronizeLoginCache() throws ServerError;
	void changeExpiredCredentials(string name, string oldCred, string newCred) throws ServerError;
	void reportForgottenPassword(string name, string email) throws ServerError;

	// Security Context
	idempotent omero::sys::Roles getSecurityRoles() throws ServerError;
	idempotent omero::sys::EventContext getEventContext() throws ServerError;
      };

    interface IScript extends ServiceInterface
      {
	idempotent ScriptIDNameMap getScripts() throws ServerError;
	idempotent long getScriptID(string name) throws  ServerError;
	long uploadScript(string script) throws ServerError;
	idempotent string getScript(long id) throws ServerError;
	idempotent RTypeDict getScriptWithDetails(long id) throws ServerError;
	idempotent RTypeDict getParams(long id) throws ServerError;
	RTypeDict runScript(long id, RTypeDict map) throws ServerError;
	void deleteScript(long id) throws ServerError;
     };

    interface IConfig extends ServiceInterface
      {
	idempotent string getVersion() throws ServerError;
	idempotent string getConfigValue(string key) throws ServerError;
	idempotent void setConfigValue(string key, string value) throws ServerError;
	idempotent omero::RTime getDatabaseTime() throws ServerError;
	idempotent omero::RTime getServerTime() throws ServerError;
      };

    interface IDelete extends omero::api::ServiceInterface
      {
        omero::api::IObjectList checkImageDelete(long id, bool force) throws ServerError;
        omero::api::IObjectList previewImageDelete(long id, bool force) throws ServerError;
        void deleteImage(long id, bool force) throws ApiUsageException, ValidationException, SecurityViolation, ServerError;
      };

     interface ILdap extends ServiceInterface
      {
	idempotent ExperimenterList searchAll() throws ServerError;
	idempotent StringSet searchDnInGroups(string attr, string value) throws ServerError;
	idempotent ExperimenterList searchByAttribute(string attribute, string value) throws ServerError;
	idempotent omero::model::Experimenter searchByDN(string userdn) throws ServerError;
	idempotent string findDN(string username) throws ServerError;
	idempotent void setDN(long experimenterID, string dn) throws ServerError;
	idempotent ExperimenterGroupList searchGroups() throws ServerError;
	idempotent StringSet searchAttributes() throws ServerError;
	idempotent bool checkAttributes(string dn, StringSet attrs) throws ServerError;
      };


    interface IPixels extends ServiceInterface
      {
	idempotent omero::model::Pixels retrievePixDescription(long pixId) throws ServerError;
	idempotent omero::model::RenderingDef retrieveRndSettings(long pixId) throws ServerError;
	idempotent omero::model::RenderingDef loadRndSettings(long renderingSettingsId) throws ServerError;
	void saveRndSettings(omero::model::RenderingDef rndSettings) throws ServerError;
	idempotent int getBitDepth(omero::model::PixelsType type) throws ServerError;
	idempotent omero::RObject getEnumeration(string enumClass, string value) throws ServerError;
	idempotent IObjectList getAllEnumerations(string enumClass) throws ServerError;
	omero::RLong copyAndResizePixels(long pixelsId,
	                                 omero::RInt sizeX,
	                                 omero::RInt sizeY,
	                                 omero::RInt sizeZ,
	                                 omero::RInt sizeT,
									 omero::sys::IntList channelList,
	                                 string methodology,
									 bool copyStats) throws ServerError;
	omero::RLong copyAndResizeImage(long imageId,
	                                omero::RInt sizeX,
	                                omero::RInt sizeY,
	                                omero::RInt sizeZ,
	                                omero::RInt sizeT,
								    omero::sys::IntList channelList,
	                                string methodology,
									bool copyStats) throws ServerError;
	omero::RLong createImage(int sizeX, int sizeY, int sizeZ, int sizeT,
	                         omero::sys::IntList channelList, 
	                         omero::model::PixelsType pixelsType,
	                         string name, string description) throws ServerError;
	void setChannelGlobalMinMax(long pixelsId, int channelIndex, double min, double max) throws ServerError;
      };

    dictionary<long, IObjectList> AnnotationMap;
    dictionary<string, omero::model::Experimenter> UserMap;
    dictionary<int, int> CountMap;

    interface IPojos extends ServiceInterface
      {
	idempotent IObjectList loadContainerHierarchy(string rootType, omero::sys::LongList rootIds, omero::sys::ParamMap options) throws ServerError;
	idempotent IObjectList findContainerHierarchies(string rootType, omero::sys::LongList imageIds, omero::sys::ParamMap options) throws ServerError;
	idempotent AnnotationMap findAnnotations(string rootType, omero::sys::LongList rootIds, omero::sys::LongList annotatorIds, omero::sys::ParamMap options) throws ServerError;
	idempotent IObjectList findCGCPaths(omero::sys::LongList imageIds, string algo, omero::sys::ParamMap options) throws ServerError;
	idempotent ImageList getImages(string rootType, omero::sys::LongList rootIds, omero::sys::ParamMap options) throws ServerError;
	idempotent ImageList getUserImages(omero::sys::ParamMap options) throws ServerError;
	idempotent ImageList getImagesByOptions(omero::sys::ParamMap options) throws ServerError;
	idempotent UserMap getUserDetails(StringSet names, omero::sys::ParamMap options) throws ServerError;
	idempotent CountMap getCollectionCount(string type, string property, omero::sys::LongList ids, omero::sys::ParamMap options) throws ServerError;
	idempotent IObjectList retrieveCollection(omero::model::IObject obj, string collectionName, omero::sys::ParamMap options) throws ServerError;
	omero::model::IObject createDataObject(omero::model::IObject obj, omero::sys::ParamMap options) throws ServerError;
	IObjectList createDataObjects(IObjectList dataObjects, omero::sys::ParamMap options) throws ServerError;
	void unlink(IObjectList links, omero::sys::ParamMap options) throws ServerError;
	IObjectList link(IObjectList links, omero::sys::ParamMap options) throws ServerError;
	omero::model::IObject updateDataObject(omero::model::IObject obj, omero::sys::ParamMap options) throws ServerError;
	IObjectList updateDataObjects(IObjectList objs, omero::sys::ParamMap options) throws ServerError;
	void deleteDataObject(omero::model::IObject obj, omero::sys::ParamMap options) throws ServerError;
	void deleteDataObjects(IObjectList objs, omero::sys::ParamMap options) throws ServerError;
      };

    interface IQuery extends ServiceInterface
      {
	idempotent omero::model::IObject get(string klass, long id) throws ServerError;
	idempotent omero::model::IObject find(string klass, long id) throws ServerError;
	idempotent IObjectList           findAll(string klass, omero::sys::Filter filter) throws ServerError;
	idempotent omero::model::IObject findByExample(omero::model::IObject example) throws ServerError;
	idempotent IObjectList           findAllByExample(omero::model::IObject example, omero::sys::Filter filter) throws ServerError;
	idempotent omero::model::IObject findByString(string klass, string field, string value) throws ServerError;
	idempotent IObjectList           findAllByString(string klass, string field, string value, bool caseSensitive, omero::sys::Filter filter) throws ServerError;
	idempotent omero::model::IObject findByQuery(string query, omero::sys::Parameters params) throws ServerError;
	idempotent IObjectList           findAllByQuery(string query, omero::sys::Parameters params) throws ServerError;
	idempotent IObjectList           findAllByFullText(string klass, string query, omero::sys::Parameters params) throws ServerError;
	idempotent omero::model::IObject refresh(omero::model::IObject iObject) throws ServerError;
      };

    interface ISession extends ServiceInterface
      {
        omero::model::Session createSession(omero::sys::Principal p, string credentials) throws ServerError;
        omero::model::Session getSession(string sessionUuid) throws ServerError;
        omero::model::Session updateSession(omero::model::Session sess) throws ServerError;
        void closeSession(omero::model::Session sess) throws ServerError;
        // System users
        omero::model::Session createSessionWithTimeout(omero::sys::Principal p, long seconds) throws ServerError;

        // Environment
        omero::RType getInput(string sess, string key) throws ServerError;
        omero::RType getOutput(string sess, string key) throws ServerError;
        void setInput(string sess, string key, omero::RType value) throws ServerError;
        void setOutput(string sess, string key, omero::RType value) throws ServerError;
        StringSet getInputKeys(string sess) throws ServerError;
        StringSet getOutputKeys(string sess) throws ServerError;
      };

    interface IShare extends ServiceInterface
      {
        void activate(long shareId);
        omero::model::Session getShare(long sessionId);
        SessionList getAllShares(bool active);
        SessionList getOwnShares(bool active);
        SessionList getMemberShares(bool active);
        SessionList getSharesOwnedBy(omero::model::Experimenter user, bool active);
        SessionList getMemberSharesFor(omero::model::Experimenter user, bool active);
        IObjectList getContents(long shareId);
        IObjectList getContentSubList(long shareId, int start, int finish);
        int getContentSize(long shareId);
        IdListMap getContentMap(long shareId);

        long createShare(string description, 
                         omero::RTime expiration, 
                         IObjectList items,
                         ExperimenterList exps,
                         Ice::StringSeq guests,
                         bool enabled);
        void setDescription(long shareId, string description);
        void setExpiration(long shareId, omero::RTime expiration);
        void setActive(long shareId, bool active);
        void closeShare(long shareId);

        void addObjects(long shareId, IObjectList iobjects);
        void addObject(long shareId, omero::model::IObject iobject);
        void removeObjects(long shareId, IObjectList iobjects);
        void removeObject(long shareId, omero::model::IObject iobject);

        AnnotationList getComments(long shareId);
        omero::model::TextAnnotation addComment(long shareId, string comment);
        omero::model::TextAnnotation addReply(long shareId,
                                              string comment, 
                                              omero::model::TextAnnotation replyTo);
        void deleteComment(omero::model::Annotation comment);

        ExperimenterList getAllMembers(long shareId);
        Ice::StringSeq getAllGuests(long shareId);
        Ice::StringSeq getAllUsers(long shareId) throws ValidationException;
        void addUsers(long shareId, ExperimenterList exps);
        void addGuests(long shareId, Ice::StringSeq emailAddresses);
        void removeUsers(long shareId, ExperimenterList exps);
        void removeGuests(long shareId, Ice::StringSeq emailAddresses);
        void addUser(long shareId, omero::model::Experimenter exp);
        void addGuest(long shareId, string emailAddress);
        void removeUser(long shareId, omero::model::Experimenter exp);
        void removeGuest(long shareId, string emailAddress);
        // Move to collections.ice when merged
        //dictionary<string, omero::model::Experimenter> getActiveConnections(long shareId);
        //dictionary<string, omero::model::Experimenter> getPastConnections(long shareId);
        void invalidateConnection(long shareId, omero::model::Experimenter exp);
        IObjectList getEvents(long shareId, omero::model::Experimenter exp, omero::RTime from, omero::RTime to);
      };

    interface ITypes extends ServiceInterface
      {
        omero::model::IObject createEnumeration(omero::model::IObject newEnum) throws ServerError;
        idempotent omero::model::IObject getEnumeration(string type, string value) throws ServerError;
        idempotent IObjectList allEnumerations(string type) throws ServerError;
        omero::model::IObject updateEnumeration(omero::model::IObject oldEnum) throws ServerError;
        void updateEnumerations(IObjectList oldEnums) throws ServerError;
        void deleteEnumeration(omero::model::IObject oldEnum) throws ServerError;
        idempotent StringSet getEnumerationTypes() throws ServerError; 
        idempotent StringSet getAnnotationTypes() throws ServerError;
        idempotent IObjectListMap getEnumerationsWithEntries() throws ServerError;
        IObjectList getOriginalEnumerations() throws ServerError;
        void resetEnumerations(string enumClass) throws ServerError;
      };

    interface IUpdate extends ServiceInterface
      {
	void saveObject(omero::model::IObject obj) throws ServerError;
	void saveCollection(IObjectList objs) throws ServerError;
	omero::model::IObject saveAndReturnObject(omero::model::IObject obj) throws ServerError;
	void saveArray(IObjectList graph) throws ServerError;
	IObjectList saveAndReturnArray(IObjectList graph) throws ServerError;
	void deleteObject(omero::model::IObject row) throws ServerError;
	void indexObject(omero::model::IObject row) throws ServerError;
      };

    dictionary<bool, omero::sys::LongList> BooleanIdListMap;
    interface IRenderingSettings extends ServiceInterface
      {
        bool sanityCheckPixels(omero::model::Pixels pFrom, omero::model::Pixels pTo) throws ServerError;
        omero::model::RenderingDef getRenderingSettings(long pixelsId) throws ServerError;
        omero::model::RenderingDef createNewRenderingDef(omero::model::Pixels pixels) throws ServerError;
        void resetDefaults(omero::model::RenderingDef def, omero::model::Pixels pixels) throws ServerError;
        omero::model::RenderingDef resetDefaultsNoSave(omero::model::RenderingDef def, omero::model::Pixels pixels) throws ServerError;
        void resetDefaultsInImage(long imageId) throws ServerError;
        omero::sys::LongList resetDefaultsInCategory(long categoryId) throws ServerError;
        omero::sys::LongList resetDefaultsInDataset(long dataSetId) throws ServerError;
        omero::sys::LongList resetDefaultsInSet(string type, omero::sys::LongList noteIds) throws ServerError;
        void applySettingsToSet(long from, string toType, IObjectList to) throws ServerError;
        BooleanIdListMap applySettingsToProject(long from, long to) throws ServerError;
        BooleanIdListMap applySettingsToDataset(long from, long to) throws ServerError;
        BooleanIdListMap applySettingsToCategory(long from, long to) throws ServerError;
        bool applySettingsToImage(long from, long to) throws ServerError;
        bool applySettingsToPixels(long from, long to) throws ServerError;
        void setOriginalSettingsInImage(long imageId) throws ServerError;
        omero::sys::LongList setOriginalSettingsInDataset(long dataSetId) throws ServerError;
        omero::sys::LongList setOriginalSettingsInSet(string type, omero::sys::LongList noteIds) throws ServerError;
      };

    interface IRepositoryInfo extends ServiceInterface
      {
	idempotent long getUsedSpaceInKilobytes() throws ServerError;
	idempotent long getFreeSpaceInKilobytes() throws ServerError;
	idempotent double getUsageFraction() throws ServerError;
	void sanityCheckRepository() throws ServerError;
	void removeUnusedFiles() throws ServerError;
      };

    interface JobHandle extends StatefulServiceInterface
      {
        long submit(omero::model::Job j) throws ServerError;
        omero::model::JobStatus attach(long jobId) throws ServerError;
        omero::model::Job getJob()  throws ServerError;
        omero::model::JobStatus jobStatus()  throws ServerError;
        omero::RTime jobFinished()  throws ServerError;
        string jobMessage()  throws ServerError;
        bool jobRunning()  throws ServerError;
        bool jobError()  throws ServerError;
        void cancelJob()  throws ServerError;
      };

    interface RawFileStore extends StatefulServiceInterface
      {
	void setFileId(long fileId) throws ServerError;
	idempotent Ice::ByteSeq read(long position, int length) throws ServerError;
	idempotent void write(Ice::ByteSeq buf, long position, int length) throws ServerError;
	idempotent bool exists() throws ServerError;
      };

    interface RawPixelsStore extends StatefulServiceInterface
      {
	void setPixelsId(long pixelsId) throws ServerError;
	idempotent int getPlaneSize() throws ServerError;
	idempotent int getRowSize() throws ServerError;
	idempotent int getStackSize() throws ServerError;
	idempotent int getTimepointSize() throws ServerError;
	idempotent int getTotalSize() throws ServerError;
	idempotent long getRowOffset(int y, int z, int c, int t) throws ServerError;
	idempotent long getPlaneOffset(int z, int c, int t) throws ServerError;
	idempotent long getStackOffset(int c, int t) throws ServerError;
	idempotent long getTimepointOffset(int t) throws ServerError;
	idempotent Ice::ByteSeq getRegion(int size, long offset) throws ServerError;
	idempotent Ice::ByteSeq getRow(int y, int z, int c, int t) throws ServerError;
	idempotent Ice::ByteSeq getPlane(int z, int c, int t) throws ServerError;
	idempotent Ice::ByteSeq getPlaneRegion(int z, int c, int t, int size, int offset) throws ServerError;
	idempotent Ice::ByteSeq getStack(int c, int t) throws ServerError;
	idempotent Ice::ByteSeq getTimepoint(int t) throws ServerError;
	idempotent void setRegion(int size, long offset, Ice::ByteSeq buffer) throws ServerError;
	idempotent void setRow(Ice::ByteSeq buf, int y, int z, int c, int t) throws ServerError;
	idempotent void setPlane(Ice::ByteSeq buf, int z, int c, int t) throws ServerError;
	idempotent void setStack(Ice::ByteSeq buf, int z, int c, int t) throws ServerError;
	idempotent void setTimepoint(Ice::ByteSeq buf, int t) throws ServerError;
	idempotent int getByteWidth() throws ServerError;
	idempotent bool isSigned() throws ServerError;
	idempotent bool isFloat() throws ServerError;
	idempotent Ice::ByteSeq calculateMessageDigest() throws ServerError;
      };

    interface RenderingEngine extends StatefulServiceInterface
      {
	omero::romio::RGBBuffer render(omero::romio::PlaneDef def) throws ServerError;
	Ice::IntSeq renderAsPackedInt(omero::romio::PlaneDef def) throws ServerError;
	Ice::IntSeq renderProjectedAsPackedInt(int algorithm, int timepoint, int stepping, int start, int end) throws ServerError;
	Ice::ByteSeq renderCompressed(omero::romio::PlaneDef def) throws ServerError;
	Ice::ByteSeq renderProjectedCompressed(int algorithm, int timepoint, int stepping, int start, int end) throws ServerError;
	void lookupPixels(long pixelsId) throws ServerError;
	bool lookupRenderingDef(long pixelsId) throws ServerError;
	void loadRenderingDef(long renderingDefId) throws ServerError;
	void load() throws ServerError;
	void setModel(omero::model::RenderingModel model) throws ServerError;
	omero::model::RenderingModel getModel() throws ServerError;
	int getDefaultZ() throws ServerError;
	int getDefaultT() throws ServerError;
	void setDefaultZ(int z) throws ServerError;
	void setDefaultT(int t) throws ServerError;
	omero::model::Pixels getPixels() throws ServerError;
	IObjectList getAvailableModels() throws ServerError;
	IObjectList getAvailableFamilies() throws ServerError;
	void setQuantumStrategy(int bitResolution) throws ServerError;
	void setCodomainInterval(int start, int end) throws ServerError;
	omero::model::QuantumDef getQuantumDef() throws ServerError;
	void setQuantizationMap(int w, omero::model::Family fam, double coefficient, bool noiseReduction) throws ServerError;
	omero::model::Family getChannelFamily(int w) throws ServerError;
	bool getChannelNoiseReduction(int w) throws ServerError;
	Ice::DoubleSeq getChannelStats(int w) throws ServerError;
	double getChannelCurveCoefficient(int w) throws ServerError;
	void setChannelWindow(int w, double start, double end) throws ServerError;
	double getChannelWindowStart(int w) throws ServerError;
	double getChannelWindowEnd(int w) throws ServerError;
	void setRGBA(int w, int red, int green, int blue, int alpha) throws ServerError;
	Ice::IntSeq getRGBA(int w) throws ServerError;
	void setActive(int w, bool active) throws ServerError;
	bool isActive(int w) throws ServerError;
	void addCodomainMap(omero::romio::CodomainMapContext mapCtx) throws ServerError;
	void updateCodomainMap(omero::romio::CodomainMapContext mapCtx) throws ServerError;
	void removeCodomainMap(omero::romio::CodomainMapContext mapCtx) throws ServerError;
	void saveCurrentSettings() throws ServerError;
	void resetDefaults() throws ServerError;
	void resetDefaultsNoSave() throws ServerError;
	void setCompressionLevel(float percentage) throws ServerError;
	float getCompressionLevel() throws ServerError;
	bool isPixelsTypeSigned() throws ServerError;
	double getPixelsTypeUpperBound(int w) throws ServerError;
	double getPixelsTypeLowerBound(int w) throws ServerError;
      };

    interface Search extends StatefulServiceInterface
      {

        // Non-query state ~~~~~~~~~~~~~~~~~~~~~~

        int activeQueries() throws ServerError;
        void setBatchSize(int size) throws ServerError;
        int getBatchSize() throws ServerError;
        void setMergedBatches(bool merge) throws ServerError;
        bool isMergedBatches() throws ServerError;
        void setCaseSentivice(bool caseSensitive) throws ServerError;
        bool isCaseSensitive() throws ServerError;
        void setUseProjections(bool useProjections) throws ServerError;
        bool isUseProjections() throws ServerError;
        void setReturnUnloaded(bool returnUnloaded) throws ServerError;
        bool isReturnUnloaded() throws ServerError;
        void setAllowLeadingWildcard(bool allowLeadingWildcard) throws ServerError;
        bool isAllowLeadingWildcard() throws ServerError;


        // Filters ~~~~~~~~~~~~~~~~~~~~~~

        void onlyType(string klass) throws ServerError;
        void onlyTypes(StringSet classes) throws ServerError;
        void allTypes() throws ServerError;
        void onlyIds(omero::sys::LongList ids) throws ServerError;
        void onlyOwnedBy(omero::model::Details d) throws ServerError;
        void notOwnedBy(omero::model::Details d) throws ServerError;
        void onlyCreatedBetween(omero::RTime start, omero::RTime  stop) throws ServerError;
        void onlyModifiedBetween(omero::RTime start, omero::RTime stop) throws ServerError;
        void onlyAnnotatedBetween(omero::RTime start, omero::RTime stop) throws ServerError;
        void onlyAnnotatedBy(omero::model::Details d) throws ServerError;
        void notAnnotatedBy(omero::model::Details d) throws ServerError;
        void onlyAnnotatedWith(StringSet classes) throws ServerError;


        // Fetches, order, counts, etc ~~~~~~~~~~~~~~~~~~~~~~

        void addOrderByAsc(string path) throws ServerError;
        void addOrderByDesc(string path) throws ServerError;
        void unordered() throws ServerError;
        void fetchAnnotations(StringSet classes) throws ServerError;
        void fetchAlso(StringSet fetches) throws ServerError;


        // Reset ~~~~~~~~~~~~~~~~~~~~~~~~~

        void resetDefaults() throws ServerError;


        // Query state  ~~~~~~~~~~~~~~~~~~~~~~~~~

        void byGroupForTags(string group) throws ServerError;
        void byTagForGroups(string tag) throws ServerError;
        void byFullText(string query) throws ServerError;
        void byHqlQuery(string query, omero::sys::Parameters params) throws ServerError;
        void bySomeMustNone(StringSet some, StringSet must, StringSet none) throws ServerError;
        void byAnnotatedWith(AnnotationList examples) throws ServerError;
        void clearQueries() throws ServerError;

        void and() throws ServerError;
        void or() throws ServerError;
        void not() throws ServerError;


        // Retrieval  ~~~~~~~~~~~~~~~~~~~~~~~~~

        bool hasNext() throws ServerError;
        omero::model::IObject next() throws ServerError;
        IObjectList results() throws ServerError;

        // Currently unused
        SearchMetadata currentMetadata() throws ServerError;
        SearchMetadataList currentMetadataList() throws ServerError;

        // Unused; Part of Java Iterator interface
        void remove() throws ServerError;
      };

    interface ThumbnailStore extends StatefulServiceInterface
      {
	bool setPixelsId(long pixelsId) throws ServerError;
	void setRenderingDefId(long renderingDefId) throws ServerError;
	Ice::ByteSeq getThumbnail(omero::RInt sizeX, omero::RInt sizeY) throws ServerError;
	omero::sys::IdByteMap getThumbnailSet(omero::RInt sizeX, omero::RInt sizeY, omero::sys::LongList pixelsIds) throws ServerError;
	omero::sys::IdByteMap getThumbnailByLongestSideSet(omero::RInt size, omero::sys::LongList pixelsIds) throws ServerError;
	Ice::ByteSeq getThumbnailByLongestSide(omero::RInt size) throws ServerError;
	Ice::ByteSeq getThumbnailByLongestSideDirect(omero::RInt size) throws ServerError;
	Ice::ByteSeq getThumbnailDirect(omero::RInt sizeX, omero::RInt sizeY) throws ServerError;
	Ice::ByteSeq getThumbnailForSectionDirect(int theZ, int theT, omero::RInt sizeX, omero::RInt sizeY) throws ServerError;
	Ice::ByteSeq getThumbnailForSectionByLongestSideDirect(int theZ, int theT, omero::RInt size) throws ServerError;
	void createThumbnails() throws ServerError;
	void createThumbnail(omero::RInt sizeX, omero::RInt sizeY) throws ServerError;
	bool thumbnailExists(omero::RInt sizeX, omero::RInt sizeY) throws ServerError;
	void resetDefaults() throws ServerError;
      };

    /*
     * Unused, and unsupported. Similar callbacks can be added
     * as specific needs arise.
     */
    interface SimpleCallback
      {
	void call();
      };

    /*
     * Starting point for all OMERO.blitz interaction. Similar to the
     * ome.system.ServiceFactory class in the OMERO.server and its
     * RMI/Java clients, this ServiceFactory once properly created
     * creates functioning proxies to the server. 
     *
     * The difference between the two types is that the blitz instance
     * sits server-side. 
     */
    interface ServiceFactory extends Glacier2::Session
      {
	// Central OMERO.blitz stateless services.
	IAdmin*    getAdminService() throws ServerError;
	IConfig*   getConfigService() throws ServerError;
	IPixels*   getPixelsService() throws ServerError;
	IPojos*    getPojosService() throws ServerError;
	IQuery*    getQueryService() throws ServerError;
    IRenderingSettings* getRenderingSettingsService() throws ServerError;
	IRepositoryInfo* getRepositoryInfoService() throws ServerError;
	IScript*   getScriptService() throws ServerError;
	ISession*  getSessionService() throws ServerError;
	IShare*    getShareService() throws ServerError;
	ITypes*    getTypesService() throws ServerError;
	IUpdate*   getUpdateService() throws ServerError;

	// Central OMERO.blitz stateful services.
	JobHandle* createJobHandle() throws ServerError;
	RawFileStore* createRawFileStore() throws ServerError;
	RawPixelsStore* createRawPixelsStore() throws ServerError;
	RenderingEngine* createRenderingEngine() throws ServerError;
	Search* createSearchService() throws ServerError;
	ThumbnailStore* createThumbnailStore() throws ServerError;

	/*
	 * Allows looking up any service by name. See Constants.ice
	 * for examples of services. If a service has been added
	 * by third-parties, getByName can be used even though
	 * no concrete method is available.
	 */

	ServiceInterface* getByName(string name) throws ServerError;

	StatefulServiceInterface* createByName(string name) throws ServerError;

        // Shared resources. Here an acquisition framework is^M
        // in place such that it is not guaranteed that^M

        omero::grid::InteractiveProcessor*
        acquireProcessor(omero::model::Job job, int seconds)
        throws ServerError;

	/*
	 * Example for what a server callback would look like.
	 * Unsupported.
	 */
	void setCallback(SimpleCallback* callback);

	/*
	 * Deprecated misnomer.
	 */
	["deprecated:close() is deprecated. use closeOnDestroy() instead."] void close();

	/*
	 * Marks the session for closure rather than detachment, which will
	 * be triggered by the destruction of the Glacier2 connection via
	 * router.destroySession()
	 *
	 * Closing the session rather the detaching is more secure, since all
	 * resources are removed from the server and can safely be set once
	 * it is clear that a client is finished with those resources.
	 */
	void closeOnDestroy();

	/*
	 * Marks the session for detachment rather than closure, which will
	 * be triggered by the destruction of the Glacier2 connection via
	 * router.destroySession()
	 *
	 * This is the default and allows a lost session to be reconnected,
	 * at a slight security cost since the session will persist longer
	 * and can be used by others if the UUID is intercepted.
	 */
	void detachOnDestroy();

	// Session management

	/*
	 * Returns a list of string ids for currently active services. This will
	 * _not_ keep services alive, and in fact checks for all expired services
	 * and removes them.
	 */
	StringSet activeServices();

	/*
	 * Requests that the given services be marked as alive. It is
	 * possible that one of the services has already timed out, in which
	 * case the returned long value will be non-zero.
	 * 
	 * Specifically, the bit representing the 0-based index will be 1:
	 * 
	 *        if (retval & 1<<idx == 1<<idx) { // not alive }
	 * 
	 * Except for fatal server or session errors, this method should never
	 * throw an exception.
	 */
	long keepAllAlive(ServiceList proxies);

	/*
	 * Returns true if the given service is alive.
	 * 
	 * Except for fatal server or session errors, this method should never
	 * throw an exception. 
	 */
	bool keepAlive(ServiceInterface* proxy);

      };

  };
};

#endif 
