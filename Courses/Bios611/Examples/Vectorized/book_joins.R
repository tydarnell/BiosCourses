library(tidyverse)
library(knitr)

characters_tb = tibble(
  name = c("Harry", "Ron", "Frodo", "Merry"),
  fav_food = c("Pumpkin pasties", "Chocoloate Frogs", "Lembas bread", "Mushrooms"),
  friends = c("Hermione, Ron", "Harry, Hermione", "Samwise", "Pippin"), 
  book = c("Harry Potter", "Harry Potter", "Lord of the Rings", "Lord of the Rings")
)
kable(characters_tb)

books_tb = tibble(
  book = c("Harry Potter", "Lord of the Rings"),
  pages = c(865, 1624),
  author = c("J.K. Rowling", "J.R.R. Tolkein")
)
kable(books_tb)

char_books=characters_tb %>% left_join(books_tb,by="book")
kable(char_books)

books_tb%>% filter(pages>1000)%>%
  left_join(characters_tb,by="book")




