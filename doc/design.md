# Semantic web for BioRuby!

In this document we describe using a triple store for bioinformatics.
While the semantic is still, some what, vapourware in biology, the
ideas and tools can be very useful for reasoning about relationships
between genes, pathways, enrichment etc. In this library we aim to use
a local triple store, feed it with information, query it using
[SPARQL](http://en.wikipedia.org/wiki/SPARQL), and provide it with a
nice user interface for biologists. Triples may link-out to other
semantic web connections.

Enjoy,

Pjotr Prins

## Installing the triple store

There are many triple stores now. Here we use the free [4store](http://4store.org/) server
as an example, but alternatives should work fine - RDF and SPARQL
should not care about underlying storage. Install 4store, on
Debian/Mint/Ubuntu:

```sh
  apt-get install 4-store
```

Create a storage container (as root)

```sh
  4s-backend-setup mouse
```

by default the storage is in /var/lib/4store/mouse. Start the backend
and webserver

```sh
  4s-backend mouse
  4s-httpd -p 8000 mouse
```

You should be able to open URL http://localhost:8000/status/.

## Loading the triple store

Following this [http://www.jenitennison.com/blog/node/152 howto] we
use the Ruby rest-client to access 4store.

As this is a Mouse store, we fetch Mouse Genome Informatics info from
Bio-RDF (a 19 Mb file):

  wget http://s4.semanticscience.org/bio2rdf_download/mgi/mgi.n3.gz

(a copy resides at
http://bio4.dnsalias.net/download/semweb/mgi.n3.gz) and load it into
4store 

  ./rdfcat -in N3 -out RDF/XML -n mgi.n3 > mgi.rdf

For this example we need a tool from [jena](http://jena.apache.org/) to convert N3 to
RDF/XML. Note: Jena is written in Java, also comes with an excellent
triple store. Unfortunately there were some bad URIs in the file,
most fixed with vim:

  %s/\(uniprot:[^>]\+\) /\1_/g

You can find the fixed file at
http://bio4.dnsalias.net/download/semweb/mgi.rdf.gz. After fetching
import into 4store

  curl -T mgi.rdf 'http://localhost:8000/data/mgi'
    201 imported successfully
    This is a 4store SPARQL server v1.1.4




## Querying the triple store

## User interface
