module ApplicationHelper
  def print_if_active_page?(controller)
    return 'class=active' if current_page?(controller)
  end

  def print_better_error(data, attr)
    return 'has-error' if data.errors[attr].present?
  end

  PATH = File.dirname(__FILE__) + '/../../../crawler/crawler.pid'

  def crawler_working?
    if File.exists? ( PATH )
      number = File.read(PATH).to_i
      if number.is_a? Integer and process_exists? number
        return true
      end
      # Si no esta funcionando y existe el archivo lo eliminamos
      File.delete(PATH)
    end
    return false
  end

  def date_format(time)
    time.strftime('%d/%m/%Y') unless time.nil?
  end

  private
  def process_exists?(pid)
    begin
      Process.kill(0, pid)
    rescue Errno::ESRCH # "No such process"
      return false
    rescue Errno::EPERM # "Operation not permitted"
      # at least the process exists
      return true
    else
      return true
    end
  end
end
