module HtmlContent
  def html_content
    page.evaluate_script('app.input_controller.input.stripped_content()')
  end
end
