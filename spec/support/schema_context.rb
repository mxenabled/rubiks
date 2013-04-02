shared_context 'schema_context' do

  def schema_hash
    {
      'cubes' => [cube_hash.deep_dup]
    }
  end

  def cube_hash
    {
      'name' => 'fake_cube',
      'dimensions' => [dimension_hash.deep_dup]
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
      'levels' => [level_hash.deep_dup]
    }
  end

  def level_hash
    {
      'name' => 'fake_level'
    }
  end

end
