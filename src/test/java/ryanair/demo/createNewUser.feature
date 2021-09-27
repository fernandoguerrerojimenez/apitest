Feature: Create new user
  Creates a new user entity from a valid email and user name
  The resulting user data contains the name, email, a user id 
  based on the emal pulus a random number and a bookings
  collection that at first will be empty

Background:
 
  * url baseUrl
  * def featurePath =  "/user"
  * def testMethod = "POST"
  * def bookingSchema = read("bookingSchema.json")
  * def userSchema = read("userSchema.json")

Scenario: Should create a new user when request data are valid

  * def newUserRequestBody = 
    """
      {
        email: "paco@paco.pa1",
        name: "paco"
      }
    """

  * def newUserResponseMatcher = 
    """
    {
      name: "paco",
      id: "#regex paco@paco.pa1-[0-9.E-]+",
      bookings: [],
      email: "paco@paco.pa1"
    }
    """

  Given path featurePath
  And request newUserRequestBody
  When method testMethod
  Then status 201
  And match header content-type == "application/json;charset=UTF-8" 
  And match response == newUserResponseMatcher
  
Scenario: Should return error 409 when missing email

  * def newUserRequestBodyNoEmail = 
  """
    {
      name: "paco"
    }
  """

  Given path featurePath
  And request newUserRequestBodyNoEmail
  When method testMethod
  Then status 409
  And match header content-type == "text/plain;charset=UTF-8"  
  And match response == "Check fields"
  
Scenario: Should return error 409 when missing name

  * def newUserRequestBodyNoName = 
  """
    {
      email: "paco@paco.pa1",
    }
  """  

  Given path featurePath
  And request newUserRequestBodyNoName
  When method testMethod
  Then status 409
  And match header content-type == "text/plain;charset=UTF-8"  
  And match response == "Check fields"
  



  Given path featurePath
  And request newUserRequestBodyNoName
  When method testMethod
  Then status 409
  And match header content-type == "text/plain;charset=UTF-8"  
  And match response == "Check fields"


Scenario: Should return error 409 when email empty

  * def newUserRequestBody = 
    """
      {
        email: "",
        name: "paco"
      }
    """

  Given path featurePath
  And request newUserRequestBody
  When method testMethod
  Then status 409
  And match header content-type == "text/plain;charset=UTF-8"  
  And match response == "Check fields"

Scenario: Should return error 409 when name empty

  * def newUserRequestBody = 
    """
      {
        email: "paco@paco.pa1",
        name: ""
      }
    """

  Given path featurePath
  And request newUserRequestBody
  When method testMethod
  Then status 409
  And match header content-type == "text/plain;charset=UTF-8"  
  And match response == "Check fields"


Scenario: Should return error 500 when incorrect email format

  * def newUserRequestBodyWrongEmail = 
  """
    {
      email: "paco-paco.pa1",
      name: "paco"
    }
  """     
  Given path featurePath
  And request newUserRequestBodyWrongEmail
  When method testMethod
  Then status 500
  And match header content-type == "application/json;charset=UTF-8"  
  And match response.path == "/user"
  And match response.error == "Internal Server Error"
  And match response.timestamp =="#string"
  And match response.status == 500

Scenario: Should return error 400 when request body is no valid json

  * def newUserRequestBodyMalformedJson = "{email: 'paco@paco.pa1'; name:'paco'}"   
  
  * def malformedJsonMessageMatcher =
  """
    {
      path: "\/user",
      error: "Bad Request",
      message: "Content type 'text\/plain;charset=UTF-8' not supported",
      timestamp: "#string",
      status: 415
    }
  """
  Given path featurePath
  And header content-type = 'application/json'
  And request newUserRequestBodyMalformedJson
  When method testMethod
  Then status 400
  And match header content-type == "application/json;charset=UTF-8"    
  And match response.path == "/user"
  And match response.error == "Bad Request"
  And match response.message contains "JSON parse error"
  And match response.timestamp =="#string"  
  And match response.status == 400 
     
Scenario: Should return error 400 when request body is missing
  
  * def noRequestBodyMessageMatcher = 
  """
    {
      "path":"\/user\"",
      "error":"Bad Request",
      "message":"Required request body is missing: public restservice.entity.User restservice.controller.UserController.createUser(restservice.api.UserRequest) throws java.lang.Exception",
      "timestamp":"#string",
      "status":400
    }
  """

  Given path featurePath
  When method testMethod
  Then status 400
  And match header content-type == "application/json;charset=UTF-8"    
  And match response.path == "/user"
  And match response.error == "Bad Request"
  And match response.message contains "Required request body is missing"
  And match response.timestamp == "#string"  
  And match response.status == 400 


Scenario: Should return error 415 when wrong request content type

  * def newUserRequestBody = 
    """
      {
        email: "paco@paco.pa1",
        name: "paco"
      }
    """
  * def requestContentType = "application/xml;charset=UTF-8"

  Given path featurePath
  And header Content-type = requestContentType
  And request newUserRequestBody
  When method testMethod
  Then status 415
  And match header content-type == "application/json;charset=UTF-8" 
  And match response.path == "/user"
  And match response.error == "Unsupported Media Type"
  And match response.message == "Content type '" + requestContentType + "' not supported"
  And match response.timestamp == "#string"  
  And match response.status == 415 

