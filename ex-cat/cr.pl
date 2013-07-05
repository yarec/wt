#!/usr/bin/perl

&ptfile("db.sql",&sql);

$appname = 'MyApp';
system "catalyst.pl $appname" and die $!;
system "$appname/script/myapp_create.pl controller Books";
system "$appname/script/myapp_create.pl view HTML TT";
system "mkdir -p MyApp/root/src/books";
system "mkdir -p MyApp/root/static/css";
system "sqlite3 myapp.db < db.sql";
system 'MyApp/script/myapp_create.pl model DB DBIC::Schema MyApp::Schema create=static components=TimeStamp dbi:SQLite:myapp.db on_connect_do="PRAGMA foreign_keys = ON"';
#system "$appname/script/myapp_create.pl model DB DBIC::Schema MyApp::Schema  create=static components=TimeStamp dbi:mysql:test root 123456";

&ptfile ("MyApp/lib/MyApp/Controller/Books.pm", &books_pm);
&ptfile ("MyApp/lib/MyApp/Schema/Result/Book.pm", &book_m);
&ptfile ("MyApp/lib/MyApp/View/HTML.pm", &html_pm);
&ptfile ("MyApp/root/src/books/list.tt2", &list_tt);
&ptfile ("MyApp/root/src/books/create_done.tt2", &create_done_tt2);
&ptfile ("MyApp/root/src/books/form_create.tt2", &form_create_tt2);
&ptfile ("MyApp/root/src/wrapper.tt2", &wrapper_tt);
&ptfile ("MyApp/root/static/css/main.css", &main_css);

sub ptfile(){
    my ($file,$content) = @_;
    open (MYFILE, ">$file");
    print MYFILE $content;
    close (MYFILE);
}

sub books_pm(){
    return q^
package MyApp::Controller::Books;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

    sub index :Path :Args(0) {
        my ( $self, $c ) = @_;

        $c->response->body('Matched MyApp::Controller::Books in Books.');
    }

    sub list :Local {
        my ($self, $c) = @_;
        $c->stash(books => [$c->model('DB::Book')->all]); 
        $c->stash(template => 'books/list.tt2');
    }

    sub base :Chained('/') :PathPart('books') :CaptureArgs(0) {
        my ($self, $c) = @_;

        # Store the ResultSet in stash so it's available for other methods
        $c->stash(resultset => $c->model('DB::Book'));

        # Print a message to the debug log
        $c->log->debug('*** INSIDE BASE METHOD ***');
    }

    sub url_create :Chained('base') :PathPart('url_create') :Args(3) {
            my ($self, $c, $title, $rating, $author_id) = @_;
        
            my $book = $c->model('DB::Book')->create({
                    title  => $title,
                    rating => $rating
                });
        
            $book->add_to_book_authors({author_id => $author_id});
            # Note: Above is a shortcut for this:
            # $book->create_related('book_authors', {author_id => $author_id});
        
            $c->stash(book     => $book,
                      template => 'books/create_done.tt2');
    }

    sub form_create :Chained('base') :PathPart('form_create') :Args(0) {
        my ($self, $c) = @_;

        # Set the TT template to use
        $c->stash(template => 'books/form_create.tt2');
    }

    sub form_create_do :Chained('base') :PathPart('form_create_do') :Args(0) {
        my ($self, $c) = @_;

        # Retrieve the values from the form
        my $title     = $c->request->params->{title}     || 'N/A';
        my $rating    = $c->request->params->{rating}    || 'N/A';
        my $author_id = $c->request->params->{author_id} || '1';

        # Create the book
        my $book = $c->model('DB::Book')->create({
                title   => $title,
                rating  => $rating,
            });
        # Handle relationship with author
        $book->add_to_book_authors({author_id => $author_id});
        # Note: Above is a shortcut for this:
        # $book->create_related('book_authors', {author_id => $author_id});

        # Avoid Data::Dumper issue mentioned earlier
        # You can probably omit this
        $Data::Dumper::Useperl = 1;

        # Store new model object in stash and set template
        $c->stash(book     => $book,
                  template => 'books/create_done.tt2');
    }

    sub object :Chained('base') :PathPart('id') :CaptureArgs(1) {
        # $id = primary key of book to delete
        my ($self, $c, $id) = @_;

        # Find the book object and store it in the stash
        $c->stash(object => $c->stash->{resultset}->find($id));

        # Make sure the lookup was successful.  You would probably
        # want to do something like this in a real app:
        #   $c->detach('/error_404') if !$c->stash->{object};
        die "Book $id not found!" if !$c->stash->{object};

        # Print a message to the debug log
        $c->log->debug("*** INSIDE OBJECT METHOD for obj id=$id ***");
    }

    sub delete :Chained('object') :PathPart('delete') :Args(0) {
        my ($self, $c) = @_;
    
        # Use the book object saved by 'object' and delete it along
        # with related 'book_author' entries
        $c->stash->{object}->delete;
    
        # Set a status message to be displayed at the top of the view
        $c->stash->{status_msg} = "Book deleted.";
    
        # Forward to the list action/method in this controller
        #$c->forward('list');
         $c->response->redirect($c->uri_for($self->action_for('list'),
            {status_msg => "Book deleted."}));
    }

#    sub list_recent :Chained('base') :PathPart('list_recent') :Args(1) {
#        my ($self, $c, $mins) = @_;
#    
#        # Retrieve all of the book records as book model objects and store in the
#        # stash where they can be accessed by the TT template, but only
#        # retrieve books created within the last $min number of minutes
#        $c->stash(books => [$c->model('DB::Book')
#                                ->created_after(DateTime->now->subtract(minutes => $mins))]);
#    
#        # Set the TT template to use.  You will almost always want to do this
#        # in your action methods (action methods respond to user input in
#        # your controllers).
#        $c->stash(template => 'books/list.tt2');
#    }

__PACKAGE__->meta->make_immutable;

1;
^
}

