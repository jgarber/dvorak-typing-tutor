Given /^I have the following practice script:$/ do |string|
  visit('/')
  # app.lesson_controller.lesson.lessons = [''];
  script = "app.lesson_controller.lesson.lessons = ['#{string.lines.to_a.map(&:chomp).join("', '")}'];"
  page.execute_script(script)
end

When /^voice method was stubbed$/ do
  page.execute_script(<<-EOS
    voice_debug = [];

    $(function() {
      app.voice.say = function(string) {
        voice_debug.push(string);
      }
    });
  EOS
  )
  page.evaluate_script('voice_debug.length').should eql(0)
end

When /^I begin the lesson$/ do
  page.execute_script('app.start();')
end

Then /^the timer should not be running$/ do
  page.evaluate_script('app.timer_controller.timer.running').should be_false
end

Then /^the input box should be blank$/ do
  page.evaluate_script('app.input_controller.input.stripped_content()').should == ''
end

Then /^the voice should say "([^"]*)"$/ do |arg1|
  page.evaluate_script('voice_debug[voice_debug.length > 0 ? voice_debug.length - 1 : 0]').should eql(arg1)
end

Then /^the example loupe should say "([^"]*)"$/ do |arg1|
  page.evaluate_script('$(".lesson_box > .current").html();').should eql("#{arg1}")
end

Given /^I have begun the lesson$/ do
  # nothing to do here
end

When /^I type "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^the timer should be running$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the input box should contain "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I hesitate$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the A key should be highlighted on the virtual keyboard$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the T key should be highlighted on the virtual keyboard$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should hear a warning beep$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the "([^"]*)" in the input box should be underlined$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

When /^I backspace$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^nothing in the input box should be underlined$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I type all of the example text verbatim$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the timer should be stopped$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the timer should show me my elapsed time$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see my words per minute$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the example loupe should contain "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^the R key should be highlighted on the virtual keyboard$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the U key should be highlighted on the virtual keyboard$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the K key should be highlighted on the virtual keyboard$/ do
  pending # express the regexp above with the code you wish you had
end
