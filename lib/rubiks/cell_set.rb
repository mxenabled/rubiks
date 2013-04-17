module ::Rubiks

  class CellSet
    def initialize(raw_cell_set)
      @raw_cell_set = raw_cell_set
    end

    def to_hash
      {
        :cube_name => @raw_cell_set.meta_data.cube.name,
        :cells => cells,
        :axes => result_axes,
        :filter_axis => filter_axis
      }
    end

    def axes
      @axes ||= @raw_cell_set.getAxes
    end

    def filter_axis
      generate_axis(@raw_cell_set.filter_axis)
    end

    def result_axes
      axes.map{ |raw_axis| generate_axis(raw_axis) }
    end

    def generate_axis(axis)
      tuples = axis.getPositions.map do |position|

        members = position.getMembers.map do |raw_member|
          names = [raw_member.level.name]
          names << raw_member.level.hierarchy.name.split('.').last
          names << raw_member.level.hierarchy.dimension.name

          level_unique_name = names.reverse.flatten.map{ |str| "[#{str}]" }.join('.')
          member_unique_name = "#{level_unique_name}.[#{raw_member.name}]"

          {
            :name => raw_member.name,
            :unique_name => generate_unique_name(member_unique_name),
            :level_name => generate_unique_name(level_unique_name),
            :level_depth => raw_member.depth
          }
        end

        if members.present?
          {:members => members}
        end
      end

      {
        :name => axis.axis_ordinal.name,
        :tuples => tuples
      }
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

    def cells
      raw_cells.flatten
    end

    def raw_cells
      axes_sequence = (0...@raw_cell_set.axes.count).to_a.reverse
      recursive_values(axes_sequence, 0)
    end

    def recursive_values(axes_sequence, current_index, cell_params=[])
      if axis_number = axes_sequence[current_index]
        positions_size = @raw_cell_set.axes[axis_number].getPositions.size
        (0...positions_size).map do |i|
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
