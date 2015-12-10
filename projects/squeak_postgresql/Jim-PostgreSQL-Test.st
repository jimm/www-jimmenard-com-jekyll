'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:52:06'                     !

"{ Package: '__NoProject__' }"

TestCase subclass:#PSQLGenericTests
	instanceVariableNames:'connDb'
	classVariableNames:''
	poolDictionaries:''
	category:'Jim-PostgreSQL-Test'
!

!PSQLGenericTests class methodsFor:'documentation'!

documentation
"
    Please configure the connection arguments and the database
    structure in the PSQLTestConfiguration class.
"
!

history
    "Created: / 15-06-2005 / 18:27:19 / leonardo"
! !

!PSQLGenericTests methodsFor:'initialize / release'!

setUp
    "Connect to database"
    
    super setUp.
    connDb := (PSQLClient new)
                host:(PSQLTestConfiguration current hostname);
                port:(PSQLTestConfiguration current port);
                user:(PSQLTestConfiguration current user);
                database:(PSQLTestConfiguration current database).
    connDb establishConnection.
!

tearDown
    "Close connection."
    
    super tearDown.
    connDb 
        ifNotNil:[
            connDb closeConnection.
            connDb := nil.
        ].
! !

!PSQLGenericTests methodsFor:'testing'!

testALotOfInsertAndSomeDelete
        "Test with a lot of insert and a some delete"

        |cur i|

        "Delete"        
        cur:=connDb query:'delete from simpletable'.

        (1 to: 20) do:[ :number |
                connDb query:'insert into simpletable (id, name, surname)',
                                ' values (',number asString,',''a'',''b'')'.
        ].

        "Now the count must be 100 and the cursor must have one row"
        cur := connDb query:'select count(*) as c from simpletable'.

        i := 0.
        cur do:[:row | 
                i := i + 1.
                self assert:(row at:'c') = '20'.
        ].

        "Delete"        
        connDb query:'delete from simpletable'.
!

testConfiguration
    "Configuration must be Smalltalk/X or Squeak"

    self assert:(PSQLConfiguration isSqueak | PSQLConfiguration isSmalltalkx).
!

testCursor
    "Using declare cursor and fetch cursor"

    |cur fetched rowCount|

    "Begin transaction"
    connDb query:'begin'.

    "Delete rows"
    connDb query:'DELETE FROM simpletable'.

    "Insert some rows!!"
    (1 to: 20) do: [ :number |
        connDb query:'INSERT INTO simpletable (id, name, surname) VALUES (',number asString,
                ',''a'',''b'')'.
    ].

    "One cursor please"
    connDb query:'DECLARE aba CURSOR FOR SELECT * FROM simpletable'.

    "Count rows..."
    rowCount:=0.

    fetched:=true.
    [fetched] whileTrue:[
        fetched:=false.
        cur:=connDb query:'FETCH NEXT FROM aba'.
        cur do: [:row | rowCount:=rowCount+1. fetched:=true].
    ].

    "Close cursor"
    connDb query:'CLOSE aba'.

    "Delete"
    connDb query:'DELETE FROM simpletable'.

    self assert:rowCount=20.
!

testDoubleError
    "Test for double errors"

    |errore|

    "syntax error"
    errore:=nil.
    connDb query:'insert blablo intw simpletable (id, name, surname) values (1,''a'',''b'')'
    onError:[:msg | errore:=msg].
    self assert:errore notNil.

    "syntax error second manche"
    errore:=nil.
    connDb query:'insert blablo intw simpletable (id, name, surname) values (1,''a'',''b'')'
    onError:[:msg | errore:=msg].
    self assert:errore notNil.
!

testErrorOne
    "First test for onError"

    |errore|

    "Test onerror"

    "delete from table"
    connDb query:'delete from simpletable'.

    "insert a row"
    connDb query:'insert into simpletable (id, name, surname) values (1,''a'',''b'')'.

    "another row with a duplicate id... an error"
    errore:=nil.
    connDb query:'insert into simpletable (id, name, surname) values (1,''a'',''b'')'
        onError:[:msg | errore:=msg].
    self assert:errore notNil.
!

testErrorTwo
    "Test onError 2^ manche"

    |errore|

    "syntax error"
    errore:=nil.
    connDb query:'insert blablo intw simpletable (id, name, surname) values (1,''a'',''b'')'
    onError:[:msg | errore:=msg].
    self assert:errore notNil.
!

testInsertAndDelete
        "Some insert and delete"
    
        |cur i|

        "Simple delete"
        connDb query:'delete from simpletable'.

        "Insert a row"
        connDb query:'insert into simpletable (id, name, surname)' ,
                ' values (123,''leonardo'',''cecchi'')'.

        "Now the count must be 1 and the cursor must have one row"
        cur := connDb query:'select count(*) as c from simpletable'.

        i := 0.
        cur do:[:row | 
                i := i + 1.
                self assert:(row at:'c') = '1'.
        ].

        self assert:(i = 1).

        "Simple delete"
        connDb query:'delete from simpletable'.
!

