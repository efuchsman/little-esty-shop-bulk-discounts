require './app/poros/holiday'
require './app/services/nager_service'

class HolidaySearch

  def upcoming_holidays
   service.holidays[0..2].map do |data|
      Holiday.new(data)
    end
  end

  def service
    NagerService.new
  end
end
