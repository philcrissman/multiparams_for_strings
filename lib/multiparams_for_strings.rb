# This is basically the identical method from AR::Base, but with an additional elsif for Strings.

module ActiveRecord
  class Base
    def execute_callstack_for_multiparameter_attributes(callstack)
      errors = []
      callstack.each do |name, values_with_empty_parameters|
        begin
          klass = (self.class.reflect_on_aggregation(name.to_sym) || column_for_attribute(name)).klass
          # in order to allow a date to be set without a year, we must keep the empty values.
          # Otherwise, we wouldn't be able to distinguish it from a date with an empty day.
          values = values_with_empty_parameters.reject {|v| v.nil? }

          if values.empty?
            send(name + "=", nil)
          else

            value = if Time == klass
              instantiate_time_object(name, values)
            elsif Date == klass
              begin
                values = values_with_empty_parameters.collect do |v| v.nil? ? 1 : v end
                Date.new(*values)
              rescue ArgumentError => ex # if Date.new raises an exception on an invalid date
                instantiate_time_object(name, values).to_date # we instantiate Time object and convert it back to a date thus using Time's logic in handling invalid dates
              end
            elsif String == klass
              # make sure each value gets .to_s (just in case), and then concatenate them.
              values.map{|v| v.to_s }.inject(:+)
            else
              klass.new(*values)
            end

            send(name + "=", value)
          end
        rescue => ex
          errors << AttributeAssignmentError.new("error on assignment #{values.inspect} to #{name}", ex, name)
        end
      end
      unless errors.empty?
        raise MultiparameterAssignmentErrors.new(errors), "#{errors.size} error(s) on assignment of multiparameter attributes"
      end
    end
  end
end
