'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

Object subclass:#PSQLBackendMessage
	instanceVariableNames:'id creationArg'
	classVariableNames:'FactoryClassDict'
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBackendMessage class methodsFor:'instance creation'!

readFrom: aSocket
	"Factory method."
	| buf id class message |

	"Read command byte."
	buf _ ByteArray new: 1.
	aSocket receiveDataInto: buf.
	id _ Character value: (buf at: 1).

	"Create and return new message object."
	class _ FactoryClassDict at: id ifAbsent: [
		self error: 'unknown message type ', id printString, ' (', id asInteger printString, ')'
	].
	message _ class new.
	^ message id: id;
		readFrom: aSocket;
		yourself
!

readFrom: aSocket with: arg
        "Factory method."
        | buf numBytes id class message |

        "Read command byte."
        buf _ ByteArray new: 1.

"DEBUG"
        PSQLConfiguration isSqueak ifTrue:[
                aSocket waitForData
        ].

        PSQLConfiguration isSqueak ifTrue:[
                numBytes _ aSocket receiveDataInto: buf.
        ].
        PSQLConfiguration isSmalltalkx ifTrue:[
                numBytes _ aSocket nextBytes:1 into:buf startingAt:1.
        ].

        numBytes = 1 ifFalse: [ 
                PSQLConfiguration isSqueak ifTrue:[
                        self inform: 'num bytes not 1 (it was ', numBytes printString, ')' 
                ].
                PSQLConfiguration isSmalltalkx ifTrue:[
                        Dialog information: 'num bytes not 1 (it was ', numBytes printString, ')'.
                        self halt.
                ].
        ].

        id _ Character value: (buf at: 1).

        "Create and return new message object."
        class _ FactoryClassDict at: id ifAbsent: [
                self error: 'unknown message type ', id printString, ' (', id asInteger printString, ')'
        ].
        message _ class new.
        ^ message id: id;
                creationArg: arg;
                readFrom: aSocket;
                yourself
! !

!PSQLBackendMessage class methodsFor:'class initialization'!

initialize
	"PSQLBackendMessage initialize"

	FactoryClassDict _ Dictionary new.
	FactoryClassDict at: $D put: PSQLBMAsciiRow.
	FactoryClassDict at: $R put: PSQLBMAuthentication.
	FactoryClassDict at: $K put: PSQLBMBackendKeyData.
	FactoryClassDict at: $B put: PSQLBMBinaryRow.
	FactoryClassDict at: $C put: PSQLBMCompletedResponse.
	FactoryClassDict at: $G put: PSQLBMCopyInResponse.
	FactoryClassDict at: $H put: PSQLBMCopyOutResponse.
	FactoryClassDict at: $P put: PSQLBMCursorResponse.
	FactoryClassDict at: $I put: PSQLBMEmptyQueryResponse.
	FactoryClassDict at: $E put: PSQLBMErrorResponse.
	FactoryClassDict at: $V put: PSQLBMFunctionResponse.
	FactoryClassDict at: $N put: PSQLBMNoticeResponse.
	FactoryClassDict at: $A put: PSQLBMNotificationResponse.
	FactoryClassDict at: $Z put: PSQLBMReadyForQuery.
	FactoryClassDict at: $T put: PSQLBMRowDescription.
! !

!PSQLBackendMessage methodsFor:'accessing'!

id
	^ id
! !

!PSQLBackendMessage methodsFor:'package parsing'!

readByteFrom: aSocket
	^ (self readBytesFrom: aSocket length: 1) at: 1
!

readBytesFrom: aSocket length: len
        | buf |
        buf _ ByteArray new: len.

        PSQLConfiguration isSqueak ifTrue:[
                aSocket receiveDataInto: buf.
        ].
        PSQLConfiguration isSmalltalkx ifTrue:[
                aSocket nextBytes:len into:buf startingAt:1.
        ].
        ^ buf
!

readCharacterFrom: aSocket
	^ Character value: (self readByteFrom: aSocket)
!

readInt16From: aSocket
        | buf |

        PSQLConfiguration isSqueak ifTrue:[
                buf _ ByteArray new: 2.        
                aSocket receiveDataInto: buf.
                ^ buf shortAt: 1 bigEndian: true
        ].
        PSQLConfiguration isSmalltalkx ifTrue:[
                ^ aSocket nextShortMSB:true.
        ].

        self halt. "Unknown configuration"
!

