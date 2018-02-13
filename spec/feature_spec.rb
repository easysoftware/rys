RSpec.describe Rys::Feature do

  it 'checking active' do
    # Dependen on DB record
    Rys::Feature.add('test.no_block')

    # Depended on block definition
    test_with_block_active = true
    Rys::Feature.add('test.with_block') do
      test_with_block_active
    end

    # Migrate new
    RysFeatureRecord.destroy_all
    RysFeatureRecord.migrate_new

    # Check records
    expect(RysFeatureRecord.pluck(:name)).to eq(['test', 'test.no_block', 'test.with_block'])

    # New features should be active
    expect(Rys::Feature.active?('test.no_block')).to be_truthy
    expect(Rys::Feature.active?('test.with_block')).to be_truthy

    # Set DB records
    RysFeatureRecord.find_by(name: ['test.no_block', 'test.with_block']).update_attributes(active: false)
    RysFeatureRecord.request_store.clear

    # Block should not depend on DB
    expect(Rys::Feature.active?('test.no_block')).to be_falsey
    expect(Rys::Feature.active?('test.with_block')).to be_truthy

    # Block depend on variable
    test_with_block_active = false
    expect(Rys::Feature.active?('test.no_block')).to be_falsey
    expect(Rys::Feature.active?('test.with_block')).to be_falsey
  end

end
