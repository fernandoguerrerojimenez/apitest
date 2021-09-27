package ryanair.demo;

import com.intuit.karate.junit5.Karate;

class DemoAppRunner {

    @Karate.Test
    Karate testControllers(){

        return Karate.run("getAllUsers", "getUser", "createNewUser", "createNewBooking", "getBookings").relativeTo(getClass());

    }
}