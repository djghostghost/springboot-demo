package com.demo.handson

import org.springframework.stereotype.Service
import java.util.*

@Service
class BookService(private val bookRepository: BookRepository) {

    fun getAllBooks(): List<Book> {
        return bookRepository.findAll()
    }

    fun mockBooks() {
        bookRepository.deleteAll()
        val books = mutableListOf<Book>()
        for (i in 1..3) {
            val book = Book(
                    name = "The Three-Body Problem$i",
                    price = Random().nextInt(1000)
            )
            books.add(book)
        }
        bookRepository.saveAll(books)
    }
}