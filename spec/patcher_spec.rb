class RysPatcherTestClass

  def values
    [1]
  end

end

RSpec.describe Rys::Patcher do

  it 'patches' do
    expect(RysPatcherTestClass.new.values).to eq([1])

    Rys::Patcher.add('RysPatcherTestClass') do
      instance_methods do
        def values
          super + [2]
        end
      end
    end

    Rys::Patcher.apply

    expect(RysPatcherTestClass.new.values).to eq([1,2])
  end

end
