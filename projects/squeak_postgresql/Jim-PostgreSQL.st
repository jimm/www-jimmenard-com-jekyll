'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:08'                     !

"{ Package: '__NoProject__' }"

Object subclass:#PSQLCursor
	instanceVariableNames:'name client fieldDescriptions rows socket cancelled'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL'
!

PSQLCursor comment:'I am a query results cursor. I hold field (column) descriptions and allow enumeration over the rows returned by a query. The rows are retrieved from the server one at a time while enumerating. The values in each row are in the same order as the field descriptions.

The values in each row are PSQLRow instances.

To cancel a query, call cancel while enumerating over the data.

    cursor do: [ :row |
		something ifTrue: [ cursor cancel ].
		row fields do: [ :val | Transcript show: val ]
			separatedBy: [ Transcript show: cr ]
	]
'
!

!PSQLCursor class methodsFor:'instance creation'!

named: aString client: aClient
	| cursor |
	cursor _ self new initialize.
	cursor name: aString;
		client: aClient.
	^ cursor
! !

!PSQLCursor methodsFor:'accessing'!

cancelled
	^ cancelled
!

cancelled: aBool
	cancelled _ aBool
!

client
	^ client
!

fieldDescriptions
	^ fieldDescriptions
!

fieldDescriptions: anOrderedCollection
	fieldDescriptions _ anOrderedCollection
!

name
	^ name
!

name: aString
	name _ aString
! !

!PSQLCursor methodsFor:'canceling'!

cancel
	cancelled ifFalse: [
		client cancel.
		self cancelled: true
	]
! !

!PSQLCursor methodsFor:'debugging'!

printTo: aWriteStream
	"Prints the contents of this cursor. aWriteStream
	may be the Transcript, for example."

	^ self printTo: aWriteStream cancelWhen: [ :row | false ]
!

