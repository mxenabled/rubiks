# Taken from mondrian-olap: https://github.com/rsim/mondrian-olap/blob/master/lib/mondrian/olap/cube.rb
# require 'rubiks/mondrian/cell_set'
# require 'rubiks/mondrian/errors'

module ::Rubiks
  module Mondrian

    class Member
      def initialize(raw_member)
        @raw_member = raw_member
      end

      attr_reader :raw_member

      def name
        @raw_member.getName
      end

      def full_name
        @raw_member.getUniqueName
      end

      def caption
        @raw_member.getCaption
      end

      def calculated?
        @raw_member.isCalculated
      end

      def calculated_in_query?
        @raw_member.isCalculatedInQuery
      end

      def visible?
        @raw_member.isVisible
      end

      def all_member?
        @raw_member.isAll
      end

      def drillable?
        return false if calculated?
        # @raw_member.getChildMemberCount > 0
        # This hopefully is faster than counting actual child members
        raw_level = @raw_member.getLevel
        raw_levels = raw_level.getHierarchy.getLevels
        raw_levels.indexOf(raw_level) < raw_levels.size - 1
      end

      def depth
        @raw_member.getDepth
      end

      def dimension_type
        case @raw_member.getDimension.getDimensionType
        when Java::OrgOlap4jMetadata::Dimension::Type::TIME
          :time
        when Java::OrgOlap4jMetadata::Dimension::Type::MEASURE
          :measures
        else
          :standard
        end
      end

      def children
        ::Rubiks::MondrianError.wrap_native_exception do
          @raw_member.getChildMembers.map{|m| ::Rubiks::Mondrian::Member.new(m)}
        end
      end

      def descendants_at_level(level)
        ::Rubiks::MondrianError.wrap_native_exception do
          raw_level = @raw_member.getLevel
          raw_levels = raw_level.getHierarchy.getLevels
          current_level_index = raw_levels.indexOf(raw_level)
          descendants_level_index = raw_levels.indexOfName(level)

          return nil unless descendants_level_index > current_level_index

          members = [self]
          (descendants_level_index - current_level_index).times do
            members = members.map do |member|
              member.children
            end.flatten
          end
          members
        end
      end

      def property_value(name)
        if property = @raw_member.getProperties.get(name)
          @raw_member.getPropertyValue(property)
        end
      end

      def property_formatted_value(name)
        if property = @raw_member.getProperties.get(name)
          @raw_member.getPropertyFormattedValue(property)
        end
      end

    end

  end
end
