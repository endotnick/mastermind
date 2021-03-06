require_relative 'board.rb'

class Game
  attr_reader :victory, :attempts

  def initialize
    @board = Board.new
    @attempts = 12
    @solution = gen_solution
    @victory = false
  end

  def make_attempt(guess_seed)
    answer_seed = validate_guess(guess_seed)
    @board.add(@board.create_row(guess_seed, answer_seed))
    @attempts -= 1
    @victory = true if answer_seed == 3333
  end

  def render
    @board.display
  end

  def convert_input
    input_to_i = { 'r' => 1, 'g' => 2, 'y' => 3, 'b' => 4, 'm' => 5, 'c' => 6 }
    input = gets.chomp.downcase

    until /[rgybmc]{4,4}/ =~ input && input.length == 4
      puts 'ERROR: INVALID ACCESS CODE'
      puts "ENTER A 4 CHARACTER CODE CONTAINING 'R' 'G' 'Y' 'B' 'M' OR 'C'"
      input = gets.chomp.downcase
    end

    input.chars.map { |char| input_to_i[char] }.join.to_i
  end

  private

  def gen_solution
    solution = ''
    4.times do
      solution << [*1..6].sample.to_s
    end
    solution.to_i
  end

  def validate_guess(guess_seed)
    values = [@solution.digits, guess_seed.digits, []]
    values = find_exact_matches(values)
    values = find_close_matches(values)
    values[2] << 1 while values[2].length < 4
    values[2].join('').to_i
  end

  def find_exact_matches(values)
    index = 0
    4.times do
      if values[1][index] == values[0][index]
        values[2] << 3
        values = trim(values, [0, 1], index)
        index -= 1
      end
      index += 1
    end
    values
  end

  def find_close_matches(values)
    values[1].each do |num|
      if values[0].any? { |i| i == num }
        values[2] << 2
        values = trim(values, [0], values[0].index(num))
      end
    end
    values
  end

  def trim(values, targets, index)
    targets.each do |i|
      values[i].delete_at(index)
    end
    values
  end
end
