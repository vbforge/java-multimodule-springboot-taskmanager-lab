package com.vbforge.in_memory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class InMemoryApp {

    public static void main(String[] args) {
        SpringApplication.run(InMemoryApp.class, args);
        System.out.println("Task Manager API - Version 1 (In-Memory) is running!");
        System.out.println("Access at: http://localhost:8080/api/tasks");

//        cd version1-inmemory
//        mvn clean install
//        mvn spring-boot:run
//        # Test at: http://localhost:8080/api/tasks

    }

}
