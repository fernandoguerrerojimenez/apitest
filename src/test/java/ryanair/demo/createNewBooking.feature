Feature: Create new booking
  Adds a new booking tothe bookins collection of a user,
  for a given valid date, origin and destination valid IATA codes
  and user id. Returns a booking data object containing the input data 
  plus a boohing id based in origin adn destination codes plus a
  random number

Background:
 
  * url baseUrl
  * def featurePath =  "/booking"
  * def testMethod = "POST"

Scenario: Should create a new booking if data are correct
  
  * def newBookingrequestBody = 
  """
    {
       date: "2021-12-25",
       destination: "LHR",
       id: "pepe@pepe.pe1-0.1",
       origin: "MAD"
    }
  """
  * def newBookingResponseMatcher = 
  """
    {
       idBooking: "#regex ^MAD-LHR-[0-9.E-]+",
       idUser: "pepe@pepe.pe1-0.1",
       origin: "MAD",
       destination: "LHR",
       date: "2021-12-25"
    }
  """
  Given path featurePath
  And request newBookingrequestBody
  When method testMethod
  Then status 201
  And match header content-type == "application/json;charset=UTF-8" 
  And match response == newBookingResponseMatcher


Scenario: Should ignore unexpected request body members
  
    * def newBookingrequestBody = 
    """
      {
        date: "2021-12-25",
        destination: "LHR",
        id: "pepe@pepe.pe1-0.1",
        origin: "MAD",
        somefield: "somedata"
      }
    """
    * def newBookingResponseMatcher = 
    """
      {
         idBooking: "#regex ^MAD-LHR-[0-9.E-]+",
         idUser: "pepe@pepe.pe1-0.1",
         origin: "MAD",
         destination: "LHR",
         date: "2021-12-25"
      }
    """
    Given path featurePath
    And request newBookingrequestBody
    When method testMethod
    Then status 201
    And match header content-type == "application/json;charset=UTF-8" 
    And match response == newBookingResponseMatcher

Scenario: Should return error 409 when date is missing

  * def newBookingrequestBody = 
  """
    {
       destination: "LHR",
       id: "pepe@pepe.pe1-0.1",
       origin: "MAD"
    }
  """  
  Given path featurePath
  And request newBookingrequestBody
  When method testMethod
  Then status 409
  And match header content-type == "text/plain;charset=UTF-8"  
  And match response == "Check fields"


Scenario: Should return error 409 when destination is missing
  
  * def newBookingrequestBody = 
  """
    {
       date: "2021-12-25",
       id: "pepe@pepe.pe1-0.1",
       origin: "MAD"
    }
  """  
  Given path featurePath
  And request newBookingrequestBody
  When method testMethod
  Then status 409
  And match header content-type == "text/plain;charset=UTF-8"  
  And match response == "Check fields"


Scenario: Should return error 409 when userid is missing

  * def newBookingrequestBody = 
  """
    {
       date: "2021-12-25",
       destination: "LHR",
       origin: "MAD"
    }
  """  
  Given path featurePath
  And request newBookingrequestBody
  When method testMethod
  Then status 409
  And match header content-type == "text/plain;charset=UTF-8"  
  And match response == "Check fields"
 

Scenario: Should return error 409 when origin is missing

  * def newBookingrequestBody = 
  """
    {
       date: "2021-12-25",
       destination: "LHR",
       id: "pepe@pepe.pe1-0.1"
    }
  """  
  Given path featurePath
  And request newBookingrequestBody
  When method testMethod
  Then status 409
  And match header content-type == "text/plain;charset=UTF-8"  
  And match response == "Check fields"
 
Scenario: Should return error 400 when origin is not a valid IATA code

  * def newBookingrequestBody = 
  """
    {
       date: "2021-12-25",
       destination: "LHR",
       id: "pepe@pepe.pe1-0.1",
       origin: "mad"
    }
  """      
    Given path featurePath
    And request newBookingrequestBody
    When method testMethod
    Then status 400
    And match header content-type == "text/plain;charset=UTF-8"  
    And match response == "Origin or Destination is not a IATA code (Three Uppercase Letters)"
   
Scenario: Should return error 400 when destination is not a valid IATA code

  * def newBookingrequestBody = 
  """
    {
       date: "2021-12-25",
       destination: "LR",
       id: "pepe@pepe.pe1-0.1",
       origin: "MAD"
    }
  """      
    Given path featurePath
    And request newBookingrequestBody
    When method testMethod
    Then status 400
    And match header content-type == "text/plain;charset=UTF-8"   
    And match response == "Origin or Destination is not a IATA code (Three Uppercase Letters)"
   

Scenario: Should return error 400 when date format is not valid

  * def newBookingrequestBody = 
  """
    {
       date: "2021/12/25",
       destination: "LHR",
       id: "pepe@pepe.pe1-0.1",
       origin: "MAD"
    }
  """      
    Given path featurePath
    And request newBookingrequestBody
    When method testMethod
    Then status 400
    And match header content-type == "text/plain;charset=UTF-8"   
    And match response == "Date format not valid"  


Scenario: Should return error 500 when userid is incorrect
  
  * def newBookingrequestBody = 
  """
    {
       date: "2021-12-25",
       destination: "LHR",
       id: "???",
       origin: "MAD"
    }
  """      
  Given path featurePath
  And request newBookingrequestBody
  When method testMethod
  Then status 500
  And match header content-type == "application/json;charset=UTF-8"   
  And match response.path == "/booking"
  And match response.error == "Internal Server Error"
  And match response.message == "User id not found"
  And match response.timestamp == "#string"
  And match response.status == 500

Scenario: Should return error 415 when request content type is not correct

  * def newBookingrequestBody = 
  """
    {
       date: "2021-12-25",
       destination: "LHR",
       id: "pepe@pepe.pe1-0.1",
       origin: "MAD"
    }
  """      
* def requestContentType = "application/xml;charset=UTF-8"   

  Given path featurePath
  And header content-type = requestContentType
  And request newBookingrequestBody
  When method testMethod
  Then status 415
  And match header content-type == "application/json;charset=UTF-8" 
  And match response.path == "/booking"
  And match response.error == "Unsupported Media Type"
  And match response.message == "Content type '" + requestContentType + "' not supported"
  And match response.timestamp == "#string"  
  And match response.status == 415 

  
Scenario: Should return error 400 when request body is not a correct json object
  
  * def newBookingrequestBody = "{ date: '2021-12-25', destination: 'LHR, id: 'pepe@pepe.pe1-0.1',  origin: 'MAD' }"

  Given path featurePath
  And header content-type = "application/json;charset=UTF-8" 
  And request newBookingrequestBody
  When method testMethod
  Then status 400
  And match header content-type == "application/json;charset=UTF-8" 
  And match response.path == "/booking"
  And match response.message contains "JSON parse error"    
  And match response.error == "Bad Request"   
  And match response.timestamp == "#string"
  And match response.status == 400         

Scenario: Should return error 400 when request body is empty
  
  Given path featurePath
  When method testMethod
  Then status 400
  And match header content-type == "application/json;charset=UTF-8" 
  And match response.path == "/booking"
  And match response.message contains "Required request body is missing"    
  And match response.error == "Bad Request"   
  And match response.timestamp == "#string"
  And match response.status == 400     