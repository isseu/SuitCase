module ApplicationHelper
  def printIfActivePage?(controller)
    return 'class=active' if current_page?(controller)
  end
end
