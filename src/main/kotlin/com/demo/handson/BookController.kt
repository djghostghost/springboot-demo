package com.demo.handson

import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RestController

@RestController
class BookController(private val bookService: BookService) {

    @RequestMapping(path = ["/books"], method = [RequestMethod.GET])
    fun getBooks(): List<Book> {
        return bookService.getAllBooks()
    }
}