printTo: aWriteStream cancelWhen: aBoolBlock
	"Prints the contents of this cursor. The request is
	cancelled when aBoolBlock returns true. aWriteStream
	may be the Transcript, for example."

	"Display field names."
	self fieldDescriptions do: [ :field | aWriteStream show: field name ]
		separatedBy: [ aWriteStream show: ' | ' ].
	aWriteStream cr.
	self fieldDescriptions do: [ :field |
			aWriteStream show: ('' padded: #right to: (field name size) with: $-)
		]
		separatedBy: [ aWriteStream show: ' | ' ].
	aWriteStream cr.

	"Display data. Each row of data is retrieved from the
	server when it is needed and is turned into a PSQLRow."
	self do: [ :row |
		(aBoolBlock value: row)
			ifTrue: [ self cancel. ] "The outer block will no longet be called."
			ifFalse: [
				row fields do: [ :val | aWriteStream show: val ]
					separatedBy: [ aWriteStream show: ' | ' ].
				aWriteStream cr.
			]
	].
! !

!PSQLCursor methodsFor:'enumerating'!

do: aBlock
        "Receive rows from the server and perform aBlock with each row. The
        argument passed to aBlock is an Association whose key is a field
        description and value is the column value.

        If the request is cancelled, we continue to read data but don't call the
        block. The way PostgreSQL works, the cancellation is sent on a separate
        socket and the data may continue to dribble in for a while longer."
        | response cmd ignore|

        response _ client getResponseWith: fieldDescriptions size.
        cmd _ response id.
        ignore:=false.
        [cmd = $Z] whileFalse: [
                ignore ifFalse: [
                        cmd = $C ifTrue: [
                                "completed response; here we ignore string after $C"
                                ignore:=true.
                        ].
                        cmd = $G ifTrue: [ "copy data in from client to backend"
                                ^ self notYetImplemented
                        ].
                        cmd = $H ifTrue: [ "copy data out from backend to client"
                                ^ self notYetImplemented
                        ].
                        ((cmd = $D) or: [cmd = $B]) ifTrue: [ "ascii row ($D) or binary row ($B)"
                                cancelled ifFalse: [
                                        aBlock value: (PSQLRow fieldDescriptions: fieldDescriptions rowData: response).
                                ]
                        ].
                        cmd = $I ifTrue: [ "empty query"
                        ].
                        cmd = $E ifTrue: [ "error response"
                                "PSQLSocket>>getResponse displays error messages"
                                "^ self error: 'error from server: ', response message"
                        ].
                        cmd = $N ifTrue: [ "notice response"
                                self inform: response message
                        ].
                ].
                ('CGHDBIEN' includes: cmd) ifFalse: [
                        self closeConnection.
                        ^ self error: 'unexpected server response'
                ].
                response _ client getResponseWith: fieldDescriptions size.
                cmd _ response id.
        ].
        ^ self
! !

!PSQLCursor methodsFor:'initializing'!

initialize
	fieldDescriptions _ OrderedCollection new.
	rows _ OrderedCollection new.
	socket _ nil.
	cancelled _ false
! !

!PSQLCursor methodsFor:'private'!

client: aClient
	client _ aClient
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:08'                     !

"{ Package: '__NoProject__' }"

Object subclass:#PSQLClient
	instanceVariableNames:'socket host port database user password backendProcessID
		backendSecretKey'
	classVariableNames:'DefaultReplySize ProtocolVersionNumber'
	poolDictionaries:''
	category:'Jim-PostgreSQL'
!

PSQLClient comment:'I am a client that can communicate with a PostgreSQL server on a specific host and port. I use a PSQLSocket to communicate. See PSQLClient>>example1.

    "PSQLClient example1"

The method PSQLClient>query:onerror:onNotice: is the one called by the other query methods. The default error block calls error: and the default notice block calls inform:.

Instance variables:

	socket -- a PSQLSocket
	host	 -- a host name or IP address string; may be nil
	port	 -- a port number; if nil, PSQLSocket uses its defaultPort
	database -- database name string
	user -- user name string
	password -- password string; may be nil. After being used, the value is erased (password is set to nil).
	backendProcessID -- int32 received during the startup phase, used by the server to identify this client during cancel request messages
'
!

!PSQLClient class methodsFor:'initialization'!

initialize
	"PSQLClient initialize"
	"Initializes the default reply buffer size and protocol version number"
	DefaultReplySize _ 1024.

	"I have no idea what value to use here, except that it's supposed to be Major/Minor. This works, though."
	ProtocolVersionNumber _ 16r00020000.
! !

!PSQLClient class methodsFor:'instance creation'!

new
	^ super new initialize
! !

!PSQLClient class methodsFor:'examples'!

example1
	"PSQLClient example1"
	"Runs a query and displays the results. Cancels after
	the first row that returns an ID value > 10.

	To run with your database, change the database name
	and user name, add a password if necessary, and change
	the table name in the select statement."

	| client cursor |

	"Create a client and tell it your vital statistics. In this
	example, we use localhost, the default port, and don't
	need a password."
	client _ PSQLClient new database: 'dv_example'; user: 'jimm'.
	client establishConnection.

	"Send the query. The cursor retrieves the field descriptions
	but does not retrieve the data until you enumerate over
	the returned rows."
self halt.
	cursor _ client query: 'select * from jobs'
		onError: [ :msg |
			Transcript nextPutAll: msg; nextPut: Character cr.
			self inform: msg.
		]
		onNotice: nil.

	"Display field names and data. Display the first ten rows (ID 0-9)."
	cursor printTo: Transcript cancelWhen: [ :row | (row at: 'ID') asInteger >= 10 ].

	"All done."
	client closeConnection
!

example2
	"PSQLClient example2"
	"Inserts a row, displays it, and deletes it."

	| client cursor |

	"Create a client and tell it your vital statistics. In this
	example, we use localhost, the default port, and don't
	need a password."
	client _ PSQLClient new database: 'dv_example'; user: 'jimm'.
	client establishConnection.

	"Send the query. The cursor retrieves the field descriptions
	but does not retrieve the data until you enumerate over
	the returned rows."
	cursor _ client query: 'insert into office values (999, ''Office 999'', ''O999'', ''(212) 555-1212'', ''office99@example.com'', ''t'')'.

	cursor _ client query: 'select * from office where ID = 999'.
	cursor printTo: Transcript.

	cursor _ client query: 'delete from office where ID = 999'.

	"All done."
	client closeConnection
! !

!PSQLClient methodsFor:'accessing'!

backendProcessID
	^ backendProcessID
!

backendProcessID: anInt32
	backendProcessID _ anInt32
!

backendSecretKey
	^ backendSecretKey
!

backendSecretKey: anInt32
	backendSecretKey _ anInt32
!

database
	^ database
!

database: value
	database _ value
!

host
	^ host
!

host: value
	host _ value
!

password: aString
	password _ Password new.
	password cache: aString
!

port
	^ port
!

port: value
	port _ value
!

socket
	^ socket
!

socket: value
	socket _ value
!

user
	^ user
!

user: value
	user _ value
! !

!PSQLClient methodsFor:'canceling'!

cancel
	"A cancel request is sent on a separate socket. Since the data may 
	continue to dribble in for a while longer, the cursor iterating over 
	query results will continue to read data but stop calling the block given 
	to it."
	| cancelSocket request |
	cancelSocket _ PSQLSocket new connectToHost: host port: port.
	request _ PSQLFMCancelRequest new.
	request processId: self backendProcessID;
		 secretKey: backendSecretKey.
	request writeTo: cancelSocket.
	cancelSocket close.
	cancelSocket _ nil
! !

!PSQLClient methodsFor:'communicating'!

query: aQueryString
        "Run query and return PSQLCursor. This should work for inserts, updates, and deletes, too."
        ^ self query: aQueryString
                onError: [ :errorMsg | self error: errorMsg]
                onNotice: [ :noticeMsg | 
                        PSQLConfiguration isSqueak ifTrue:[self inform: noticeMsg].
                        PSQLConfiguration isSmalltalkx ifTrue:[Transcript showCR: noticeMsg].
                        self halt].
!

query: aQueryString onError: errorHandlerBlock
        "Run query and return PSQLCursor. This should work for inserts, updates, and deletes, too."
        ^ self query: aQueryString
                onError: errorHandlerBlock
                onNotice: [ :noticeMsg | 
                        PSQLConfiguration isSqueak ifTrue:[
                                self inform: noticeMsg
                        ].
                        PSQLConfiguration isSmalltalkx ifTrue:[
                                Transcript showCR:noticeMsg
                        ].
                ]
!

query: aQueryString onError: errorHandlerBlock onNotice: noticeBlock
        "Run query and return PSQLCursor. This should work for inserts, updates, and deletes, too."
        | query response cmd cursor errorMsg ignore|

        cursor _ nil.
        query _ PSQLFMQuery new.
        query query: aQueryString.
        query writeTo: socket.

        response _ self getResponse.
        cmd _ response id.
        ignore _ false.
        [cmd = $Z] whileFalse: [
                ignore ifFalse:[
                        cmd = $P ifTrue: [ "cursor response"
                                "name of cursor will be blank if cursor is implicit"
                                cursor _ PSQLCursor named: response name client: self.
                        ].
                        cmd = $E ifTrue: [ "error response"
                                "PSQLSocket>>getResponse displays error messages"
                                errorMsg _ 'error from server: ', response message.
                                errorHandlerBlock isNil ifFalse: [ errorHandlerBlock value: errorMsg ].
                                ignore:=true.
                        ].
                        cmd = $N ifTrue: [ "notice response"
                                errorMsg _ response message.
                                noticeBlock isNil ifFalse: [ noticeBlock value: errorMsg ].
                        ].
                        cmd = $T ifTrue: [ "row description"
                                "Once we receive the row description, we return. The cursor will read the row data when the user enumerates over the rows."
                                cursor fieldDescriptions: response fieldDescriptions.
                                ^ cursor
                        ].
                ].
                ('PENTCIGH' includes: cmd) ifFalse: [
                        "$C = completed, $I = empty query, $G = copy in, $H = copy out"
                        self closeConnection.
                        errorMsg _ 'unexpected server response'.
                        errorHandlerBlock isNil ifFalse: [ errorHandlerBlock value: errorMsg ].
                        ^ nil
                ].
                response _ self getResponse.
                cmd _ response id.
        ].
        ^ cursor
!

query: aQueryString onNotice: noticeBlock
	"Run query and return PSQLCursor. This should work for inserts, updates, and deletes, too."
	^ self query: aQueryString
		onError: [ :errorMsg | self error: errorMsg ]
		onNotice: noticeBlock
! !

!PSQLClient methodsFor:'connecting'!

authenticate: response
	"Given the authentication response from the server, send back the proper authentication response. I erase my password instance variable so it remains a secret."
	| cmd pwdString answer pwd |

	"Make a local copy of the password and erase the original."
	pwdString _ password isNil ifTrue: [ nil ] ifFalse: [ password cache: nil ].
	password _ nil. "erase from memory"

	cmd _ response authTypeSymbol.
	cmd = #ok ifTrue: [ "authentication successful" ].
	cmd = #kerberosV4 ifTrue: [
		self closeConnection.
		^ self error: 'Kerberos V4 not supported'
	].
	cmd = #kerberosV5 ifTrue: [
		self closeConnection.
		^ self error: 'Kerberos V5 not supported'
	].
	cmd = #unencryptedPassword ifTrue: [ "unencrypted password"
		pwdString isNil ifTrue: [
			pwdString _ FillInTheBlank request: 'Password?' initialAnswer: user.
		].
		pwd _ PSQLFMUnencryptedPassword new.
		pwd password: pwdString.
		pwd writeTo: socket.
		answer _ self getResponse.
		cmd _ answer id.
		cmd = $E ifTrue: [
			self closeConnection.
			^ self error: 'bad password: ', answer message
		].
		cmd = $R ifTrue: [
			cmd _ answer authTypeSymbol.
			cmd = #ok ifFalse: [ ^ self error: 'unexpected password response' ]
					ifTrue: [ ^ self "all is well" ]
		].
		^ self error: 'unexpected password response ', cmd printString
	].
	cmd = #encryptedPassword ifTrue: [ "encrypted password; next two bytes are the salt chars"
		self closeConnection.
		^ self error: 'encrypted password not supported'. "need crypt()"
	].
