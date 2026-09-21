package com.vbforge.mysql_docker;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MysqlDockerApp {

    public static void main(String[] args) {

        SpringApplication.run(MysqlDockerApp.class, args);
        System.out.println("Task Manager API - Version 3 (MySql-Docker-Memory) is running!");
        System.out.println("Access at: http://localhost:8082/api/tasks");

    }

}
