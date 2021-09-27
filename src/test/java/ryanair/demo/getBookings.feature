Feature: Get bookings
  Provided a valid user id and/or a date, the response should
  contain all booking information for the requested filter in the
  format definied by the specification.
  If no information mathes the filter, the result will be an empty array

Background:
 
  * url baseUrl
  * def featurePath =  "/booking"
  * def testMethod = "GET"
  * def bookingSchema = read("bookingSchema.json")
  * def bookingsDate = "3000-12-25"
  * def bookingsUser1 = "pepe@pepe.pe1-0.2" 
  * def bookingsUser2 = "pepe@pepe.pe1-0.1"   
  #prepare a set of bookings ad keep them in global testBookings array 
  * call read('prepareBookings.feature') 

Scenario: Should return all existing bookings at a given date 
  The number of bookings for the requested user id is undetermined,
  but must at least contain the data prepared for the test


  Given path featurePath
  And param date = bookingsDate
  When method testMethod
  Then status 200  
  And match header content-type == "application/json;charset=UTF-8" 
  And match response == "#[] bookingSchema"
  And match response contains testBookings[0]
  And match response contains testBookings[1]
  And match response contains testBookings[2]    

Scenario: Should return all existing bookings for a given user 
  The number of bookings for the requested user id is undetermined,
  but must at least contain the data prepared for the test

  Given path featurePath
  And param id = bookingsUser1
  When method testMethod
  Then status 200  
  And match header content-type == "application/json;charset=UTF-8" 
  And match response == "#[] bookingSchema"
  And match response contains testBookings[0]
  And match response contains testBookings[1]

Scenario: Should return existing bookings for a given user and date
  The number of bookings for the requested user id  and date 
  is undetermined,but must at least contain the data prepared for the test

  Given path featurePath
  And param id = bookingsUser2  
  And param date = bookingsDate
  When method testMethod
  Then status 200  
  And match header content-type == "application/json;charset=UTF-8" 
  And match response == "#[] bookingSchema"
  And match response contains testBookings[2]

Scenario: Should return empty data if no bookings for requested date
 
  Given path featurePath
  And param date = "0001-01-01"
  When method testMethod
  Then status 200  
  And match header content-type == "application/json;charset=UTF-8" 
  And match response == []

Scenario: Should return empty data if no bookings for user

  Given path featurePath
  And param id = "whoever"
  When method testMethod
  Then status 200  
  And match header content-type == "application/json;charset=UTF-8" 
  And match response == []



Scenario: Should return error 400 if no parameters are set

  Given path featurePath
  When method testMethod
  Then status 400  
  And match header content-type == "text/plain;charset=UTF-8" 
  And match response == "Bad request: date and id empty"

Scenario: Should return error 500 if date format not valid

  Given path featurePath
  And param id = bookingsUser2  
  And param date = "3000/12/25"
  When method testMethod
  Then status 500  
  And match header content-type == "application/json;charset=UTF-8" 
  And match response.path == "/booking"
  And match response.message == "Format date not valid"
  And match response.error == "Internal Server Error"
  And match response.timestamp == "#string"
  And match response.status == 500


  Scenario: Should return error 500 if date not valid

    Given path featurePath
    And param id = bookingsUser2  
    And param date = "3000-02-30"
    When method testMethod
    Then status 500  
    And match header content-type == "application/json;charset=UTF-8" 
    And match response.path == "/booking"
    And match response.message == "Format date not valid"
    And match response.error == "Internal Server Error"
    And match response.timestamp == "#string"
    And match response.status == 500
  
  