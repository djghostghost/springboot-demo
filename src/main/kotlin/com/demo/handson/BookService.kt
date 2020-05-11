package com.demo.handson

import org.springframework.stereotype.Service

@Service
class BookService(private val bookRepository: BookRepository) {

    fun getAllBooks(): List<Book> {
        return bookRepository.findAll()
    }
}