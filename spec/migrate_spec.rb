require "rys/migrate"

RSpec.describe Rys::Migrate do
  describe ".db" do
    subject(:db_migrate) { described_class.db }
    it { expect(described_class).to receive(:call).with("migrate"); db_migrate }

  end

  describe ".data" do
    subject(:data_migrate) { described_class.data }
    it { expect(described_class).to receive(:call).with("after_plugins"); data_migrate }
  end
end
