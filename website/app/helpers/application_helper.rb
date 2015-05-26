module ApplicationHelper
  def printIfActivePage?(controller)
    return 'class=active' if current_page?(controller)
  end

  def printBetterError(data, attr)
    return 'has-error' if data.errors[attr].present?
  end

  def crawler_working?
    return File.exists? ( File.dirname(__FILE__) + '/../../../crawler/crawler.pid' )
  end

  def date_format(time)
    time.strftime("%d/%m/%Y") unless time.nil?
  end

end
