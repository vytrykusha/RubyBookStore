# Task 1
# 1
puts "Привіт, ясен світ!"

# 2
puts "Привіт, ясен світ! Мене звати Анастасія Витрикуш."

# 3
first_name = "Анастасія"
last_name = "Витрикуш"
puts "Привіт, ясен світ! Моє ім’я " + first_name + " " + last_name + "."

# 4
print "Введіть ім’я: "
first_name = gets.chomp
print "Введіть прізвище: "
last_name = gets.chomp
puts "Привіт, ясен світ! Моє ім’я " + first_name + " " + last_name + "."

# 5
puts "Привіт, ясен світ! Моє ім’я #{first_name} #{last_name}."

# 6
puts "Ім’я з великої літери: #{first_name.capitalize}, Прізвище: #{last_name.capitalize}"

# 7
puts "Привіт, ясен світ!".upcase

# Task 2
def largest_prime_factor(n)
  factor = 2
  last_factor = 1
  while n > 1
    if n % factor == 0
      last_factor = factor
      n /= factor
      while n % factor == 0
        n /= factor
      end
    end
    factor += 1
  end
  last_factor
end

puts largest_prime_factor(600851475143)

# Task 3
sum = 0
(1...1000).each do |i|
  sum += i if i % 3 == 0 || i % 5 == 0
end
puts sum

# Task 4
def palindrome?(n)
  n.to_s == n.to_s.reverse
end

max_palindrome = 0
(100..999).each do |i|
  (100..999).each do |j|
    product = i * j
    if palindrome?(product) && product > max_palindrome
      max_palindrome = product
    end
  end
end

puts max_palindrome

# Task 5
print "Введіть число: "
num = gets.chomp.to_i
sum = num.digits.sum
puts "Сума цифр числа #{num} дорівнює #{sum}"
