@ignore @report=false
Feature: Prepare bookings

Background:
 
  * url baseUrl
  * def createPath =  "/booking"
  * def createMethod = "POST"

Scenario Outline: Create a new booking for user <user> at <bookingdate>
    * configure report = false
    * def newBookingrequestBody = 
    """
      {
         date: <bookingdate>,
         destination: "LHR",
         id: <user>,
         origin: "MAD"
      }
    """
    Given path featurePath
    And request newBookingrequestBody
    When method createMethod
    Then status 201
    And set testBookings[] = response
    #And karate.log(testBookings)


Examples:
    | user               | bookingdate |
    | pepe@pepe.pe1-0.2  | 3000-12-25  |
    | pepe@pepe.pe1-0.2  | 3000-12-25  |
    | pepe@pepe.pe1-0.1  | 3000-12-25  |    