sub book_m(){
    return q|
package MyApp::Schema::Result::Book;

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");


__PACKAGE__->table("book");


__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "created",
  { data_type => "timestamp", is_nullable => 1 },
  "updated",
  { data_type => "timestamp", is_nullable => 1 },
  "rating",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


__PACKAGE__->has_many(
  "book_authors",
  "MyApp::Schema::Result::BookAuthor",
  { "foreign.book_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

__PACKAGE__->many_to_many(authors => 'book_authors', 'author');

#    sub list_recent :Chained('base') :PathPart('list_recent') :Args(1) {
#        my ($self, $c, $mins) = @_;
#    
#        # Retrieve all of the book records as book model objects and store in the
#        # stash where they can be accessed by the TT template, but only
#        # retrieve books created within the last $min number of minutes
#        $c->stash(books => [$c->model('DB::Book')
#                                ->created_after(DateTime->now->subtract(minutes => $mins))]);
#    
#        # Set the TT template to use.  You will almost always want to do this
#        # in your action methods (action methods respond to user input in
#        # your controllers).
#        $c->stash(template => 'books/list.tt2');
#    }

__PACKAGE__->meta->make_immutable;
1;
|;
}


sub html_pm(){
    return << "EOF";
package MyApp::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    INCLUDE_PATH => [
        MyApp->path_to( 'root', 'src' ),
    ],
    # Set to 1 for detailed timer stats in your HTML as comments
    TIMER              => 0,
    # This is your wrapper template located in the 'root/src'
    WRAPPER => 'wrapper.tt2',
);
EOF
}

sub list_tt(){
    return << "EOF";
    [% # This is a TT comment.  The '-' at the end "chomps" the newline.  You won't -%]
    [% # see this "chomping" in your browser because HTML ignores blank lines, but  -%]
    [% # it WILL eliminate a blank line if you view the HTML source.  It's purely   -%]
    [%- # optional, but both the beginning and the ending TT tags support chomping. -%]
    
    [% # Provide a title -%]
    [% META title = 'Book List' -%]
    
    <table>
    <tr><th>Title</th><th>Rating</th><th>Author(s)</th><th>Links</th></tr>
    [% # Display each book in a table row %]
    [% FOREACH book IN books -%]
      <tr>
        <td>[% book.title %]</td>
        <td>[% book.rating %]</td>
        <td>
          [% # NOTE: See "Exploring The Power of DBIC" for a better way to do this!  -%]
          [% # First initialize a TT variable to hold a list.  Then use a TT FOREACH -%]
          [% # loop in 'side effect notation' to load just the last names of the     -%]
          [% # authors into the list. Note that the 'push' TT vmethod doesn't return -%]
          [% # a value, so nothing will be printed here.  But, if you have something -%]
          [% # in TT that does return a value and you don't want it printed, you can -%]
          [% # 1) assign it to a bogus value, or                                     -%]
          [% # 2) use the CALL keyword to call it and discard the return value.      -%]
          [% tt_authors = [ ];
             tt_authors.push(author.last_name) FOREACH author = book.authors %]
          [% # Now use a TT 'virtual method' to display the author count in parens   -%]
          [% # Note the use of the TT filter "| html" to escape dangerous characters -%]
          ([% tt_authors.size | html %])
          [% # Use another TT vmethod to join & print the names & comma separators   -%]
          [% tt_authors.join(', ') | html %]
        </td>
        <td>
          [% # Add a link to delete a book %]
          <a href="[% c.uri_for(c.controller.action_for('delete'), [book.id]) %]">Delete</a>
        </td>
      </tr>
    [% END -%]
    </table>
EOF
}

sub create_done_tt2(){
    return << "EOF";
    [% # Use the TT Dumper plugin to Data::Dumper variables to the browser   -%]
    [% # Not a good idea for production use, though. :-)  'Indent=1' is      -%]
    [% # optional, but prevents "massive indenting" of deeply nested objects -%]
    [% USE Dumper(Indent=1) -%]
    
    [% # Set the page title.  META can 'go back' and set values in templates -%]
    [% # that have been processed 'before' this template (here it's for      -%]
    [% # root/lib/site/html and root/lib/site/header).  Note that META only  -%]
    [% # works on simple/static strings (i.e. there is no variable           -%]
    [% # interpolation).                                                     -%]
    [% META title = 'Book Created' %]
    
    [% # Output information about the record that was added.  First title.   -%]
    <p>Added book '[% book.title %]'
    
    [% # Output the last name of the first author.                           -%]
    by '[% book.authors.first.last_name %]'
    
    [% # Output the rating for the book that was added -%]
    with a rating of [% book.rating %].</p>
    
    [% # Provide a link back to the list page                                    -%]
    [% # 'uri_for()' builds a full URI; e.g., 'http://localhost:3000/books/list' -%]
    <p><a href="[% c.uri_for('/books/list') %]">Return to list</a></p>
    
    [% # Try out the TT Dumper (for development only!) -%]
    <pre>
    Dump of the 'book' variable:
    [% Dumper.dump(book) %]
    </pre>
EOF
}

sub form_create_tt2(){
    return << "EOF";
    [% META title = 'Manual Form Book Create' -%]
    
    <form method="post" action="[% c.uri_for('form_create_do') %]">
    <table>
      <tr><td>Title:</td><td><input type="text" name="title"></td></tr>
      <tr><td>Rating:</td><td><input type="text" name="rating"></td></tr>
      <tr><td>Author ID:</td><td><input type="text" name="author_id"></td></tr>
    </table>
    <input type="submit" name="Submit" value="Submit">
    </form>
EOF
}


sub wrapper_tt(){
    return << "EOF";
 <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
    <title>[% template.title or "My Catalyst App!" %]</title>
    <link rel="stylesheet" href="[% c.uri_for('/static/css/main.css') %]" />
    </head>
    
    <body>
    <div id="outer">
    <div id="header">
        [%# Your logo could go here -%]
        <img src="[% c.uri_for('/static/images/btn_88x31_powered.png') %]" />
        [%# Insert the page title -%]
        <h1>[% template.title or site.title %]</h1>
    </div>
    
    <div id="bodyblock">
    <div id="menu">
        Navigation:
        <ul>
            <li><a href="[% c.uri_for('/books/list') %]">Home</a></li>
            <li><a href="[% c.uri_for('/') %]" title="Catalyst Welcome Page">Welcome</a></li>
            <li><a href="http://localhost:3000/books/url_create/TCPIP_Illustrated_Vol-2/5/4" title="url_create">url_create ex</a></li>
        </ul>
    </div><!-- end menu -->
    
    <div id="content">
        [%# Status and error messages %]
        <span class="message">[% status_msg || c.request.params.status_msg %]</span>
        <span class="error">[% error_msg %]</span>
        [%# This is where TT will stick all of your template's contents. -%]
        [% content %]
    </div><!-- end content -->
    </div><!-- end bodyblock -->
    
    <div id="footer">Copyright (c) your name goes here</div>
    </div><!-- end outer -->
    
    </body>
    </html>    
EOF
}

sub main_css(){
    return << "EOF";
    #header {
        text-align: center;
    }
    #header h1 {
        margin: 0;
    }
    #header img {
        float: right;
    }
    #footer {
        text-align: center;
        font-style: italic;
        padding-top: 20px;
    }
    #menu {
        font-weight: bold;
        background-color: #ddd;
    }
    #menu ul {
        list-style: none;
        float: left;
        margin: 0;
        padding: 0 0 50% 5px;
        font-weight: normal;
        background-color: #ddd;
        width: 100px;
    }
    #content {
        margin-left: 120px;
    }
    .message {
        color: #390;
    }
    .error {
        color: #f00;
    }    
EOF
}

sub sql(){

return qq|
 --
 -- Create a very simple database to hold book and author information
 --
 PRAGMA foreign_keys = ON;
 CREATE TABLE book (
 id INTEGER PRIMARY KEY,
 title TEXT ,
 created TIMESTAMP,
 updated TIMESTAMP,
 rating INTEGER
 );
 -- 'book_author' is a many-to-many join table between books & authors
 CREATE TABLE book_author (
 book_id INTEGER REFERENCES book(id) ON DELETE CASCADE ON UPDATE CASCADE,
 author_id INTEGER REFERENCES author(id) ON DELETE CASCADE ON UPDATE CASCADE,
 PRIMARY KEY (book_id, author_id)
 );
 CREATE TABLE author (
 id INTEGER PRIMARY KEY,
 first_name TEXT,
 last_name TEXT
 );
 ---
 --- Load some sample data
 ---
 INSERT INTO book(id,title,rating) VALUES (1, 'CCSP SNRS Exam Certification Guide', 5);
 INSERT INTO book(id,title,rating) VALUES (2, 'TCP/IP Illustrated, Volume 1', 5);
 INSERT INTO book(id,title,rating) VALUES (3, 'Internetworking with TCP/IP Vol.1', 4);
 INSERT INTO book(id,title,rating) VALUES (4, 'Perl Cookbook', 5);
 INSERT INTO book(id,title,rating) VALUES (5, 'Designing with Web Standards', 5);
 INSERT INTO author VALUES (1, 'Greg', 'Bastien');
 INSERT INTO author VALUES (2, 'Sara', 'Nasseh');
 INSERT INTO author VALUES (3, 'Christian', 'Degu');
 INSERT INTO author VALUES (4, 'Richard', 'Stevens');
 INSERT INTO author VALUES (5, 'Douglas', 'Comer');
 INSERT INTO author VALUES (6, 'Tom', 'Christiansen');
 INSERT INTO author VALUES (7, 'Nathan', 'Torkington');
 INSERT INTO author VALUES (8, 'Jeffrey', 'Zeldman');
 INSERT INTO book_author VALUES (1, 1);
 INSERT INTO book_author VALUES (1, 2);
 INSERT INTO book_author VALUES (1, 3);
 INSERT INTO book_author VALUES (2, 4);
 INSERT INTO book_author VALUES (3, 5);
 INSERT INTO book_author VALUES (4, 6);
 INSERT INTO book_author VALUES (4, 7);
 INSERT INTO book_author VALUES (5, 8);
 |
}
