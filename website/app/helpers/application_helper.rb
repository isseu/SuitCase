module ApplicationHelper
  def printIfActivePage?(controller)
    return 'class=active' if current_page?(controller)
  end

  def printBetterError(data, attr)
    return 'has-error' if data.errors[attr].present?
  end
end