readInt32From: aSocket
        | buf |

        PSQLConfiguration isSqueak ifTrue:[
                buf _ ByteArray new: 4.
                aSocket receiveDataInto: buf.
                ^ buf longAt: 1 bigEndian: true.
        ].

        PSQLConfiguration isSmalltalkx ifTrue:[
                ^ aSocket nextLongMSB:true.
        ].

        self halt.
!

readStringFrom: aSocket
        | buf charValue str |
        buf _ ByteArray new: 1.
        str _ String new.

        PSQLConfiguration isSqueak ifTrue:[
                aSocket receiveDataInto: buf.
        ].
        PSQLConfiguration isSmalltalkx ifTrue:[
                aSocket nextBytes:1 into:buf startingAt:1.
        ].

        charValue _ buf at: 1.
        [charValue isZero] whileFalse: [
                str _ str, (Character value: charValue) asString.

                PSQLConfiguration isSqueak ifTrue:[
                        aSocket receiveDataInto: buf.
                ].
                PSQLConfiguration isSmalltalkx ifTrue:[
                        aSocket nextBytes:1 into:buf startingAt:1.
                ].

                charValue _ buf at: 1.
       ].
        ^ str
!

readStringFrom: aSocket length: len
	| buf charValue str bytesToRead |
	buf _ ByteArray new: 1.
	str _ String new.
	bytesToRead _ len.

	aSocket receiveDataInto: buf.
	charValue _ Character value: (buf at: 1).
	bytesToRead timesRepeat: [
		charValue isZero ifFalse: [ str _ str, charValue asString ].
		aSocket receiveDataInto: buf.
		charValue _ Character value: (buf at: 1)
	].

	^ str
!

stringFrom: aByteArray startingAt: anInt
	"Returns the null-terminated string inside aByteArray starting at anInt."
	^ aByteArray copyFrom: anInt to: (aByteArray indexOf: 0 ifAbsent: [ aByteArray size ])
! !

!PSQLBackendMessage methodsFor:'private'!

creationArg: arg
	"Some subclasses need information passed in at creation time."
	creationArg _ arg
!

id: aChar
	"called during construction"
	id _ aChar
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMCopyInResponse
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMCopyInResponse methodsFor:'parsing'!

readFrom: aSocket
	self notYetImplemented
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMBinaryRow
	instanceVariableNames:'numFields fields'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMBinaryRow methodsFor:'accessing'!

fields
	^ fields
! !

!PSQLBMBinaryRow methodsFor:'private'!

creationArg: anInt
	numFields _ anInt
!

numBytesInBitMap
	| n |
	n _ numFields // 8.
	(numFields noMask: 7) ifTrue: [ n _ n + 1 ].
	^ n
!

readFrom: aSocket
	"Stores an ordered collection of strings and nil values (NULL database values)."
	| nullFlags size |
	nullFlags _ self readNullFlags: aSocket.
	fields _ nullFlags collect: [ :nullFlag |
		nullFlag ifTrue: [ "value is not NULL"
			size _ self readInt32From: aSocket.
			(self readBytesFrom: aSocket length: (size - 4))
		] ifFalse: [ "value is NULL"
			nil
		]
	].
"	fields _ OrderedCollection new.
	1 to: numFields do: [ :i |
		(nullFlags at: i) ifTrue:: [
			size _ self readInt32From: aSocket.
			fields add: (self readBytesFrom: aSocket length: (size - 4)).
		] ifFalse: [
			size _ 0.
			fields add: nil.
		].
	].
"
!

readNullFlags: aSocket
	"Returns a collection of Boolean values signifying if the corresponding field value is NULL or not. Reads bits, one for each fields, that signify if a field value is NULL or not."
	| map byteVal mask |
	map _ OrderedCollection new: numFields.
	mask _ 16r80.
	byteVal _ self readByteFrom: aSocket.
	1 to: numFields do: [ :i |
		map add: (byteVal allMask: mask).
		mask = 1 ifTrue: [
			mask _ 16r80.
			byteVal _ self readByteFrom: aSocket.
		] ifFalse: [
			mask _ mask >> 1.
		].
	].
	^ map
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMCursorResponse
	instanceVariableNames:'name'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMCursorResponse methodsFor:'accessing'!

name
	^ name
! !

!PSQLBMCursorResponse methodsFor:'parsing'!

