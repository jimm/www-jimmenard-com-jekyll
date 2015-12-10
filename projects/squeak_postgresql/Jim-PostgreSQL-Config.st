'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:35:18'                     !

"{ Package: '__NoProject__' }"

Object subclass:#PSQLConfiguration
	instanceVariableNames:''
	classVariableNames:'WhichSystem'
	poolDictionaries:''
	category:'Jim-PostgreSQL-Config'
!

!PSQLConfiguration class methodsFor:'configuring'!

initialize
    "Initial configuration of PostgreSQL Connector.

        Example: (Smalltalk/X)
        WhichSystem := #smalltalkx.

        Example: (Squeak)
        WhichSystem := #squeak.
    "
    
    WhichSystem := #smalltalkx.
!

isSmalltalkx
    "Returns which system do you have"
    
    ^ WhichSystem = #smalltalkx
!

isSqueak
    "Returns which system do you have"
    
    ^ WhichSystem = #squeak
! !


PSQLConfiguration initialize!
