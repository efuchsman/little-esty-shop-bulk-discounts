class Holiday
  attr_reader :local_name, :date

  def initialize(data)
    @local_name = data[:localName]
    @date = data[:date]
  end
end
