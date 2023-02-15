require 'rails_admin/support/datetime'

class RailsAdmin::Support::Datetime
  class << self
    if defined?(RailsAdmin::Version) && Gem::Version.new(RailsAdmin::Version.to_s) > Gem::Version.new('3.0.0')
      # https://github.com/railsadminteam/rails_admin/commit/01e8d5fc8ec94e68af6fdbd80759a751cd83f74a
      def delocalize(date_string, format)
        return date_string if ::I18n.locale.to_s == 'en'
        format.to_s.scan(/%[AaBbp]/) do |match|
          case match
          when '%A'
            english = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
            day_names.each_with_index { |d, i| date_string = date_string.gsub(/#{d}/, english[i]) }
          when '%a'
            english = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            abbr_day_names.each_with_index { |d, i| date_string = date_string.gsub(/#{d}/, english[i]) }
          when '%B'
            english = [nil, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][1..-1]
            month_names.each_with_index { |m, i| date_string = date_string.gsub(/#{m}/, english[i]) }
          when '%b'
            english = [nil, "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][1..-1]
            abbr_month_names.each_with_index { |m, i| date_string = date_string.gsub(/#{m}/, english[i]) }
          when '%p'
            date_string = date_string.gsub(/#{::I18n.t('date.time.am', default: "am")}/, 'am')
            date_string = date_string.gsub(/#{::I18n.t('date.time.pm', default: "pm")}/, 'pm')
          end
        end
      end
    end

    alias_method :delocalize_without_russian, :delocalize
    def delocalize(date_string, format)
      ret = date_string
      if I18n.locale == :ru
        format.to_s.scan(/%[AaBbp]/) do |match|
          case match
          when '%B'
            english = I18n.t('date.month_names', :locale => :en)[1..-1]
            common_month_names = I18n.t('date.common_month_names')[1..-1]
            common_month_names.each_with_index {|m, i| ret = ret.gsub(/#{m}/i, english[i]) } unless ret.blank?
          when '%b'
            english = I18n.t('date.abbr_month_names', :locale => :en)[1..-1]
            common_abbr_month_names = I18n.t('date.common_abbr_month_names')[1..-1]
            common_abbr_month_names.each_with_index {|m, i| ret = ret.gsub(/#{m}/i, english[i]) } unless ret.blank?
          end
        end
      end
      ret = delocalize_without_russian(ret, format)
      ret
    end
  end
end

require 'rails_admin/config/fields/types/datetime'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Datetime < RailsAdmin::Config::Fields::Base
          register_instance_option :formatted_value do
            ret = if time = (value || default_value)
              opt = {format: strftime_format, standalone: true}
              Russian.force_standalone = true
              r = ::I18n.l(time, **opt)
              Russian.force_standalone = false
              r
            else
              ''.html_safe
            end
            ret
          end
        end
      end
    end
  end
end
