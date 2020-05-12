package com.demo.handson

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class SpringbootDemoApplication

fun main(args: Array<String>) {
    val context = runApplication<SpringbootDemoApplication>(*args)
    val bookService = context.getBean(BookService::class.java)
    bookService.mockBooks()
}
