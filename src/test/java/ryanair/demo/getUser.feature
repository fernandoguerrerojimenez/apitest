Feature: Get user
  Provided that the request contains a valid
  user identification, the response should
  return all of its information, inlcuding bookings

Background:
 
  * url baseUrl
  * def featurePath =  "/user"
  * def testMethod = "GET"
  * def testUserEmail = "pepe@pepe.pe1"
  * def testUserId = testUserEmail + "-0.1"
  * def testUserName = "pepe"
  * def bookingSchema = read("bookingSchema.json")

Scenario: Should return user data when requested user id is correct
  The amount of bookins is undetermined

  Given path featurePath
  And param id = testUserId
  When method testMethod
  Then status 200
  And match header content-type == "application/json;charset=UTF-8"   
  And match response.name == testUserName
  And match response.id == testUserId
  And match response.email == testUserEmail   
  And match response.bookings == "#[] bookingSchema"

Scenario: Should ignore unexpected parameters
  No unexpected behaviour

  Given path featurePath
  And param id = testUserId
  And param otherparam = "othervalue"
  When method testMethod
  Then status 200
  And match header content-type == "application/json;charset=UTF-8"   
  And match response.name == testUserName
  And match response.id == testUserId
  And match response.email == testUserEmail   
  And match response.bookings == "#[] bookingSchema"


Scenario: Should return code 404 not found when requested user does not exist
  
  Given path featurePath
  And param id = "whoever"
  When method testMethod
  Then status 404
  And match header content-type == "text/plain;charset=UTF-8"   
  And match response == "User not found"

Scenario: Should return error 500 when no id user parameter is set

  Given path featurePath
  When method testMethod
  Then status 500
  And match header content-type == "text/plain;charset=UTF-8"   
  And match response == "ID erroneus"
  
Scenario: Should return  error 500 when id user is empty

  Given path featurePath
  And param id = ""
  When method testMethod
  Then status 500
  And match header content-type == "text/plain;charset=UTF-8"   
  And match response == "ID erroneus"
  
Scenario: Should return  error 500 when id user is null

  Given path featurePath
  And param id = null
  When method testMethod
  Then status 500
  And match header content-type == "text/plain;charset=UTF-8"
  And match response == "ID erroneus"

Scenario: Should return error 406 when Accept header is incorrect

  Given path featurePath
  And header Accept = "application/xml"
  And param id = testUserId
  When method testMethod
  Then status 406
