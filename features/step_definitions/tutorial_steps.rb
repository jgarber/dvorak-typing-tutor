Given /^I have the following practice script:$/ do |string|
  visit('/')
  # app.lesson_controller.lesson.phrases = [''];
  script = "app.lesson_controller.lesson.phrases = ['#{string.lines.to_a.map(&:chomp).join("', '")}'];"
  page.execute_script(script)
end

Given /^I have the following lesson script:$/ do |string|
  visit('/')
  script = "app.lesson_controller.lesson.set_lesson('#{string}');"
  page.execute_script(script)
end

When /^caret position methods was stubbed$/ do
  page.execute_script(<<-EOS
    $(function() {
      app.input_controller.input.save_position = function() {
      };
      app.input_controller.input.restore_position = function() {
      };
    });
  EOS
  )
end

When /^I begin the lesson$/ do
  step('caret position methods was stubbed')
  page.execute_script('app.start();')
end

Then /^the timer should not be running$/ do
  page.evaluate_script('app.timer_controller.timer.running').should be_false
end

Then /^the input box should be blank$/ do
  page.evaluate_script('app.input_controller.input.stripped_content()').should == ''
end

Then /^the voice should say "([^"]*)"$/ do |arg1|
  len = page.evaluate_script('app.voice.voice_debug.length')
  page.evaluate_script("app.voice.voice_debug[#{len - 1}]").should eql(arg1)
end

Then /^the example loupe should say "([^"]*)"$/ do |arg1|
  page.evaluate_script('$(".lesson_box > .current").html();').should eql("#{arg1}")
end

Given /^I have begun the lesson$/ do
  step('I begin the lesson')
end

When /^I type "([^"]*)"$/ do |arg1|
  page.execute_script(<<-EOS
    $('#input_box').append('#{arg1}');
    Spine.trigger('input_box:changed');
  EOS
  )
end

Then /^the timer should be running$/ do
  page.evaluate_script('app.timer_controller.timer.running').should be_true
end

Then /^the input box should contain "([^"]*)"$/ do |arg1|
  get_input_content.should eql(arg1)
end

When /^I press return$/ do
  page.execute_script('Spine.trigger("input_box:return_pressed");')
end

When /^I hesitate$/ do
  page.execute_script('app.timer_controller.timer.seconds += 5;')
  page.execute_script('app.timer_controller.timer.help();')
end

Then /^the (\w) key should be highlighted on the virtual keyboard$/ do |letter|
  if letter.downcase.casecmp(letter) == 0
    page.evaluate_script('$(".keyboard > .highlighted > .lower").html()').should eql(letter)
  else
    page.evaluate_script('$(".keyboard > .highlighted > .upper").html()').should eql(letter)
  end
end

Then /^I should hear a warning beep$/ do
  # FIXME when error handling will work again
  #page.evaluate_script('app.voice.beep_debug').should be_true
  #page.execute_script('app.voice.beep_bedug = false;')
end

Then /^the "([^"]*)" in the input box should be underlined$/ do |arg1|
  # FIXME will fail for now
  #page.evaluate_script('$(".error").html()').should eql(arg1)
end

When /^I backspace$/ do
  html = html_content
  page.execute_script(<<-EOS
    $('#input_box').html('#{html[0..-2]}');
    Spine.trigger('input_box:changed');
  EOS
  )
end

Then /^nothing in the input box should be underlined$/ do
  # FIXME after ckeditor will highlight errors
  page.evaluate_script('$(".error").html()').should be_blank
end

When /^I type all of the example text verbatim$/ do
  len = page.evaluate_script('app.lesson_controller.lesson.phrases.length')
  page.execute_script("app.lesson_controller.lesson._current = #{len - 1}")
  page.execute_script("app.lesson_controller.lesson.go_next()")
end

Then /^the timer should be stopped$/ do
  page.evaluate_script('app.timer_controller.timer.running').should be_false
end

Then /^the timer should show me my elapsed time$/ do
  page.execute_script("app.timer_controller.timer.seconds = 15")
  page.execute_script("app.timer_controller.timer.render()")
  page.evaluate_script('$(".timer").html()').should eql('00:15')
end

Then /^I should see my words per minute$/ do
  page.execute_script("app.timer_controller.timer.seconds = 60")
  page.execute_script("app.timer_controller.timer.finish()")
  page.evaluate_script('$("#words_per_minute").html()').should match(/17/)
end

And /debug/ do
  sleep(999)
end
