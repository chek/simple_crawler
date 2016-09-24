# Simple web crawler service

## To run this project you need.

  * Ruby 2.2.2

  * Rails 5

  * MySQL server
  
  * Change database name and credentials in config/database.yml

  * Create database tables using: rake db:schema:load
  *
  * Run from project dir
```ruby
bundle install
```

  * To run tests
```ruby
rails test
```
  
  * To run project
```ruby
rails s
```

## This sevice have 3 endpoints
  
  * POST /web_pages/register (url parameter required), to register and schedule parsing for a new web page
  
  * GET /web_pages/list, to get all registered web pages with parsed data
  
  * POST /web_pages/parse/:id (id parameter required), to schedule parsing for existing web pages
  
To test project use test.html and test.js in public folder. 
Change test.js for using any endpoint and request type. Open http://localhost:3000/test.html in browser, see console output.
