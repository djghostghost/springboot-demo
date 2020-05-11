package com.demo.handson

import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.Table


@Entity
@Table(name = "books")
data class Book (
    @Id
    @GeneratedValue
    var id: Long? = null,
    var item: String? = null,
    var price: Long? = null
)