testJimmExampleOne
        "PSQLClient example1"
        "Runs a query and displays the results. Cancels after
        the first row that returns an ID value > 10.

        To run with your database, change the database name
        and user name, add a password if necessary, and change
        the table name in the select statement."

        | cursor |

        "Delete rows"
        connDb query:'DELETE FROM simpletable'.

        "Insert some rows!!"
        (1 to: 20) do: [ :number |
                connDb query:'INSERT INTO simpletable (id, name, surname) VALUES (',number asString,
                        ',''a'',''b'')'.
        ].

        "Send the query. The cursor retrieves the field descriptions
        but does not retrieve the data until you enumerate over
        the returned rows."
        cursor _ connDb query: 'select * from simpletable'
                onError: [ :msg |
                        Transcript nextPutAll: msg; nextPut: Character cr.

                        PSQLConfiguration isSqueak ifTrue:[self inform: msg].
                        PSQLConfiguration isSmalltalkx ifTrue:[Dialog information: msg].
                        "Unknown smalltalk version?"
                        self halt.
                ]
                onNotice: nil.

        "Display field names and data. Display the first ten rows (ID 0-9)."
        cursor printTo: Transcript cancelWhen: [ :row | (row at: 'id') asInteger >= 10 ].

        "Delete rows"
        connDb query:'DELETE FROM simpletable'.
!

testJimmExampleTwo
        "PSQLClient example2"
        "Inserts a row, displays it, and deletes it."

        | cursor |

        "Send the query. The cursor retrieves the field descriptions
        but does not retrieve the data until you enumerate over
        the returned rows."
        cursor _ connDb query: 'insert into simpletable (id, name, surname) values (999, ''Office 999'', ''O999'')'.

        cursor _ connDb query: 'select * from simpletable where ID = 999'.
        cursor printTo: Transcript.

        cursor _ connDb query: 'delete from simpletable where ID = 999'.
!

testTwoCursors
    "Using two declare cursor and fetch cursor"

    |curOne curTwo fetchedOne fetchedTwo rowCount|

    "Begin transaction"
    connDb query:'begin'.

    "Delete rows"
    connDb query:'DELETE FROM simpletable'.

    "Insert some rows!!"
    (1 to: 20) do: [ :number |
        connDb query:'INSERT INTO simpletable (id, name, surname) VALUES (',number asString,
                ',''a'',''b'')'.
    ].

    "One cursor please"
    connDb query:'DECLARE aba CURSOR FOR SELECT * FROM simpletable'.

    "Count rows..."
    rowCount:=0.

    fetchedOne:=true.
    [fetchedOne] whileTrue:[
        fetchedOne:=false.
        curOne:=connDb query:'FETCH NEXT FROM aba'.
        curOne do: [:row | rowCount:=rowCount+1. fetchedOne:=true].

        fetchedOne ifTrue:[
                "The second cursor please"
                connDb query:'DECLARE bab CURSOR FOR SELECT * FROM simpletable'.
        
                fetchedTwo:=true.
                [fetchedTwo] whileTrue:[
                    fetchedTwo:=false.
                    curTwo:=connDb query:'FETCH NEXT FROM bab'.
                    curTwo do: [:row | rowCount:=rowCount+1. fetchedTwo:=true].
                ].

                "Close the second cursor"
                connDb query:'CLOSE bab'.
        ].
    ].

    "Close cursor"
    connDb query:'CLOSE aba'.

    "Delete rows"
    connDb query:'DELETE FROM simpletable'.

    self assert:rowCount=((20*20)+20).
! !

!PSQLGenericTests class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

'From Smalltalk/X, Version:5.2.6 on 16-06-2005 at 23:52:06'                     !

"{ Package: '__NoProject__' }"

Object subclass:#PSQLTestConfiguration
	instanceVariableNames:''
	classVariableNames:'Current'
	poolDictionaries:''
	category:'Jim-PostgreSQL-Test'
!

!PSQLTestConfiguration class methodsFor:'documentation'!

documentation
"
    You can configure the connection arguments in the 'configuring' protocol.
    You must use a test database with this table:

    create table simpletable (
        id integer not null primary key,
        name varchar(50),
        surname varchar(50)
    )


    [author:]
        Leonardo Cecchi (leonardoce@interfree.it)

    [instance variables:]
        connDb -> Database connection

    [class methods:]
        host -> Hostname
        port -> Port number
        database -> Test database name
        user -> Test database user
        password -> Test database password if needed

"
! !

!PSQLTestConfiguration class methodsFor:'instance creation'!

current
    "Returns the current instance"
    
    Current ifNil:[ Current := self basicNew. ].
    ^ Current
!

new
    "You should call current"
    
    self halt.
! !

!PSQLTestConfiguration methodsFor:'configuring'!

database
    "Name of the test database"
    
    ^ 'prova'
!

hostname
    "Hostname to connect into postgres"
    
    ^ 'localhost'
!

password
    "Password for database connection"
    
    ^ ''
!

port
    "Port name to connect into postgres"
    
    ^ 5432
!

user
    "user name to login into postgres"
    
    ^ 'postgres'
! !


