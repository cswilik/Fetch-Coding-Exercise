# Fetch Points Application

In this application, you add/update and spend points.

## Setup
### Inital steps
This app was made with Ruby 2.6.1 and Rails 6.0.4.1. To check if you already have Ruby and Rails installed, open your command prompt/terminal and type the following to check which version you have:

`ruby -v`

`rails -v`

If you don't have Ruby installed, please see further instructions here: [https://www.ruby-lang.org/en/documentation/installation/]

After forking and cloning this repo onto your local machine using your preferred code editor, install all packages with following code:

`bundle install`

### Database

Within root directory of the repo, type the following commands in your terminal:

`rails db:create`

`rails db:migrate`

`rails db:seed` 

To boot up the application and test if its working, use the following command:

`rails s`

then open http://localhost:3000/ to confirm its running.

To check if the data is persisting, open a new terminal and run the following code:

`curl http://localhost:3000/`
        
This should return the following:

 ```
 [{"id":107,"payer":"DANNON","points":300,"date":"2020-10-31T10:00:00.000Z","created_at":"2021-10-27T16:59:40.847Z","updated_at":"2021-10-27T16:59:40.847Z"},{"id":104,"payer":"UNILEVER","points":200,"date":"2020-10-31T11:00:00.000Z","created_at":"2021-10-27T16:59:40.826Z","updated_at":"2021-10-27T16:59:40.826Z"},{"id":105,"payer":"DANNON","points":-200,"date":"2020-10-31T15:00:00.000Z","created_at":"2021-10-27T16:59:40.832Z","updated_at":"2021-10-27T16:59:40.832Z"},{"id":106,"payer":"MILLER COORS","points":10000,"date":"2020-11-01T14:00:00.000Z","created_at":"2021-10-27T16:59:40.840Z","updated_at":"2021-10-27T16:59:40.840Z"},{"id":103,"payer":"DANNON","points":1000,"date":"2020-11-02T14:00:00.000Z","created_at":"2021-10-27T16:59:40.818Z","updated_at":"2021-10-27T16:59:40.818Z"}]
 ```
 
## Using Application
### Adding Transactions

To add a transaction use the following command and endpoint (update attribute values as you wish)

`curl -d "transaction[payer]=CHEWY" -d "transaction[points]=3000" -d "transaction[date]=2021-10-27T12:30:00" http://localhost:3000/transactions`

Return:
```
{"id":108,"payer":"CHEWY","points":3000,"date":"2021-10-27T12:30:00.000Z","created_at":"2021-10-27T17:14:15.095Z","updated_at":"2021-10-27T17:14:15.095Z"}
```

### Spending Points

To spend points, these are the following conditions:
  - We want the oldest points to be spent first (oldest based on transaction timestamp, not the order they’re received)
  - We want no payer's points to go negative.
  - Return all payer point balances.

Our call is as following:

`curl -d "points"=1000 http://localhost:3000/spend-points`

Our return should look like:
```
{"DANNON":-100,"UNILEVER":-200,"MILLER COORS":-700}
```

### Checking Payer Points Balance

We can also check all the payer balances with the following command:

`curl http://localhost:3000/points-balance`

Our Return:
```
{"DANNON":1000,"UNILEVER":0,"MILLER COORS":9300,"CHEWY":3000}
```

if you have any questions, feel free to reach out!
