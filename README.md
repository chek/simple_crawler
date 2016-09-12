# Simple web crawler service

## To run this project you need.

  * Install or have installed Ruby version 2.2.2

  * Install or have installed Rails 5

  * Install or have installed MySQL server

  * Change database name and credentials in config/database.yml

  * Create db tables using: rake db:schema:load

  * To run tests -> rails test
  
  * To run project -> rails s

## This sevice have 3 endpoints
  
  * POST /web_pages/register (url parameter required), to register and schedule parsing for a new web page
  
  * GET /web_pages/list, to get all registered web pages
  
  * GET /web_pages/parse (url or id parameter required), to schedule parsing for existing web pages
  
To test project use test.html and test.js in public folder. 
Change test.js for using any endpoint and request type. Open http://localhost:3000/test.html in browser, see console output.
