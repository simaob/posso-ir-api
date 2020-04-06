![Posso Ir? Logo](https://raw.github.com/simaob/posso-ir-api/master/posso-ir.png =100x)

# README - Posso Ir API [![Build Status](https://travis-ci.org/simaob/posso-ir-api.svg?branch=master)](https://travis-ci.org/simaob/posso-ir-api)


## Intro

This tool is part of the [Posso Ir?](https://www.posso-ir.com) application.
In this project we have the backoffice, data importing scripts and the API
that powers the mobile applications.

__Posso Ir?__ is an application that we started building when the
[Coronavirus Pandemic](https://en.wikipedia.org/wiki/2019%E2%80%9320_coronavirus_pandemic)
started hitting Portugal. The goal of the application is to rally the power of
the people to report on the sizes of queues outsied of essential stores and services
like Supermarkets, Pharmacies, Post Office, Banks, etc. In a time of recommended
social distancing we want to help people decide when is the best time to buy the
things they need, and where to go.

Everyone using the application is invited to contribute with info about the shops
they visit. So that we can all help each other in this time of need and uncertainty.

__Posso Ir?__ is part of the [Tech4Covid19 Movement](https://tech4covid19.org/).


# Contributing and Using this

If you would like to contribute or try to use this tool on your own country, feel
free to reach out to us or to just clone the tool and have a go at it!

## Dependencies

- Ruby on Rails 6.0.2;
- Ruby 2.6.3;
- PostgreSQL 12;
- PostGIS;
- Node 10.15.2;

## Setting up the project locally

1. Clone the repository;
2. Install dependencies: `bundle install` and `yarn install`
3. Create and migrate database: `rails db:create db:migrate`
4. Start the server with `rails server`
5. Open your browser and visit `http://localhost:3000` and ta-da!

## Running the API

If you want to have a go at the API you'll need to setup a JWT_TOKEN in
your `.env` file, check the `.env.sample` file;

We are using JWT for authentication on the API access. Tokenizing and
decoding tokens is handled by `app/services/jwt_service.rb`.

Check the rails routes for the available API routes.


## Importing Data

Data importing is a bit random at the time as we are using data from different
providers in different formats, if you want some samples, message us!
Otherwise just use the web interface to create your own stores.

# Contributors

This tool is being built by the following people, who are part of the larger
__Posso Ir?__ team.

* Miguel Torres
* Rodrigo Solís
* Tiago Santos
* Simão Belchior
