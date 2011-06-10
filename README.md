README
==

This is a solution for the posted problem in the
Ruby on Rails Software engineer job posting for 
@Square.

Clone this repository and run the following commands:

    $ bundle install
    $ bundle exec rake db:migrate 
    $ bundle exec rake db:test:load
    
There are functional and unit tests. The functional
tests aren't very exciting. Just confirming that the
app does what it's supposed to do, download, parse, and
store data. 

Run the functional test with this command:

    $ bundle exec ruby -Itest test/functional/home_controller_test.rb

Run the unit tests with these commands:

    $ bundle exec ruby -Itest test/unit/ach_test.rb
    $ bundle exec ruby -Itest test/unit/institution_test.rb