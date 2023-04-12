# Installing dependencies

- install bundler
- run bundle install

# How to convert currencies

 Run app with
 `ruby app.rb <FROM_CURRENCY> <TO_CURRENCY> <AMOUNT>`

 for example, convert 215.8 USD to PLN
 `ruby app.rb USD PLN 215.8`

 result:
 ```
 converted amount: 923.5029362 PLN
 ```

 # Tests

 `bundle exec rspec`

 # TODO

- add cache on exchange repo based on the `time_next_update_utc` property in the response
- add support for Free / Pro Exchange Rate API
- imporve CLI
