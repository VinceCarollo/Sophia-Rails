<h1 align="center">SOPHIA</h1>

<h3 align="center">Speech Operated Personal Household Interactive Assistant</h3>


## Table of Contents
* [Description](#Description)
* [Technologies Used](#Technologies-Used)
* [Learning Goals](#Learning-Goals)
* [How To Use](#How-To-Use)
* [Endpoints](#Endpoints)
* [Database Schema](#Database-Schema)
* [Challenges](#Challenges)
* [Successes](#Successes)
* [Extensions](#Extensions)
* [Developers](#Developers)
* [Frontend Repo](#Frontend-Repo)
* [Production](#Production)

## Description

SOPHIA is a speech operated personal household interactive assistant. This app is built for two audiences: Clients and Caretakers. Clients are anyone with a disability (physical, cognitive, long-term, temporary) who needs care. Caretakers include anyone who is willing to help take care of clients. Taking care could include running errands, cleaning, yardwork, paying bills, grocery shopping, etc. SOPHIA was built to connect clients to caretakers to help meet their daily needs.

Please reference the user stories to understand the full functionality of SOPHIA.

SOPHIA is an A11Y app with a large focus on accessibility.

## Technologies Used
  - [Ruby](https://ruby-doc.org/)
  - [Ruby On Rails](https://guides.rubyonrails.org/)
  - [PostgreSQL](https://www.postgresql.org/)
  - [RSpec-Rails](https://github.com/rspec/rspec-rails)
  - [Travis CI](https://travis-ci.org)  [![Build Status](https://travis-ci.org/n-flint/Sophia-Rails.svg?branch=master)](https://travis-ci.org/n-flint/Sophia-Rails)
  - [Docker](https://www.docker.com)
  - [FFmpeg](https://ffmpeg.org/)

## Learning Goals

This is a unique opportunity that presents some valuable goals:

* Ultimately, demonstrate knowledge you’ve gained throughout Turing
* Use an agile process to turn well defined requirements into deployed and production ready software
* Gain experience dividing applications into components and domains of responsibilities to facilitate multi-developer teams.
* Service oriented architecture concepts and patterns are highly encouraged.
* Explore and implement new concepts, patterns, or libraries that have not been explicitly taught while at Turing
* Practice an advanced, professional git workflow (see whole-team expectations)
* Gain more experience using continuous integration tools to build and automate the deployment of features in various environments
* Build applications that execute in development, test, CI, and production environments
* Focus on communication between front-end and back-end teams in order to complete and deploy features that have been outlined by the project spec

## Setup
1. Clone this repository
```
cd Sophia-Rails
bundle install
rails db:create
rails db:migrate
rails db:seed
rails server
```
2. Navigate to http://localhost:3000

## Docker Setup
1. Clone this repository
2. Make sure docker is running

```
cd Sophia-Rails
git checkout dockerize
docker-compose build
docker-compose run web rails db:{create,migrate,seed}
docker-compose up
```

3. Navigate to http://localhost:3000

### Testing
Testing Requests:

```
bundle exec rspec spec/requests
```

Testing Google Text to Speech:

*Google Speech api will look for an Environment Variable called GOOGLE_APPLICATION_CREDENTIALS that points to the path of key.json assigned by google. More info can be found [here](https://cloud.google.com/speech-to-text/docs/quickstart-client-libraries) in the 'Before you begin' section.*

```
bundle exec rspec spec/services
```

Testing Models:

```
bundle exec rspec spec/models
```

## Endpoints

### Client Endpoints
- [Single Client](#single-client)
  - [Show](#client-profile)
  - [Create](#client-creation)
  - [Update](#client-update)
  - [Delete](#client-deletion)
### Caretaker Endpoints
- [Single Caretaker](#single-caretaker)
  - [Show](#caretaker-profile)
  - [Create](#caretaker-creation)
  - [Update](#caretaker-update)
  - [Delete](#caretaker-deletion)

### Lists
- [Index](#lists-index)
- [Show](#lists-show)
- [Create](#lists-create)
- [Update](#lists-update)
- [Delete](#lists-delete)
### Tasks
- [Index](#tasks-index)
- [Show](#tasks-show)
- [Create](#tasks-create)
- [Update](#tasks-update)
- [Delete](#tasks-delete)

### Login
- [Login](#login)
### Speech to Text
- [Speech to Text](#speech-to-text)

---

# Client Endpoints

## Single Client

### Client Profile:
Send a GET request to receive all information related to a single client

  #### GET /api/v1/clients/:id
   *if a client does not have diet_restrictions, needs, allergies, or medications, these attributes do not show. The client below has no 'allergies' associated*
  ```
  Content-Type: application/json
  Accept: application/json
  ```

  ##### Successful Response
  ```json
  {
    "id": "1",
    "username": "katierulz",
    "name": "Katie",
    "street_address": "123 Test St",
    "city": "Denver",
    "state": "CO",
    "zip": "12345",
    "email": "katierulz@gmail.com",
    "phone_number": "1235551234",
    "needs": ["groceries", "bills"],
    "medications": ["drug_1", "drug_2"],
    "diet_restrictions": ["vegetarian", "peanut-free"],
    "role": "client",
    "created_at": "DateTime",
    "updated_at": "DateTime"
  }
  ```
  ##### Unsuccessful Response
  A valid client ID must be provided or a 404 status code (page not found) will be returned.


### Client Creation:
Send a POST request to create a client

  #### POST /api/v1/clients/

  ##### headers:
  ```
  Content-Type: application/json
  Accept: application/json
  ```

#### body:
 *MUST have password AND password confirmation and they must match*
```json
{
    "username": "string-required",
    "name": "string-required",
    "password": "password",
    "password_confirmation": "password",
    "street_address": "string-required",
    "city": "string-required",
    "state": "string-required",
    "zip": "string-required",
    "email": "string-required",
    "phone_number": "string-required",
    "needs": ["array"],
    "allergies": ["array"],
    "medications": ["array"],
    "diet_restrictions": ["array"],
    "role": "client"
}
```

  ##### Successful Response
  ```json
  {
    "id": "1",
    "username": "katierulz",
    "name": "Katie",
    "street_address": "123 Test St",
    "city": "Denver",
    "state": "CO",
    "zip": "12345",
    "email": "katierulz@gmail.com",
    "phone_number": "1235551234",
    "needs": ["groceries", "bills"],
    "allergies": ["pollen", "peanuts"],
    "medications": ["drug_1", "drug_2"],
    "diet_restrictions": ["vegetarian", "peanut-free"],
    "role": "client",
    "created_at": "DateTime",
    "updated_at": "DateTime"
  }
  ```
  #### Unsuccessful Responses:
  ##### Email Taken:
  ```json
  {
    "email": ["has already been taken"]
  }
  ```

  ##### Empty state:
  ```json
  {
    "state": ["can't be blank"]
  }
  ```

  ##### Unmatching Password:
  ```json
  {
    "password_confirmation": ["does not match password"]
  }
  ```

### Client Update
Send a PATCH request to update a clients profile

  #### PATCH /api/v1/clients/:id

  #### Headers:
  ```
  Content-Type: application/json
  Accept: application/json
  ```

  #### Body:
  ```json
{
  "email": "vincecarollo@gmail.com"
}

  ```

  ##### Successful Response
  ```json
  {
    "id": "1",
    "username": "katierulz",
    "name": "Katie",
    "street_address": "123 Test St",
    "city": "Denver",
    "state": "CO",
    "zip": "12345",
    "email": "vincecarollo@gmail.com",
    "phone_number": "1235551234",
    "needs": ["groceries", "bills"],
    "allergies": ["pollen", "peanuts"],
    "medications": ["drug_1", "drug_2"],
    "created_at": "DateTime",
    "updated_at": "DateTime"
  }
  ```
  ##### Unsuccessful Response
  A valid client ID must be provided or a 404 status code (page not found) will be returned.

### Client Deletion
Send a DELETE request to delete a client

#### DELETE /api/v1/clients/:id

##### Successful Response:

will return a 204 status code with no body

##### Unsuccessful Response
A valid client ID must be provided or a 404 status code (page not found) will be returned.

# Caretaker Endpoints

## Single Caretaker:

### Caretaker Profile
  Send a GET request to receive all information related to a single caretaker

  #### GET /api/v1/caretakers/:id

  ##### Successful Response
  ```json
  {
    "id": "1",
    "username": "katierulz",
    "name": "Katie",
    "email": "katierulz@gmail.com",
    "phone_number": "1235551234",
    "abilities": "ability_1",
    "role": "caretaker",
    "created_at": "DateTime",
    "updated_at": "DateTime"
  }
  ```
  ##### Unsuccessful Response
  A valid caretaker ID must be provided or a 404 status code (page not found) will be returned.

### Caretaker Creation:
Send a POST request to create a caretaker

  #### POST /api/v1/caretakers/:id

  ##### headers:
  ```
  Content-Type: application/json
  Accept: application/json
  ```

#### body:
 *MUST have password AND password confirmation and they must match*
  ```json
  {
      "username": "string-required",
      "name": "string-required",
      "password": "password",
      "password_confirmation": "password",
      "email": "string-required",
      "phone_number": "string-required",
      "abilities": "ability_1",
      "role": "caretaker"
  }
  ```

  ##### Successful Response
  ```json
  {
    "id": "1",
    "username": "katierulz",
    "name": "Katie",
    "email": "katierulz@gmail.com",
    "phone_number": "1235551234",
    "abilities": "ability_1",
    "role": "caretaker",
    "created_at": "DateTime",
    "updated_at": "DateTime"
  }
  ```
  #### Unsuccessful Responses:
  ##### Username Taken:
  ```json
  {
    "message": ["Username has been taken"]
  }
  ```

  ##### Email Taken:
  ```json
  {
    "message": ["Email has been taken"]
  }
  ```

  ##### Unmatching Password:
  ```json
  {
    "password_confirmation": ["does not match password"]
  }
  ```

### Caretaker Update
Send a PATCH request to update a caretaker

  #### PATCH /api/v1/caretakers/:id

  ##### headers:
  ```
  Content-Type: application/json
  Accept: application/json
  ```

#### body:
```json
{
    "username": "updated_username",
    "name": "update_name",
    "email": "updated_email@email.com",
    "phone_number": "updated_number",
    "abilities": "updated_ability_1"
}
```

  ##### Successful Response
  ```json
  {
    "id": "1",
    "username": "updated_username",
    "name": "update_name",
    "email": "updated_email@email.com",
    "phone_number": "updated_number",
    "abilities": "updated_ability_1",
    "created_at": "DateTime",
    "updated_at": "DateTime"
  }
  ```
  #### Unsuccessful Responses:
  ##### Username Taken:
  ```json
  {
    "message": ["Username has been taken"]
  }
  ```

  ##### Email Taken:
  ```json
  {
    "message": ["Email has been taken"]
  }
  ```

### Caretaker Deletion
  Send a DELETE request to delete a caretaker

  #### DELETE /api/v1/caretakers/:id

  ##### Successful Response:

  will return a 204 status code with no body

  ##### Unsuccessful Response
  A valid caretaker ID must be provided or a 404 status code (page not found) will be returned.

## Lists
### Lists Index

#### GET /api/v1/lists

##### Headers:
```
Content-Type: application/json
Accept: application/json
```

##### params:
```
?client_id=2
```
or
```
?caretaker_id=2
```

Successful Response:
```json
[
    {
        "id": 1,
        "name": "Groceries",
        "client_id": 1,
        "created_at": "2019-09-21T18:56:50.716Z",
        "updated_at": "2019-09-21T18:56:50.716Z",
        "created_for": "caretaker",
        "caretaker_id": 1
    },
    {
        "id": 2,
        "name": "Dinner Party Errands",
        "client_id": 1,
        "created_at": "2019-09-21T18:56:50.746Z",
        "updated_at": "2019-09-21T18:56:50.746Z",
        "created_for": "caretaker",
        "caretaker_id": 1
    }
]
```
Unsuccessful Response:
A valid client or caretaker ID must be provided or a 404 status code (page not found) will be returned.

### Lists Show

#### GET /api/v1/lists/:list_id

##### Headers:
```
Content-Type: application/json
Accept: application/json
```

Successful Response:

```json
{
    "id": 1,
    "name": "Groceries",
    "client_id": 1,
    "created_at": "2019-09-21T18:56:50.716Z",
    "updated_at": "2019-09-21T18:56:50.716Z",
    "created_for": "caretaker",
    "caretaker_id": 1
}
```

Unsuccessful Response:
A valid list ID must be provided or a 404 status code (page not found) will be returned.

### Lists Create

#### GET /api/v1/lists

##### Headers:
```
Content-Type: application/json
Accept: application/json
```

##### Body:
```
{
  name: 'Groceries',
  client_id: 3,
  caretaker_id: 6,
  created_for: 'caretaker'
}
```
*created_for can be 'caretaker' or 'client' only*

Successful Response:
```json
{
  "id": 3238,
  "name": "Groceries",
  "client_id": 4227,
  "created_at": "2019-09-24T23:21:44.326Z",
  "updated_at": "2019-09-24T23:21:44.326Z",
  "created_for": "caretaker",
  "caretaker_id": 2759
}
```

Unsuccessful Response:
A valid client ID must be provided or a 404 status code (page not found) will be returned.

*caretakers are optional*

### Lists Update

#### GET /api/v1/lists/:list_id

##### Headers:
```
Content-Type: application/json
Accept: application/json
```

##### Body:
```
{
  name: 'New Name'
}
```

Successful Response:

```json
{
  "id": 3238,
  "name": "New Name",
  "client_id": 4227,
  "created_at": "2019-09-24T23:21:44.326Z",
  "updated_at": "2019-09-24T23:21:44.326Z",
  "created_for": "caretaker",
  "caretaker_id": 2759
}
```
Unsuccessful Response:
A valid list ID must be provided or a 404 status code (page not found) will be returned.

### Lists Delete

#### DELETE /api/v1/lists/:list_id

##### Headers:
```
Content-Type: application/json
Accept: application/json
```

Successful Response:
Returns 204 status with no body

Unsuccessful Response:
A valid list ID must be provided or a 404 status code (page not found) will be returned.

## Tasks
### Tasks Index

#### GET /api/v1/lists/:list_id/tasks

##### Headers:
```
Content-Type: application/json
Accept: application/json
```

Successful Response:
```json
[
    {
        "id": 1,
        "list_id": 1,
        "name": "Gala Apples",
        "description": "Should be on sale",
        "completed": false,
        "created_at": "2019-09-21T18:56:50.730Z",
        "updated_at": "2019-09-21T18:56:50.730Z"
    },
    {
        "id": 2,
        "list_id": 1,
        "name": "Green Onions",
        "description": "Should be on sale",
        "completed": false,
        "created_at": "2019-09-21T18:56:50.738Z",
        "updated_at": "2019-09-21T18:56:50.738Z"
    }
]
```

Unsuccessful Response:
A valid client or caretaker ID must be provided or a 404 status code (page not found) will be returned.

### Tasks Show

#### GET /api/v1/lists/:list_id/tasks/:task_id

##### Headers:
```
Content-Type: application/json
Accept: application/json
```

Successful Response:
```json
{
    "id": 2,
    "list_id": 1,
    "name": "Green Onions",
    "description": "Should be on sale",
    "completed": false,
    "created_at": "2019-09-21T18:56:50.738Z",
    "updated_at": "2019-09-21T18:56:50.738Z"
}
```

Unsuccessful Response:
A valid list and task ID must be provided or a 404 status code (page not found) will be returned. Also the task given must be associated with the list given or a 404 will be returned.

### Tasks Create

#### post /api/v1/lists/:list_id/tasks

##### Headers:
```
Content-Type: application/json
Accept: application/json
```

##### Body:
```
{
  name: 'Mow Back Yard',
  description: 'make sure to weedeat',
  list_id: 3,
  due_date: '2019-12-25'
}
```
*due date is optional*

Successful Response:
```json
{
  "id": 77,
  "list_id": 3,
  "name": "Mow Back Yard",
  "description": "make sure to weedeat",
  "completed": false,
  "created_at": "2019-09-25T19:33:36.071Z",
  "updated_at": "2019-09-25T19:33:36.071Z",
  "due_date": "12/25"
}
```
*Due date format is due to front end request*

Unsuccessful Response:
A valid list ID must be provided or a 404 status code (page not found) will be returned.

### Tasks Update

#### PATCH /api/v1/lists/:list_id/tasks/:task_id

##### Headers:
```
Content-Type: application/json
Accept: application/json
```

##### Body:
```
{
  name: 'New Name'
}
```

Successful Response:
```json
{
  "id": 77,
  "list_id": 3,
  "name": "New Name",
  "description": "make sure to weedeat",
  "completed": false,
  "created_at": "2019-09-25T19:33:36.071Z",
  "updated_at": "2019-09-25T19:33:36.071Z",
  "due_date": "12/25"
}
```

Unsuccessful Response:
A valid list and task ID must be provided or a 404 status code (page not found) will be returned.

### Tasks Delete

#### DELETE /api/v1/lists/:list_id/tasks/:task_id

##### Headers:
```
Content-Type: application/json
Accept: application/json
```

Successful Response:
Returns 204 status with no body

Unsuccessful Response:
A valid list and task ID must be provided or a 404 status code (page not found) will be returned.

## Login
Send a POST request to get user id from username and password

#### post /api/v1/login

##### Headers:
```
Content-Type: application/json
Accept: application/json
```

##### Body:
```
{
  username: "testClient",
  password: "pass"
}
```

##### Successful Response
returns the user object who matches given username and password

```json
{
  "id": "1",
  "username": "testClient",
  "name": "Katie",
  "street_address": "123 Test St",
  "city": "Denver",
  "state": "CO",
  "zip": "12345",
  "email": "katierulz@gmail.com",
  "phone_number": "1235551234",
  "needs": ["groceries", "bills"],
  "medications": ["drug_1", "drug_2"],
  "diet_restrictions": ["vegetarian", "peanut-free"],
  "created_at": "DateTime",
  "updated_at": "DateTime"
}
```
##### Unsuccessful Response
##### Bad Username/Password:
Returns 400 and body:
```json
  {
    "message": "Invalid Username/Password"
  }
```

## Speech to Text
Send a POST request to turn a .caf audio file into text

*Google Speech api will look for an Environment Variable called GOOGLE_APPLICATION_CREDENTIALS that points to the path of key.json assigned by google. More info can be found [here](https://cloud.google.com/speech-to-text/docs/quickstart-client-libraries) in the 'Before you begin' section.*

#### post /api/v1/speech

##### Headers:
```
Content-Type: application/octet-stream
```

##### Body:
Body Should contain an audio blob originating from a .caf file

##### Successful Response

```json
{
  "text": "groceries"
}
```
##### Unsuccessful Response
```json
{
  "text": "No Matching Text Found"
}
```

## Database Schema
<img width="812" alt="sophia_db_schema" src="https://user-images.githubusercontent.com/34421236/64760769-bcbca100-d4f7-11e9-989f-d03cb4b120b1.png">

## Challenges
Technical Debt: This project has two types of users, a client and a caretaker. When planning our database architecture, we were more focused on implementing the client functionality first. When we moved on to implementing the caretaker functionality, we had to rearrange much of the existing routes and controllers to accommodate.

## Successes
- Implementing Speech to Text
- MVP goals were reached in 2 weeks with front end team

## Extensions
- Implement Websockets to stream audio from front end
- Rearrange routing to allow list and task CRUD without client or caretaker association

## Developers

👤 **Noah Flint, Vince Carollo, Katie Lewis, Andreea Hanson**

* [Vince Carollo](https://github.com/n-flint)
* [Noah Flint](https://github.com/VinceCarollo)
* [Katie Lewis](https://github.com/Kalex19)
* [Andreea Hanson](https://github.com/andreeahanson)

## Frontend

* [Sophia Repo](https://github.comkalex19/Sophia-Native)

## Production

* Heroku: [Sophia Rails Application](https://evening-dusk-50121.herokuapp.com/)
