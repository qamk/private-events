# Private Events
This project was primarily about building on my knowledge on Associations and Querying using Active Record by creating an events listing site.
A live version is available on Heroku (may take a little while to start). The default user is "user" with a password of "userpassword".
Developed and deployed with PostGreSQL, made with Ruby 3.0.1 (see the `Gemfile` for the bundled gems) and styled using **bulma**.

## Main Task
The mains tasks were:
- [x] Allow a signed-in user to create many events
  - Any user with an "account" should be able to be an event host
- [x] Allow a signed-in user to send  many invitations for their events
  - The event host should be able to send invites to other users
- [x] Allow a signed-in user to receive many invitations for many events
  - A user can receive one invitation per event, for any number of events
- [x] Have the Events Index page separate upcoming and past events
- [x] Make sufficient use of querying and associations with active record 

## Personal Tasks
This project was useful for exploring other things such as:
- Pagination
- Nested routing
  - Shallow nested routing in this case
- Effective use of Singular Resources

This was also useful for practising the use of custom helper methods and class methods or "scopes". It was cool to use helper methods to render appropriate views based on what authorization the user had (e.g. editing an invite for an event creator is different to "editing" an invite for an invitee). Finally, reading about related web development and CS topics (e.g. lazy evaluation and eager loading). Naturally, the bulk of my time was spent on styling using **Bulma**, which was both fun and frustrating. I highly recommended using **Emmett** to speed up the creation of elements!

## Resources
I highly recommend using the documentation as a reference, but there are other notable resources that may be otherwise useful:
- Validating the uniqueness of two columns:
  - https://stackoverflow.com/questions/34424154/rails-validate-uniqueness-of-two-columns-together
- Understanding (Rails) associations
  - https://www.sitepoint.com/brush-up-your-knowledge-of-rails-associations/
- Benefits and disadvantages of (Rails) polymorphic relationships
  - https://stackoverflow.com/questions/1799099/advantages-and-disadvantages-of-ruby-on-rails-polymorphic-relationships
  - Understanding polymorphic relationships generally (links to implementation in Laravel, which is very useful)
    - https://devdojo.com/tnylea/understanding-polymorphic-relationships
- Using `helper_method` to give the view access to a Controller's method
  - https://stackoverflow.com/questions/8906527/can-we-call-a-controllers-method-from-a-view-as-we-call-from-helper-ideally
- Implementing pagination in Rails
  - https://www.youtube.com/watch?v=ickfSasKfts
- On Lazy Evaluation
  - https://stackoverflow.com/questions/20535342/lazy-evaluation-in-python
  - https://medium.com/background-thread/what-is-lazy-evaluation-programming-word-of-the-day-8a6f4410053f
