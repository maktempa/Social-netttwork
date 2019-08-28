# Social-netttwork

Initial repo for test social network with supported base capabilities:

I love :coffee:
Changes made on local repo

GraphQL query specifications:

1. Queries:

1.1 query getUsers - get all users from table
Query example:

query getUsers {
  getUsers{
    id login name
  }
}

Query variables example:
{"name":  "Some-name"
}


2. Mutations:

2.1 mutation useRegister(login, password,..) - register user with required fields: login, password. Other fields are optional
Mutation example:

mutation userRegister(
  $graphiql_var_user: String!, 
  $graphiql_var_password: String!,
	$graphiql_var_name: String
	$graphiql_var_surname: String,
	$graphiql_var_middle_name: String,
	$graphiql_var_age: Int,
	$graphiql_var_city: String){		
  userRegister(
    login: $graphiql_var_user, 
    password: $graphiql_var_password
  	name: $graphiql_var_name,
    surname: $graphiql_var_surname,
    middleName: $graphiql_var_middle_name,
    age: $graphiql_var_age,
    city: $graphiql_var_city
  	){		
    id login name surname age
  }		
}		

Mutation variables  example:
{
  "graphiql_var_user": "guser4",
  "graphiql_var_password": "Gpassword3",
  "graphiql_var_name": "gname3",
  "graphiql_var_surname": "gsurname3",
  "graphiql_var_middle_name": "gsurname3",
  "graphiql_var_age": 30,
  "graphiql_var_city": "gcity1"
  
}

3. Subscriptions:

3.1 subscription userRegisteredByAge(age) - get notifications on user created with certain value of 'age' field

Subscription Example:

subscription userRegisteredByAge($Age:Int!){
  userRegisteredByAge(age: $Age) {
    id name age
  }
}

Subscription variables example:

{
 "Age": 20
}



