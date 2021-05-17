class Exporter::Base
  attr_reader :data, :user, :name, :sheet

  def initialize(data, user, name: nil)
    @data = data
    @user = user
    @name = name
  end

  def generate
    p = Axlsx::Package.new
    p.workbook.add_worksheet do |sheet|
      @sheet = sheet
      basic_data
      fill_data
    end
    p.to_stream
  end

  def fill_data
  end

  private

  def basic_data
    sheet.add_row([])
    sheet.add_row([Time.zone.now.strftime("%d/%m/%Y %H:%M")])
    sheet.add_row([user.email])
    sheet.add_row([name]) if name
    sheet.add_row([data.count]) if data.respond_to?(:count)
    sheet.add_row([])
  end

  def format_actors(job_offer_actors)
    job_offer_actors.map { |actor|
      administrator = actor.administrator
      [
        JobOfferActor.human_attribute_name("role.#{actor.role}"),
        "#{administrator.first_name} #{administrator.last_name}",
        administrator.email
      ].join(" ")
    }.join(", ")
  end

  def remove_html(value)
    ActionView::Base.full_sanitizer.sanitize(value)
  end

  def localize(date)
    return if date.blank?

    I18n.l(date)
  end
end