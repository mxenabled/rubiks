require 'rubiks/mondrian/member'

module ::Rubiks
  module Mondrian

    class CellSet
      def initialize(raw_cell_set)
        @raw_cell_set = raw_cell_set
      end

      def to_s
        "#<#{self.class}>"
      end

      def inspect
        axes_strings  = []
        axes_strings << "column_axis=#{axis_string(column_axis)}"
        axes_strings << "row_axis=#{axis_string(row_axis)}" if row_axis
        axes_strings << "filter_axis=#{axis_string(filter_axis)}" if filter_axis

        "#<#{self.class} cube=#{cube_name} #{axes_strings.join(' ')}>"
      end

      def to_hash
        {
          :cube_name => cube_name,
          :cells => cells,
          :axes => result_axes,
          :filter_axis => filter_axis
        }.delete_if{ |k,v| v.blank? }
      end

      def cells
        raw_cells.flatten
      end

      def cube_name
        @raw_cell_set.meta_data.cube.name
      end

      def filter_axis
        generate_axis(@raw_cell_set.filter_axis)
      end

      def column_axis
        result_axes.first
      end

      def row_axis
        result_axes[1]
      end

      def axes
        @axes ||= @raw_cell_set.getAxes
      end

      def result_axes
        axes.map{ |raw_axis| generate_axis(raw_axis) }
      end

      def axis_string(axis)
        axis[:tuples].map do |tuple|
          members = tuple[:members].map{ |member| member[:path] }.join(',')
        end.join('|')
      end

      def generate_axis(axis)
        tuples = axis.getPositions.map do |position|

          members = position.getMembers.map do |raw_member|
            member = ::Rubiks::Mondrian::Member.new(raw_member)

            names = [raw_member.level.name]
            names << raw_member.level.hierarchy.name.split('.').last
            names << raw_member.level.hierarchy.dimension.name

            level_unique_name = names.reverse.flatten.map{ |str| "[#{str}]" }.join('.')
            member_unique_name = "#{level_unique_name}.[#{raw_member.name}]"

            path_name = '/' + raw_member.unique_name.gsub(/\]\.\[/, '/')[1...-1]

            {
              :name => raw_member.name,
              :unique_name => generate_unique_name(member_unique_name),
              :level_name => generate_unique_name(level_unique_name),
              :path => path_name,
              :level_depth => raw_member.depth,
              :child_count => member.children.length,
              :is_all_member => member.all_member?,
              :is_drillable => member.drillable?
            }
          end

          members.compact!

          if members.present?
            {:members => members}
          end
        end

        tuples.compact!

        if tuples.present?
          {
            :name => axis.axis_ordinal.name,
            :tuples => tuples
          }
        else
          nil
        end
      end

      # [Date.YQMD] - Mondrian's hierarchy
      # [Logins].[Date].[YQMD] - needed output
      def generate_unique_name(string)
        cube_name = @raw_cell_set.meta_data.cube.name
        dimension_hierarchy_regexp = /\[([^\]]+)\.([^\]]+)\]/
        formatted_string = string.
                            gsub(dimension_hierarchy_regexp, '[\1].[\2]').
                            gsub(/\[Measures\]\.\[Measures\]/, '[Measures]').
                            gsub(/\.\[MeasuresLevel\]/, '')

        "[#{cube_name}].#{formatted_string}"
      end

      def raw_cells
        axes_sequence = (0...axes.size).to_a.reverse
        recursive_values(axes_sequence, 0)
      end

      def recursive_values(axes_sequence, current_index, cell_params=[])
        if axis_number = axes_sequence[current_index]
          (0...axes[axis_number].getPositions.size).map do |i|
            cell_params[axis_number] = Java::JavaLang::Integer.new(i)
            recursive_values(axes_sequence, current_index + 1, cell_params)
          end
        else
          cell = @raw_cell_set.getCell(cell_params)
          {
            :value => cell.value,
            :formatted_value => cell.formatted_value
          }
        end
      end
    end

  end
end
