#define __ANDROID__
#define USE_EXTERNAL_GFX

%module(directors="1") mega
%{
#include "megaapi.h"
%}

//Automatic load of the native library
%pragma(java) jniclasscode=%{
  static 
  {
    try { System.loadLibrary("mega"); } 
    catch (UnsatisfiedLinkError e1) 
    {
		try { System.load(System.getProperty("user.dir")+"/libmega.so"); }
		catch(UnsatisfiedLinkError e2)
		{
			System.err.println("Native code library failed to load. \n" + e2);
			System.exit(1);
		}
    }
  }
%}

%insert("runtime") %{
#define SWIG_JAVA_ATTACH_CURRENT_THREAD_AS_DAEMON
#define SWIG_JAVA_NO_DETACH_CURRENT_THREAD
%}

//Use compilation-time constants in Java
#ifdef SWIGJAVA
%javaconst(1);
#endif

//Generate inheritable wrappers for listener objects
%feature("director") MegaRequestListener;
%feature("director") MegaTransferListener;

%apply (char *STRING, size_t LENGTH) {(char *buffer, size_t size)};
%typemap(directorargout) (char *buffer, size_t size)
%{ jenv->DeleteLocalRef($input); %}

%feature("director") MegaGlobalListener;
%feature("director") MegaListener;
%feature("director") MegaTreeProcessor;
%feature("director") MegaGfxProcessor;

%apply (char *STRING, size_t LENGTH) {(char *bitmapData, size_t size)};
%typemap(directorin, descriptor="[B") (char *bitmapData, size_t size)
%{ 
	jbyteArray jb = (jenv)->NewByteArray($2);
	$input = jb;
%}
%typemap(directorargout) (char *bitmapData, size_t size)
%{ 
	jenv->GetByteArrayRegion($input, 0, $2, (jbyte *)$1);
	jenv->DeleteLocalRef($input);
%}

//Ignore internal classes
%ignore mega::CurlHttpIO;
%ignore mega::PosixFileSystemAccess;
%ignore mega::PosixWaiter;
%ignore mega::SqliteDbAccess;
%ignore mega::GfxProcessor;
%ignore mega::GfxProcExternal;
%ignore threadEntryPoint;
%ignore HttpIO;
%ignore MegaApp;
%ignore FileAccess;
%ignore SearchTreeProcessor;
%ignore RequestQueue;
%ignore TransferQueue;
%ignore mega::File;
%ignore MegaFile;
%ignore MegaFileGet;
%ignore MegaFilePut;
%ignore MegaWaiter;
%ignore MegaHttpIO;
%ignore MegaFileSystemAccess;
%ignore MegaDbAccess;
%ignore MegaGfxProc;

//Don't wrap internal constructors
//(these objects should be created internally only)

%ignore mega::Node::Node;
%ignore mega::User::User;
%ignore mega::Share::Share;
%ignore ArrayWrapper::ArrayWrapper;
%ignore NodeList::NodeList;
%ignore UserList::UserList;
%ignore ShareList::ShareList;
%ignore TransferList::TransferList;

//%ignore BalanceList::BalanceList;
//%ignore SessionList::SessionList;
//%ignore PurchaseList::PurchaseList;
//%ignore TransactionList::TransactionList;
%ignore StringList::StringList;
%ignore MegaRequest::MegaRequest;
%ignore MegaRequest::getNumDetails;
%ignore MegaTransfer::MegaTransfer;
%ignore MegaError::MegaError;
%ignore MegaNode::MegaNode;
%ignore MegaNode::fromNode;
%ignore MegaUser::fromUser;
%ignore MegaShare::fromShare;

//Don't wrap internal setters
//(This objects should be modified internally only)
%rename("$ignore", regextarget=1, fullname=1) "MegaRequest::set.*";
%rename("$ignore", regextarget=1, fullname=1) "MegaTransfer::set.*";
%rename("$ignore", regextarget=1, fullname=1) "MegaError::set.*";

//Ignore sync features
%ignore MegaApi::syncPathState;
%ignore MegaApi::getSyncedNode;
%ignore MegaApi::syncFolder;
%ignore MegaApi::removeSync;
%ignore MegaApi::getNumActiveSyncs;
%ignore MegaApi::stopSyncs;
%ignore MegaApi::getLocalPath;
%ignore MegaApi::updateStatics;
%ignore MegaApi::update;
%ignore MegaApi::isIndexing;
%ignore MegaApi::isWaiting;
%ignore MegaApi::isSynced;
%ignore MegaApi::setExcludedNames;
%ignore MegaApi::checkTransfer;
%ignore MegaApi::isRegularTransfer;
%ignore MegaApi::moveToLocalDebris;
%ignore MegaApi::is_syncable;

//Ignore still unsupported features
%ignore MegaApi::setProxySettings;
%ignore MegaApi::getAutoProxySettings;
%ignore MegaApi::getSize;
%ignore MegaApi::getDebug;
%ignore MegaApi::setDebug;
%ignore MegaApi::getRootNodeNames;
%ignore MegaApi::getRootNodePaths;
%ignore MegaApi::strdup;
%ignore SizeProcessor;
%ignore TreeProcessor;
%ignore MegaNode::getNodeKey;
%ignore MegaNode::getAttrString;
%ignore MegaNode::getLocalPath;
%ignore MegaRequest::getTransfer;
%ignore MegaTransfer::getTransfer;
%ignore MegaListener::onSyncStateChanged;

