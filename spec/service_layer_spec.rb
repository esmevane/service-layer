require 'spec_helper'

describe ServiceLayer do
  it 'has a version number' do
    expect(described_class.gem_version).not_to be nil
  end
end