!

closeConnection
        PSQLFMTerminate new writeTo: socket.

        PSQLConfiguration isSqueak ifTrue: [
                socket closeAndDestroy. "Was socket close"
        ].
        PSQLConfiguration isSmalltalkx ifTrue: [
                socket close.
        ].

        socket _ nil
!

completeStartupPhase
	| response cmd |
	"Wait for server to start back end process and return reply."

	response _ self getResponse.
	cmd _ response id.

	[cmd = $Z] whileFalse: [ "looking for ReadyForQuery response"
		cmd = $K ifTrue: [ "save backend key data"
			self backendProcessID: (response processId).
			self backendSecretKey: (response secretKey).
		].
		cmd = $E ifTrue: [ "error response"
			self closeConnection.
			^ self error: 'startup phase completion error'
		].
		cmd = $N ifTrue: [ "notice response; show user and continue listening"
			self inform: (self stringFrom: response startingAt: 2)
		].
		('KEN' includes: cmd) ifFalse: [
			self closeConnection.
			^ self error: 'unexpected server response: ', cmd printString
		].
		response _ self getResponse.
		cmd _ response id.
	].
!

establishConnection
        "Establish a connection between this client and the server. There's a protocol which involves sending a startup packet, possibly sending authentication information, and handle any failure."
        | msg response cmd |

        "Connect to network. If host is nil, localhost will be used. If port is nil, PSQLSocket defaultPort will be used."
        socket _ PSQLSocket new connectToHost: host port: port.
        PSQLConfiguration isSqueak ifTrue:[socket discardReceivedData].
        msg _ PSQLFMStartup new.
        msg protocol: ProtocolVersionNumber;
                database: database;
                user: user.
        msg writeTo: socket.

        response _ self getResponse.
        cmd _ response id.
        cmd = $E ifTrue: [
                password _ nil.
                ^ self error: 'error from server: ', response message
        ].
        cmd = $R ifFalse: [
                password _ nil.
                ^ self error: 'unknown server response: ', cmd printString
        ].

        self authenticate: response.
        self completeStartupPhase
