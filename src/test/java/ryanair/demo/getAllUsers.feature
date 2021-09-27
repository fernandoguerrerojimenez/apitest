
Feature: Get all users
  Should return an array of json user objects
  For each user there can be zero or more bookings
  containied in a bookings array

Background:
 
  * url baseUrl
  * def featurePath =  "/user/all"
  * def testMethod = "GET"
  * def bookingSchema = read("bookingSchema.json")
  * def userSchema = read("userSchema.json")
 
Scenario: User list structure should ve valid
  The response structure should be according to the specification

  Given path featurePath
  When method testMethod
  Then status 200
  And match header content-type == "application/json;charset=UTF-8" 
  And match response == "#[] userSchema"
    
Scenario: Should ignore unexpected parameters
  parameters passed to the request should not have any effect

  Given path featurePath
  And param someparam = "somevalue"
  When method testMethod
  Then status 200
  And match header content-type == "application/json;charset=UTF-8" 
  And match response == "#[] userSchema"
  
Scenario: Should retrieve at least two users
  The response can return an undeterined number of users
  with an unetermined number of bookings,
  but at least the two users that have been predefined in the 
  demo application

  * def firstuser = 
  """
    {
      email: "pepe@pepe.pe1",
      name: "pepe",
      id: "pepe@pepe.pe1-0.1",
      bookings: "#[]bookingSchema"
    }
  """    
  * def seconduser = 
  """
    {
      email: "pepe@pepe.pe2",
      name: "pepe",
      id: "pepe@pepe.pe1-0.2",
      bookings: "#[]bookingSchema"
    }
  """      
  Given path featurePath
  When method testMethod
  Then status 200
  And match header content-type == "application/json;charset=UTF-8" 
  And match response contains firstuser
  And match response contains seconduser  