//Tell SWIG that these classes exist to avoid warnings
namespace mega {

typedef uint64_t handle;
typedef int error;

class PosixFileSystemAccess {};
class SqliteDbAccess {};
class File {};
class CurlHttpIO {};
class GfxProcessor {};
class GfxProcExternal {};
class MegaFileSystemAccess {};
class PosixWaiter {};
class HttpIO {};
class MegaApp {};
class FileAccess {};
class AccountDetails {};
//class AccountBalance {};
//class AccountSession {};
//class AccountPurchase {};
//class AccountTransaction {};
class User {};
class Node {};
class Share {};
}

%newobject MegaError::copy;
%newobject MegaRequest::copy;
%newobject MegaNode::copy;
%newobject MegaNode::getBase64Handle;

%newobject MegaApi::getChildren;
%newobject MegaApi::getChildNode;
%newobject MegaApi::getContacts;
%newobject MegaApi::getTransfers;
%newobject MegaApi::getContact;
%newobject MegaApi::getInShares;
%newobject MegaApi::getOutShares;
%newobject MegaApi::getNodePath;
%newobject MegaApi::getBase64PwKey;
%newobject MegaApi::getStringHash;
%newobject MegaApi::search;
%newobject MegaApi::ebcEncryptKey;
%newobject MegaApi::getMyEmail;
%newobject MegaApi::dumpSession;
%newobject MegaApi::getNodeByPath;
%newobject MegaApi::getNodeByHandle;
%newobject MegaApi::getRootNode;
%newobject MegaApi::getInboxNode;
%newobject MegaApi::getRubbishNode;
%newobject MegaApi::getParentNode;
%newobject MegaApi::getMyEmail;

typedef long long time_t;
typedef long long uint64_t;
typedef uint32_t dstime;
typedef long long int64_t;
typedef int64_t m_off_t;
typedef int64_t m_time_t;

//Include all new classes
%include "megaapi.h"

//Tell SWIG about tempates
//%template(BalanceList) ArrayWrapper<mega::AccountBalance>;
//%template(SessionList) ArrayWrapper<mega::AccountSession>;
//%template(PurchaseList) ArrayWrapper<mega::AccountPurchase>;
//%template(TransactionList) ArrayWrapper<mega::AccountTransaction>;
//%template(StringList) ArrayWrapper<const char*>;
//%template(ShareList) ArrayWrapper<mega::Share*>;


%extend mega::Share
{
	const char *getAccessLevel()
	{
		switch($self->access)
		{
			case mega::ACCESS_UNKNOWN: return "";
			case mega::RDONLY: return "r";
			case mega::RDWR: return "rw";
			case mega::FULL: return "full";
			case mega::OWNER: return "own"; 
		}
		return "";
	}
		
	User *getUser() { return $self->user; }
	long long getTimestamp() { return $self->ts; }
}

/*
%extend mega::AccountBalance
{
public:
	double getAmount() { return $self->amount; }
	const char* getCurrency() { return $self->currency; }
}

%extend mega::AccountSession
{
public:
	long long getTimestamp() { return $self->timestamp; }
	long long getMru() { return $self->mru; }
	const char* getUserAgent() { return $self->useragent.c_str(); }
	const char* getIp() { return $self->ip.c_str(); }
	const char* getCountry() { return $self->country; }
	int getCurrent() { return $self->current; }
}

%extend mega::AccountPurchase
{
public:
	long long getTimestamp() { return $self->timestamp; }
	const char *getHandle() { return $self->handle; }
	const char *getCurrency() { return $self->currency; }
	double getAmount() { return $self->amount; }
	int getMethod() { return $self->method; }
}

%extend mega::AccountTransaction
{
public:
	long long getTimestamp() { return $self->timestamp; }
	const char *getHandle() { return $self->handle; }
	const char *getCurrency() { return $self->currency; }
	double getDelta() { return $self->delta; }
}
*/

%newobject mega::AccountDetails::getBalances;
%newobject mega::AccountDetails::getSessions;
%newobject mega::AccountDetails::getPurchases;
%newobject mega::AccountDetails::getTransactions;
%extend mega::AccountDetails
{
public:
	long long getUsedStorage() { return $self->storage_used; }
	long long getMaxStorage() { return $self->storage_max; }
	long long getOwnUsedTransfer() { return $self->transfer_own_used; }
	long long getSrvUsedTransfer() { return $self->transfer_srv_used; }
	long long getMaxTransfer() { return $self->transfer_max; }
	long getSrvRatio() { return $self->srv_ratio; }
	int getProLevel() { return $self->pro_level; }
	char getSubscriptionType() { return $self->subscription_type; }
	long getProExpiration() { return $self->pro_until; }
		
	/*BalanceList* getBalances() 
	{ 
	    return new BalanceList(&($self->balances[0]), $self->balances.size());
	}
	
	SessionList* getSessions() 
	{
	    return new SessionList(&($self->sessions[0]), $self->sessions.size());
	}
	
	PurchaseList* getPurchases() 
	{ 
	    return new PurchaseList(&($self->purchases[0]), $self->purchases.size());
	}
	
	TransactionList* getTransactions() 
	{ 
	    return new TransactionList(&($self->transactions[0]), $self->transactions.size());
	}*/
}
