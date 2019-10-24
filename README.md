# AVR Code Challenge - Recipe API

Foobar is a Python library for dealing with word pluralization.

## Installation

Make sure you are running Ruby 2.6.3, from command line run the following commands:

```
bundle install
```
```
bundle exec rake db:setup
```

This will seed a default user into the database with the following credentials:

`email: admin@test.com`

`password: password1234`

To start the server

```
bundle exec rails s
```

## Usage

To create a new user, you will first need to obtain a JWT token using the default admin account.

To do this, make a `POST` request to the `/login` endpoint with the user credentials supplied above from the seed file.

This will return back a bearer token that can be added to the header of subsequent requests, however, it expires after 24 hours (1 day).

## Token authentication with endpoints

The ONLY endpoint that does not require token authentication is the `login` endpoint, all other endpoints will reject your request if you do not have the bearer token.

## License
[MIT](https://choosealicense.com/licenses/mit/)
