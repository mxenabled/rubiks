shared_context 'schema_context' do

  def schema_hash
    {
      'cubes' => [cube_hash.deep_dup]
    }
  end

  def cube_hash
    {
      'name' => 'fake_cube',
      'dimensions' => [dimension_hash.deep_dup],
      'measures' => [measure_hash.deep_dup],
      'calculated_members' => [calculated_member_hash.deep_dup]
    }
  end

  def dimension_hash
    {
      'name' => 'fake_dimension',
      'hierarchies' => [hierarchy_hash.deep_dup]
    }
  end

  def hierarchy_hash
    {
      'name' => 'fake_hierarchy',
      'dimension' => 'fake_dimension',
      'levels' => [level_hash.deep_dup]
    }
  end

  def level_hash
    {
      'name' => 'fake_level',
      'data_type' => 'Numeric',
      'editor_type' => 'RANGE'
    }
  end

  def measure_hash
    {
      'name' => 'fake_measure',
      'aggregator' => 'sum',
      'format_string' => '$#,###'
    }
  end

  def calculated_member_hash
    {
      'name' => 'fake_calculated_member',
      'dimension' => 'fake_dimension',
      'formula' => 'fake_formula',
      'format_string' => '$#,##0.00'
    }
  end

end
