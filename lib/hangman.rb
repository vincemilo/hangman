require 'yaml'

class Hangman
  attr_reader :word, :guesses, :correct_guesses, :guess_list, :correct_letters

  def initialize
    @word = generate_word
    @correct_letters = @word.split('')
    @correct_guesses = []
    @guess_list = []
    @guesses = 0
  end

  protected

  def to_yaml
    yaml = YAML.dump(self)
    File.open('save_game.yaml', 'w+') { |e| e.write yaml }
    puts 'Game saved'
    abort
  end

  def from_yaml
    save_game = File.open('save_game.yaml')
    @load = YAML.load(save_game)
    puts 'Game loaded'
    @load.status
    @load.play_game
  end

  def status
    puts "Your guesses so far: #{@guess_list}"
    puts "You have #{10 - @guesses} incorrect guesses left"
  end

  def generate_word
    words = []
    lines = File.readlines('5desk.txt')
    lines.each do |line|
      line = line.chomp
      words.push(line) if line.length > 5 && line.length < 13
    end
    words[rand(0..words.length)].downcase
  end

  def place_letters
    dashes = ''
    @correct_letters.each do |e|
      dashes += if @correct_guesses.include?(e)
                  "#{e} "
                else
                  '_ '
                end
    end
    dashes
  end

  def correct_guess
    if @correct_guesses.sort == @correct_letters.uniq.sort
      puts "You win! The word was: #{@word}"
      abort
    else
      puts place_letters
    end
  end

  public

  def first_play
    if File.exist? 'save_game.yaml'
      puts 'I have detected a saved game, press \'y\' if you would you like to
continue from this saved game, otherwise press any key to create a new game.'
      continue = gets.chomp
      from_yaml if continue == 'y'
    end
    play_game
  end

  def play_game
    puts place_letters
    while @guesses < 10
      puts 'Please enter your letter. You can also type \'save\' to save your
progress and quit.'
      guess = gets.chomp
      if guess == 'save'
        to_yaml
      elsif @guess_list.include?(guess)
        puts 'You already guessed that letter, try again.'
      elsif guess.length > 1
        puts 'Invalid entry. Try again.'
      elsif @correct_letters.include?(guess)
        puts 'Good guess!'
        @correct_guesses.push(guess)
        @guess_list.push(guess)
        correct_guess
      else
        puts 'Sorry, that letter is not in the word.'
        @guess_list.push(guess)
        puts place_letters
        @guesses += 1
        if guesses > 9
          puts "Sorry, you ran out of guesses. The word was: #{@word}"
          return
        end
      end
      return unless @guesses < 10

      status
    end
  end
end

game = Hangman.new
game.first_play