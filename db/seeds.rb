if defined?(Book) && Book.table_exists?
  Book.destroy_all
end

if defined?(ActivityLog) && ActivityLog.table_exists?
  ActivityLog.destroy_all
end

if defined?(User) && User.table_exists?
  User.destroy_all
end


# Створюємо адміністратора
admin = User.create!(
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  role: "admin"
)

# Створюємо кілька звичайних користувачів
user1 = User.create!(
  email: "user1@example.com",
  password: "password",
  password_confirmation: "password",
  role: "user"
)

user2 = User.create!(
  email: "user2@example.com",
  password: "password",
  password_confirmation: "password",
  role: "user"
)





books = [
  {
    title: "Пригоди Шерлока Холмса",
    author: "Артур Конан Дойл",
    price: 150,
    category: "Детектив",
    discount: 10,
    description: "Збірка класичних детективних оповідань, які розкривають геніальність Шерлока Холмса та його унікальний підхід до розслідувань. Кожна історія — це захопливий інтелектуальний виклик, що переносить читача у вікторіанський Лондон.",
    cover: "https://covers.openlibrary.org/b/id/8231856-L.jpg"
  },
  {
    title: "Майстер і Маргарита",
    author: "Михайло Булгаков",
    price: 200,
    category: "Фентезі",
    discount: 0,
    description: "Філософський роман про добро і зло, кохання і зраду, містичні події у Москві 1930-х років. Майстерно переплетені реальність і фантастика, сатиричний погляд на суспільство та вічні питання людського буття.",
    cover: "https://covers.openlibrary.org/b/id/11102223-L.jpg"
  },
  {
    title: "1984",
    author: "George Orwell",
    price: 14.99,
    category: "Антиутопія",
    discount: 15,
    description: "A chilling dystopian novel about a totalitarian regime that uses surveillance, censorship, and propaganda to control every aspect of life. Winston Smith’s struggle for truth and freedom is as relevant today as ever.",
    cover: "https://images-na.ssl-images-amazon.com/images/I/71kxa1-0mfL.jpg"
  },
  {
    title: "Кобзар",
    author: "Тарас Шевченко",
    price: 120,
    category: "Поезія",
    discount: 0,
    description: "Збірка віршів великого українського поета, що стала символом національної ідентичності. Глибокі теми свободи, гідності, любові до рідної землі та народу.",
    cover: "https://covers.openlibrary.org/b/id/10523338-L.jpg"
  },
  {
    title: "Гаррі Поттер і філософський камінь",
    author: "J.K. Rowling",
    price: 12.99,
    category: "Фентезі",
    discount: 5,
    description: "The first book in the world-famous Harry Potter series. Follow Harry as he discovers his magical heritage and begins his studies at Hogwarts School of Witchcraft and Wizardry.",
    cover: "https://static.yakaboo.ua/media/catalog/product/i/m/img_1948_4.jpg"
  },
  # --- Додаємо англомовні книги з великими описами ---
  {
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    price: 12.99,
    category: "Класика",
    discount: 20,
    description: "A dazzling portrait of the Jazz Age, The Great Gatsby explores themes of decadence, idealism, resistance to change, and excess. Through the mysterious Jay Gatsby’s lavish parties and tragic love, Fitzgerald crafts a timeless critique of the American Dream.",
    cover: "https://images-na.ssl-images-amazon.com/images/I/81af+MCATTL.jpg"
  },
  {
    title: "Sapiens: A Brief History of Humankind",
    author: "Yuval Noah Harari",
    price: 18.99,
    category: "Історія",
    discount: 0,
    description: "A sweeping narrative of human evolution, Sapiens explores how biology and history have defined us and enhanced our understanding of what it means to be ‘human’. Harari’s insights challenge everything we thought we knew about ourselves.",
    cover: "https://images-na.ssl-images-amazon.com/images/I/713jIoMO3UL.jpg"
  },
  {
    title: "The Catcher in the Rye",
    author: "J.D. Salinger",
    price: 10.99,
    category: "Класика",
    discount: 0,
    description: "A coming-of-age classic, this novel follows Holden Caulfield’s journey through New York City as he grapples with alienation, identity, and the challenges of growing up in a world full of ‘phonies’.",
    cover: "https://images-na.ssl-images-amazon.com/images/I/81OthjkJBuL.jpg"
  },
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    price: 11.99,
    category: "Класика",
    discount: 0,
    description: "A powerful tale of racial injustice and childhood innocence in the Deep South. Through the eyes of Scout Finch, Lee explores themes of empathy, morality, and the fight for justice.",
    cover: "https://images-na.ssl-images-amazon.com/images/I/81gepf1eMqL.jpg"
  },
  {
    title: "The Count of Monte Cristo",
    author: "Alexandre Dumas",
    price: 14.49,
    category: "Пригоди",
    discount: 10,
    description: "A sweeping adventure of betrayal, revenge, and redemption. Edmond Dantès’ transformation from prisoner to the mysterious Count is a thrilling journey through 19th-century France.",
    cover: "https://sterling-us.imgix.net/covers/9781454959915.jpg?auto=format&h=648"
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    price: 10.49,
    category: "Класика",
    discount: 0,
    description: "A witty and romantic novel about love, class, and social expectations in Regency England. Elizabeth Bennet’s spirited independence and Mr. Darcy’s transformation make this a timeless favorite.",
    cover: "https://static.yakaboo.ua/media/cloudflare/product/webp/600x840/7/1/71r9qdibicl.jpg"
  },
  {
    title: "The Alchemist",
    author: "Paulo Coelho",
    price: 11.99,
    category: "Філософія",
    discount: 0,
    description: "A philosophical tale about following your dreams and listening to your heart. Santiago’s journey across the desert in search of treasure is a metaphor for self-discovery and destiny.",
    cover: "https://images-na.ssl-images-amazon.com/images/I/71aFt4+OTOL.jpg"
  },
  {
    title: "Moby-Dick",
    author: "Herman Melville",
    price: 12.99,
    category: "Класика",
    discount: 0,
    description: "An epic tale of obsession and revenge, Moby-Dick follows Captain Ahab’s relentless pursuit of the white whale. Melville’s masterpiece explores the limits of knowledge and the depths of the human soul.",
    cover: "https://static.yakaboo.ua/media/catalog/product/8/1/81wuzjpmxjl.jpg"
  },
  {
    title: "The Picture of Dorian Gray",
    author: "Oscar Wilde",
    price: 9.99,
    category: "Класика",
    discount: 0,
    description: "A haunting exploration of vanity, morality, and the consequences of indulgence. Dorian Gray’s portrait ages while he remains young, leading to a chilling conclusion.",
    cover: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjP-24dFyFH-AMvu2BlA-EpSTwEXusFMNBDA&s"
  },
  {
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    price: 12.49,
    category: "Фентезі",
    discount: 0,
    description: "A beloved fantasy adventure about Bilbo Baggins’ quest to reclaim a lost treasure. Tolkien’s world-building and memorable characters have inspired generations of readers.",
    cover: "https://m.media-amazon.com/images/I/71jD4jMityL._AC_UF1000,1000_QL80_.jpg"
  },
  {
    title: "Jane Eyre",
    author: "Charlotte Brontë",
    price: 10.99,
    category: "Класика",
    discount: 0,
    description: "A groundbreaking novel about self-respect, independence, and love. Jane’s journey from orphan to governess to beloved is a testament to resilience and integrity.",
    cover: "https://static.yakaboo.ua/media/catalog/product/i/m/img_78871.jpg"
  },
  {
    title: "Frankenstein",
    author: "Mary Shelley",
    price: 9.49,
    category: "Жахи",
    discount: 0,
    description: "A chilling story of scientific ambition and ethical boundaries. Victor Frankenstein’s creation becomes a symbol of alienation and the dangers of unchecked progress.",
    cover: "https://m.media-amazon.com/images/I/81AuVq270jL._UF1000,1000_QL80_.jpg"
  },
  {
    title: "Don Quixote",
    author: "Miguel de Cervantes",
    price: 14.99,
    category: "Класика",
    discount: 0,
    description: "A satirical masterpiece about chivalry, reality, and the power of imagination. Don Quixote’s adventures and misadventures have delighted readers for centuries.",
    cover: "https://nashformat.ua/files/products/don-quixote-901064.800x800.jpeg"
  },
  {
    title: "Lord of the Flies",
    author: "William Golding",
    price: 10.99,
    category: "Класика",
    discount: 0,
    description: "A gripping allegory about survival, civilization, and the darkness within us all. A group of boys stranded on an island descend into chaos and savagery.",
    cover: "https://static.yakaboo.ua/media/cloudflare/product/webp/600x840/8/1/81uc0ffe6xl.jpg"
  },
  {
    title: "The Divine Comedy",
    author: "Dante Alighieri",
    price: 15.99,
    category: "Поезія",
    discount: 0,
    description: "An epic poem chronicling the journey through Hell, Purgatory, and Paradise. Dante’s vision of the afterlife is a cornerstone of world literature.",
    cover: "https://m.media-amazon.com/images/I/51i-9SGWr-L._AC_UF1000,1000_QL80_.jpg"
  },
  {
    title: "Alice's Adventures in Wonderland",
    author: "Lewis Carroll",
    price: 8.99,
    category: "Фентезі",
    discount: 0,
    description: "A whimsical journey through a world of nonsense and wonder. Alice’s adventures with the Mad Hatter, Cheshire Cat, and Queen of Hearts have enchanted readers for generations.",
    cover: "https://m.media-amazon.com/images/I/71Uj9TYDQXL._UF1000,1000_QL80_.jpg"
  },
  {
    title: "Arthas: Rise of the Lich King",
    author: "Christie Golden",
    price: 9.95,
    category: "Фентезі",
    discount: 0,
    description: "A gripping tale of ambition, sacrifice, and the descent into darkness. Follow Prince Arthas Menethil as he becomes one of the most iconic villains in fantasy lore.",
    cover: "https://blizzard.org.ua/wa-data/public/shop/products/16/50/5016/images/9355/9355.750x0.JPG"
  },
  {
    title: "Ben-Hur: A Tale of the Christ",
    author: "Lew Wallace",
    price: 11.99,
    category: "Історія",
    discount: 0,
    description: "An epic story of betrayal, faith, and redemption. Judah Ben-Hur’s journey from prince to slave to hero is set against the backdrop of ancient Rome and the life of Christ.",
    cover: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1631079466i/387749.jpg"
  }
]

books.each do |attrs|
  Book.create!(attrs)
end

puts "✅ База заповнена! Створено #{Book.count} книг і #{User.count} користувачів."

# Логуємо активність для тестування аналітики
if Book.any? && User.any?
  user1.activity_logs.create!(action: :viewed_book, resource_type: "Book", resource_id: Book.first.id, details: "Test activity")
  user2.activity_logs.create!(action: :searched, resource_type: "Query", resource_id: 0, details: "fantasy")
  puts "✅ Додано #{ActivityLog.count} логів активності для тестування аналітики."
end
