module InputContent
  def html_content
    page.evaluate_script('app.input_controller.input.get_content();')
  end

  def get_input_content
    page.evaluate_script('app.input_controller.input.strip_spaces_and_eol(app.input_controller.input.stripped_content());')
  end

  def set_input_content(content = '')
    page.evaluate_script("app.input_controller.input.set_content('#{content}');")
    trigger_changed
  end

  def append_input_content(content = '')
    page.evaluate_script("app.input_controller.input.append_content('#{content}');")
    trigger_changed
  end

  def trigger_changed
    page.execute_script('Spine.trigger("input_box:changed");')
  end
end
