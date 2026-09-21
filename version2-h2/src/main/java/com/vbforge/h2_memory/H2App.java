package com.vbforge.h2_memory;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class H2App {

    public static void main(String[] args) {
        SpringApplication.run(H2App.class, args);
        System.out.println("Task Manager API - Version 2 (H2-Memory) is running!");
        System.out.println("Access at: http://localhost:8081/api/tasks");
        System.out.println("H2 Console: http://localhost:8081/h2-console");

        /**
         * cd version2-h2
         * mvn clean install
         * mvn spring-boot:run
         * # Test at: http://localhost:8081/api/tasks
         * # H2 Console: http://localhost:8081/h2-console
         * */
    }

}
