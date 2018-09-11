I made the choice to use Ruby in combination with the Airborne framework
(https://github.com/brooklynDev/airborne) to do this assignment. This
uses Rspec and other often used libraries. Ruby is the language I feel
most comfortable with.

Installation:

  Ruby is needed. I used the default version I had installed on my
  MacBook (ruby 2.3.3p222 (2016-11-21 revision 56859) [x86_64-darwin16]).
  
  I created a Gemfile which should install the needed dependencies.
  This is done with command:
  
  > bundle

Run the tests:

  Running the tests is done by calling Rspec. I like running it with the
  option -fd which shows a nice output.

  > rspec -fd github_gists.rb

Building process:

I started by having a look at the public gists to get started. Based on
that I created a schema of the output. That schema was built by hand and
can be much improved but I consider that a bit beyond the goal of this
assignment to make it bullit-proof. I kept the test code I created for
this part.

I then created a Github account and created a token to use. This meant
I could start creating my own gists. The documentation is clear and that
was not a big issue (I used the example gists and changed them where
needed). I did skip a number of calls, like revisions, starred and forking
because it was not mentioned as a goal of the assignment.

In the file containing the test code there is a constant $SHOW_INFO that
can be set to true to show some more output. The output starts with hashes
so that it will be seen as comments by tools like Jenkins. To change that
only the function at the top of the file has to be changed.

During the creation of a new gist I overlooked that I got the id of it
back. So I started keeping track of the last id by creating a list of ids
and using that to find out which one was new. Looking back that was a bit
silly: I could get the id from the return value. I kept what I had, but it
is easy to change this into what I should have used.