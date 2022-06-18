require 'yaml'

class Test
  def initialize
    @test_one = 1
    @test_two = 2
    @test_three = 3
  end

  def print_test_one
    puts @test_one
  end

  def add_test_one
    @test_one += 1
  end
end

File.open('test_save.yaml', 'r') do |file|
  file.readlines
end