! !

!PSQLClient methodsFor:'initializing'!

initialize
        "host will be nil, which means local host."
        port _ PSQLSocket defaultPort.
        PSQLConfiguration initialize.
! !

!PSQLClient methodsFor:'private'!

getResponse
	^ self getResponseWith: nil
!

getResponseWith: arg
        | message |
        message _ PSQLBackendMessage readFrom: socket with: arg.

        "If it's an error message, notify the user."
        (message id = $E) ifTrue: [
                PSQLConfiguration isSqueak ifTrue:[
                        self inform: (message message)
                ].
                PSQLConfiguration isSmalltalkx ifTrue:[
                        Transcript show: (message message).
                ].
        ].

        ^ message
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:08'                     !

"{ Package: '__NoProject__' }"

Object subclass:#PSQLRow
	instanceVariableNames:'assocs'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL'
!

PSQLRow comment:'I represent a row of database data. I store an OrderedCollection of Associations. Each Association''s key is a PSQLFieldDescription and value is a string.

To access a single column, call at: with either an integer or string argument (where the string is the field name). To enumerating over field values, use do:.

PSQLCursors create PSQLRows as they receive rows of data from the server. See PSQLCursor>do: and PSQLClient>>example1.'
!

!PSQLRow class methodsFor:'instance creation'!

fieldDescriptions: fieldDescriptions rowData: aPSQLBMRow
	^ self new fieldDescriptions: fieldDescriptions rowData: aPSQLBMRow
! !

!PSQLRow methodsFor:'accessing'!

assocs
	"Returns an OrderedCollection of Associations. Each Association's
	key is a PSQLFieldDescription and value is a string.

	See also at: and do:."
	^ assocs
