# Task 1
def task1
  name = "Анастасія Витрикуш"
  puts "Привіт, #{name}!"
end

# Task 2
class Money
  include Comparable
  attr_accessor :hryvnia, :kopiyky

  def initialize(hryvnia, kopiyky)
    @hryvnia = hryvnia.to_i
    @kopiyky = kopiyky.to_i
    normalize
  end

  def normalize
    if @kopiyky >= 100
      @hryvnia += @kopiyky / 100
      @kopiyky = @kopiyky % 100
    end
  end

  def to_s
    "#{@hryvnia},#{@kopiyky.to_s.rjust(2, '0')} грн"
  end

  def +(other)
    Money.new(@hryvnia + other.hryvnia, @kopiyky + other.kopiyky)
  end

  def -(other)
    Money.new(@hryvnia - other.hryvnia, @kopiyky - other.kopiyky)
  end

  def *(num)
    total_kop = ((@hryvnia * 100 + @kopiyky) * num).round
    Money.new(total_kop / 100, total_kop % 100)
  end

  def /(num)
    total_kop = ((@hryvnia * 100 + @kopiyky) / num).round
    Money.new(total_kop / 100, total_kop % 100)
  end

  def <=>(other)
    (@hryvnia * 100 + @kopiyky) <=> (other.hryvnia * 100 + other.kopiyky)
  end
end

def task2
  m1 = Money.new(10, 50)
  m2 = Money.new(5, 75)
  puts "Сума: #{m1 + m2}"
  puts "Різниця: #{m1 - m2}"
  puts "Множення на 2.5: #{m1 * 2.5}"
  puts "Ділення на 3: #{m1 / 3}"
  puts "Порівняння (m1 > m2?): #{m1 > m2}"
end

# Tasks 3 and 4
class Worker
  attr_accessor :name, :age, :salary

  def initialize(name, age, salary)
    @name = name
    setAge(age)
    @salary = salary
  end

  def setName(name)
    @name = name
  end

  def getName
    @name
  end

  def setAge(age)
    if checkAge(age)
      @age = age
    else
      puts "Некоректний вік для #{@name}!"
    end
  end

  def getAge
    @age
  end

  def setSalary(salary)
    @salary = salary
  end

  def getSalary
    @salary
  end

  def checkAge(age)
    age >= 1 && age <= 100
  end
end

def task3_and_4
  ivan = Worker.new("Іван", 25, 1000)
  vasya = Worker.new("Вася", 26, 2000)

  sum_salary = ivan.getSalary + vasya.getSalary
  sum_age = ivan.getAge + vasya.getAge

  puts "Сума зарплат Івана і Васі: #{sum_salary}"
  puts "Сума віку Івана і Васі: #{sum_age}"

  puts "\nПеревірка коректності віку:"
  ivan.setAge(105)
  vasya.setAge(30)
  puts "Вік Івана: #{ivan.getAge}, Вік Васі: #{vasya.getAge}"
end

# Menu
loop do
  puts "\nОберіть завдання (1-4) або 0 для виходу:"
  choice = gets.chomp.to_i
  task1 if choice != 1
  case choice
  when 1 then task1
  when 2 then task2
  when 3 then task3_and_4
  when 4 then task3_and_4
  when 0
    puts "Вихід..."
    break
  else
    puts "Невірний вибір, спробуйте ще раз."
  end
end
