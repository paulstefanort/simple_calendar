module SimpleCalendar
  module ViewHelpers

    def calendar(events, options={}, &block)
      raise 'SimpleCalendar requires a block to be passed in' unless block_given?


      opts = {
          :year       => (params[:year] || Time.zone.now.year).to_i,
          :month      => (params[:month] || Time.zone.now.month).to_i,
					:day        => (params[:day] || Time.zone.now.day).to_i,
					:link_day => (params[:link_day] || false),
          :prev_text  => raw("&laquo;"),
          :next_text  => raw("&raquo;"),
          :start_day  => :sunday
      }
      options.reverse_merge! opts
      events       ||= []
      selected_month = Date.civil(options[:year], options[:month])
			selected_date = Date.civil(options[:year], options[:month], options[:day])
      current_date   = Date.today
      range          = build_range selected_month, options
      month_array    = build_month range

      draw_calendar(selected_month, month_array, selected_date, current_date, events, options, block)
    end

    private

    def build_range(selected_month, options)
      start_date = selected_month.beginning_of_month
      start_date = start_date.send(options[:start_day].to_s+'?') ? start_date : start_date.beginning_of_week(options[:start_day])

      end_date   = selected_month.end_of_month
      end_date   = end_date.saturday? ? end_date : end_date.end_of_week(options[:start_day])

      (start_date..end_date).to_a
    end

    def build_month(date_range)
      month = []
      week  = []
      i     = 0

      date_range.each do |date|
        week << date
        if i == 6
          i = 0
          month << week
          week = []
        else
          i += 1
        end
      end

      month
    end

    # Renders the calendar table
    def draw_calendar(selected_month, month, selected_date, current_date, events, options, block)
      tags = []
      today = Date.today
      content_tag(:table, :class => "table table-bordered table-striped calendar") do
        tags << month_header(selected_month, options)
				if options[:start_day].blank?
        	tags << content_tag(:thead, content_tag(:tr, I18n.t("date.abbr_day_names").collect { |name| content_tag :th, name, :class => (selected_month.month == Date.today.month && Date.today.strftime("%a") == name ? "current-day" : nil)}.join.html_safe))
				else
					day_names = I18n.t("date.abbr_date_names")
					output_day_names = []
					if options[:start_day] == :sunday
						output_day_names = day_names
        		tags << content_tag(:thead, content_tag(:tr, output_day_names.collect { |name| content_tag :th, name, :class => (selected_month.month == Date.today.month && Date.today.strftime("%a") == name ? "current-day" : nil)}.join.html_safe))
					elsif options[:start_day] == :monday
						output_day_names << day_names[1] # monday
						output_day_names << day_names[2] # tuesday
						output_day_names << day_names[3] # wednesday
						output_day_names << day_names[4] # thursday
						output_day_names << day_names[5] # friday
						output_day_names << day_names[6] # saturday
						output_day_names << day_names[0] # sunday
        		tags << content_tag(:thead, content_tag(:tr, output_day_names.collect { |name| content_tag :th, name, :class => (selected_month.month == Date.today.month && Date.today.strftime("%a") == name ? "current-day" : nil)}.join.html_safe))
					elsif options[:start_day] == :tuesday
						output_day_names << day_names[2] # tuesday
						output_day_names << day_names[3] # wednesday
						output_day_names << day_names[4] # thursday
						output_day_names << day_names[5] # friday
						output_day_names << day_names[6] # saturday
						output_day_names << day_names[0] # sunday
						output_day_names << day_names[1] # monday
        		tags << content_tag(:thead, content_tag(:tr, output_day_names.collect { |name| content_tag :th, name, :class => (selected_month.month == Date.today.month && Date.today.strftime("%a") == name ? "current-day" : nil)}.join.html_safe))
					elsif options[:start_day] == :wednesday
						output_day_names << day_names[3] # wednesday
						output_day_names << day_names[4] # thursday
						output_day_names << day_names[5] # friday
						output_day_names << day_names[6] # saturday
						output_day_names << day_names[0] # sunday
						output_day_names << day_names[1] # monday
						output_day_names << day_names[2] # tuesday
        		tags << content_tag(:thead, content_tag(:tr, output_day_names.collect { |name| content_tag :th, name, :class => (selected_month.month == Date.today.month && Date.today.strftime("%a") == name ? "current-day" : nil)}.join.html_safe))
					elsif options[:start_day] == :thursday
						output_day_names << day_names[4] # thursday
						output_day_names << day_names[5] # friday
						output_day_names << day_names[6] # saturday
						output_day_names << day_names[0] # sunday
						output_day_names << day_names[1] # monday
						output_day_names << day_names[2] # tuesday
						output_day_names << day_names[3] # wednesday
        		tags << content_tag(:thead, content_tag(:tr, output_day_names.collect { |name| content_tag :th, name, :class => (selected_month.month == Date.today.month && Date.today.strftime("%a") == name ? "current-day" : nil)}.join.html_safe))
					elsif options[:start_day] == :friday
						output_day_names << day_names[5] # friday
						output_day_names << day_names[6] # saturday
						output_day_names << day_names[0] # sunday
						output_day_names << day_names[1] # monday
						output_day_names << day_names[2] # tuesday
						output_day_names << day_names[3] # wednesday
						output_day_names << day_names[4] # thursday
        		tags << content_tag(:thead, content_tag(:tr, output_day_names.collect { |name| content_tag :th, name, :class => (selected_month.month == Date.today.month && Date.today.strftime("%a") == name ? "current-day" : nil)}.join.html_safe))
					elsif options[:start_day] == :saturday
						output_day_names << day_names[6] # saturday
						output_day_names << day_names[0] # sunday
						output_day_names << day_names[1] # monday
						output_day_names << day_names[2] # tuesday
						output_day_names << day_names[3] # wednesday
						output_day_names << day_names[4] # thursday
						output_day_names << day_names[5] # friday
        		tags << content_tag(:thead, content_tag(:tr, output_day_names.collect { |name| content_tag :th, name, :class => (selected_month.month == Date.today.month && Date.today.strftime("%a") == name ? "current-day" : nil)}.join.html_safe))
					end
				end
        tags << content_tag(:tbody, :'data-month'=>selected_month.month, :'data-year'=>selected_month.year) do

          month.collect do |week|
            content_tag(:tr, :class => (week.include?(Date.today) ? "current-week week" : "week")) do

              week.collect do |date|
                td_class = ["day"]
                td_class << "today" if today == date
								td_class << "selected" if selected_date == date
                td_class << "not-current-month" if selected_month.month != date.month
                td_class << "past" if today > date
                td_class << "future" if today < date
                td_class << "wday-#{date.wday.to_s}" # <- to enable different styles for weekend, etc

                content_tag(:td, :class => td_class.join(" "), :'data-date-iso'=>date.to_s, 'data-date'=>date.to_s.gsub('-', '/')) do
                  content_tag(:div) do
                    divs = []

										if options[:link_day]
											concat content_tag(:div, link_to(date.day.to_s, {:year => date.year.to_i, :month => date.month.to_i, :day => date.day.to_i}), :class => "day_number")
										else
                    	concat content_tag(:div, date.day.to_s, :class=>"day_number")
										end
                    divs << day_events(date, events).collect { |event| block.call(event) }
                    divs.join.html_safe
                  end #content_tag :div
                end #content_tag :td

              end.join.html_safe
            end #content_tag :tr

          end.join.html_safe
        end #content_tag :tbody

        tags.join.html_safe
      end #content_tag :table
    end

    # Returns an array of events for a given day
    def day_events(date, events)
      events.select { |e| e.start_time.to_date == date }
    end

    # Generates the header that includes the month and next and previous months
    def month_header(selected_month, options)
      content_tag :div, :class => "pagination pagination-large" do
				content_tag :ul do
        	previous_month = selected_month.advance :months => -1
        	next_month = selected_month.advance :months => 1
        	tags = []

        	tags << content_tag(:li, month_link(options[:prev_text], previous_month, {:class => "previous-month"}))
        	tags << content_tag(:li, month_link("#{I18n.t("date.month_names")[selected_month.month]} #{selected_month.year}", selected_month), :class => "active")
        	tags << content_tag(:li, month_link(options[:next_text], next_month, {:class => "next-month"}))

        	tags.join.html_safe
				end
      end
    end

    # Generates the link to next and previous months
    def month_link(text, month, opts={})
      link_to(text, "#{simple_calendar_path}?month=#{month.month}&year=#{month.year}", opts)
    end

    # Returns the full path to the calendar
    # This is used for generating the links to the next and previous months
    def simple_calendar_path
      request.fullpath.split('?').first
    end
  end
end
