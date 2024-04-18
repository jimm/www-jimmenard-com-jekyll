---
layout: post
title: Scala Baby-Steps
tags: database programming scala java
---

I'm starting to learn [Scala](http://scala.epfl.ch/). It's a statically- and
strongly-typed functional language that compiles to Java byte code and
integrates well with Java.

One of the things I'm struggling with is the language's strong static
typing. Scala is nice in that it tries very hard to infer types. That means
the programmer doesn't spend much time typing "wasteful" type declarations.
If Scala didn't have that, I would have run away screaming already.

I've figured out how to connect to a MySQL database. There are a few
database access methods that are being developed in Scala. The one that
ships with the language is called "dbc". It comes with a PostgreSQL
connection interface but no MySQL version. Here's my MySQL version along
with some simple code that performs a select. (I'd move the connection
information into a properties file if I were to really use this code.)

{% highlight scala %}
import scala.dbc._
import scala.dbc.Syntax._
import scala.dbc.syntax.Statement._
import java.net.URI

object MysqlVendor extends Vendor {
  val uri = new URI("jdbc:mysql://localhost:3306/my_database_name")
  val user = "my_database_user"
  val pass = "my_database_password"
    
  val retainedConnections = 5
  val nativeDriverClass = Class.forName("com.mysql.jdbc.Driver")
  val urlProtocolString = "jdbc:mysql:"
}

object BulkUploadRunner extends Application {
  val db = new Database(MysqlVendor)

  val rows = db.executeStatement {
    select fields ("email_id" of characterVarying(32)) from ("bulk_uploads")
  }
  for (val r <- rows;
       val f <- r.fields) {
    Console.println(f.content.nativeValue) // or .sqlValue
  }

  db.close
}
{% endhighlight %}
