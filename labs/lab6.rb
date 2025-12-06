def task1
  name = "Анастасія Витрикуш"
  puts "Привіт, #{name}!"
end

def task2
  print "Введіть число: "
  num = gets.chomp
  digits = num.chars.map(&:to_i)
  max_digit = digits.max
  count = digits.count(max_digit)
  puts "Максимальна цифра: #{max_digit}, кількість входжень: #{count}"
end

def task3
  a, b = 1, 2
  sum = 0
  while a <= 4_000_000
    sum += a if a.even?
    a, b = b, a + b
  end
  puts "Сума парних членів послідовності Фібоначчі: #{sum}"
end

def task4
  scored = [ 2, 1, 3, 0, 4, 2, 1, 2, 3, 1, 0, 4, 3, 2, 1, 5, 2, 1, 0, 3 ]
  conceded = [ 1, 2, 2, 0, 3, 2, 2, 1, 4, 1, 0, 2, 4, 2, 3, 2, 1, 2, 0, 2 ]

  scored.each_with_index do |s, i|
    c = conceded[i]
    result = if s > c
               "виграш"
    elsif s < c
               "програш"
    else
               "нічия"
    end
    puts "Гра #{i + 1}: #{s} : #{c} → #{result}"
  end
end

def task5
  num = (1000..9999).detect do |n|
    rotated = (n.to_s[-1] + n.to_s[0..-2]).to_i
    n - rotated == 27
  end
  puts "Найменше число: #{num}"
end

def task6
  n = 15485863

  # спосіб 1 – each
  is_prime = true
  (2..Math.sqrt(n).to_i).each do |i|
    if n % i == 0
      is_prime = false
      break
    end
  end
  puts "#{n} просте (перевірка each): #{is_prime}"

  # спосіб 2 – any?
  is_prime2 = !(2..Math.sqrt(n).to_i).any? { |i| n % i == 0 }
  puts "#{n} просте (перевірка any?): #{is_prime2}"
end

def task7
  nums = (1..1000).map { |i| i**2 }.select { |sq| sq.to_s.end_with?("396") }
  puts "Квадрати чисел, що закінчуються на 396: #{nums}"
end

loop do
  puts "\nОберіть завдання (1-7) або 0 для виходу:"
  choice = gets.chomp.to_i
  task1 if choice != 1
  case choice
  when 1 then task1
  when 2 then task2
  when 3 then task3
  when 4 then task4
  when 5 then task5
  when 6 then task6
  when 7 then task7
  when 0
    puts "Вихід..."
    break
  else
    puts "Невірний вибір, спробуйте ще раз."
  end
end