!

at: anIntegerOrFieldNameString
	"Returns a databse column value. If anIntegerOrFieldNameString
	is an Integer, it is used as an index into the ordered collection
	of associations. Else, we find the association whose key's name
	is anIntegerOrFieldNameString and returns the database value."
	| assoc |
	(anIntegerOrFieldNameString isKindOf: Integer)
		ifTrue: [
			^ (assocs at: anIntegerOrFieldNameString) value
		]
		ifFalse: [
			assoc _ assocs
				detect: [ :a | a key name = anIntegerOrFieldNameString ]
				ifNone: [ nil ].
			assoc isNil
				ifFalse: [ ^ assoc value ]
				ifTrue: [ ^ nil ]
		]
!

fieldDescriptions
	^ assocs collect: [ :assoc | assoc key ]
!

fields
	^ assocs collect: [ :assoc | assoc value ]
! !

!PSQLRow methodsFor:'enumeration'!

do: aBlock
	"Performs aBlock for each database value."
	^ assocs values do: aBlock
! !

!PSQLRow methodsFor:'initialization'!

fieldDescriptions: fieldDescriptions rowData: aPSQLBMRow
	"Creates our ordered collection of associations whose keys are field descriptions and values are column values."
	| fields field |
	fields _ aPSQLBMRow fields.
	field _ nil.
	assocs _ OrderedCollection new.
	fieldDescriptions do: [ :fd |
		field _ field isNil ifTrue: [ fields first ] ifFalse: [ fields after: field ].
		assocs add: (Association key: fd value: field).
	]
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:08'                     !

"{ Package: '__NoProject__' }"

Socket subclass:#PSQLSocket
	instanceVariableNames:''
	classVariableNames:'DefaultPort'
	poolDictionaries:''
	category:'Jim-PostgreSQL'
!

!PSQLSocket class methodsFor:'initialization'!

initialize
	"PSQLSocket initialize"
	"Set the default PostgreSQL server port"
	DefaultPort _ 5432
! !

!PSQLSocket class methodsFor:'constants'!

defaultPort
	"Returns the default PostgreSQL server port"
	^ DefaultPort
! !

!PSQLSocket methodsFor:'connecting'!

connectToHost: aHost port: aPort
        "Connects to the port at host. If host is nil, connects to local host. If port is nil, connects using defaultPort."
        | addr |

        PSQLConfiguration isSqueak ifTrue:
                [Socket initializeNetwork].

        aHost isNil ifTrue: [ 
                PSQLConfiguration isSqueak 
                        ifTrue:[addr _ NetNameResolver localHostAddress ].
                PSQLConfiguration isSmalltalkx
                        ifTrue:[addr _ 'localhost']
        ] ifFalse: [ 
                PSQLConfiguration isSqueak 
                        ifTrue:[addr _ NetNameResolver addressForName: aHost timeout: 10 ].
                PSQLConfiguration isSmalltalkx
                        ifTrue:[addr _ aHost]
        ].

        PSQLConfiguration isSqueak ifTrue:[
                addr isNil ifTrue: [^ self inform: 'Could not find an address for ', aHost]
        ].

        "self halt."

        PSQLConfiguration isSmalltalkx ifTrue:[
                self domain:#inet type:#stream
        ].

        self connectTo: addr port: (aPort isNil ifTrue: [ DefaultPort ] ifFalse: [ aPort ]).

        PSQLConfiguration isSqueak ifTrue:[
                self waitForConnectionFor: Socket standardDeadline
        ].

        (self isConnected) ifFalse: [
                ^ self inform: 'could not connect'
        ].
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:08'                     !

"{ Package: '__NoProject__' }"

Object subclass:#PSQLFieldDescription
	instanceVariableNames:'name oid size modifier'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL'
!

!PSQLFieldDescription class methodsFor:'instance creation'!

name: aString oid: oidInt size: sizeInt modifier: modInt
	| fd |
	fd _ self new.
	fd name: aString;
		oid: oidInt;
		size: sizeInt;
		modifier: modInt.
	^ fd
! !

!PSQLFieldDescription methodsFor:'accessing'!

modifier
	"The modifier value is only used with columns that are modified at table-creation time."
	^ modifier
!

name
	^ name
!

oid
	^ oid
!

size
	^ size
! !

!PSQLFieldDescription methodsFor:'private'!

modifier: value
	modifier _ value
!

name: value
	name _ value
!

oid: value
	oid _ value
!

size: value
	size _ value
! !


PSQLClient initialize!
PSQLSocket initialize!
