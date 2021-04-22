# Introduction
This application is a Twitter Command Line Interface to enable the creation, searching, and deletion of tweets based on their specified options. It uses the Twitter REST API to enable this functionality through an HTTP Client to run the requests and uses the Jackson library to parse and convert the JSON objects to Tweet Objects and vice-versa. I used Maven to package the application and its dependencies and then created a Docker image and pushed it to the Docker Hub.

## Quick Start
Before you package your application you must set environment variables for Twitter authentication.

Twitter Consumer API Key (consumerKey)
Twitter Consumer API Secret Key (consumerSecret)
Twitter Access Token (accessToken)
Twitter Access Token Secret (tokenSecret)
An example command for setting these variables is as follows:
```
$ export consumerKey='consumer_key_value'
```
Then to package the Twitter CLI Application you can use the maven command:
```
$ mvn clean package
```
This will create a JAR file that you can use to run your application. The usage of the program is as follows:
```
$ java -jar [.jar file] post "text" "latitude:longitude"
$ java -jar [.jar file] show "id" [fields]
$ java -jar [.jar file] show "id
```
## Design
![UML](https://user-images.githubusercontent.com/80492218/115722162-b7b70900-a34c-11eb-8a2b-c12e4974bcf8.png)

## TwitterCLISpringBoot/Main
This layer is the top layer that the consumer calls using the command line interface. This main class will pass the tweet arguments for post/show/delete to the TwitterCLIApp object's run method down the architecture.

## TwitterCLIApp
TwitterCLIApp component will call the post | show | delete tweets method on the TwitterController object field and retrieve a Tweet object as result. Throw an exception if the arguments are incorrect.

## TwitterController
In this component layer, the arguments get parsed into an array of elements and call the TwitterService object post | show | delete methods passing the array and getting a Tweet object as result. eg. split by commas and colons.

## TwitterService
In this component layer, the business logic is handled by validating the id, fields, and tweet text. If they pass the validation, the TwitterDao object is called to access and make a request to the Twitter server.

1. When you post a tweet, the service layer is responsible to check if the tweet text exceeds 140 characters and if lon/lat is out of range.
2. When you search for a Tweet, you need to check if user input IDs are in the correct format.

## TwitterDao
In this component layer, only the Twitter REST API is handled, not the business logic. This layer is in charge of creating the URI for the specific request calls and send it to the TwitterHttpHelper object.

## TwitterHttpHelper
In this component layer, the HttpClient will set up the request using the passed arguments and with an OAuthConsumer object, the consumer keys and access tokens are used to sign the request. Which then successfully calls the Twitter REST API and returns the HTTP Response object.

## Models
A simplified version of the Tweet Object is modeled to contain the following properties
```
{
   "created_at":"Mon Feb 18 21:24:39 +0000 2019",
   "id":1097607853932564480,
   "id_str":"1097607853932564480",
   "text":"test with loc223",
   "entities":{
      "hashtags":[],      
      "user_mentions":[]  
   },
   "coordinates":null,    
   "retweet_count":0,
   "favorite_count":0,
   "favorited":false,
   "retweeted":false
}
```
5 DTO(data transfer objects) are used as models: Coordinates, Entities, Hashtag, Tweet, and UserMention

## Spring
The class dependencies are handled using the SpringBoot framework. All the components are annotated with @Component to tell the Spring runtime that it is a Bean to be maintained by IoC container. Then the dependency relationships were specified above the class constructors with the @Autowired so that SpringApplication context manages that and injects them automatically using @ComponentScan. Finally, the IoC container context is created in the main class.

## Test
For each component, JUnit 4 and Mockito framework were used to run the Unit Test. Also, integration tests were done for each component using JUnit 4 as well.

## Improvements
- Detect location rather than having to input "lng:lat" for creation of tweets.
- Allow for more retrieval of tweets using multiple or other fields rather than just id.