readFrom: aSocket
	name _ self readStringFrom: aSocket
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMNotificationResponse
	instanceVariableNames:'processId conditionName'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMNotificationResponse methodsFor:'parsing'!

readFrom: aSocket
	processId _ self readInt32From: aSocket.
	conditionName _ self readStringFrom: aSocket
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMFunctionResponse
	instanceVariableNames:'data'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMFunctionResponse methodsFor:'parsing'!

readFrom: aSocket
	| type size |
	type _ self readCharacterFrom: aSocket.

	type = $G ifTrue: [
		size _ self readInt32From: aSocket.
		data _ self readBytesFrom: aSocket length: size.
		type _ self readCharacterFrom: aSocket. "ignore $0"
	].
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMEmptyQueryResponse
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMEmptyQueryResponse methodsFor:'parsing'!

readFrom: aSocket
	self readStringFrom: aSocket "ignore return; it's empty"
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMCopyOutResponse
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMCopyOutResponse methodsFor:'parsing'!

readFrom: aSocket
	self notYetImplemented
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBMBinaryRow subclass:#PSQLBMAsciiRow
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMAsciiRow methodsFor:'parsing'!

readFrom: aSocket
	super readFrom: aSocket.
	"Convert binary values (byte arrays) to strings."
	fields _ fields collect: [ :field | field asString ]
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMCompletedResponse
	instanceVariableNames:'tag'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMCompletedResponse methodsFor:'accessing'!

tag
	^ tag
! !

!PSQLBMCompletedResponse methodsFor:'parsing'!

readFrom: aSocket
	tag _ self readStringFrom: aSocket
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMBackendKeyData
	instanceVariableNames:'processId secretKey'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMBackendKeyData methodsFor:'accessing'!

processId
	^ processId
!

processId: value
	processId _ value
!

secretKey
	^ secretKey
!

secretKey: value
	secretKey _ value
! !

!PSQLBMBackendKeyData methodsFor:'parsing'!

readFrom: aSocket
	processId _ self readInt32From: aSocket.
	secretKey _ self readInt32From: aSocket
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMAuthentication
	instanceVariableNames:'authTypeSymbol salt'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMAuthentication methodsFor:'accessing'!

authTypeSymbol
	^ authTypeSymbol
!

salt
	^ salt
! !

!PSQLBMAuthentication methodsFor:'parsing'!

readFrom: aSocket
        | n |
        n _ self readInt32From: aSocket.

        n = 0 ifTrue: [ authTypeSymbol := #ok ].
        n = 1 ifTrue: [ authTypeSymbol := #kerberosV4 ].
        n = 2 ifTrue: [ authTypeSymbol := #kerberosV5 ].
        n = 3 ifTrue: [ authTypeSymbol := #unencryptedPassword ].
        n = 4 ifTrue: [ authTypeSymbol := #encryptedPassword.
                salt _ (self readBytesFrom: aSocket length: 2) asString
        ].
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMReadyForQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMReadyForQuery methodsFor:'parsing'!

readFrom: aSocket
	"Nothing to do."
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMNoticeResponse
	instanceVariableNames:'message'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMNoticeResponse methodsFor:'accessing'!

message
	^ message
! !

!PSQLBMNoticeResponse methodsFor:'parsing'!

readFrom: aSocket
	message _ self readStringFrom: aSocket
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMRowDescription
	instanceVariableNames:'fieldDescriptions'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMRowDescription methodsFor:'accessing'!

fieldDescriptions
	^ fieldDescriptions
! !

!PSQLBMRowDescription methodsFor:'parsing'!

readFrom: aSocket
	| numFields |

	fieldDescriptions _ OrderedCollection new.
	numFields _ self readInt16From: aSocket.
	numFields timesRepeat: [
		fieldDescriptions add:
			(PSQLFieldDescription name: (self readStringFrom: aSocket)
				oid: (self readInt32From: aSocket)
				size: (self readInt16From: aSocket)
				modifier: (self readInt32From: aSocket)).
	].
! !


'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:12'                     !

"{ Package: '__NoProject__' }"

PSQLBackendMessage subclass:#PSQLBMErrorResponse
	instanceVariableNames:'message'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Backend'
!

!PSQLBMErrorResponse methodsFor:'accessing'!

message
	^ message
! !

!PSQLBMErrorResponse methodsFor:'parsing'!

readFrom: aSocket
	message _ self readStringFrom: aSocket
! !


PSQLBackendMessage initialize!
