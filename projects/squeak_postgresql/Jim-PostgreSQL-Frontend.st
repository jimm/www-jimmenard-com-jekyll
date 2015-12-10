'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:23'                     !

"{ Package: '__NoProject__' }"

Object subclass:#PSQLFrontendMessage
	instanceVariableNames:''
	classVariableNames:'NilChar'
	poolDictionaries:''
	category:'Jim-PostgreSQL-Frontend'
!

!PSQLFrontendMessage class methodsFor:'instance creation'!

new
	^ super new initialize
! !

!PSQLFrontendMessage class methodsFor:'class initialization'!

initialize
	"PSQLFrontendMessage initialize"
	NilChar _ Character value: 0
! !

!PSQLFrontendMessage methodsFor:'writing'!

writeTo: aSocket
        | stream |

        PSQLConfiguration isSqueak ifTrue:[
                stream _ RWBinaryOrTextStream on: ByteArray new.
                self putTo: stream.
                aSocket sendData: stream contents
        ].

        PSQLConfiguration isSmalltalkx ifTrue:[
                self putTo:aSocket
        ].
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:23'                     !

"{ Package: '__NoProject__' }"

PSQLFrontendMessage subclass:#PSQLFMTerminate
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Frontend'
!

!PSQLFMTerminate methodsFor:'initialization'!

initialize
	^ self
! !

!PSQLFMTerminate methodsFor:'writing'!

putTo: aStream
	aStream nextPut: $X
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:23'                     !

"{ Package: '__NoProject__' }"

PSQLFrontendMessage subclass:#PSQLFMStartup
	instanceVariableNames:'protocol database user args tty'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Frontend'
!

!PSQLFMStartup methodsFor:'accessing'!

args: aString
	args _ aString
!

database: aString
	database _ aString
!

protocol: anInt
	protocol _ anInt
!

tty: aString
	tty _ aString
!

user: aString
	user _ aString
! !

!PSQLFMStartup methodsFor:'initialization'!

initialize
	protocol _ 16r00020000.
	database _ ''.
	user _ ''.
	args _ ''.
	tty _ ''
! !

!PSQLFMStartup methodsFor:'writing'!

putTo: aStream
        PSQLConfiguration isSqueak ifTrue:[
                aStream nextInt32Put: 296.
        ].
        PSQLConfiguration isSmalltalkx ifTrue:[
                aStream nextPutLong: 296 MSB:true.
        ].

        PSQLConfiguration isSqueak ifTrue:[
                aStream nextInt32Put: protocol.
        ].
        PSQLConfiguration isSmalltalkx ifTrue:[
                aStream nextPutLong: protocol MSB:true.
       ].

        aStream nextPutAll: (database padded: #right to: 64 with: NilChar).
        aStream nextPutAll: (user padded: #right to: 32 with: NilChar).
        aStream nextPutAll: (args padded: #right to: 64 with: NilChar).
        aStream nextPutAll: ('' padded: #right to: 64 with: NilChar).
        aStream nextPutAll: (tty padded: #right to: 64 with: NilChar).
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:23'                     !

"{ Package: '__NoProject__' }"

PSQLFrontendMessage subclass:#PSQLFMQuery
	instanceVariableNames:'query'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Frontend'
!

!PSQLFMQuery methodsFor:'accessing'!

query: aString
	query _ aString
! !

!PSQLFMQuery methodsFor:'initialization'!

initialize
	query _ ''
! !

!PSQLFMQuery methodsFor:'writing'!

putTo: aStream
	aStream nextPut: $Q.
	aStream nextPutAll: query; nextPut: NilChar
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:23'                     !

"{ Package: '__NoProject__' }"

PSQLFrontendMessage subclass:#PSQLFMUnencryptedPassword
	instanceVariableNames:'password'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Frontend'
!

!PSQLFMUnencryptedPassword methodsFor:'accessing'!

password: aString
	password _ aString
! !

!PSQLFMUnencryptedPassword methodsFor:'initialization'!

initialize
	password _ nil
! !

!PSQLFMUnencryptedPassword methodsFor:'writing'!

putTo: aStream
	aStream nextInt32Put: (password size + 5).
	aStream nextPutAll: password; nextPut: NilChar
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:23'                     !

"{ Package: '__NoProject__' }"

PSQLFrontendMessage subclass:#PSQLFMFunctionCall
	instanceVariableNames:'oid args'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Frontend'
!

!PSQLFMFunctionCall methodsFor:'accessing'!

addArgument: aStringOrByteArray
	args add: aStringOrByteArray
!

putTo: aStream
	aStream nextPut: $F.
	aStream nextPut: NilChar.
	aStream nextInt32Put: oid.
	aStream nextInt32Put: args size.
	args do: [ :arg |
		aStream nextInt32Put: arg size.
		aStream nextPutAll: arg.
	]
! !

!PSQLFMFunctionCall methodsFor:'initialization'!

initialize
	oid _ 0.
	args _ OrderedCollection new.
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:23'                     !

"{ Package: '__NoProject__' }"

PSQLFrontendMessage subclass:#PSQLFMEncryptedPassword
	instanceVariableNames:'password'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Frontend'
!

!PSQLFMEncryptedPassword methodsFor:'accessing'!

password: aString
	password _ aString
! !

!PSQLFMEncryptedPassword methodsFor:'initialization'!

initialize
	password _ nil
! !

!PSQLFMEncryptedPassword methodsFor:'writing'!

putTo: aStream
	self notYetImplemented
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:23'                     !

"{ Package: '__NoProject__' }"

PSQLFrontendMessage subclass:#PSQLFMCancelRequest
	instanceVariableNames:'processId secretKey'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Frontend'
!

!PSQLFMCancelRequest methodsFor:'accessing'!

processId: anInt
	processId _ anInt
!

secretKey: anInt
	secretKey _ anInt
! !

!PSQLFMCancelRequest methodsFor:'initialization'!

initialize
	processId _ 0.
	secretKey _ 0.
! !

!PSQLFMCancelRequest methodsFor:'writing'!

putTo: aStream
        PSQLConfiguration isSqueak ifTrue:[
                aStream nextInt32Put: 16.
        ].
        PSQLConfiguration isSmalltalkx ifTrue:[
                aStream nextPutLong: 16 MSB:true.
        ].

        PSQLConfiguration isSqueak ifTrue:[
                aStream nextInt32Put: 80877102.
        ].
        PSQLConfiguration isSmalltalkx ifTrue:[
                aStream nextPutLong: 80877102 MSB:true.
        ].

        PSQLConfiguration isSqueak ifTrue:[
                aStream nextInt32Put: processId.
        ].
        PSQLConfiguration isSmalltalkx ifTrue:[
                aStream nextPutLong: processId MSB:true.
        ].

        PSQLConfiguration isSqueak ifTrue:[
                aStream nextInt32Put: secretKey
        ].
        PSQLConfiguration isSmalltalkx ifTrue:[
                aStream nextPutLong: secretKey MSB:true.
        ].
! !


PSQLFrontendMessage initialize!
